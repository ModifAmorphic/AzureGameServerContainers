data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

 data "azurerm_storage_account" "gamestorage" {
   name                     = "persistantgamestorage"
   resource_group_name      = data.azurerm_resource_group.gaming.name
}

data "azurerm_network_security_group" "gaming-nsg" {
  name                = "gaming-nsg"
  resource_group_name = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault" "gaming_keyvault" {
  name                        = "gaming-keyvault"
  resource_group_name         = data.azurerm_resource_group.gaming.name
}

data "azurerm_key_vault_secret" "server_pass" {
  name      = "ValheimSanitysRefugePassword"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

data "azurerm_key_vault_secret" "discord_valheim_webhook" {
  name      = "ValheimSanitysRefugeDiscordWebhook"
  key_vault_id = data.azurerm_key_vault.gaming_keyvault.id
}

locals {
  env_secrets = {
    PASSWORD = "${data.azurerm_key_vault_secret.server_pass.value}"
    PRE_BOOTSTRAP_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"${var.discord_starting_json}\" ${data.azurerm_key_vault_secret.discord_valheim_webhook.value}"
    POST_SERVER_LISTENING_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"${var.discord_ready_json}\" ${data.azurerm_key_vault_secret.discord_valheim_webhook.value}"
  }
  server_env_vars = merge(local.env_secrets, var.env_vars)
}

##Storage Account File Shares
resource "azurerm_storage_share" "valheim-saves" {
  name                 = var.azure_saves_share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 5
}

resource "azurerm_storage_share" "valheim-server" {
  name                 = var.azure_server_share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 10
}

resource "azurerm_storage_share" "valheim-backups" {
  name                 = var.azure_backups_share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 5
}

# resource "azurerm_storage_share" "valheim-logs" {
#   name                 = var.azure_logs_share
#   storage_account_name = data.azurerm_storage_account.gamestorage.name
#   quota                = 5
# }

resource "azurerm_container_group" "valheim" {
  name                = "${var.container_name}"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns-name}"
  os_type             = "Linux"

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 2456
      protocol = "UDP"
    }

    ports {
      port     = 2457
      protocol = "UDP"
    }

    environment_variables = local.server_env_vars

    volume {
      name       = var.azure_saves_share
      mount_path = "/home/valheim/valheim-saves"
      read_only  = false
      share_name = azurerm_storage_share.valheim-saves.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }

    volume {
      name       = var.azure_server_share
      mount_path = "/home/valheim/valheim-server"
      read_only  = false
      share_name = azurerm_storage_share.valheim-server.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }

    volume {
      name       = var.azure_backups_share
      mount_path = "/home/valheim/valheim-backups"
      read_only  = false
      share_name = azurerm_storage_share.valheim-backups.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }

    # volume {
    #   name       = var.azure_logs_share
    #   mount_path = "/home/valheim/valheim-logs"
    #   read_only  = false
    #   share_name = azurerm_storage_share.valheim-logs.name

    #   storage_account_name = data.azurerm_storage_account.gamestorage.name
    #   storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    # }
    
  }
}