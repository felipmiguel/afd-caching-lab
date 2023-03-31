terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
  }
}

resource "azurecaf_name" "storage_account" {
  name          = var.application_name
  resource_type = "azurerm_storage_account"
  suffixes      = [var.environment]
}

resource "azurerm_storage_account" "storage_blob" {
  name                            = azurecaf_name.storage_account.result
  resource_group_name             = var.resource_group
  location                        = var.location
  account_tier                    = "Premium"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Deny"
  }

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

# resource "azurecaf_name" "blob_cdn_origin" {
#   name          = var.application_name
#   resource_type = "azurerm_cdn_frontdoor_origin"
#   suffixes      = [var.environment]
# }


# resource "azurerm_cdn_frontdoor_origin" "blob_cdn_origin" {
#   name                          = azurecaf_name.blob_cdn_origin.result
#   cdn_frontdoor_origin_group_id = var.afd_origin_group_id
#   enabled                       = true

#   certificate_name_check_enabled = true
#   host_name                      = azurerm_storage_account.storage_blob.primary_blob_host
#   origin_host_header             = azurerm_storage_account.storage_blob.primary_blob_host
#   priority                       = 1
#   weight                         = 500

#   private_link {
#     request_message        = "Request access for Private Link Origin CDN Frontdoor"
#     target_type            = "blob"
#     location               = azurerm_storage_account.storage_blob.location
#     private_link_target_id = azurerm_storage_account.storage_blob.id
#   }
# }


resource "azurecaf_name" "storage_container" {
  name          = var.application_name
  resource_type = "azurerm_storage_container"
  suffixes      = [var.environment]
}

# resource "azurerm_storage_container" "storage_blob" {
#   name                  = azurecaf_name.storage_container.result
#   storage_account_name  = azurerm_storage_account.storage_blob.name
#   container_access_type = "private"
# }
