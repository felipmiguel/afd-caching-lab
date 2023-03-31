terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
  }
}

resource "azurecaf_name" "afd_profile" {
  name          = var.application_name
  resource_type = "azurerm_cdn_frontdoor_profile"
  suffixes      = [var.environment]
}

resource "azurerm_cdn_frontdoor_profile" "afd_profile" {
  name                = azurecaf_name.afd_profile.result
  resource_group_name = var.resource_group
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurecaf_name" "public_endpoint" {
  name          = var.application_name
  resource_type = "azurerm_cdn_frontdoor_endpoint"
  suffixes      = [var.environment]
}

resource "azurerm_cdn_frontdoor_endpoint" "public_endpoint" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
  name                     = azurecaf_name.public_endpoint.result
}





