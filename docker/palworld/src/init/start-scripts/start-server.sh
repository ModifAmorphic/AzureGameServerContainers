#!/bin/bash
#set -e

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=$STEAM_APP_ID

./PalServer.sh -port=$PORT \
        -useperfthreads \
        -NoAsyncLoadingThread \
        -UseMultithreadForDS

#Export the Process ID so process can be waited on
export SERVER_PID=$!

llog "${GAME_NAME} Server Started with PID ${SERVER_PID}"

export LD_LIBRARY_PATH=$templdpath