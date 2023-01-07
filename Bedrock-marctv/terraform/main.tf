data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

 data "azurerm_storage_account" "gamestorage" {
   name                     = "persistantgamestorage"
   resource_group_name      = data.azurerm_resource_group.gaming.name
}

data "azurerm_network_security_group" "gaming_nsg" {
  name                = "gaming-nsg"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

## NSG Rules
resource "azurerm_network_security_rule" "nsg_inbound_rule1" {
  name                       = "MinecraftServersUdp"
  priority                   = 210
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "19132"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = data.azurerm_resource_group.gaming.name
  network_security_group_name = data.azurerm_network_security_group.gaming_nsg.name
}
resource "azurerm_network_security_rule" "nsg_inbound_rule2" {
  name                       = "MinecraftServersTcp"
  priority                   = 220
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "19132"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = data.azurerm_resource_group.gaming.name
  network_security_group_name = data.azurerm_network_security_group.gaming_nsg.name
}

##Storage Account File Shares
resource "azurerm_storage_share" "minecraft_data" {
  name                 = var.dataShare
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 15
}

resource "azurerm_container_group" "game_aci" {
  name                = "${var.containerName}"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
  ip_address_type     = "Public"
  dns_name_label      = var.dnsName
  os_type             = "Linux"

  container {
    name   = var.containerName
    image  = var.containerImage
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 19132
      protocol = "UDP"
    }

    volume {
      name       = azurerm_storage_share.minecraft_data.name
      mount_path = "${var.worldsMountPath}"
      read_only  = false
      share_name = azurerm_storage_share.minecraft_data.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }
  }

}

