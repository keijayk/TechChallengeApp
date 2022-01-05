output "app_service_name" {
  value = azurerm_app_service.app_service.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.app_service.default_site_hostname}"
}

output "container_registry_name" {
  value = azurerm_container_registry.container_registry.name
}

output "resource_group_name" {
    value = azurerm_resource_group.resource_group.name
}

output "key_vault_endpoint" {
  value = azurerm_key_vault.key_vault.vault_uri
}

output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}


output "application_identity_principal_id" {
  value = azurerm_app_service.app_service.identity.0.principal_id
}