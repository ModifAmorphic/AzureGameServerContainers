az container show `
    --resource-group gaming `
    --name palworld `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table