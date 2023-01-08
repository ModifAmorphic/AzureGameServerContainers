mkdir /opt/bedrock-thewilds -p

echo "Downloading start-container.sh to /opt/bedrock-thewilds/start-container.sh"
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/start-container.sh > /opt/bedrock-thewilds/start-container.sh \
    && chmod +x /opt/bedrock-thewilds/start-container.sh

echo "Downloading docker-compose.yml to /opt/bedrock-thewilds/docker-compose.yml"
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/docker-compose.yml > /opt/bedrock-thewilds/docker-compose.yml

echo "Installing bedrock-thewilds.service."
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/bedrock-thewilds.service > /etc/systemd/system/bedrock-thewilds.service

echo "Enabling bedrock-thewilds service"
systemctl enable bedrock-thewilds
echo "Starting bedrock-thewilds service"
systemctl start bedrock-thewilds