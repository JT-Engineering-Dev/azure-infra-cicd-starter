variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "acr_sku"             { type = string }
variable "log_analytics_id"    { type = string }
variable "vnet_id"             { type = string }
variable "subnets"             { type = map(string) }
variable "tags"                { type = map(string) }
