#!/bin/bash

NORMAL='\033[0m'
#NORMAL=$(tput sgr0)
YELLOW='\033[0;33m'
#YELLOW=$(tput setaf 3)
RED='\033[0;31m'
#RED=$(tput setaf 1)

log() {
    local _msg=$1; local _source=$2
    
    addLogPrefix _msg $_source
    printf "%s\n" "$_msg"
}

logError() {
    local _msg=$1; local _source=$2
    
    addLogPrefix _msg $_source
    >&2 printf  "${RED}%s${NORMAL}\n" "$_msg"
}

logWarn() {
    local _msg=$1; local _source=$2
    
    addLogPrefix _msg $_source
    printf  "${YELLOW}%s${NORMAL}\n" "$_msg"
}

logPipe() {
    read _msg; local _source=$2

    log "$_msg" "$_source"
}

logPipeX() {
    local _source=$2
    while read _msg; do
        if [[ "$_msg" == "ERROR"* ]] || [[ "$_msg" == "[Error"* ]]; then 
            logError "$_msg" "$_source"
        elif [[ "$_msg" == "WARNING"* ]] || [[ "$_msg" == "[Warning"* ]]; then 
            logWarn "$_msg" "$_source"
        else
            log "$_msg" "$_source"
        fi
    done
}

addLogPrefix()
{
    local -n ___msgRef=$1; local _source="$2"
    
    ___msgRef="[${_source}] `date --utc +%T` - ${___msgRef}"
}