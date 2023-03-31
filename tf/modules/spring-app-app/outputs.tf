output "app_fqdn" {
  value       = trimprefix(azurerm_spring_cloud_app.application.url, "https://")
  description = "Application FQDN"
}
