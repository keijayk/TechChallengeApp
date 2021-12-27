prefix  = "devopschallengeservian"

tag_managed_by         ="Servian DevOps Challenge"
tag_provisioned_with   ="Terraform"

resource_group_name                 ="rg"
resource_location                   ="japaneast"
environment                         ="dev"

# PostGreSQL variable assignment
postgresql_server                   ="psql"
postgresql_db                       ="northwind"                                   


# App Service Plan assignment
app_service_plan_kind               ="Linux"
app_service_plan_sku_tier           ="Premiumv2"
app_service_plan_sku_size           ="P1v2"



app_service_app_command_line                        ="serve"
app_service_website_dns_server                      ="168.63.129.16"
app_service_website_vnet_route_all                  = "1"
app_service_website_enable_storage                  = "false"
app_service_website_container_start_time_limit      =1800
app_service_website_port                            =3000
app_service_port                                    =3000

app_service_monitor_autoscale_name      ="AutoscaleSetting"

app_container_image_name_tag            = "registry-1-stage.docker.io/keijayk/techchallengeapp:dev23"

container_registry_sku                  ="Basic"
container_registry_admin_enabled        =true

postgresql_server_name                          ="postgresql-server-kg"
postgresql_server_sku_name                      ="GP_Gen5_2"

postgresql_server_storage_mb                   = 5120
postgresql_server_backup_retention_days        = 7
postgresql_server_geo_redundant_backup_enabled = false
postgresql_server_auto_grow_enabled            = true
postgresql_server_administrator_login          = "psqladmin"
postgresql_server_version                      = "9.5"
postgresql_server_ssl_enforcement_enabled      = false


postgresql_database_name                       ="app"
postgresql_database_charset                    ="UTF8"
postgresql_database_collation                  ="English_United States.1252"

postgresql_firewall_rule_name                  ="postgresql-fw-rule"
postgresql_firewall_rule_start_ip_address      ="0.0.0.0"
postgresql_firewall_rule_end_ip_address        ="0.0.0.0"