az container show `
    --resource-group gaming `
    --name valheim-cm2network-sanitysrefuge `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table