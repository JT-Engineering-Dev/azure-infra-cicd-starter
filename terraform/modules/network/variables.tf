variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "vnet_cidr"           { type = string }

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
}

variable "tags" {
  type = map(string)
}
