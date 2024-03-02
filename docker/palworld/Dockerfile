ARG serverUser="palworld" \
	userGroup="palworld" \
 	steamDir="Steam" \
	gameName="Palworld" \
	gameNameLower="palworld"

FROM ubuntu:jammy AS steam_installer
ARG serverUser \
 	steamDir

## Install steamcommand, configure local and add user to run server
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl lib32gcc-s1 ca-certificates \
	&& update-ca-certificates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir "/${steamDir}" \
	&& curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C "/${steamDir}" \
	&& chmod +x "/${steamDir}/steamcmd.sh" \
	&& "/${steamDir}/steamcmd.sh" +quit

FROM ubuntu:jammy AS configurer
ARG serverUser \
	userGroup \
    steamDir \
	gameName \
	gameNameLower

# RUN apt-get update \
# 	&& apt-get install -y --no-install-recommends \
# 		lib32gcc-s1 locales ca-certificates moreutils \
# 	&& update-ca-certificates \
# 	&& locale-gen en_US.UTF-8 \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/* \
# 	&& useradd -m $serverUser

WORKDIR "/home/${serverUser}"

#System env variables
ENV	GAME_NAME="${gameName}" \
	GAME_NAME_LOWER="${gameNameLower}" \
	STEAM_APP_ID="2394010" \
	SERVER_USER="${serverUser}" \
	USER_GROUP="${userGroup}" \
	USER_HOME="/home/${serverUser}" \
 	STEAM_PATH="/home/${serverUser}/${steamDir}" \
	MA_SCRIPTS_PATH="/home/${serverUser}/scripts" \
	MA_LIBS_PATH="/home/${serverUser}/scripts/ma-libs" \
	LOG_PATH="/home/${serverUser}/${gameNameLower}-logs/Pal/Saved/Logs" \
	LOGFILE_PATH="" \
    LOGGER_PATH="/home/${serverUser}/scripts/ma-libs/logger.sh" \
	SERVER_PATH="/home/${serverUser}/${gameNameLower}-server" \
	# Configurable Environment Variables
 	PAL_ServerName="${gameName} Dedicated Server" \
	PAL_ServerPassword=""\
	PORT=8211 \
	PAL_PublicPort=8211 \
	PAL_RCONPort=25575 \
	PAL_RCONEnabled="False" \
	CUSTOM_START_SCRIPT="" \
	DISCORD_WEBHOOK="" \
	DISCORD_STARTING_MESSAGE="" \
	DISCORD_READY_MESSAGE="" \
	ENABLE_ENGINE_OPTIMIZATIONS=1 \
	ENABLE_PALWORLD_SETTINGS_OVERRIDES=1 \
	TIMEZONE="US/Mountain"

COPY --from=steam_installer /Steam $STEAM_PATH

# Install packages
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		lib32gcc-s1 locales ca-certificates moreutils \
		xdg-user-dirs xdg-utils python3-pandas iproute2 \
		curl \
	&& update-ca-certificates \
	&& locale-gen en_US.UTF-8 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Copy entry and startup scripts
COPY ./src/ $USER_HOME

## Setup user Access / Ownership
RUN useradd -m $SERVER_USER \
	&& mv "${USER_HOME}/entry.sh" /entry.sh && chmod +x /entry.sh \
	&& mv "${USER_HOME}/limits.conf" /etc/security \
	&& mkdir -p "${USER_HOME}/.steam/sdk32" \
	&& mkdir -p "${USER_HOME}/.steam/sdk64" \
	&& mkdir -p "${USER_HOME}/.config" \
	&& chown -R "${SERVER_USER}":"${USER_GROUP}" "${USER_HOME}/.config" \
	&& chown -R "${SERVER_USER}":"${USER_GROUP}" "${STEAM_PATH}" \
	&& chown -R "${SERVER_USER}":"${USER_GROUP}" "${MA_SCRIPTS_PATH}" \
	&& chown -R "${SERVER_USER}":"${USER_GROUP}" "${USER_HOME}/.steam" \
	&& chown -R "${SERVER_USER}":"${USER_GROUP}" "${MA_LIBS_PATH}" \
	&& chmod +x "${LOGGER_PATH}" \
	&& chmod +x "${USER_HOME}/init.sh" && chown "${SERVER_USER}":"${USER_GROUP}" "${USER_HOME}/init.sh" \
	&& chmod +x "${MA_SCRIPTS_PATH}/install-server.sh" \
	&& chmod +x "${MA_SCRIPTS_PATH}/start-server.sh"
	
# RUN runuser - "${serverUser}" -c \
# 		"ln -s \"${STEAM_PATH}/linux32/steamcmd\" \"${STEAM_PATH}/linux32/steam\" \
# 			&& ln -s \"${STEAM_PATH}/linux64/steamcmd\" \"${STEAM_PATH}/linux64/steam\" \
# 			&& ln -s \"${STEAM_PATH}/linux32/steamclient.so\" \"${USER_HOME}/.steam/sdk32/steamclient.so\" \
# 			&& ln -s \"${STEAM_PATH}/linux32/steamclient.so\" \"${STEAM_PATH}/steamclient.so\" \
# 			&& ln -s \"${STEAM_PATH}/linux64/steamclient.so\" \"${USER_HOME}/.steam/sdk64/steamclient.so\" \
# 			&& ln -s \"${STEAM_PATH}/steamcmd.sh\" \"${STEAM_PATH}/steam.sh\""

# && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
#                 && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
#                 && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
#                 && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
#                 && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
#                 && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \

#RUN ln -s "${STEAM_PATH}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]
CMD [ "/home/palworld/init.sh" ] 