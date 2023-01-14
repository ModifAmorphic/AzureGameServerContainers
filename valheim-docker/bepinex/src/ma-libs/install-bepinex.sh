#!/bin/bash

set -e

versionFile="${SERVER_PATH}/bepinex_version"

[[ -f $versionFile ]] && installedVersion="$(<$versionFile)" && llog "BepInEx installed version - $installedVersion"

packageJson=$(curl -sqLS -H "Accept: application/json" "${THUNDERSTORE_API_URL}/experimental/package/denikson/BepInExPack_Valheim/")
version=$(jq -r .latest.version_number <<< "$packageJson")

if [[ "$installedVersion" != "$version" ]] && [[ -n "$version" ]]; then
    if [[ -z "$installedVersion" ]]; then
        llog "Installing BepinEx version ${version}"    
    else
        llog "Upgrading BepinEx to version ${version}"
    fi

    downloadUrl=$(jq -r .latest.download_url <<< "$packageJson")
    #Download, unzip, copy files to server folder and clean up
    llog "Downloading new version from $downloadUrl"
    curl -sL $downloadUrl --output "bep.zip" && unzip -q -C "bep.zip" BepInExPack_Valheim/* && yes | cp -af BepInExPack_Valheim/. "${SERVER_PATH}" && rm -r BepInExPack_Valheim && rm bep.zip
    printf -- "$version" > "$versionFile"
fi