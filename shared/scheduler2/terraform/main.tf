data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "schedulers" {
  location = "southcentralus"
  name     = "gaming-schedulers2"
}

resource "azurerm_application_insights" "schedulerai" {
  name                = "gameservers-scheduler-ai-2"
  location            = azurerm_resource_group.schedulers.location
  resource_group_name = azurerm_resource_group.schedulers.name
  application_type    = "web"
}

resource "azurerm_service_plan" "scheduler_asp" {
  name                = "scheduler-asp2"
  resource_group_name = azurerm_resource_group.schedulers.name
  location            = azurerm_resource_group.schedulers.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_account" "functions_storage" {
  name                     = "gamingfunctionsstorage2"
  resource_group_name      = azurerm_resource_group.schedulers.name
  location                 = azurerm_resource_group.schedulers.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Create the function app
resource "azurerm_linux_function_app" "scheduler" {
  name                       = "gameservers-scheduler2"
  resource_group_name        = azurerm_resource_group.schedulers.name
  location                   = azurerm_resource_group.schedulers.location
  storage_account_name       = azurerm_storage_account.functions_storage.name
  storage_account_access_key = azurerm_storage_account.functions_storage.primary_access_key
  # storage_uses_managed_identity = "true"
  service_plan_id = azurerm_service_plan.scheduler_asp.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
  app_settings = {
    DiscordStartServerAppKey              = "02d204735b24106608045d758f1998c62608eabb705e07cf8683fc0451a6ad42",
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.schedulerai.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.schedulerai.connection_string
  }
}

data "azurerm_role_definition" "container_manager_role" {
  name  = "Container Instance Manager"
  scope = data.azurerm_subscription.primary.id
}

data "azurerm_role_definition" "vm_scheduler_role" {
  name  = "Virtual Machine Scheduler"
  scope = data.azurerm_subscription.primary.id
}

# Assign the Container Manager role to the function app's Managed Identity
resource "azurerm_role_assignment" "container_manager_role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = data.azurerm_role_definition.container_manager_role.name
  principal_id         = azurerm_linux_function_app.scheduler.identity[0].principal_id
}

resource "azurerm_role_assignment" "vm_scheduler_role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = data.azurerm_role_definition.vm_scheduler_role.name
  principal_id         = azurerm_linux_function_app.scheduler.identity[0].principal_id
}