data "azurerm_resource_group" "gaming" {
  name = "gaming"
}

data "azurerm_storage_account" "gamestorage" {
  name                = "persistantgamestorage"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

data "azurerm_network_security_group" "gaming-nsg" {
  name                = "gaming-nsg"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault" "gaming_keyvault" {
  name                = "gaming-keyvault"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault_secret" "server_pass" {
  name      = "PalworldPassword"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

data "azurerm_key_vault_secret" "discord_webhook" {
  name      = "PalworldDiscordServerWebhook"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

locals {
  env_secrets = {
    SERVER_PASSWORD = data.azurerm_key_vault_secret.server_pass.value
    DISCORD_WEBHOOK = data.azurerm_key_vault_secret.discord_webhook.value
  }
  server_env_vars = merge(local.env_secrets, var.env_vars)
  #server_env_vars = var.env_vars
}

##Storage Account File Shares

resource "azurerm_storage_share" "game-server" {
  name                 = var.azure_server_share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 10
}

resource "azurerm_container_group" "this" {
  name                        = var.container_name
  location                    = var.location #data.azurerm_resource_group.gaming.location
  resource_group_name         = data.azurerm_resource_group.gaming.name
  ip_address_type             = "Public"
  dns_name_label              = var.dns-name
  os_type                     = "Linux"
  dns_name_label_reuse_policy = "SubscriptionReuse"
  priority                    = var.priority

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.cpu
    memory = var.memory

    dynamic "ports" {
      for_each = toset(var.ports)
      content {
        port = ports.value.port
        protocol = ports.value.protocol
      }
    }

    environment_variables = local.server_env_vars

    volume {
      name       = var.azure_server_share
      mount_path = "/home/palworld/palworld-server"
      read_only  = false
      share_name = azurerm_storage_share.game-server.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }
  }
}