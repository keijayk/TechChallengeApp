# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.virtual_network_address_space
}

# Create subnet for app service
resource "azurerm_subnet" "integration_subnet" {
  name                 = var.integration_subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_1")].ip]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# Create virtual network swift connection for app service
resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id  = azurerm_app_service.app_service.id
  subnet_id       = azurerm_subnet.integration_subnet.id
}

# Create subnet for container instance
resource "azurerm_subnet" "container_instance_subnet" {
  name                 = var.container_instance_subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_3")].ip]
  
  delegation {
    name = "acidelegationservice"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Create endpoint subnet for postgressql database
resource "azurerm_subnet" "endpoint_subnet" {
  name                                           = var.endpoint_subnet_name
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.virtual_network.name
  address_prefixes                               = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_2")].ip]
  enforce_private_link_endpoint_network_policies = true
}

# Create private dns zone for postgressql database
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Create private dns zone vrtual network link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}

# Create private endpoint
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