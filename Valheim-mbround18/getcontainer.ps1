az container show `
    --resource-group gaming `
    --name valheim-mbround18-sanitysrefuge `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table