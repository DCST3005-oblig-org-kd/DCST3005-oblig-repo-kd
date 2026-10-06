resource "azurerm_role_assignment" "pipeline_blob_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pipeline_principal_id
  principal_type       = "ServicePrincipal"

  depends_on = [
    azurerm_storage_account.tfstate,
    azurerm_storage_container.tfstate,
  ]
}

resource "azurerm_key_vault" "kv" {
  name                = substr(lower("kv-tf-${var.owner}${random_string.storage_suffix.result}"), 0, 24)
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                    = "standard"
  rbac_authorization_enabled  = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  tags = local.tags
}

resource "azurerm_role_assignment" "kv_officer_meg" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"
}

resource "azurerm_role_assignment" "kv_user_pipeline" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.pipeline_principal_id
  principal_type       = "ServicePrincipal"
}
