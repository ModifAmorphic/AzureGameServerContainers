$STORAGE_KEY=$(az storage account keys list --resource-group gaming --account-name persistantgamestorage --query "[0].value" --output tsv)
#echo $STORAGE_KEY

#to actually create the minecraft server int the dns name "minesvrbedrock"
#the server will be running into server "minesvrbedrock.southcentralus.azurecontainer.io" port "19132", this take some time be patient.
Write-Output "Creating bedrock server container"
az container create --resource-group gaming `
    --name bedrock-server `
    --image itzg/minecraft-bedrock-server `
    --dns-name-label thewilds `
    --ip-address public `
    --ports 19132 19133 `
    --protocol udp `
    --restart-policy OnFailure `
        --e EULA=TRUE `
        SERVER_NAME="The Wilds" `
        LEVEL_NAME="Wilds" `
        GAMEMODE="survival" `
        DIFFICULTY="normal" `
        ALLOW_CHEATS="false" `
        ENABLE_LAN_VISIBILITY="false" `
        MAX_THREADS=0 `
    --azure-file-volume-account-name persistantgamestorage --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name bedrock --azure-file-volume-mount-path /data

az container attach --name bedrock-server --resource-group gaming