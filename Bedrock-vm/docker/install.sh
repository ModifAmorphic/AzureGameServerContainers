mkdir /opt/bedrock-thewilds -p

echo "Downloading download-and-start.sh to /opt/bedrock-thewilds/download-and-start.sh"
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/download-and-start.sh > /opt/bedrock-thewilds/download-and-start.sh \
    && chmod +x /opt/bedrock-thewilds/download-and-start.sh

echo "Installing bedrock-thewilds.service."
curl -sL https://raw.githubusercontent.com/ModifAmorphic/AzureGameServerContainers/main/Bedrock-vm/docker/bedrock-thewilds.service > /etc/systemd/system/bedrock-thewilds.service

echo "Enabling bedrock-thewilds service"
systemctl enable bedrock-thewilds
echo "Starting bedrock-thewilds service"
systemctl start bedrock-thewilds