#!/bin/sh

mkdir /opt/bedrock-thewilds -p

echo "Downloading start-container.sh to /opt/bedrock-thewilds/start-container.sh"
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/start-container.sh > /opt/bedrock-thewilds/start-container.sh \
    && chmod +x /opt/bedrock-thewilds/start-container.sh

curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/stop-container.sh > /opt/bedrock-thewilds/stop-container.sh \
    && chmod +x /opt/bedrock-thewilds/stop-container.sh

echo "Downloading docker-compose.yml to /opt/bedrock-thewilds/docker-compose.yml"
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/docker-compose.yml > /opt/bedrock-thewilds/docker-compose.yml

/opt/bedrock-thewilds/start-container.sh