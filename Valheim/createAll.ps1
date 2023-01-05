az group create --name gaming --location southcentralus

Write-Output "Creating Storage Account 'persistantgamestorage'"
az storage account create --resource-group gaming --name persistantgamestorage --location southcentralus --sku Standard_LRS --kind StorageV2

Write-Output "Creating storage account share 'valheim'"
az storage share create --name valheim-config --account-name persistantgamestorage
az storage share create --name valheim-server --account-name persistantgamestorage

Write-Output "Opening Valheim Server Ports for client connections."
az network nsg rule create --name ValheimServers `
                           --nsg-name gaming-nsg `
                           --priority 130 `
                           --resource-group gaming `
                           --access Allow `
                           --description "UDP Ports clients need open to connect to a Valheim Server" `
                           --destination-port-ranges 2456-2457 `
                           --direction Inbound `
                           --protocol Udp `

.\createContainer.ps1