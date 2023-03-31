terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

resource "azurecaf_name" "static_site" {
  name          = var.application_name
  resource_type = "azurerm_static_site"
  suffixes      = [var.environment]
}

resource "azurerm_static_site" "static_site" {
  name                = azurecaf_name.static_site.result
  resource_group_name = var.resource_group
  location            = var.location
  sku_tier            = "Standard"
  sku_size            = "Standard"
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group
}

# resource "azapi_update_resource" "static_site_cdn" {
#   type      = "Microsoft.Web/staticSites@2022-03-01"
#   parent_id = data.azurerm_resource_group.resource_group.id
#   name      = azurecaf_name.static_site.result
#   body = jsonencode({
#     properties = {
#       enterpriseGradeCdnStatus = "Enabled"
      
#     }
#   })
#   depends_on = [
#     azurerm_static_site.static_site
#   ]
# }
