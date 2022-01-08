# Create postgressql server
resource "azurerm_postgresql_server" "postgresql_server" {
  name                          = var.postgresql_server_name
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name

  sku_name                      = var.postgresql_server_sku_name

  storage_mb                    = var.postgresql_server_storage_mb
  backup_retention_days         = var.postgresql_server_backup_retention_days
  geo_redundant_backup_enabled  = var.postgresql_server_geo_redundant_backup_enabled
  auto_grow_enabled             = var.postgresql_server_auto_grow_enabled

  administrator_login           = var.postgresql_db_user
  administrator_login_password  = azurerm_key_vault_secret.postgress_key_vault_secret.value
  version                       = var.postgresql_server_version
  ssl_enforcement_enabled       = var.postgresql_server_ssl_enforcement_enabled
}

# Create postgressql database
resource "azurerm_postgresql_database" "postgresql_database" {
  name                = var.postgresql_database_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = var.postgresql_database_charset
  collation           = var.postgresql_database_collation
}

# Create postgressql firewall rule
resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule" {
  name                = var.postgresql_firewall_rule_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = var.postgresql_firewall_rule_start_ip_address
  end_ip_address      = var.postgresql_firewall_rule_end_ip_address
}