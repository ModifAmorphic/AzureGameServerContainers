# Instructions

- Provision resource dependencies with /shared/install-vm-deps.ps1
- Apply terraform with "terraform apply -var-file vm-games-host.tfvars"
- Connect via Bastion, then  execute docker install script.
  - curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/DockerHost/terraform/install_docker.sh
  