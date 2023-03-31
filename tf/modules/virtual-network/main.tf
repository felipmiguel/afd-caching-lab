terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
  }
}

resource "azurecaf_name" "virtual_network" {
  name          = var.application_name
  resource_type = "azurerm_virtual_network"
  suffixes      = [var.environment]
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = azurecaf_name.virtual_network.result
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

resource "azurecaf_name" "service_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "svc"]
}

resource "azurerm_subnet" "service_subnet" {
  name                 = azurecaf_name.service_subnet.result
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.service_subnet_prefix]
}

resource "azurecaf_name" "app_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "app"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = azurecaf_name.app_subnet.result
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.app_subnet_prefix]
  # service_endpoints    = var.service_endpoints
}


resource "azurecaf_name" "appgateway_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "appgateway"]
}

resource "azurerm_subnet" "appgateway_subnet" {
  name                 = azurecaf_name.appgateway_subnet.result
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.appgateway_subnet_prefix]
}

resource "azurecaf_name" "private_endpoints_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "pe"]
}

resource "azurerm_subnet" "private_endpoints_subnet" {
  name                                      = azurecaf_name.private_endpoints_subnet.result
  resource_group_name                       = var.resource_group
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.private_endpoints_subnet_prefix]
  private_endpoint_network_policies_enabled = true
}
