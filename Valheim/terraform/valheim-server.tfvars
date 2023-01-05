container-name = "valheim-sanitysrefuge"
dns-name = "sanitysrefuge"
cpu = "2"
memory = "4"

config-share = "valheim-sanitysrefuge-config"
server-share = "valheim-sanitysrefuge-server"

env-vars = {
    SERVER_NAME="Sanity's Refuge"
    WORLD_NAME="TheWilds"
    SERVER_PUBLIC="false"
    UPDATE_CRON="5 */1 * * *"
    UPDATE_IF_IDLE="true"
    RESTART_CRON="35 8 * * *"
    RESTART_IF_IDLE="true"
    TZ="UTC"
}