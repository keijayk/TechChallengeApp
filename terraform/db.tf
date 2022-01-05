
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.endpoint_subnet.id

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }

  private_service_connection {
    name                            = var.private_service_connection_name
    private_connection_resource_id  = azurerm_postgresql_server.postgresql_server.id
    subresource_names               = ["postgresqlServer"]
    is_manual_connection            = false
  }
}

resource "azurerm_postgresql_server" "postgresql_server" {
  name                          = var.postgresql_server_name
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name

  sku_name                      = var.postgresql_server_sku_name

  storage_mb                    = var.postgresql_server_storage_mb
  backup_retention_days         = var.postgresql_server_backup_retention_days
  geo_redundant_backup_enabled  = var.postgresql_server_geo_redundant_backup_enabled
  auto_grow_enabled             = var.postgresql_server_auto_grow_enabled

  administrator_login           = var.postgresql_server_administrator_login
  administrator_login_password  = azurerm_key_vault_secret.postgress_key_vault_secret.value
  version                       = var.postgresql_server_version
  ssl_enforcement_enabled       = var.postgresql_server_ssl_enforcement_enabled
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name                = var.postgresql_database_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = var.postgresql_database_charset
  collation           = var.postgresql_database_collation
}

resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule" {
  name                = var.postgresql_firewall_rule_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = var.postgresql_firewall_rule_start_ip_address
  end_ip_address      = var.postgresql_firewall_rule_end_ip_address
}