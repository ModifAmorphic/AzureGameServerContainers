az container delete -g gaming --name bedrock-server

$STORAGE_KEY=$(az storage account keys list --resource-group gaming --account-name persistantgamestorage --query "[0].value" --output tsv)
#echo $STORAGE_KEY

#to actually create the minecraft server int the dns name "minesvrbedrock"
#the server will be running into server "minesvrbedrock.southcentralus.azurecontainer.io" port "19132", this take some time be patient.
.\createContainer.ps1