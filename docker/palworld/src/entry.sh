#!/bin/bash

#setup logger
. "${LOGGER_PATH}"
export LOG_SOURCE="Entry"

llog "Running elevated commands"
llog "Assigning user $SERVER_USER ownership of ${GAME_NAME_LOWER} directories"

#Ensures the $SERVER_USER owns the game paths if they already exist, otherwise creates them first and then assigns ownership.
[ ! -d "$LOG_PATH" ] && mkdir -p "$LOG_PATH"
chown -R "${SERVER_USER}":"${USER_GROUP}" "$LOG_PATH"

[ ! -d "$SERVER_PATH" ] && mkdir -p "$SERVER_PATH"
chown -R "${SERVER_USER}":"${USER_GROUP}" "$SERVER_PATH"

for file in "${MA_SCRIPTS_PATH}"/*.sh; do
    if [[ ! -x "$file" ]]; then
        llog "Granting execute on script ${file}"
        chmod +x "$file"
    fi
    owner="$(stat --format '%U' "$file")"
    if [[ "$owner" != "$SERVER_USER" ]]; then
        llog "Assigning user \"${SERVER_USER}\" ownership of file \"${file}\""
        chown "${SERVER_USER}":"${USER_GROUP}" "$file"
    fi
done

for file in "${MA_LIBS_PATH}"/*.sh; do
    if [[ ! -x "$file" ]]; then
        llog "Granting execute on script ${file}"
        chmod +x "$file"
    fi
    owner="$(stat --format '%U' "$file")"
    if [[ "$owner" != "$SERVER_USER" ]]; then
        llog "Assigning user \"${SERVER_USER}\" ownership of file \"${file}\""
        chown "${SERVER_USER}":"${USER_GROUP}" "$file"
    fi
done

# Ensures manually added custom start script is executable
if [[ -n "$CUSTOM_START_SCRIPT" ]] && [[ -f "$SERVER_PATH/$CUSTOM_START_SCRIPT" ]] && [[ ! -x "$SERVER_PATH/$CUSTOM_START_SCRIPT" ]]; then
    llog "Granting execute access to custom startup script \"${CUSTOM_START_SCRIPT}\""
    chmod +x "${SERVER_PATH}/${CUSTOM_START_SCRIPT}"
fi

# No longer needed
. "${MA_LIBS_PATH}/shared.sh"
# # Add steamclient.so link if it doesn't exist 
linkFileIfMissingChown "${STEAM_PATH}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" "$SERVER_USER" "$USER_GROUP"

# Switches user from root to the $SERVER_USER
llog "Finished elevated commands. Switching to ${SERVER_USER} user"
exec runuser -u $SERVER_USER "$@"

# # Check if this is the first run of this server
# if [[ -f ${SERVER_PATH}/${CUSTOM_START_SCRIPT} ]]