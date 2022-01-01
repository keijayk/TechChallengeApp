prefix  = "devopschallengeservian"

tag_managed_by         ="Servian DevOps Challenge"
tag_provisioned_with   ="Terraform"

resource_group_name                 ="rg"
resource_location                   ="japaneast"
environment                         ="dev"

# networking variable assignment
virtual_network                      ="vnet"
virtual_network_address_space        =["10.0.0.0/16"] 

# three subnets
subnet_addresses                    =[
                                        {
                                            ip      = "10.0.1.0/24"
                                            name     = "snet_1"
                                        },
                                        {
                                            ip      = "10.0.2.0/24"
                                            name     = "snet_2"
                                        },
                                        {
                                            ip      = "10.0.3.0/24"
                                            name     = "snet_3"
                                        }
                                    ]



                          


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


private_dns_zone_name                           ="privatelink.azurewebsites.net"
private_dns_zone_virtual_network_link_name      ="dnszonelink"
private_endpoint_name                           ="dbprivateendpoint"
private_dns_zone_group_name                     ="privatednszonegroup"
private_service_connection_name                 ="privateendpointconnection"

# PostGreSQL variable assignment
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

viper_prefix                                   ="VTT"

key_vault_name                         ="devopschallgegevault"
key_vault_sku_name                     ="standard"
key_vault_secret_name                  ="postgresscredentials"
key_vault_postgress_secret_value       ="H@Sh1CoR3!ABC"


autoscale_capacity_default = 1
autoscale_capacity_minimum = 1
autoscale_capacity_maximum = 10


autoscale_metric_trigger_metric_name        = "CpuPercentage"
autoscale_metric_trigger_time_grain         = "PT1M"
autoscale_metric_trigger_statistic          = "Average"
autoscale_metric_trigger_time_window        = "PT5M"
autoscale_metric_trigger_time_aggregation   = "Average"
autoscale_metric_trigger_operator_gt        = "GreaterThan"
autoscale_metric_trigger_operator_lt        = "LessThan"
autoscale_metric_trigger_threshold          = 80


autoscale_scale_action_direction_inc = "Increase"
autoscale_scale_action_type      = "ChangeCount"
autoscale_scale_action_value     = "1"
autoscale_scale_action_cooldown  = "PT1M"
autoscale_scale_action_direction_dec = "Decrease"