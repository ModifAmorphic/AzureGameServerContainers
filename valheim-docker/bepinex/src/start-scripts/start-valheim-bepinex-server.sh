#!/bin/bash
#set -e

export DOORSTOP_ENABLE=TRUE
export DOORSTOP_INVOKE_DLL_PATH=./BepInEx/core/BepInEx.Preloader.dll
export DOORSTOP_CORLIB_OVERRIDE_PATH=./unstripped_corlib

export LD_LIBRARY_PATH="./doorstop_libs:$LD_LIBRARY_PATH"
export LD_PRELOAD="libdoorstop_x64.so:$LD_PRELOAD"
####

export LD_LIBRARY_PATH="./linux64:$LD_LIBRARY_PATH"
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
        $CROSSPLAY_SWITCH \
        > /dev/null 2>&1 #quiet you!
        #&  #Start in background

#Export the Process ID so process can be waited on
export SERVER_PID=$!

llog "Exported Server PID ${SERVER_PID}"
