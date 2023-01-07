# Reference gaming rg
data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

# Reference VNet
data "azurerm_virtual_network" "gaming_vnet" {
  name                = "gaming-vnet"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

# Create Resource Group
resource "azurerm_resource_group" "bastion" {
  location = "southcentralus"
  name     = var.resource_group
}

# Create subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.gaming.name
  virtual_network_name = data.azurerm_virtual_network.gaming_vnet.name
  address_prefixes     = var.subnet_addresses
}

# Create NSG
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
}
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
  sku                 = var.bastion_sku

  ip_configuration {
    name                 = "bastion-host-ipconfig"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}

#Assign NSG to Bastion Vnet
resource "azurerm_subnet_network_security_group_association" "bastion_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
  subnet_id = azurerm_subnet.bastion_subnet.id
}

## NSG Inbound Rules
resource "azurerm_network_security_rule" "rule_allowHttpsInbound" {
  name                       = "AllowHttpsInbound"
  priority                   = 120
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "Internet"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}
resource "azurerm_network_security_rule" "rule_allowGatewayManagerInbound" {
  name                       = "AllowGatewayManagerInbound"
  priority                   = 130
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "GatewayManager"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}
resource "azurerm_network_security_rule" "rule_allowBastionHostCommunication1" {
  name                       = "AllowBastionHostCommunication1"
  priority                   = 150
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     ="8080"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "rule_allowBastionHostCommunication2" {
  name                       = "AllowBastionHostCommunication2"
  priority                   = 160
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     ="5701"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

## NSG Outbound Rules
resource "azurerm_network_security_rule" "rule_allowSshRdpOutbound" {
  name                       = "AllowSshRdpOutbound"
  priority                   = 100
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_ranges    = [ "22", "3389" ]
  source_address_prefix      = "*"
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "rule_allowAzureCloudOutbound" {
  name                       = "AllowAzureCloudOutbound"
  priority                   = 120
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "AzureCloud"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "rule_allowBastionCommunication1" {
  name                       = "AllowBastionCommunication1"
  priority                   = 130
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "8080"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "rule_allowBastionCommunication2" {
  name                       = "AllowBastionCommunication2"
  priority                   = 140
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range    = "5701"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "rule_allowGetSessionInformation" {
  name                       = "AllowGetSessionInformation"
  priority                   = 150
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "Internet"
  resource_group_name         = azurerm_resource_group.bastion.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

# #Create Private NIC
# resource "azurerm_network_interface" "bastion_internal_nic" {
#   name                = "bastion-internal-nic"
#   resource_group_name = azurerm_resource_group.bastion.name
#   location            = azurerm_resource_group.bastion.location

#   ip_configuration {
#     name                          = "bastion-internal-nic-ipconfig"
#     subnet_id                     = azurerm_subnet.bastion_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# #Create Azure Network Interface Cards
# resource "azurerm_network_interface" "bastion_public_nic" {
#   name                = "bastion-public-nic"
#   resource_group_name = azurerm_resource_group.bastion.name
#   location            = azurerm_resource_group.bastion.location

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.bastion_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_interface_security_group_association" "bastion_nsg_assoc" {

#     network_interface_id      = azurerm_network_interface.bastion_internal_nic.id
#     network_security_group_id = azurerm_network_security_group.bastion_nsg.id
# }
