resource "azurerm_container_registry" "acr" {
  name                = replace("${var.prefix}acr", "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = var.tags
}

resource "azurerm_container_app_environment" "cae" {
  name                = "${var.prefix}-cae"
  location            = var.location
  resource_group_name = var.resource_group_name
  internal_load_balancer_enabled = false
  tags                = var.tags
  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_monitor_diagnostic_setting" "acr_diag" {
  name                       = "${var.prefix}-acr-diag"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
