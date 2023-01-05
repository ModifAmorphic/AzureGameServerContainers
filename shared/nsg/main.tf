data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

resource "azurerm_network_security_group" "gaming-nsg" {
  name                = "gaming-nsg"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
}