resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.virtual_network_address_space
}

resource "azurerm_subnet" "integrationsubnet" {
  name                 = var.integration_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_1")].ip]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "endpointsubnet" {
  name                                           = "endpointsubnet"
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_2")].ip]
  enforce_private_link_endpoint_network_policies = true
}


resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id  = azurerm_app_service.main.id
  subnet_id       = azurerm_subnet.integrationsubnet.id
}

resource "azurerm_subnet" "container_instance_subnet" {
  name                 = var.container_instance_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_addresses[index(var.subnet_addresses.*.name, "snet_3")].ip]
  
  delegation {
    name = "acidelegationservice"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}