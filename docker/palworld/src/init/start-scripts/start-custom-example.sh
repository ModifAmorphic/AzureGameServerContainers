#!/bin/bash
#set -e

#####################################################
#  Custom Script Example. Make a copy of this script
#  and edit it, then set CUSTOM_START_SCRIPT variable
#  to this scripts location inside the container.
#####################################################

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=$STEAM_APP_ID

# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.

./PalServer.sh -port=$PORT \
        -useperfthreads \
        -NoAsyncLoadingThread \
        -UseMultithreadForDS \
        & #Start in background

#Export the Process ID
export serverPID=$!

export LD_LIBRARY_PATH=$templdpath