echo "######### Terraform bootstrapping"
terraform -chdir=bootstrap apply

echo ""
echo "######### Terraform keyvault"
terraform -chdir=keyvault apply

echo ""
echo "######### Terraform vnet"
terraform -chdir=vnet apply

echo ""
echo "######### Terraform nsg"
terraform -chdir=nsg apply

echo ""
echo "######### Terraform Bastion"
terraform -chdir=bastion apply -var-file bastion.tfvars