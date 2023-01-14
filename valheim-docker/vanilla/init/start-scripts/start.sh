#!/bin/bash

set -e

#Check if crossplay env variable was set
export CROSSPLAY_SWITCH=$([[ $IS_CROSSPLAY -eq 1 ]] || [[ "${IS_CROSSPLAY,,}" = "true" ]] && printf -- "-crossplay")
#Ensure logFile path is set
export SERVER_LOG_FILE=$(([[ "$LOG_PATH" == */ ]] && printf "$LOG_PATH") || ([[ ${#LOG_PATH} -ne 0 ]] && printf -- "${LOG_PATH}/"))valheim-server.log

if [[ -z "$CUSTOM_START_SCRIPT" ]]; then
    llog "Starting Valheim Dedicated Server"
    . ./start-valheim-server.sh
else
    llog "Starting Valheim Dedicated Server with custom script \"${CUSTOM_START_SCRIPT}\""
    . ./$CUSTOM_START_SCRIPT
    if [[ -z "$SERVER_PID" ]]; then
        lerror "SERVER_PID not exported by \"${CUSTOM_START_SCRIPT}\" script. Server will now exit."
        exit 1
    fi
fi

if [[ -n "$SERVER_PID" ]]; then
    #Output logs to console
    while [ ! -f "$SERVER_LOG_FILE" ]; do sleep 1; done
    tail -F $SERVER_LOG_FILE | logPipeX - "Valheim" &
    llog "Waiting on server PID ${SERVER_PID}."
    wait $SERVER_PID
else
    lerror "SERVER_PID ${SERVER_PID} not set. Exiting"
    exit 1
fi

#cat entry.sh | xargs -IL date +"[Valheim] %H:%M:%S:L"

#cat entry.sh | awk '{ print strftime("[Valheim] %H:%M:%S: "), $0; fflush(); }'