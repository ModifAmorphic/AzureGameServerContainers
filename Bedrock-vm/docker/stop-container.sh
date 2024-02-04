#!/bin/sh

storageAccount="persistantgamestorage"
azureShareName="minecraft-thewilds-data"

mntPath="/azmounts/$storageAccount/$azureShareName"

echo "Stopping Bedrock Container - The Wilds"
docker compose -f /opt/bedrock-thewilds/docker-compose.yml down --volumes

# echo "Unmounting Azure File Share $smbPath"
# sudo unmount "$mntPath"