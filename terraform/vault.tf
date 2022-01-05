data "azurerm_client_config" "current" {}

# Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_name
 
  access_policy {
    tenant_id           = data.azurerm_client_config.current.tenant_id
    object_id           = data.azurerm_client_config.current.object_id

    secret_permissions  = [ "Get", "Set", "List" , "Delete", "Purge"]
  }
}


# Create KeyVault  postgress credentials
resource "random_password" "postgress_password" {
  length = 20
  special = true
}

# Secret
resource "azurerm_key_vault_secret" "postgress_key_vault_secret" {
  name          = var.key_vault_secret_name
  value         = random_password.postgress_password.result
  key_vault_id  = azurerm_key_vault.key_vault.id
  depends_on    = [ azurerm_key_vault.key_vault, random_password.postgress_password ]
}