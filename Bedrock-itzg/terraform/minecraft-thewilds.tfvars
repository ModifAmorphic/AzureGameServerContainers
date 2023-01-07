containerName = "minecraft-thewilds"
containerImage = "itzg/minecraft-bedrock-server"
dnsName = "thewilds"
cpu = "2"
memory = "4"

dataShare = "minecraft-thewilds-data"

envVars = {
    EULA="TRUE"
    SERVER_NAME="The Wilds"
    LEVEL_NAME="Wilds"
    GAMEMODE="survival"
    DIFFICULTY="normal"
    ALLOW_CHEATS="false"
    ENABLE_LAN_VISIBILITY="false"
    MAX_THREADS=0
}