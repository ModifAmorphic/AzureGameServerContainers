container_name = "nwnee-sanitysrefuge"
container_image = "modifamorphic/nwnee"
dns-name = "sanitysrefugenwn"
cpu = "2"
memory = "4"

azure_home_share = "nwnee-home"
#azure_backups_share = "valheim-sanitysrefuge-backups"
#azure_logs_share = "valheim-sanitysrefuge-logs"

env_vars = {
    SERVER_NAME="Wailing: Chapt 2"
    PORT=5121
    IS_PUBLIC=0
    SAVE_INTERVAL=15
	DM_PASSWORD="dmpass"
}

discord_starting_json = "{\\\"content\\\":\\\"Neverwinter Nights EE server is starting...\\\"}"
discord_ready_json = "{\\\"content\\\":\\\Neverwinter Nights EE server is running and ready for players!\\\"}"