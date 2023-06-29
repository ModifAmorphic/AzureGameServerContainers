ARG server_user="nwn" \
 	steam_dir="Steam"

FROM ubuntu:jammy AS steam_installer
ARG server_user \
 	steam_dir

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
ARG server_user \
    steam_dir


# RUN apt-get update \
# 	&& apt-get install -y --no-install-recommends \
# 		lib32gcc-s1 locales ca-certificates moreutils \
# 	&& update-ca-certificates \
# 	&& locale-gen en_US.UTF-8 \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/* \
# 	&& useradd -m $server_user

WORKDIR "/home/${server_user}"

# Installs
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		lib32gcc-s1 locales ca-certificates moreutils \
		curl iputils-ping \
	&& update-ca-certificates \
	&& locale-gen en_US.UTF-8 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#System env variables
ENV	SERVER_USER="${server_user}" \
	USER_HOME="/home/${server_user}" \
 	STEAM_PATH="/home/${server_user}/${steam_dir}" \
	STEAM_APP_ID=704450 \
	MA_LIBS_PATH="/home/${server_user}/ma-libs" \
	LOG_PATH="/home/${server_user}/nwn-logs" \
	LOGFILE_PATH="/home/${server_user}/nwn-logs/nwn-server.log" \
    LOGGER_PATH="/home/${server_user}/ma-libs/logger.sh" \
	SERVER_PATH="/home/${server_user}/nwn-server" \
	# Configurable Environment Variables
 	SERVER_NAME="Wailing: Chapt 2" \
	PORT=5121 \
	PLAYER_PASSWORD="" \
	DM_PASSWORD="dmpass" \
	ADMIN_PASSWORD="adminpass" \
	IS_PUBLIC=0 \
	MODULE="Chapter2" \
	LOAD_SLOT="" \
	MIN_LEVEL=1 \
	MAX_LEVEL=40 \
	PAUSE_AND_PLAY=0 \
	PVP_TYPE=1 \
	USE_SERVER_VAULT=0 \
	ENFORCE_LEGAL_CHARs=1 \
	ITEM_LEVEL_RESTRICTIONS=0 \
	GAME_TYPE=1 \
	ONE_PARTY=1 \
	DIFFICULTY=2 \
	AUTOSAVE_INTERVAL=5 \
	RELOAD_WHEN_EMPTY=0 \
	CUSTOM_START_SCRIPT=""

COPY --from=steam_installer /Steam $STEAM_PATH


# Copy entry and startup scripts
COPY ./src/ $USER_HOME

## Set Access / Ownership to $server_user
RUN	useradd -m $server_user \
	&& mv "${USER_HOME}/entry.sh" /entry.sh && chmod +x /entry.sh \
	&& mv "${USER_HOME}/limits.conf" /etc/security \
	&& mv "${USER_HOME}/init/"* "${USER_HOME}/"  && rm -r "${USER_HOME}/init" \
	&& mkdir -p "${USER_HOME}/.steam/sdk32" \
	&& mkdir -p "${USER_HOME}/.steam/sdk64" \
	&& chown -R $server_user:$server_user "${STEAM_PATH}" \
	&& chown -R $server_user:$server_user "${USER_HOME}/start-scripts" \
	&& chown -R $server_user:$server_user "${USER_HOME}/.steam" \
	&& chown -R $server_user:$server_user "${MA_LIBS_PATH}" \
	&& chmod +x "${LOGGER_PATH}" \
	&& chmod +x "${USER_HOME}/init.sh" && chown $server_user:$server_user "${USER_HOME}/init.sh" \
	&& chmod +x "${MA_LIBS_PATH}/install-nwnee.sh" \
	&& chmod +x "${USER_HOME}/start-scripts/start.sh"  \
	&& chmod +x "${USER_HOME}/start-scripts/start-nwnee-server.sh" \
	&& runuser - "${server_user}" -c \
		"ln -s \"${STEAM_PATH}/linux32/steamcmd\" \"${STEAM_PATH}/linux32/steam\" \
				&& ln -s \"${STEAM_PATH}/linux32/steamclient.so\" \"${USER_HOME}/.steam/sdk32/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/linux64/steamclient.so\" \"${USER_HOME}/.steam/sdk64/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/steamcmd.sh\" \"${STEAM_PATH}/steam.sh\""


#RUN ln -s "${STEAM_PATH}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]
CMD [ "/home/nwn/init.sh" ] 