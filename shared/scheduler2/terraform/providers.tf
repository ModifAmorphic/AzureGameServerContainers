terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "gaming"
    storage_account_name = "persistantgamestorage"
    container_name       = "tfstate"
    key                  = "scheduler2.tfstate"
  }
}

provider "azurerm" {
  features {}
}