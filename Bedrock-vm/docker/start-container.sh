#!/bin/sh

storageAccount="persistantgamestorage"
resourceGroup="gaming"
azureShareName="minecraft-thewilds-data"
dockerVolName="mcwilds"

#Login to Azure using Managed Identity
az login --identity

# This command assumes you have logged in with az login
httpEndpoint=$(az storage account show \
        --resource-group $resourceGroup \
        --name $storageAccount \
        --query "primaryEndpoints.file" --output tsv | tr -d '"')

smbPath=$(echo $httpEndpoint | cut -c7-${#httpEndpoint})$azureShareName
fileHost=$(echo $smbPath | tr -d "/")

mntPath="/azmounts/$storageAccount/$azureShareName"
mkdir -p "$mntPath"

storageKey=$(az storage account keys list --resource-group ${resourceGroup} --account-name ${storageAccount} --query [0].value -otsv)
sudo mount -t cifs $smbPath $mntPath -o username=$storageAccount,password="$storageKey",serverino,nosharesock,actimeo=30

docker compose up