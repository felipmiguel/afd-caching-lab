output "virtual_network_id" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "Application Virtual Network"
}

output "app_subnet_id" {
  value       = azurerm_subnet.app_subnet.id
  description = "Application Subnet"
}

output "service_subnet_id" {
  value       = azurerm_subnet.service_subnet.id
  description = "Azure Spring Apps services subnet"
}

output "appgateway_subnet_id" {
  value       = azurerm_subnet.appgateway_subnet.id
  description = "Application Gateway subnet"
}

output "private_endpoints_subnet_id" {
  value       = azurerm_subnet.private_endpoints_subnet.id
  description = "Private endpoints subnet"
}