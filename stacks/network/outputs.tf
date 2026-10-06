output "resource_group_name" {
  description = "Ressursgruppa (videreformidlet, til verifiseringssteg i workflowen)."
  value       = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "subnet_ids" {
  description = "LESES av app-stacken via terraform_remote_state (K9) - ikke kopier denne verdien manuelt noe sted."
  value       = module.network.subnet_ids
}
