variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
}

variable "location" {
  type        = string
  description = "The location of the resources"
}

variable "afd_profile_id" {
  type        = string
  description = "The ID of the Azure Front Door profile"
}

variable "afd_public_endpoint_id" {
  type        = string
  description = "The ID of the Azure Front Door public endpoint"
}

variable "name" {
  type        = string
  description = "The name of the route"
}

variable "pattern" {
  type        = string
  description = "The pattern to match of the route"
}

variable "host_name" {
  type        = string
  description = "The source host"
}

variable "origin_host_header" {
  type        = string
  description = "The host header to be sent to the origin if different to host_name"
  default     = null  
}

variable "source_resource" {
  type = object({
    id   = string
    type = string
  })
  description = "Azure resource id of the origin in case it is necessary to create a private link"
  default     = null
}

variable "certificate_name_check_enabled" {
  type        = bool
  description = "Enable certificate name check"
  default     = true
}
