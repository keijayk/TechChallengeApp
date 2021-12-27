resource "azurerm_postgresql_server" "main" {
  name                              = var.postgresql_server_name
  location                          = azurerm_resource_group.main.location
  resource_group_name               = azurerm_resource_group.main.name

  sku_name = var.postgresql_server_sku_name

  storage_mb                   = var.postgresql_server_storage_mb
  backup_retention_days        = var.postgresql_server_backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_server_geo_redundant_backup_enabled
  auto_grow_enabled            = var.postgresql_server_auto_grow_enabled

  administrator_login          = var.postgresql_server_administrator_login
  administrator_login_password = azurerm_key_vault_secret.postgresscredentials.value
  version                      = var.postgresql_server_version
  ssl_enforcement_enabled      = var.postgresql_server_ssl_enforcement_enabled
}

resource "azurerm_postgresql_database" "main" {
  name                = var.postgresql_database_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  charset             = var.postgresql_database_charset
  collation           = var.postgresql_database_collation
}

resource "azurerm_postgresql_firewall_rule" "main" {
  name                = var.postgresql_firewall_rule_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = var.postgresql_firewall_rule_start_ip_address
  end_ip_address      = var.postgresql_firewall_rule_end_ip_address
}