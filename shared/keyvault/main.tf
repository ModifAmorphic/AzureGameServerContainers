data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "gaming_keyvault" {
  name                        = "gaming-keyvault"
  location                    = data.azurerm_resource_group.gaming.location
  resource_group_name         = data.azurerm_resource_group.gaming.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "vm-ssh-key-private"
  value        = tls_private_key.vm_ssh_key.private_key_openssh
  key_vault_id = azurerm_key_vault.gaming_keyvault.id
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "vm-ssh-key-public"
  value        = tls_private_key.vm_ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.gaming_keyvault.id
}