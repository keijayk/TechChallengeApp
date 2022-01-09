# Create container instance for updating the database
resource "null_resource" "updatedb_container_create" {
      provisioner "local-exec" {
      command = <<-EOT
      az container create --resource-group ${azurerm_resource_group.resource_group.name} \
      --name ${var.container_name} \
      --image ${local.app_container_image}  \
      --ports ${var.app_service_port} --command-line "./TechChallengeApp updatedb" \
      --subnet ${azurerm_subnet.container_instance_subnet.name} \
      --vnet ${azurerm_virtual_network.virtual_network.name} \
      --restart-policy Never \
      --environment-variables "VTT_DBPASSWORD"="${azurerm_key_vault_secret.postgres_key_vault_secret.value}"  \
      "VTT_DBUSER"="${var.postgresql_db_user}"  "VTT_DBUSERWITHHOST"="${var.postgresql_db_user_with_host}"   \
      "VTT_DBHOST"="${var.postgresql_db_host}"  "VTT_DBLISTENHOST"="${var.postgresql_db_listen_host}" \
      --registry-username ${azurerm_container_registry.container_registry.admin_username} \
      --registry-password ${azurerm_container_registry.container_registry.admin_password}
      EOT
      }

      depends_on = [azurerm_postgresql_server.postgresql_server, azurerm_postgresql_database.postgresql_database, azurerm_key_vault_secret.postgres_key_vault_secret]
}

# Remove container instance created for updating the database
resource "null_resource" "updatedb_container_remove" {
      provisioner "local-exec" {
      command = <<-EOT
      ../scripts/check_status.sh "${azurerm_resource_group.resource_group.name}" "${var.container_name}"  \
      "${var.expected_log_message}"
      az container delete --yes --resource-group ${azurerm_resource_group.resource_group.name} \
      --name ${var.container_name}
      EOT
      }

      depends_on = [null_resource.updatedb_container_create]
}

# Push application container image to registry
resource "null_resource" "docker_push" {
      provisioner "local-exec" {
      command = <<-EOT
        docker tag ${var.app_container_image_name_tag} ${local.app_container_image}
        docker login --username ${azurerm_container_registry.container_registry.admin_username}  \
        --password ${azurerm_container_registry.container_registry.admin_password}  \
        ${azurerm_container_registry.container_registry.login_server}
        docker push ${local.app_container_image}
      EOT
      }

      depends_on = [azurerm_container_registry.container_registry, azurerm_role_assignment.role_assignment ]
}