variable "application_name" {
  type        = string
  description = "The name of your application"
  default     = "demo-2920-2016"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
  default     = "westeurope"
}

variable "address_space" {
  type        = string
  description = "Virtual Network address space"
  default     = "10.11.0.0/16"
}

variable "app_subnet_prefix" {
  type        = string
  description = "Application subnet prefix"
  default     = "10.11.0.0/24"
}

variable "service_subnet_prefix" {
  type        = string
  description = "Azure Spring Apps service subnet prefix"
  default     = "10.11.1.0/24"
}

variable "appgateway_subnet_prefix" {
  type        = string
  description = "Application Gateway subnet prefix"
  default     = "10.11.2.0/24"
}

variable "private_endpoints_subnet_prefix" {
  type        = string
  description = "Private endpoints subnet prefix"
  default     = "10.11.3.0/24"
}

variable "cidr_ranges" {
  type        = list(string)
  description = "A list of (at least 3) CIDR ranges (at least /16) which are used to host the Azure Spring Apps infrastructure, which must not overlap with any existing CIDR ranges in the Subnet. Changing this forces a new resource to be created"
  default     = ["10.4.0.0/16", "10.5.0.0/16", "10.3.0.1/16"]
}

variable "dns_name" {
  type        = string
  description = "The DNS name for the application to be exposed thru Application Gateway"
  default     = "demo-2920-2016.io"
}
