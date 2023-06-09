variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

# variable "sources" {
#   type = list(object({
#     name        = string
#     pattern       = string
#     host_name   = string
#     resource_id = optional(string)
#   }))
#   description = "Values to map an endpoint to a backend(s)"
# }
