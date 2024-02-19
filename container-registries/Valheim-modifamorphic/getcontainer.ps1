az container show `
    --resource-group gaming `
    --name valheim-sanitysrefuge `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table