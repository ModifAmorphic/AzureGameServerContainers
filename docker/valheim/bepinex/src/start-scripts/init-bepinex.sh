#!/bin/bash

set -e

declare logSource="Init-BepInEx"
llog()
{
    log "$1" "$logSource"
}
lwarn()
{
    logWarn "$1" "$logSource"
}
lerror()
{
    logError "$1" "$logSource"
}

#Install Latest BepInEx
. ${MA_LIBS_PATH}/install-bepinex.sh

#Install Plugins
. ${MA_LIBS_PATH}/install-plugins.sh

. ./start-valheim-bepinex-server.sh