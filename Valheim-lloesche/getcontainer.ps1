az container show `
    --resource-group gaming `
    --name valheim-sanitysrefuge-group `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table