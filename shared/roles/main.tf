data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

data "azurerm_subscription" "primary" {
}

# resource "azurerm_role_definition" "storage_account_role" {
#   name        = "Storage Account Manager"
#   scope       = data.azurerm_subscription.primary.id
#   description = "Allow full access to the Azure Container Instance container group resources. Custom role created with Terraform."

#   permissions {
#     actions     = [
#       "Microsoft.ContainerInstance/containerGroups/*",
#       "Microsoft.Resources/subscriptions/resourcegroups/read"
#       ]
#     not_actions = []
#   }

#   assignable_scopes = [
#     data.azurerm_subscription.primary.id, # /subscriptions/00000000-0000-0000-0000-000000000000
#   ]
# }