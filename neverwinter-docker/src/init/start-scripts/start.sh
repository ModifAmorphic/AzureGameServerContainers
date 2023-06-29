#!/bin/bash

set -e

#remove log from last session
[[ -f "$LOGFILE_PATH" ]] && rm $LOGFILE_PATH

startBackgroundLogs(){
    while [ ! -f "$LOGFILE_PATH" ]; do sleep 2; done && tail -F $LOGFILE_PATH | logPipeX - "NWN" &
}

if [[ -z "$CUSTOM_START_SCRIPT" ]]; then
    llog "Starting Neverwinter Nights EE Dedicated Server"
    startBackgroundLogs
    . ./start-nwnee-server.sh
else
    llog "Starting Neverwinter Nights EE Dedicated Server with custom script \"${CUSTOM_START_SCRIPT}\""
    startBackgroundLogs
    . ./$CUSTOM_START_SCRIPT
fi
