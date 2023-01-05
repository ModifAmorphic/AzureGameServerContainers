$STORAGE_KEY=$(az storage account keys list --resource-group gaming --account-name persistantgamestorage --query "[0].value" --output tsv)
#echo $STORAGE_KEY

Write-Output "Creating Valheim server container"
az container create --resource-group gaming `
    --name valheim-server `
    --image lloesche/valheim-server `
    --dns-name-label sanitysrefuge `
    --ip-address public `
    --ports 2456 2457 `
    --protocol udp `
    --memory 4 `
    --cpu 2 `
    --restart-policy OnFailure `
        --e EULA=TRUE `
        SERVER_NAME="Sanity's Refuge" `
        WORLD_NAME="TheWilds" `
        SERVER_PASS="password" `
        SERVER_PUBLIC="false" `
        UPDATE_CRON="5 */1 * * *" `
        UPDATE_IF_IDLE="true" `
        RESTART_CRON="35 */3 * * *" `
        RESTART_IF_IDLE="true" `
        TZ="UTC" `
    --azure-file-volume-account-name persistantgamestorage --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name valheim-config --azure-file-volume-mount-path /config `
    --azure-file-volume-account-name persistantgamestorage --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name server --azure-file-volume-mount-path /opt/valheim

az container attach --name valheim-server --resource-group gaming