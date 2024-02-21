#!/bin/bash

set -e

#setup logger
. "${LOGGER_PATH}"
declare logSource="Startup"

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

. "${MA_LIBS_PATH}/install-server.sh"
mv start-scripts/* ${SERVER_PATH}/
cd ${SERVER_PATH}

. ./start.sh