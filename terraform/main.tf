resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_location
}

resource "azurerm_app_service_plan" "main" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = var.app_service_plan_kind
  reserved            = true

  sku {
    tier = var.app_service_plan_sku_tier
    size = var.app_service_plan_sku_size
  }

  tags = {
    ManagedBy       = var.tag_managed_by
    ProvisionedWith = var.tag_provisioned_with
  }
}

resource "azurerm_app_service" "main" {
  name                = local.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id
  https_only          = true

  site_config {
    always_on        = true
    linux_fx_version = local.app_service_linux_fx_version
    app_command_line = var.app_service_app_command_line

    cors {
      allowed_origins = ["*"]
    }
  }

  lifecycle {
    ignore_changes = [
      site_config[0].linux_fx_version, # deployments are made outside of Terraform
    ]
  }

  app_settings = {
    "WEBSITE_DNS_SERVER"                  = var.app_service_website_dns_server,
    "WEBSITE_VNET_ROUTE_ALL"              = var.app_service_website_vnet_route_all
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = var.app_service_website_enable_storage
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = var.app_service_website_container_start_time_limit
    "WEBSITES_PORT"                       = var.app_service_website_port
    "PORT"                                = var.app_service_port
    "DOCKER_REGISTRY_SERVER_URL"          = local.docker_registry_server_url
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
  }
  tags = {
    ManagedBy       = var.tag_managed_by
    ProvisionedWith = var.tag_provisioned_with
  }

}
