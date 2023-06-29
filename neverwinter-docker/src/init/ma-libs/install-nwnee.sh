#!/bin/bash

set -e

user=$( whoami )
llog "Current user is \"$user\""
llog "Installing / Updating Neverwinter Nights EE Dedicated Server to $SERVER_PATH"

#$STEAM_PATH/steamcmd.sh +force_install_dir "$SERVER_PATH" +login anonymous +app_update 704450 +quit 2>&1 | awk '{ print strftime("[SteamCmd] %H:%M:%S "), $0; fflush(); }'
$STEAM_PATH/steamcmd.sh +force_install_dir "$SERVER_PATH" +login anonymous +app_update $STEAM_APP_ID +quit 2>&1 | logPipeX - "SteamCMD"