container_name = "valheim-cm2network-sanitysrefuge"
container_image = "cm2network/valheim"
dns-name = "sanitysrefuge-cm2network"
cpu = "2"
memory = "4"

azure_saves_share = "valheim-sanitysrefuge-saves"
azure_server_share = "valheim-sanitysrefuge-server-install"
azure_backups_share = "valheim-sanitysrefuge-backups"

env_vars = {
    SERVER_NAME="Sanity's Refuge"
    SERVER_WORLD_NAME="TheWilds"
    SERVER_PORT=2456
    SERVER_PUBLIC=0
    SERVER_SAVE_DIR="/home/steam/valheim-worlds"
    #BEPINEX
    DOORSTOP_ENABLE="TRUE"
    DOORSTOP_INVOKE_DLL_PATH="./BepInEx/core/BepInEx.Preloader.dll"
    DOORSTOP_CORLIB_OVERRIDE_PATH="./unstripped_corlib"

    # LD_LIBRARY_PATH="./doorstop_libs:$LD_LIBRARY_PATH"
    # LD_PRELOAD="libdoorstop_x64.so:$LD_PRELOAD"
}

discord_starting_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is starting...\\\"}"
discord_ready_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is running and ready for players!\\\"}"