output "azurerm_storage_account_name" {
  value       = azurerm_storage_account.storage_blob.name
  description = "The Azure Blob storage account name."
}

output "azurerm_storage_account_key" {
  value       = azurerm_storage_account.storage_blob.primary_access_key
  sensitive   = true
  description = "The Azure Blob storage access key."
}

output "azurerm_storage_blob_endpoint" {
  value       = azurerm_storage_account.storage_blob.primary_blob_endpoint
  description = "The Azure Blob storage endpoint."
}

output "storage_blob_host" {
  value       = azurerm_storage_account.storage_blob.primary_blob_host
  description = "The Azure Blob storage host name."
}

output "storage_account_resource_id" {
  value       = azurerm_storage_account.storage_blob.id
  description = "The Azure Blob storage resource ID."
}
