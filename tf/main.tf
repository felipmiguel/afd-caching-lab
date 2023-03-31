terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
    azapi = {
      source = "azure/azapi"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  // If an environment is set up (dev, test, prod...), it is used in the application name
  environment = var.environment == "" ? "dev" : var.environment
}

data "http" "myip" {
  url = "http://whatismyip.akamai.com"
}

locals {
  myip = chomp(data.http.myip.response_body)
}

resource "azurecaf_name" "resource_group" {
  name          = var.application_name
  resource_type = "azurerm_resource_group"
  suffixes      = [local.environment]
}

resource "azurerm_resource_group" "main" {
  name     = azurecaf_name.resource_group.result
  location = var.location

  tags = {
    "terraform"        = "true"
    "environment"      = local.environment
    "application-name" = var.application_name
    "nubesgen-version" = "0.15.2"
  }
}

module "application" {
  source           = "./modules/spring-apps"
  resource_group   = azurerm_resource_group.main.name
  application_name = var.application_name
  environment      = local.environment
  location         = var.location

  virtual_network_id = module.network.virtual_network_id
  app_subnet_id      = module.network.app_subnet_id
  service_subnet_id  = module.network.service_subnet_id
  cidr_ranges        = var.cidr_ranges
}

module "network" {
  source                          = "./modules/virtual-network"
  resource_group                  = azurerm_resource_group.main.name
  application_name                = var.application_name
  environment                     = local.environment
  location                        = var.location
  address_space                   = var.address_space
  app_subnet_prefix               = var.app_subnet_prefix
  service_subnet_prefix           = var.service_subnet_prefix
  appgateway_subnet_prefix        = var.appgateway_subnet_prefix
  private_endpoints_subnet_prefix = var.private_endpoints_subnet_prefix
}

module "front_door" {
  source           = "./modules/front-door"
  resource_group   = azurerm_resource_group.main.name
  application_name = var.application_name
  environment      = local.environment
  location         = var.location
}

module "storage_blob" {
  source           = "./modules/storage-blob"
  resource_group   = azurerm_resource_group.main.name
  application_name = var.application_name
  environment      = local.environment
  location         = var.location
  subnet_id        = module.network.app_subnet_id
  myip             = local.myip
  # afd_origin_group_id = module.front_door.afd_origin_group_id
}

# module "storage_afd" {
#   source                 = "./modules/front-door-route"
#   application_name       = var.application_name
#   environment            = local.environment
#   location               = var.location
#   afd_profile_id         = module.front_door.afd_profile_id
#   afd_public_endpoint_id = module.front_door.afd_endpoint_id
#   name                   = "blobpoc"
#   pattern                = "/blobpoc/*"
#   host_name              = module.storage_blob.storage_blob_host
#   source_resource = {
#     id   = module.storage_blob.storage_account_resource_id
#     type = "blob"
#   }
# }

module "swa" {
  source           = "./modules/static-web-site"
  resource_group   = azurerm_resource_group.main.name
  application_name = var.application_name
  environment      = local.environment
  location         = var.location
}

# module "swa_afd" {
#   source                 = "./modules/front-door-route"
#   application_name       = var.application_name
#   environment            = local.environment
#   location               = var.location
#   afd_profile_id         = module.front_door.afd_profile_id
#   afd_public_endpoint_id = module.front_door.afd_endpoint_id
#   name                   = "swapoc"
#   pattern                = "/swapoc/*"
#   host_name              = module.swa.default_host_name
# }

module "app_spring_gateway" {
  source                   = "./modules/spring-app-app"
  resource_group           = azurerm_resource_group.main.name
  application_name         = "gateway"
  assign_public_endpoint   = true
  spring_apps_service_name = module.application.spring_apps_service_name
  cert_id                  = module.keyvault.certificate_id
  cert_name                = module.keyvault.certificate_name
  custom_domain            = var.dns_name
}

module "app_spring_cache_poc_app" {
  source                   = "./modules/spring-app-app"
  resource_group           = azurerm_resource_group.main.name
  application_name         = "cache-poc"
  assign_public_endpoint   = false
  spring_apps_service_name = module.application.spring_apps_service_name
}

module "keyvault" {
  source             = "./modules/keyvault"
  resource_group     = azurerm_resource_group.main.name
  application_name   = var.application_name
  environment        = local.environment
  location           = var.location
  virtual_network_id = module.network.virtual_network_id
  subnet_id          = module.network.private_endpoints_subnet_id
  dns_name           = var.dns_name
}


module "application_gateway" {
  source                = "./modules/application_gateway"
  resource_group        = azurerm_resource_group.main.name
  application_name      = var.application_name
  environment           = local.environment
  location              = var.location
  appgateway_subnet_id  = module.network.appgateway_subnet_id
  backend_fqdn          = module.app_spring_gateway.app_fqdn
  certificate_secret_id = module.keyvault.certificate_secret_id
  keyvault_id           = module.keyvault.kv_id
  dns_name              = var.dns_name
  domain_name_label     = var.application_name
  probe_path            = "/actuator/health"
}

module "afd_appgw_route" {
  source                         = "./modules/front-door-route"
  application_name               = var.application_name
  environment                    = local.environment
  location                       = var.location
  afd_profile_id                 = module.front_door.afd_profile_id
  afd_public_endpoint_id         = module.front_door.afd_endpoint_id
  name                           = "appgw"
  pattern                        = "/*"
  host_name                      = module.application_gateway.public_ip_address
  origin_host_header             = var.dns_name
  certificate_name_check_enabled = true
}

