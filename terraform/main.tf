resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  vnet_cidr           = var.vnet_cidr
  subnets             = var.subnets
  tags                = var.tags
}

module "observability" {
  source              = "./modules/observability"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  tags                = var.tags
}

module "container_artifacts" {
  source              = "./modules/container_artifacts"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  acr_sku             = var.acr_sku
  log_analytics_id    = module.observability.log_analytics_id
  vnet_id             = module.network.vnet_id
  subnets             = module.network.subnet_ids
  tags                = var.tags
}
