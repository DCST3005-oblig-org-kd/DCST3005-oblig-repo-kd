resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.base_name}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.base_name}"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = "snet-${var.base_name}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, each.value)]

  dynamic "service_endpoint" {
    for_each = each.key == "data" ? ["Microsoft.Storage"] : []

    content {
      service = service_endpoint.value
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main.id
}