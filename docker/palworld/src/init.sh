#!/bin/bash

set -e

#setup logger
. "${LOGGER_PATH}"
export LOG_SOURCE="Init"

. "${MA_LIBS_PATH}/shared.sh"
. "${MA_LIBS_PATH}/server-commands.sh"

main() {
    # Fix missing links to steam files if needed
    # linkFileIfMissing "${STEAM_PATH}/linux32/steam" "${STEAM_PATH}/linux32/steamcmd"
    # linkFileIfMissing "${STEAM_PATH}/linux64/steam" "${STEAM_PATH}/linux64/steamcmd"
    linkFileIfMissing "${STEAM_PATH}/linux32/steamclient.so" "${USER_HOME}/.steam/sdk32/steamclient.so"
    linkFileIfMissing "${STEAM_PATH}/linux32/steamclient.so" "${STEAM_PATH}/steamclient.so"
    linkFileIfMissing "${STEAM_PATH}/linux64/steamclient.so" "${USER_HOME}/.steam/sdk64/steamclient.so"
    #linkFileIfMissing "${STEAM_PATH}/steamcmd.sh" \"${STEAM_PATH}/steam.sh"

    # Check if server has been downloaded before. If not, create a firstrun file
    llog "Checking if this is the server's first run. (result=$([[ -f "${SERVER_PATH}/PalServer.sh" ]] && printf -- "false" || printf -- "true"))"
    #touch "${SERVER_PATH}/firstrun"
    [[ -f "${SERVER_PATH}/PalServer.sh" ]] || touch "${SERVER_PATH}/firstrun"

    # Install / update the game server
    . "${MA_SCRIPTS_PATH}/install-server.sh"
    # mv scripts/* ${SERVER_PATH}/
    cd ${SERVER_PATH}

    [[ -f "$LOGFILE_PATH" ]] && rm $LOGFILE_PATH
    
    # No log files to log to console
    #startBackgroundLogs
    startServer
}

main