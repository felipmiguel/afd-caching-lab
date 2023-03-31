resource "azurerm_spring_cloud_app" "application" {
  name                = var.application_name
  resource_group_name = var.resource_group
  service_name        = var.spring_apps_service_name
  is_public           = var.assign_public_endpoint
  identity {
    type = "SystemAssigned"
  }
}



resource "azurerm_spring_cloud_java_deployment" "application_deployment" {
  name                = "default"
  spring_cloud_app_id = azurerm_spring_cloud_app.application.id
  instance_count      = 1
  runtime_version     = "Java_17"

  quota {
    cpu    = "1"
    memory = "1Gi"
  }
}

resource "azurerm_spring_cloud_active_deployment" "active_deployment" {
  deployment_name     = azurerm_spring_cloud_java_deployment.application_deployment.name
  spring_cloud_app_id = azurerm_spring_cloud_app.application.id
}

resource "azurerm_spring_cloud_certificate" "app_certificate" {
  count                    = var.cert_id != null ? 1 : 0
  name                     = var.cert_name
  key_vault_certificate_id = var.cert_id
  resource_group_name      = var.resource_group
  service_name             = var.spring_apps_service_name
}

resource "azurerm_spring_cloud_custom_domain" "app_custom_domain" {
  count               = var.cert_id != null ? 1 : 0
  name                = var.custom_domain
  spring_cloud_app_id = azurerm_spring_cloud_app.application.id
  thumbprint          = azurerm_spring_cloud_certificate.app_certificate[0].thumbprint
  certificate_name    = azurerm_spring_cloud_certificate.app_certificate[0].name
}
