output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "containerapps_env_id" {
  value = azurerm_container_app_environment.cae.id
}
