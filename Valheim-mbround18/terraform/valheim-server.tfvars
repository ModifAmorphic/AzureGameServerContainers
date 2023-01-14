container_name = "valheim-mbround18-sanitysrefuge"
dns-name = "sanitysrefuge-mbround18"
cpu = "2"
memory = "4"

azure_saves_share = "valheim-sanitysrefuge-saves"
azure_server_share = "valheim-sanitysrefuge-server-install"
azure_backups_share = "valheim-sanitysrefuge-backups"

env_vars = {
    NAME="Sanity's Refuge"
    WORLD="TheWilds"
    PORT=2456
    PUBLIC="0"
    TYPE="BEPINEX"
    TZ="UTC"
}

discord_starting_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is starting...\\\"}"
discord_ready_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is running and ready for players!\\\"}"