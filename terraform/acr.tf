# Create container registry
resource "azurerm_container_registry" "container_registry" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = var.container_registry_sku
  admin_enabled       = var.container_registry_admin_enabled

  tags = {
    ManagedBy       = var.tag_managed_by
    ProvisionedWith = var.tag_provisioned_with
  }
}

# Create applicatoion for container registry
resource "azuread_application" "application" {
  display_name = var.container_registry_display_name
}

# Create service principle for container registry
resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.application.application_id
}

# Create service principle password for container registry
resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = azuread_service_principal.service_principal.id

}

# Create role assignment for container registry
resource "azurerm_role_assignment" "role_assignment" {
  scope                =  azurerm_container_registry.container_registry.id
  role_definition_name =  var.role_definition_name
  principal_id         =  azuread_service_principal_password.service_principal_password.service_principal_id
}