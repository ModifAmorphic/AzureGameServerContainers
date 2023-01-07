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

data "azurerm_subnet" "gaming_subnet" {
  name                 = "gaming-subnet"
  virtual_network_name = "gaming-vnet"
  resource_group_name  = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault" "gaming_keyvault" {
  name                        = "gaming-keyvault"
  resource_group_name         = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "vm-ssh-key-public"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

data "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "vm-ssh-key-private"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

# Create public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vmName}-public-ip"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "nic1" {
  name                = "${var.vmName}-nic"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name

  ip_configuration {
    name                          = "${var.vmName}-nic-config"
    subnet_id                     = data.azurerm_subnet.gaming_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_nic1_assoc" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = data.azurerm_network_security_group.gaming_nsg.id
}

# ## NSG Rules
# resource "azurerm_network_security_rule" "nsg_inbound_rule1" {
#   name                       = "MinecraftServersUdp"
#   priority                   = 210
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Udp"
#   source_port_range          = "*"
#   destination_port_range     = "19132"
#   source_address_prefix      = "*"
#   destination_address_prefix = "*"
#   resource_group_name         = data.azurerm_resource_group.gaming.name
#   network_security_group_name = data.azurerm_network_security_group.gaming_nsg.name
# }
# resource "azurerm_network_security_rule" "nsg_inbound_rule2" {
#   name                       = "MinecraftServersTcp"
#   priority                   = 220
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_range     = "19132"
#   source_address_prefix      = "*"
#   destination_address_prefix = "*"
#   resource_group_name         = data.azurerm_resource_group.gaming.name
#   network_security_group_name = data.azurerm_network_security_group.gaming_nsg.name
# }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "games_host_vm" {
  name                  = var.vmName
  location              = data.azurerm_resource_group.gaming.location
  resource_group_name   = data.azurerm_resource_group.gaming.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  size                  = "Standard_B2s"
  
  computer_name                   = "${var.vmName}"
  admin_username                  = var.adminUsername
  disable_password_authentication = true

  os_disk {
    name                 = "${var.vmName}-disk-os"
    caching              = "ReadWrite"
    #Can't go smaller than 30 gb for this image
    #disk_size_gb         = 15
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.adminUsername
    public_key = "${data.azurerm_key_vault_secret.ssh_public_key.value}"
  }

  identity {
    type = "SystemAssigned"
  }

  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }
}

# Grant VM's managed identity access to storage account file shares
resource "azurerm_role_assignment" "storage_share_role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = azurerm_linux_virtual_machine.games_host_vm.identity[0].principal_id
}

# Needs SSH access. Public IP or Bastion Standard
# #Copy over the docker install script.
# resource "null_resource" remoteExecProvisionerWFolder {

#   provisioner "file" {
#     source      = "install_docker.sh"
#     destination = "~/install_docker.sh"
#   }

#   connection {
#     host     = "${azurerm_virtual_machine.azurerm_linux_virtual_machine.ip_address}"
#     type     = "ssh"
#     user     = "${var.adminUsername}"
#     private_key = "${data.azurerm_key_vault_secret.ssh_private_key.value}"
#     agent    = "false"
#   }
# }