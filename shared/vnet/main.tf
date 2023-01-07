data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

# Create virtual network
resource "azurerm_virtual_network" "gaming_vnet" {
  name                = "gaming-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
}

# Create subnet
resource "azurerm_subnet" "gaming_subnet" {
  name                 = "gaming-subnet"
  resource_group_name  = data.azurerm_resource_group.gaming.name
  virtual_network_name = azurerm_virtual_network.gaming_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}