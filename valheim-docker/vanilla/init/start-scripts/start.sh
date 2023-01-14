#!/bin/bash

set -e

startBackgroundLogs(){
    while [ ! -f "$LOGFILE_PATH" ]; do sleep 2; done && tail -F $LOGFILE_PATH | logPipeX - "Valheim" &
}

#Check if crossplay env variable was set
export CROSSPLAY_SWITCH=$([[ $IS_CROSSPLAY -eq 1 ]] || [[ "${IS_CROSSPLAY,,}" = "true" ]] && printf -- "-crossplay")
#Ensure logFile path is set
# export SERVER_LOG_FILE=$(([[ "$LOG_PATH" == */ ]] && printf "$LOG_PATH") || ([[ ${#LOG_PATH} -ne 0 ]] && printf -- "${LOG_PATH}/"))valheim-server.log


if [[ -z "$CUSTOM_START_SCRIPT" ]]; then
    llog "Starting Valheim Dedicated Server"
    startBackgroundLogs
    . ./start-valheim-server.sh
else
    llog "Starting Valheim Dedicated Server with custom script \"${CUSTOM_START_SCRIPT}\""
    startBackgroundLogs
    . ./$CUSTOM_START_SCRIPT
    # if [[ -z "$SERVER_PID" ]]; then
    #     lerror "SERVER_PID not exported by \"${CUSTOM_START_SCRIPT}\" script. Server will now exit."
    #     exit 1
    # fi
fi

# if [[ -n "$SERVER_PID" ]]; then
#     #Output logs to console
#     while [ ! -f "$LOGFILE_PATH" ]; do sleep 1; done
#     tail -F $LOGFILE_PATH | logPipeX - "Valheim" &
#     llog "Waiting on server PID ${SERVER_PID}."
#     wait $SERVER_PID
#     llog "Done waiting on ${SERVER_PID}. Checking if Server is still running"
#     while ps -p $SERVER_PID > /dev/null; do sleep 5; done
#     llog "Server process ${SERVER_PID} ended. Exiting"
# else
#     lerror "SERVER_PID ${SERVER_PID} not set. Exiting"
#     exit 1
# fi