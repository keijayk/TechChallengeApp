resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.container_registry_sku
  admin_enabled       = var.container_registry_admin_enabled

  tags = {
    ManagedBy       = var.tag_managed_by
    ProvisionedWith = var.tag_provisioned_with
  }
}

resource "azuread_application" "acr-app" {
  display_name = "${var.container_registry_display_name}"
}

resource "azuread_service_principal" "acr-sp" {
  application_id = "${azuread_application.acr-app.application_id}"
}



resource "azuread_service_principal_password" "acr-sp-pass" {
  service_principal_id = "${azuread_service_principal.acr-sp.id}"

}

resource "azurerm_role_assignment" "acr-assignment" {
  scope                = "${azurerm_container_registry.acr.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal_password.acr-sp-pass.service_principal_id}"
}