az container show `
    --resource-group gaming `
    --name valheim-modifamorphic-sanitysrefuge `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table