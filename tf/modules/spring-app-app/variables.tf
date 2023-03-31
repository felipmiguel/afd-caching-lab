variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "spring_apps_service_name" {
  type        = string
  description = "The name of the Azure Spring App Service"
}

variable "assign_public_endpoint" {
  type        = bool
  description = "Whether to assign a public endpoint to the application"
  default     = false
}

variable "environment_variables" {
  type        = map(string)
  description = "The environment variables"
  default     = {}
}

variable "cert_id" {
  type        = string
  description = "The ID of the certificate to use for the HTTPS listener"
  default     = null
}

variable "cert_name" {
  type        = string
  description = "The name of the certificate to use for the HTTPS listener"
  default     = null
}

variable "custom_domain" {
  type        = string
  description = "The custom domain to use for the HTTPS listener"
  default     = null
}
