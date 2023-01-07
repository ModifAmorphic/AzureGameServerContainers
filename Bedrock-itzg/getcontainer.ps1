az container show `
    --resource-group gaming `
    --name minecraft-thewilds `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table