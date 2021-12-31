
variable "prefix" {
  type        = string
  description = "Short name of the project"
}

variable "resource_group_name" {
  type              = string
  description       = "Name of the Resource Group"
}

variable "resource_location" {
  type              = string
  description = "The Azure location where all resources for the application should be created"
}

variable "environment" {
  type        = string
  description = "Name of the target environment where the applicatin should be deployed"
}

variable "app_container_image_name_tag" {
  type        = string
  description = "Application Container image name and tag"
}

locals {
  region_abbrev                 = lookup({ japaneast = "ejpn" }, var.resource_location, "ejpn")
  environment_abbrev            = lower(substr(var.environment, 0, 1)) # first letter of environment
  environment_abbrev_long       = lookup({ development = "dev" }, lower(var.environment), "dev")
  resource_group_name           = "rg-${var.prefix}-${local.region_abbrev}-${local.environment_abbrev}"

  app_service_plan_name         = "${var.prefix}-apsp-${local.region_abbrev}-${local.environment_abbrev}"
  app_service_name              = "${var.prefix}-appservice-${local.region_abbrev}-${local.environment_abbrev}"
  app_service_linux_fx_version  = "DOCKER|${var.app_container_image_name_tag}"

  container_registry_name       = "${var.prefix}acr${local.region_abbrev}${local.environment_abbrev}" 
  docker_registry_server_url    = "https://${azurerm_container_registry.acr.login_server}"  # url doesn't have https

  viper_db_user = upper(format("%s_%s",var.viper_prefix,"DbUser"))
  viper_db_password = upper(format("%s_%s",var.viper_prefix,"DbPassword"))
  viper_db_name = upper(format("%s_%s",var.viper_prefix,"DbName"))
  viper_db_port = upper(format("%s_%s",var.viper_prefix,"DbPort"))
  viper_db_host = upper(format("%s_%s",var.viper_prefix,"DbHost"))
  viper_db_host_name = upper(format("%s_%s",var.viper_prefix,"DbHostName"))
  viper_listen_host = upper(format("%s_%s",var.viper_prefix,"ListenHost"))
  viper_listen_port = upper(format("%s_%s",var.viper_prefix,"ListenPort"))
}


variable "virtual_network" {
  type        = string
  description = "Name of the virtual network where the applicatin should be deployed"
}

variable "virtual_network_address_space" {
  type        = list
  description = "Address space of the virtual network where the applicatin should be deployed"
}


variable "app_service_plan_kind" {
  type        = string
  description = "App service plan Kind"
}

variable "app_service_plan_sku_tier" {
  type        = string
  description = "App service plan Stock Keeping Unit tier"
}

variable "app_service_plan_sku_size" {
  type        = string
  description = "App service plan Stock Keeping Unit size"
}

variable "tag_managed_by" {
  type        = string
  description = "ManagedBy tag"
}

variable "tag_provisioned_with" {
  type        = string
  description = "ProvisionedWith tag"
}

variable "app_service_app_command_line" {
  type        = string
  description = "App service command"
}

variable "app_service_website_dns_server" {
  type        = string
  description = "App service website DNS server"
}

variable "app_service_website_vnet_route_all" {
  type        = string
  description = "App service website VNET route all flag"
}

variable "app_service_website_enable_storage" {
  type        = string
  description = "App service website enable storage flag "
}

variable "app_service_website_container_start_time_limit" {
  type        = string
  description = "App service website container start time"
}

variable "app_service_website_port" {
  type        = string
  description = "App service website port"
}

variable "app_service_port" {
  type        = string
  description = "App service port"
}

variable "app_service_monitor_autoscale_name" {
  type        = string
  description = "App service auto scale name"
}

variable "container_registry_sku" {
  type        = string
  description = "Container registry SKU"
}

variable "container_registry_admin_enabled" {
  type        = string
  description = "Container registry admin_enabled flag"
}

variable private_dns_zone_name {
  type        = string
  description = "Private DNS zone name"
}

variable private_dns_zone_virtual_network_link_name {
  type        = string
  description = "Private DNS zone virtual network link name"
}

variable private_endpoint_name {
  type        = string
  description = "Private endpoint name"
}


variable private_dns_zone_group_name {
  type        = string
  description = "Private DNS zone Group name"
}

variable private_service_connection_name {
  type        = string
  description = "Private service connection name"
}

variable postgresql_server_name {
  type        = string
  description = "Postgresssl server name"
}

variable postgresql_server_sku_name {
  type        = string
  description = "Postgresssl SKU name"
}


variable postgresql_server_storage_mb {
  type        = string
  description = "Postgresssl server storage mb"
}

variable postgresql_server_backup_retention_days {
  type        = string
  description = "Postgresssl server backup retention days"
}

variable postgresql_server_geo_redundant_backup_enabled {
  type        = string
  description = "Postgresssl geo redundant backup enabled"
}

variable postgresql_server_auto_grow_enabled {
  type        = string
  description = "Postgresssl server auto grow enabled flag"
}

variable postgresql_server_administrator_login {
  type        = string
  description = "Postgresssl server admin login"
}

variable postgresql_server_version {
  type        = string
  description = "Postgresssl server version"
}

variable postgresql_server_ssl_enforcement_enabled {
  type        = string
  description = "Postgresssl server ssl enforcement enabled flag"
}

variable postgresql_database_name {
  type        = string
  description = "Postgresssl database name"
}

variable postgresql_database_charset {
  type        = string
  description = "Postgresssl database charset"
}

variable postgresql_database_collation {
  type        = string
  description = "Postgresssl database collation"
}

variable postgresql_firewall_rule_name {
  type        = string
  description = "Postgresssl firewall rule"
}

variable postgresql_firewall_rule_start_ip_address {
  type        = string
  description = "Postgresssl firewall rule startup ip address"
}

variable postgresql_firewall_rule_end_ip_address {
  type        = string
  description = "Postgresssl firewall rule end ip address"
}

variable "viper_prefix" {
  type        = string
  description = "The viper prefix used on environment variables"
}


variable key_vault_name {
  type        = string
  description = "Vault name"
}

variable key_vault_sku_name {
  type        = string
  description = "Vault SKU name"
}

variable key_vault_secret_name {
  type        = string
  description = "Vault secret name"
}

variable key_vault_postgress_secret_value {
  type        = string
  description = "Vault secret value"
}


variable autoscale_capacity_default {
  type        = string
  description = "Auto scale setting for default capacity"
}

variable autoscale_capacity_minimum {
  type        = string
  description = "Auto scale setting for capacity minimum"
}

variable autoscale_capacity_maximum {
  type        = string
  description = "Auto scale setting for capacity maximum"
}

variable autoscale_metric_trigger_metric_name {
  type        = string
  description = "Auto scale setting for trigger metric name"
}

variable autoscale_metric_trigger_time_grain {
    type        = string
  description = "Auto scale setting for trigger metric time"
}

variable autoscale_metric_trigger_statistic {
  type        = string
  description = "Auto scale setting for trigger statistic"
} 

variable autoscale_metric_trigger_time_window {
  type        = string
  description = "Auto scale setting for trigger time window"
} 

variable autoscale_metric_trigger_time_aggregation {
  type        = string
  description = "Auto scale setting for time aggregation"
} 

variable autoscale_metric_trigger_operator_gt {
  type        = string
  description = "Auto scale setting for trigger operator greater than"
} 

variable autoscale_metric_trigger_operator_lt {
  type        = string
  description = "Auto scale setting for trigger operator less than"
} 

variable autoscale_metric_trigger_threshold {
  type        = string
  description = "Auto scale setting for trigger threshold"
} 

variable autoscale_scale_action_direction_inc {
  type        = string
  description = "Auto scale setting for scale action increase direction"
} 

variable autoscale_scale_action_type {
  type        = string
  description = "Auto scale setting for scale action type"
} 

variable autoscale_scale_action_value  {
  type        = string
  description = "Auto scale setting for scale action value"
} 

variable autoscale_scale_action_cooldown {
  type        = string
  description = "Auto scale setting for scale action cooldown"
} 

variable autoscale_scale_action_direction_dec {
  type        = string
  description = "Auto scale setting for scale action decrease direction"
} 
   