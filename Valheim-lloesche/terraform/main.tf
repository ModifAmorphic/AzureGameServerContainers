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
    SERVER_PASS = "${data.azurerm_key_vault_secret.server_pass.value}"
    PRE_BOOTSTRAP_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"${var.discord_starting_json}\" ${data.azurerm_key_vault_secret.discord_valheim_webhook.value}"
    POST_SERVER_LISTENING_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"${var.discord_ready_json}\" ${data.azurerm_key_vault_secret.discord_valheim_webhook.value}"
  }
  server_env_vars = merge(local.env_secrets, var.env_vars)
}

## NSG Rules
resource "azurerm_network_security_rule" "valheim-servers" {
  name                       = "ValheimServers"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "2456-2457"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = data.azurerm_resource_group.gaming.name
  network_security_group_name = data.azurerm_network_security_group.gaming-nsg.name
}

##Storage Account File Shares
resource "azurerm_storage_share" "valheim-config" {
  name                 = var.config-share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 10
}

resource "azurerm_storage_share" "valheim-server" {
  name                 = var.server-share
  storage_account_name = data.azurerm_storage_account.gamestorage.name
  quota                = 15
}

resource "azurerm_container_group" "valheim" {
  name                = "${var.container_name}"
  location            = data.azurerm_resource_group.gaming.location
  resource_group_name = data.azurerm_resource_group.gaming.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns-name}"
  os_type             = "Linux"

  container {
    name   = var.container_name
    image  = "lloesche/valheim-server"
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
      name       = var.config-share
      mount_path = "/config"
      read_only  = false
      share_name = azurerm_storage_share.valheim-config.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }

    volume {
      name       = var.server-share
      mount_path = "/opt/valheim"
      read_only  = false
      share_name = azurerm_storage_share.valheim-server.name

      storage_account_name = data.azurerm_storage_account.gamestorage.name
      storage_account_key  = data.azurerm_storage_account.gamestorage.primary_access_key
    }
  }

}