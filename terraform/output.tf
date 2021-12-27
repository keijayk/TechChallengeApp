output "app_service_name" {
  value = azurerm_app_service.main.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.main.default_site_hostname}"
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "resource_group" {
    value = azurerm_resource_group.main.name
}

output "key_vault_endpoint" {
  value = azurerm_key_vault.main.vault_uri
}

output "key_vault_id" {
  value = azurerm_key_vault.main.id
}


output "application_identity_principal_id" {
  value = "${azurerm_app_service.main.identity.0.principal_id}"
}