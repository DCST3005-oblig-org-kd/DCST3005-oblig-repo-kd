output "vnet_id" {
  description = "Ressurs-ID til virtual network."
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Navnet på virtual network."
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "Subnet-ID per subnettnavn. LESES av app-stacken via terraform_remote_state (K9)."
  value       = { for navn, s in azurerm_subnet.main : navn => s.id }
}
