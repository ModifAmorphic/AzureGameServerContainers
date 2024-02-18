#!/bin/bash
#set -e

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.

./valheim_server.x86_64 -name "${SERVER_NAME}" \
        -port ${PORT} \
        -world "${WORLD_NAME}" \
        -password "${PASSWORD}" \
        -savedir "${SAVE_PATH}" \
        -public ${IS_PUBLIC} \
        -logFile "${SERVER_LOG_FILE}" \
        -saveinterval ${SAVE_INTERVAL} \
        -backups ${X_SAVES_RETAINED} \
        $CROSSPLAY_SWITCH 
        #&  #Start in background

#Export the Process ID so process can be waited on
export SERVER_PID=$!

llog "Valheim Server Started with PID ${SERVER_PID}"

export LD_LIBRARY_PATH=$templdpath