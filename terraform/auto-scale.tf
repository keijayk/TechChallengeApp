# Create auto scale setting for app service
resource "azurerm_monitor_autoscale_setting" "autoscale_setting" {
  name                = var.app_service_monitor_autoscale_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  target_resource_id  = azurerm_app_service_plan.app_service_plan.id

  profile {
    name = "defaultProfile"

    capacity {
      default = var.autoscale_capacity_default
      minimum = var.autoscale_capacity_minimum
      maximum = var.autoscale_capacity_maximum
    }

    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_trigger_metric_name
        metric_resource_id = azurerm_app_service_plan.app_service_plan.id
        time_grain         = var.autoscale_metric_trigger_time_grain
        statistic          = var.autoscale_metric_trigger_statistic
        time_window        = var.autoscale_metric_trigger_time_window
        time_aggregation   = var.autoscale_metric_trigger_time_aggregation
        operator           = var.autoscale_metric_trigger_operator_gt
        threshold          = var.autoscale_metric_trigger_threshold
      }

      scale_action {
        direction = var.autoscale_scale_action_direction_inc
        type      = var.autoscale_scale_action_type
        value     = var.autoscale_scale_action_value
        cooldown  = var.autoscale_scale_action_cooldown
      }
    }

    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_trigger_metric_name
        metric_resource_id = azurerm_app_service_plan.app_service_plan.id
        time_grain         = var.autoscale_metric_trigger_time_grain
        statistic          = var.autoscale_metric_trigger_statistic
        time_window        = var.autoscale_metric_trigger_time_window
        time_aggregation   = var.autoscale_metric_trigger_time_aggregation
        operator           = var.autoscale_metric_trigger_operator_lt
        threshold          = var.autoscale_metric_trigger_threshold
      }

      scale_action {
        direction = var.autoscale_scale_action_direction_dec
        type      = var.autoscale_scale_action_type
        value     = var.autoscale_scale_action_value
        cooldown  = var.autoscale_scale_action_cooldown
      }
    }
  } 
}