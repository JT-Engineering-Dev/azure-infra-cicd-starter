variable "prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "jtj"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    owner = "jt-engineering"
    env   = "dev"
  }
}

variable "acr_sku" {
  description = "ACR SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR for VNet"
  default     = "10.50.0.0/16"
}

variable "subnets" {
  description = "Map of subnet names to CIDRs"
  type = map(object({
    address_prefix = string
  }))
  default = {
    "apps"   = { address_prefix = "10.50.1.0/24" }
    "system" = { address_prefix = "10.50.2.0/24" }
  }
}
