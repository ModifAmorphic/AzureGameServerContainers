. "${MA_LIBS_PATH}/palWorldSettings.sh"

## constants
LinuxServerPath="${SERVER_PATH}/Pal/Saved/Config/LinuxServer"

firstStartCalls=0

startBackgroundLogs() {
    while [ ! -f "$LOGFILE_PATH" ]; do sleep 2; done && tail -F $LOGFILE_PATH | logPipeX - "${GAME_NAME}" &
}

configureServer() {
    llog "Configuring server $PAL_ServerName."
    
    # if (( $SERVER_FIRST_RUN == 1 )); then
    #     # Append optimizations to Engine.ini on first run
    #     cat ~/configs/EngineOptimizations.ini >> "${LinuxServerPath}/Engine.ini"
    # fi
    
    /bin/python3 "${MA_LIBS_PATH}/configini.py" --config-directory "$LinuxServerPath"

    readPalEnvSettings
    
    # Create PalWorldSettings.ini if it doesn't already exist
    if [[ ! -f "${LinuxServerPath}/PalWorldSettings.ini" ]]; then
        cat "${SERVER_PATH}/DefaultPalWorldSettings.ini" > "${LinuxServerPath}/PalWorldSettings.ini"
    fi

    # TODO Update PalWorldSettings.ini
        # ,ServerPassword="
}

stopServer() {
    set +e
        llog "Sending kill to server with process Id $PALSERVER_PID"
        kill -INT $PALSERVER_PID
        # Wait for process to be killed
        local isAlive=$(kill -0 $PALSERVER_PID 2> /dev/null && printf -- 1 || printf -- 0)
        local tick=0
        while (( $isAlive > 0 )) && (( $tick < 30 )); do
            sleep 1
            isAlive=$(kill -0 $PALSERVER_PID 2> /dev/null && printf -- 1 || printf -- 0)
            tick=$(($tick + 1))
        done
        if (( $isAlive > 0 )); then
            lwarn "Timed out waiting for $PAL_ServerName to shut down gracefully. Forcing shutdown."
            kill -9 $PALSERVER_PID
            timeout 30 bash -c "while kill -0 $PALSERVER_PID; do sleep 1; done"
        else
            llog "$PAL_ServerName stopped."
        fi

    set -e
}

startServer() {
    export LOG_SOURCE="Startup"
    # Check if this is the first time the server has been ran
    if [[ -f "${SERVER_PATH}/firstrun" ]] && (( firstStartCalls < 2 )); then
        rm -f "${SERVER_PATH}/firstrun"
        export SERVER_FIRST_RUN=1
    else
        if (( $firstStartCalls > 1 )); then
            lwarn "Detected multiple "first start" attempts to initialize config files. Abandoning future attempts until next run."
            # attempt to delete firstrun file if it still exists. Ignore errors.
            [[ -f "${SERVER_PATH}/firstrun" ]] && set +e && rm -f "${SERVER_PATH}/firstrun" && set -e
        fi
        if (( S$ERVER_FIRST_RUN < 1 )); then configureServer; fi
        export SERVER_FIRST_RUN=0
    fi

    if [[ -z "$CUSTOM_START_SCRIPT" ]]; then
        llog "Starting ${GAME_NAME} Dedicated Server"
        . "${MA_SCRIPTS_PATH}/start-server.sh"
    else
        llog "Starting ${GAME_NAME} Dedicated Server with custom script \"${CUSTOM_START_SCRIPT}\""
        . "${MA_SCRIPTS_PATH}/${CUSTOM_START_SCRIPT}"
    fi

    # Get the child process the pal server script
    local palServerId=$(pgrep -f PalServer-Linux-Test) || :;
    while ! [[ $palServerId ]]; do
        sleep 1
        palServerId=$(pgrep -f PalServer-Linux-Test) || :;
    done

    export PALSERVER_PID=$palServerId
    if (( $SERVER_FIRST_RUN == 1 )); then
        llog "###  First time startup detected. Configuring server and restarting. ###"
        configureServerFirstStart
    else
        # Wait on server's process ID to prevent container from exiting.
        if [[ -n "$DISCORD_READY_MESSAGE" ]]; then 
            doAfterPortListening $PORT "sendDiscordMessage \"$DISCORD_READY_MESSAGE\""
        fi
        wait $SERVER_PID
    fi
}

doAfterPortListening() {
    local port=$1
    local command=$2
    local timeout=240

    local listening=$(ss --udp --listening --no-header src :$port)
    while [[ ! $listening ]]; do   
        sleep 1
        tick=$(($tick + 1))
        listening=$(ss --udp --listening --no-header src :$port)
    done
    if (( $tick > $timeout )); then
        lwarn "Timed out waiting for port $PORT to listen."
    else
        eval $command
    fi
}

# Intended to be used the first time a server is being ran, after a fresh install.
# 1. Waits for game server to start and all config files have been created.
# 2. Shuts down game server and modifies config files.
# 3. Starts game server back up by calling the startServer function.
configureServerFirstStart() {
    firstStartCalls=$(($firstStartCalls + 1))
    llog "Waiting for port $PORT."
    doAfterPortListening $PORT 'stopServer; configureServer && startServer'
}