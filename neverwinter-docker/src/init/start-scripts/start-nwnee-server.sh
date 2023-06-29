#!/bin/bash
#set -e

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=$STEAM_APP_ID

module_or_load="-module \"${MODULE}\""
if [[ -z "$LOAD_SLOT" ]]; then
    module_or_load="-load $LOAD_SLOT"
fi
        
./nwserver-linux \
        -servername "${SERVER_NAME}" \
        ${module_or_load} \
        -minlevel ${MIN_LEVEL} \
        -maxlevel ${MAX_LEVEL} \
        -pauseandplay ${PAUSE_AND_PLAY} \
        -pvp ${PVP_TYPE} \
        -servervault ${USE_SERVER_VAULT} \
        -elc ${ENFORCE_LEGAL_CHARs} \
        -ilr ${ITEM_LEVEL_RESTRICTIONS} \
        -gametype ${GAME_TYPE} \
        -oneparty ${ONE_PARTY} \
        -difficulty ${DIFFICULTY} \
        -autosaveinterval ${AUTOSAVE_INTERVAL} \
        -playerpassword "${PLAYER_PASSWORD}" \
        -dmpassword "${DM_PASSWORD}" \
        -adminpassword "${ADMIN_PASSWORD}" \
        -publicserver ${IS_PUBLIC} \
        -reloadwhenempty ${RELOAD_WHEN_EMPTY} \
        -port ${PORT}
        #&  #Start in background

#Export the Process ID so process can be waited on
export SERVER_PID=$!

llog "Neverwinter Nights EE Server Started with PID ${SERVER_PID}"

export LD_LIBRARY_PATH=$templdpath