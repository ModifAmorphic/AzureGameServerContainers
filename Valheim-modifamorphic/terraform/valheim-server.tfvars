container_name = "valheim-modifamorphic-sanitysrefuge"
container_image = "modifamorphic/valheim-bepinex"
dns-name = "sanitysrefuge-ma"
cpu = "2"
memory = "4"

azure_saves_share = "valheim-sanitysrefuge-saves"
azure_server_share = "valheim-sanitysrefuge-server-install"
azure_backups_share = "valheim-sanitysrefuge-backups"

env_vars = {
    SERVER_NAME="Sanity's Refuge"
    WORLD_NAME="TheWilds"
    PORT=2456
    IS_PUBLIC=0
    THUNDERSTORE_PLUGINS="[{ \"namespace\": \"ValheimModding\", \"name\": \"Jotunn\", \"version\": \"latest\" }, { \"namespace\": \"Menthus\", \"name\": \"Heightmap_Unlimited\", \"version\": \"latest\" }]"
}

discord_starting_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is starting...\\\"}"
discord_ready_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is running and ready for players!\\\"}"