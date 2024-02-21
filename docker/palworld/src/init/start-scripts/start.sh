#!/bin/bash

set -e

#remove log from last session
[[ -f "$LOGFILE_PATH" ]] && rm $LOGFILE_PATH

startBackgroundLogs(){
    while [ ! -f "$LOGFILE_PATH" ]; do sleep 2; done && tail -F $LOGFILE_PATH | logPipeX - "${GAME_NAME}" &
}

#Check if crossplay env variable was set
export CROSSPLAY_SWITCH=$([[ $IS_CROSSPLAY -eq 1 ]] || [[ "${IS_CROSSPLAY,,}" = "true" ]] && printf -- "-crossplay")

if [[ -z "$CUSTOM_START_SCRIPT" ]]; then
    llog "Starting ${GAME_NAME} Dedicated Server"
    startBackgroundLogs
    . ./start-server.sh
else
    llog "Starting ${GAME_NAME} Dedicated Server with custom script \"${CUSTOM_START_SCRIPT}\""
    startBackgroundLogs
    . ./$CUSTOM_START_SCRIPT
fi
