output "afd_profile_id" {
  value       = azurerm_cdn_frontdoor_profile.afd_profile.id
  description = "The ID of the Azure Front Door profile"
}

output "afd_endpoint_id" {
  value       = azurerm_cdn_frontdoor_endpoint.public_endpoint.id
  description = "The ID of the Azure Front Door public endpoint"
}

output "afd_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.public_endpoint.host_name
  description = "The hostname of the Azure Front Door public endpoint"
}