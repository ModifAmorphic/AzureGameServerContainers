data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "gaming" {
  name     = "gaming"
}

resource "azurerm_role_definition" "container_manager_role" {
  name        = "Container Instance Manager"
  scope       = data.azurerm_subscription.current.id
  description = "Allow full access to the Azure Container Instance container group resources. Custom role created with Terraform."

  permissions {
    actions     = [
      "Microsoft.ContainerInstance/containerGroups/*",
      "Microsoft.Resources/subscriptions/resourcegroups/read"
      ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}

resource "azurerm_role_definition" "vm_scheduler_role" {
  name        = "Virtual Machine Scheduler"
  scope       = data.azurerm_subscription.current.id
  description = "Allows listing, starting and stopping of virtual machines. Custom role created with Terraform."

  permissions {
    actions     = [
      "Microsoft.Compute/virtualMachines/*"
      ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}
