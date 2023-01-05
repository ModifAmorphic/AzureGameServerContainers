resource "azurerm_resource_group" "gaming" {
  location = "southcentralus"
  name     = "gaming"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "persistantgamestorage"
  resource_group_name      = azurerm_resource_group.gaming.name
  location                 = azurerm_resource_group.gaming.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}