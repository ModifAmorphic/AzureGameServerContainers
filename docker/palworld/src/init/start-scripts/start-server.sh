#!/bin/bash
#set -e

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=$STEAM_APP_ID

# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.

./PalServer.sh -port=$PORT \
        -useperfthreads \
        -NoAsyncLoadingThread \
        -UseMultithreadForDS

#Export the Process ID so process can be waited on
export SERVER_PID=$!

llog "${GAME_NAME} Server Started with PID ${SERVER_PID}"

export LD_LIBRARY_PATH=$templdpath