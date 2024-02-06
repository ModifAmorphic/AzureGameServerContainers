SUBSCRIPTION_ID="$(az account show --query id -otsv)"
RESOUCE_GROUP="gaming"
GITHUB_IDENTITY_NAME="github-actions-identity"

terraform import azurerm_resource_group.gaming "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOUCE_GROUP}"
terraform import azurerm_storage_account.persistantgamestorage "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOUCE_GROUP}/providers/Microsoft.Storage/storageAccounts/persistantgamestorage"
terraform import azurerm_storage_container.tfstate "https://persistantgamestorage.blob.core.windows.net/tfstate"

# Import User Assigned ID for Github Actions
terraform import azurerm_user_assigned_identity.githubActions "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOUCE_GROUP}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${GITHUB_IDENTITY_NAME}"

# Import Contributor Role assignment to GitHub User Assigned ID
identityPrincipalId=$(az identity show --name $GITHUB_IDENTITY_NAME --resource-group gaming --query principalId -otsv)
roleAssignId=$(az role assignment list --query "[?roleDefinitionName=='Contributor' && principalId=='$identityPrincipalId'].id" -otsv)
terraform import azurerm_role_assignment.contributor "$roleAssignId"

# Import Federated Credential for OIDC with github
federatedCredentailId=$(az identity federated-credential show \
                        --identity-name $GITHUB_IDENTITY_NAME \
                        --resource-group $RESOUCE_GROUP \
                        --name AzureGameServerContainers \
                        --query 'id' -otsv)
#Fix "resourcegroup" casing to "resourceGroup"
federatedCredentailId=${federatedCredentailId//resourcegroups/resourceGroups}
terraform import azurerm_federated_identity_credential.GithubOidc "$federatedCredentailId"