ARG server_user="PalWorld" \
 	steam_dir="Steam" \
	game_name="PalWorld"

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

#System env variables
ENV	GAME_NAME="${game_name}" \
	STEAM_APP_ID="2394010" \
	SERVER_USER="${server_user}" \
	USER_HOME="/home/${server_user}" \
 	STEAM_PATH="/home/${server_user}/${steam_dir}" \
	MA_LIBS_PATH="/home/${server_user}/ma-libs" \
	LOG_PATH="/home/${server_user}/${game_name}-logs" \
	LOGFILE_PATH="/home/${server_user}/${game_name}-logs/${game_name}-server.log" \
    LOGGER_PATH="/home/${server_user}/ma-libs/logger.sh" \
	SERVER_PATH="/home/${server_user}/${game_name}-server" \
	# Configurable Environment Variables
 	SERVER_NAME="${game_name} Dedicated Server" \
	PORT=8211 \
	CUSTOM_START_SCRIPT=""

COPY --from=steam_installer /Steam $STEAM_PATH

# Copy entry and startup scripts
COPY ./src/ $USER_HOME

## Set Access / Ownership to $server_user
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		lib32gcc-s1 locales ca-certificates moreutils \
	&& update-ca-certificates \
	&& locale-gen en_US.UTF-8 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& useradd -m $server_user \
	&& mv "${USER_HOME}/entry.sh" /entry.sh && chmod +x /entry.sh \
	&& mv "${USER_HOME}/limits.conf" /etc/security \
	&& mv "${USER_HOME}/init/"* "${USER_HOME}/"  && rm -r "${USER_HOME}/init" \
	&& mkdir -p "${USER_HOME}/.steam/sdk32" \
	&& mkdir -p "${USER_HOME}/.steam/sdk64" \
	&& chown -R $server_user:"$GAME_NAME" "${STEAM_PATH}" \
	&& chown -R $server_user:"$GAME_NAME" "${USER_HOME}/start-scripts" \
	&& chown -R $server_user:"$GAME_NAME" "${USER_HOME}/.steam" \
	&& chown -R $server_user:"$GAME_NAME" "${MA_LIBS_PATH}" \
	&& chmod +x "${LOGGER_PATH}" \
	&& chmod +x "${USER_HOME}/init.sh" && chown $server_user:"$GAME_NAME" "${USER_HOME}/init.sh" \
	&& chmod +x "${MA_LIBS_PATH}/install-server.sh" \
	&& chmod +x "${USER_HOME}/start-scripts/start.sh"  \
	&& chmod +x "${USER_HOME}/start-scripts/start-server.sh" \
	&& runuser - "${server_user}" -c \
		"ln -s \"${STEAM_PATH}/linux32/steamcmd\" \"${STEAM_PATH}/linux32/steam\" \
				&& ln -s \"${STEAM_PATH}/linux32/steamclient.so\" \"${USER_HOME}/.steam/sdk32/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/linux64/steamclient.so\" \"${USER_HOME}/.steam/sdk64/steamclient.so\" \
				&& ln -s \"${STEAM_PATH}/steamcmd.sh\" \"${STEAM_PATH}/steam.sh\""


#RUN ln -s "${STEAM_PATH}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]
CMD [ "/home/PalWorld/init.sh" ] 