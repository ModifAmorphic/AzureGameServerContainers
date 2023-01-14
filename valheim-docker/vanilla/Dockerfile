ARG server_user="valheim"
ARG steam_dir="Steam"

FROM ubuntu:jammy AS steam_installer
ARG server_user
ARG steam_dir

## Install steamcommand, configure local and add user to run server
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl lib32gcc-s1 ca-certificates \
	&& update-ca-certificates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir "/${steam_dir}" \
	&& curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C "/${steam_dir}" \
	&& chmod +x "/${steam_dir}/steamcmd.sh" \
	&& "/${steam_dir}/steamcmd.sh" +quit

FROM ubuntu:jammy AS configurer
ARG server_user
ARG steam_dir

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		lib32gcc-s1 locales ca-certificates moreutils \
	&& update-ca-certificates \
	&& locale-gen en_US.UTF-8 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& useradd -m $server_user

#System env variables
ENV	SERVER_USER="${server_user}" \
	USER_HOME="/home/${server_user}" \
 	STEAM_PATH="/home/${server_user}/${steam_dir}" \
	MA_LIBS_PATH="/home/${server_user}/ma-libs" \
	LOG_PATH="/home/${server_user}/valheim-logs" \
	LOGFILE_PATH="/home/${server_user}/valheim-logs/valheim-server.log" \
    LOGGER_PATH="/home/${server_user}/ma-libs/logger.sh" \
	SERVER_PATH="/home/${server_user}/valheim-server" \
	SAVE_PATH="/home/${server_user}/valheim-saves" \
    BACKUP_PATH="/home/${server_user}/valheim-backups"

# Configurable Environment Variables
ENV SERVER_NAME="Valheim Dedicated Server" \
	PORT=2456 \
	PASSWORD="password" \
	WORLD_NAME="TheWilds" \
	IS_PUBLIC=1 \
	IS_CROSSPLAY=0 \
	LAST_X_SAVES_RETAINED=4 \
	SAVE_INTERVAL=900 \
	CUSTOM_START_SCRIPT=""

WORKDIR "$USER_HOME"

COPY --from=steam_installer /Steam $STEAM_PATH

# Copy entry and startup scripts
COPY ./entry.sh /entry.sh
COPY ./init/ $USER_HOME
COPY ./limits.conf /etc/security/

ARG symlink="ln -s \"${STEAM_PATH}/linux32/steamcmd\" \"${STEAM_PATH}/linux32/steam\" \
				&& ln -s \"${STEAM_PATH}/linux32/steamclient.so\" \"${USER_HOME}/.steam/sdk32/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/linux64/steamclient.so\" \"${USER_HOME}/.steam/sdk64/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/steamcmd.sh\" \"${STEAM_PATH}/steam.sh\""

## Set Access / Ownership to $server_user
RUN chmod +x /entry.sh \
	&& mkdir -p "${USER_HOME}/.steam/sdk32" \
	&& mkdir -p "${USER_HOME}/.steam/sdk64" \
	&& chown -R $server_user:valheim "${STEAM_PATH}" \
	&& chown -R $server_user:valheim "${USER_HOME}/start-scripts" \
	&& chown -R $server_user:valheim "${USER_HOME}/.steam" \
	&& chown -R $server_user:valheim "${MA_LIBS_PATH}" \
	&& chmod +x "${LOGGER_PATH}" \
	&& chmod +x "${USER_HOME}/init.sh" && chown $server_user:valheim "${USER_HOME}/init.sh" \
	&& chmod +x "${MA_LIBS_PATH}/install-valheim.sh" \
	&& chmod +x "${USER_HOME}/start-scripts/start.sh"  \
	&& chmod +x "${USER_HOME}/start-scripts/start-valheim-server.sh"  \
	&& runuser - ${server_user} -c "${symlink}"

#RUN ln -s "${STEAM_PATH}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]
CMD [ "/home/valheim/init.sh" ] 