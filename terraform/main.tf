# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}
  tenant_id       = "YOUR TENNANT ID"
  subscription_id = "YOUR SUBSCRIPTION ID"
  client_id       = "YOUR CLIENT ID"
  client_secret   = "YOUR CLIENT SECRET"
}

resource "azurerm_resource_group" "main" {
  name     = "Azuredevops"
  location = var.location
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip-address"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  count               = var.number_of_virtual_machines
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowInternalVMCommunication"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowOutboundVMCommunication"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowLoadBalancerHTTP-TCP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowLoadBalancerHTTP-UDP"
    priority                   = 121
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllFromInternet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count                     = var.number_of_virtual_machines
  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-availability-set"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  managed = true
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-loadbalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend-config"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = "${var.prefix}-loadbalancer-backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.number_of_virtual_machines
  ip_configuration_name   = azurerm_network_interface.main[count.index].ip_configuration[0].name
  network_interface_id    = azurerm_network_interface.main[count.index].id
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}


resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.number_of_virtual_machines
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = azurerm_availability_set.main.id
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  source_image_id = "/subscriptions/ae905fde-e5ea-40f0-a6db-35397678cc4c/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/ubuntu-1804-custom"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    Project = "DevOps-AZ-1"
  }
}
