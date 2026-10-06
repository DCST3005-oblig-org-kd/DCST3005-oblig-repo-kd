data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.network_state_key
    use_azuread_auth     = true
  }
}

locals {
  base_name = lower(format("%s-%s-%s", var.project_name, var.environment, var.owner))
  subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[var.data_subnet_key]

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project_name
    stack       = "app"
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-app-%s", local.base_name)
  location = var.location
  tags     = local.tags
}

resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}


resource "azurerm_storage_account" "data" {
  name                = substr(lower("st${var.project_name}${var.environment}${random_string.suffix.result}"), 0, 24)
  resource_group_name = azurerm_resource_group.rg.name
  location             = var.location

  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [local.subnet_id]
  }

  tags = local.tags
}
