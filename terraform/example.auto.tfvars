prefix   = "jtj"
location = "eastus"
tags = {
  owner = "jt-engineering"
  env   = "dev"
}
acr_sku = "Basic"
vnet_cidr = "10.50.0.0/16"
subnets = {
  apps   = { address_prefix = "10.50.1.0/24" }
  system = { address_prefix = "10.50.2.0/24" }
}
