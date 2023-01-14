#!/bin/bash

#setup logger
. "${LOGGER_PATH}"
declare logSource="Entry"

llog()
{
    log "$1" "$logSource"
}

llog "Running elevated commands"
llog "Assigning user $SERVER_USER ownership of valheim directories"

#Ensures the $SERVER_USER owns the game paths if they already exist, otherwise creates them first and then assigns ownership.
[ ! -d "$LOG_PATH" ] && mkdir -p "$LOG_PATH"
chown -R $SERVER_USER:valheim "$LOG_PATH"

[ ! -d "$SERVER_PATH" ] && mkdir -p "$SERVER_PATH"
chown -R $SERVER_USER:valheim "$SERVER_PATH"

[ ! -d "$SAVE_PATH" ] && mkdir -p "$SAVE_PATH"
chown -R $SERVER_USER:valheim "$SAVE_PATH"

[ ! -d "$BACKUP_PATH" ] && mkdir -p "$BACKUP_PATH"
chown -R $SERVER_USER:valheim "$BACKUP_PATH"

for file in "${MA_LIBS_PATH}"/*.sh; do
    if [[ ! -x "$file" ]]; then
        llog "Granting execute on script ${file}"
        chmod +x "$file"
    fi
    owner="$(stat --format '%U' "$file")"
    if [[ "$owner" != "$SERVER_USER" ]]; then
        llog "Assigning user \"${SERVER_USER}\" ownership of file \"${file}\""
        chown $SERVER_USER:valheim "$file"
    fi
done

# Ensures manually added custom start script is executable
if [[ -n "$CUSTOM_START_SCRIPT" ]] && [[ -f "$SERVER_PATH/$CUSTOM_START_SCRIPT" ]] && [[ ! -x "$SERVER_PATH/$CUSTOM_START_SCRIPT" ]]; then
    llog "Granting execute access to custom startup script \"${CUSTOM_START_SCRIPT}\""
    chmod +x "${SERVER_PATH}/${CUSTOM_START_SCRIPT}"
fi

# Switches user from root to the $SERVER_USER
llog "Finished elevated commands. Switching to ${SERVER_USER} user"
exec runuser -u $SERVER_USER "$@"