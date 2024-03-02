#!/bin/bash

set -e

user=$( whoami )
llog "Current user is \"$user\""
llog "Installing / Updating Palworld Dedicated Server to $SERVER_PATH"

$STEAM_PATH/steamcmd.sh +force_install_dir "$SERVER_PATH" +login anonymous +app_update ${STEAM_APP_ID} +quit 2>&1 | logPipeX - "SteamCMD"