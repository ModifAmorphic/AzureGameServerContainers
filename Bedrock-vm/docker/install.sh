mkdir /opt/bedrock-thewilds -p

curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/start-container.sh > /opt/bedrock-thewilds/start-container.sh \
    && chmod +x /opt/bedrock-thewilds/start-container.sh
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/docker-compose.yml > /opt/bedrock-thewilds/docker-compose.yml
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/bedrock-thewilds.service > /etc/systemd/system/bedrock-thewilds.service

systemctl enable bedrock-thewilds
systemctl start bedrock-thewilds