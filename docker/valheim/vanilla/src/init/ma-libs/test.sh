#!/bin/bash

. ./logger.sh

logMsg='Regular Message'
echoMsg=`echo message`
warn="Warning Shot"

#echo $msg
log "$echoMsg" "Echo"
log "$logMsg" "Battleship"
logWarn "$warn" "Battleship"
logError "Direct Hit!" "Battleship"
echo "ERROR Piping hot" | logPipeX - "Pipe"

cat test.sh | logPipeX - "File"