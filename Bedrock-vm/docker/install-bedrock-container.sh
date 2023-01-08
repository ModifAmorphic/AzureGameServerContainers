storageAccount="persistantgamestorage"
resourceGroup="gaming"
azureShareName="minecraft-thewilds-data"
dockerVolName="mcwilds"

#Login to Azure using Managed Identity
az login --identity

storageKey=$(az storage account keys list --resource-group ${resourceGroup} --account-name ${storageAccount} --query [0].value -otsv)

#PERSISTANT_GAME_STORAGE_CNN=$(az storage account show-connection-string --resource-group gaming --name persistantgamestorage --query connectionString -otsv)
docker plugin install --alias cloudstor:${storageAccount} --grant-all-permissions docker4x/cloudstor:17.06.2-ee-23-azure1 CLOUD_PLATFORM=AZURE AZURE_STORAGE_ACCOUNT_KEY="${storageKey}" AZURE_STORAGE_ACCOUNT="${storageKey}" AZURE_STORAGE_ENDPOINT="core.windows.net" DEBUG=1
docker volume create --driver cloudstor:${storageAccount} --opt share=${azureShareName} --name ${dockerVolName}
