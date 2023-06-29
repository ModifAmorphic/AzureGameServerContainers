az container show `
    --resource-group gaming `
    --name nwnee-sanitysrefuge `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table