output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "acr_login_server" {
  value = module.container_artifacts.acr_login_server
}

output "containerapps_env_id" {
  value = module.container_artifacts.containerapps_env_id
}

output "log_analytics_id" {
  value = module.observability.log_analytics_id
}
