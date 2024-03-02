#! /bin/bash

linkFileIfMissing() {
    local sFile="$1"
    local dFile="$2"

    if [ ! -e "$dFile" ]; then
        ln -s "$sFile" "$dFile"
        llog "Created symlink from \"$sFile\" to \"$dFile\"."
    fi
}

linkFileIfMissingChown() {
    local sFile="$1"
    local dFile="$2"
    local owner="$3"
    local group="$4"

    linkFileIfMissing "$sFile" "$dFile"
    currentOwner=$(stat -c '%U' $dFile)
    if [[ "$owner" != "$currentOwner" ]]; then
        if [[ -f "$dFile" ]]; then
            chown -h ${owner}:"${group}" "$dFile"
            llog "Changed owner from ${currentOwner} to ${owner} for file \"${dFile}\"."
        elif [[ -L "$dFile" ]]; then
            chown -h ${owner}:"${group}" "$dFile"
            llog "Changed owner from ${currentOwner} to ${owner} for symlink \"${dFile}\"."
        else
            lwarn "Unable to determine owner of \"${dFile}\". Path is not a file or symlink."
        fi
    fi
}