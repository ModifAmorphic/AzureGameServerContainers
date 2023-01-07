data "azurerm_subscription" "primary" {
}

data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

data "azurerm_storage_account" "gamestorage" {
  name                     = var.storageAccount
  resource_group_name      = var.storageAccountRg
}

data "azurerm_network_security_group" "gaming_nsg" {
  name                = "gaming-nsg"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault" "gaming_keyvault" {
  name                        = "gaming-keyvault"
  resource_group_name         = data.azurerm_resource_group.gaming.name
}

##Storage Account File Shares
resource "azurerm_storage_share" "minecraft_data" {
  name                 = var.fileShareName
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 10
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

# # Create virtual machine
# resource "azurerm_linux_virtual_machine" "docker_host_vm" {
#   name                  = var.vmName
#   location              = data.azurerm_resource_group.gaming.location
#   resource_group_name   = data.azurerm_resource_group.gaming.name
#   network_interface_ids = [azurerm_network_interface.nic1.id]
#   size                  = "Standard_B2s"
  
#   computer_name                   = "${var.vmName}"
#   admin_username                  = var.adminUsername
#   disable_password_authentication = true

#   os_disk {
#     name                 = "${var.vmName}-disk-os"
#     caching              = "ReadWrite"
#     #Can't go smaller than 30 gb for this image
#     #disk_size_gb         = 15
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-minimal-jammy"
#     sku       = "minimal-22_04-lts-gen2"
#     version   = "latest"
#   }

#   admin_ssh_key {
#     username   = var.adminUsername
#     public_key = "${data.azurerm_key_vault_secret.ssh_public_key.value}"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   # boot_diagnostics {
#   #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
#   # }
# }