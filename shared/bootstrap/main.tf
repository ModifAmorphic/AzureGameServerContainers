data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "gaming" {
  location = "southcentralus"
  name     = "gaming"
}

resource "azurerm_storage_account" "persistantgamestorage" {
  name                     = "persistantgamestorage"
  resource_group_name      = azurerm_resource_group.gaming.name
  location                 = azurerm_resource_group.gaming.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.persistantgamestorage.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "githubActions" {
  location            = azurerm_resource_group.gaming.location
  name                = "github-actions-identity"
  resource_group_name = azurerm_resource_group.gaming.name
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.githubActions.principal_id
}

resource "azurerm_role_definition" "role_contributor" {
  name        = "Role Contributor"
  scope       = data.azurerm_subscription.current.id
  description = "Allows reading, writing, and deleting of role definitions and assignments."

  permissions {
    actions     = [
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",
      "Microsoft.Authorization/roleDefinitions/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.Authorization/roleAssignments/read"
      ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_assignment" "role_contributor_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.role_contributor.name
  principal_id         = azurerm_user_assigned_identity.githubActions.principal_id
}

locals {
  repoName = "AzureGameServerContainers"
  githubOrgName = "ModifAmorphic"
  environment = "vs-subscription"
}

# Setup OIDC Federated Login for Github Actions use
resource "azurerm_federated_identity_credential" "GithubOidc" {
  name                = local.repoName
  resource_group_name =  azurerm_resource_group.gaming.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.githubActions.id
  subject             = "repo:${local.githubOrgName}/${local.repoName}"

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = "./local-exec/enable-repo-subject.sh ${local.githubOrgName} ${local.repoName}" 
  }
}

resource "null_resource" "createGithubEnvironment" {
  # Create Github Environment
  provisioner "local-exec" {
    command = "gh api --method PUT -H \"Accept: application/vnd.github+json\" repos/${local.githubOrgName}/${local.repoName}/environments/${local.environment}" 
  }
}

resource "null_resource" "createGithubSecrets" {
  # Set env secrets everytime this runs
  triggers = {
    script_hash = "${sha256(timestamp())}"
  }
  depends_on = [ null_resource.createGithubEnvironment ]

  #Create AZURE_TENANT_ID Secret
  provisioner "local-exec" {
    command = "echo \"AZURE_TENANT_ID=${data.azurerm_subscription.current.tenant_id}\" | gh secret set --env \"${local.environment}\" -f -"
  }

  #Create AZURE_SUBSCRIPTION_ID Secret
  provisioner "local-exec" {
    command = "echo \"AZURE_SUBSCRIPTION_ID=${data.azurerm_subscription.current.subscription_id}\" | gh secret set --env \"${local.environment}\" -f -"
  }

  #Create AZURE_OIDC_CLIENT_ID Secret
  provisioner "local-exec" {
    command = "echo \"AZURE_OIDC_CLIENT_ID=${azurerm_user_assigned_identity.githubActions.client_id}\" | gh secret set --env \"${local.environment}\" -f -"
  }
}
