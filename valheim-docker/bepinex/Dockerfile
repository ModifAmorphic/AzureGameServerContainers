ARG server_user="valheim"
ARG steam_dir="Steam"

FROM modifamorphic/valheim:latest as installs
ARG server_user
ARG steam_dir

RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl jq unzip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

FROM installs
ARG server_user
ARG steam_dir

#System env variables
ENV	SERVER_USER="${server_user}" \
	USER_HOME="/home/${server_user}" \
 	STEAM_PATH="/home/${server_user}/${steam_dir}" \
	MA_LIBS_PATH="/home/${server_user}/ma-libs" \
	LOG_PATH="/home/${server_user}/valheim-logs" \
    LOGGER_PATH="/home/${server_user}/ma-libs/logger.sh" \
	SERVER_PATH="/home/${server_user}/valheim-server" \
	SAVE_PATH="/home/${server_user}/valheim-saves" \
    BACKUP_PATH="/home/${server_user}/valheim-backups"

#BepInEx specific env vars
ENV BEPINEX_PATH="${SERVER_PATH}/BepInEx" \
	PLUGINS_PATH="${SERVER_PATH}/BepInEx/plugins" \
 	PLUGINS_CONFIG_PATH="${SERVER_PATH}/BepInEx/config" \
	LOGFILE_PATH="${SERVER_PATH}/BepInEx/LogOutput.log"
	
# Configurable Environment
ENV SERVER_NAME="Valheim Dedicated Server" \
	PORT=2456 \
	PASSWORD="password" \
	WORLD_NAME="TheWilds" \
	IS_PUBLIC=1 \
	IS_CROSSPLAY=0 \
	LAST_X_SAVES_RETAINED=4 \
	SAVE_INTERVAL=900 \
	CUSTOM_START_SCRIPT="init-bepinex.sh" \
	THUNDERSTORE_API_URL="https://valheim.thunderstore.io/api" \
	THUNDERSTORE_MODS='' \
	PRUNE_MODS=0

WORKDIR "$USER_HOME"

# Copy entry and startup scripts
COPY ./src/ $USER_HOME

## Set Access / Ownership to $server_user
RUN chown -R $server_user:valheim "${MA_LIBS_PATH}" \
	&& chmod +x "${MA_LIBS_PATH}/install-bepinex.sh" \
	&& chmod +x "${MA_LIBS_PATH}/install-plugins.sh" \
	&& chown -R $server_user:valheim "${USER_HOME}/start-scripts" \
	&& chmod +x "${USER_HOME}/start-scripts/start-valheim-bepinex-server.sh"

ENTRYPOINT [ "/bin/bash", "/entry.sh" ]
CMD [ "/home/valheim/init.sh" ] 