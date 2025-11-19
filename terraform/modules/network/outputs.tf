output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.subs : k => s.id }
}
