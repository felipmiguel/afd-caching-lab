terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.24"
    }
  }
}

resource "azurecaf_name" "afd_origin_group" {
  name          = var.name
  resource_type = "azurerm_cdn_frontdoor_origin_group"
  suffixes      = [var.application_name, var.environment]
}

resource "azurerm_cdn_frontdoor_origin_group" "afd_origin_group" {
  name                     = azurecaf_name.afd_origin_group.result
  cdn_frontdoor_profile_id = var.afd_profile_id

  health_probe {
    path                = "/"
    interval_in_seconds = 30
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {}
}

resource "azurecaf_name" "cdn_origin" {
  name          = var.name
  resource_type = "azurerm_cdn_frontdoor_origin"
  suffixes      = [var.application_name, var.environment]
}


resource "azurerm_cdn_frontdoor_origin" "cdn_origin" {
  name                          = azurecaf_name.cdn_origin.result
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  enabled                       = true

  certificate_name_check_enabled = var.certificate_name_check_enabled
  host_name                      = var.host_name
  origin_host_header             = var.origin_host_header != null ? var.origin_host_header : var.host_name
  priority                       = 1
  weight                         = 1
  http_port                      = 80
  https_port                     = 443


  dynamic "private_link" {
    for_each = var.source_resource != null ? [1] : []
    content {
      request_message        = "Request access for Private Link Origin CDN Frontdoor"
      target_type            = var.source_resource.type
      location               = var.location
      private_link_target_id = var.source_resource.id
    }
  }
}


resource "azurecaf_name" "route_name" {
  resource_type = "azurerm_cdn_frontdoor_route"
  suffixes      = [var.name, var.environment]
}

resource "azurerm_cdn_frontdoor_route" "route_to_origin" {
  name                          = azurecaf_name.route_name.result
  cdn_frontdoor_endpoint_id     = var.afd_public_endpoint_id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.cdn_origin.id]
  enabled                       = true
  patterns_to_match             = [var.pattern]
  forwarding_protocol           = "HttpOnly"
  https_redirect_enabled        = false
  supported_protocols           = ["Http", "Https"]
  cdn_frontdoor_origin_path     = "/"

  cache {
    query_string_caching_behavior = "UseQueryString"
  }
  link_to_default_domain = true
}


