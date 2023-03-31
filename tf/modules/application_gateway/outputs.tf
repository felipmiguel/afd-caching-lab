output "public_ip_fqdn" {
  value       = azurerm_public_ip.app_gw_public_ip.fqdn
  description = "Public IP FQDN"
}

output "public_ip_address" {
  value       = azurerm_public_ip.app_gw_public_ip.ip_address
  description = "Public IP Address"
}