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
    PRE_BOOTSTRAP_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"{\\\"content\\\":\\\"Sanity's Refuge Valheim server is starting...\\\"}\" https://discord.com/api/webhooks/1060706703487803433/9vClfWZMX05Odsmkoete3LLKVk5e4WgLuE9q3QPvqra6KsaRtyhooGF6r7csh9Rq6y15"
    POST_SERVER_LISTENING_HOOK="curl -sfSL -X POST -H \"Content-Type: application/json\" -d \"{\\\"content\\\":\\\"Sanity's Refuge Valheim server is running and ready for players!\\\"}\" https://discord.com/api/webhooks/1060706703487803433/9vClfWZMX05Odsmkoete3LLKVk5e4WgLuE9q3QPvqra6KsaRtyhooGF6r7csh9Rq6y15"
}