data "azurerm_client_config" "current" {}

# Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_name
 
  access_policy {
    tenant_id           = data.azurerm_client_config.current.tenant_id
    object_id           = data.azurerm_client_config.current.object_id

    secret_permissions  = [ "Get", "Set", "List" , "Delete"]
  }
}


# Create KeyVault  postgress credentials
resource "random_password" "postgresscredentials" {
  length = 20
  special = true
}

# Secret
resource "azurerm_key_vault_secret" "postgresscredentials" {
  name          = var.key_vault_secret_name
  value         = random_password.postgresscredentials.result
  key_vault_id  = azurerm_key_vault.main.id
  depends_on    = [ azurerm_key_vault.main, random_password.postgresscredentials]
}