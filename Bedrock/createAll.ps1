#you need the Azure cli https://docs.microsoft.com/es-es/cli/azure/

#Login to Azure portal
#az login

#defaults to southcentralus but you can change it to one of the following list locations
#az account list-locations --query "[].{Region:name}" --out table
 
#create a new resource group "mineResGroup"
az group create --name gaming --location southcentralus

Write-Output "Creating Storage Account 'persistantgamestorage'"
#put the storage account "acismineacc" into that group
az storage account create --resource-group gaming --name persistantgamestorage --location southcentralus --sku Standard_LRS --kind StorageV2

Write-Output "Creating storage account share 'bedrock'"
#create the volume share "acismineshare" into the storage account
az storage share create --name bedrock --account-name persistantgamestorage

#obtain the key from the account "acismineacc" in the resource group "mineResGroup"
Write-Output "Getting Storage Account Key"
$STORAGE_KEY=$(az storage account keys list --resource-group gaming --account-name persistantgamestorage --query "[0].value" --output tsv)
#echo $STORAGE_KEY

#to actually create the minecraft server int the dns name "minesvrbedrock"
#the server will be running into server "minesvrbedrock.southcentralus.azurecontainer.io" port "19132", this take some time be patient.
Write-Output "Creating bedrock server container"
az container create --resource-group gaming `
    --name bedrock-server `
    --image itzg/minecraft-bedrock-server `
    --dns-name-label thewilds `
    --ports 19132 19133 `
    --protocol udp `
    --restart-policy OnFailure `
        --e EULA=TRUE `
        SERVER_NAME="The Wilds" `
        LEVEL_NAME="Wilds" `
        GAMEMODE="survival" `
        DIFFICULTY="normal" `
        ALLOW_CHEATS="false" `
    --azure-file-volume-account-name persistantgamestorage --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name bedrock --azure-file-volume-mount-path /data 

#connect to fileshare drive "M" to edit server.properties and everything else
#you need to restart the container after each change.
# cmd.exe /C "cmdkey /add:`"persistantgamestorage.file.core.windows.net`" /user:`"Azure\persistantgamestorage`" /pass:`"$STORAGE_KEY`""
# New-PSDrive -Name M -PSProvider FileSystem -Root "\\persistantgamestorage.file.core.windows.net\persistantgamestorage" -Persist
