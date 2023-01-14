#!/bin/bash

#set -e

main() {
    if [[ -z "$THUNDERSTORE_PLUGINS" ]]; then
        llog "No plugins set in THUNDERSTORE_PLUGINS" 
        return 0
    fi

    local namespace; local name; local version;

    jq -c '.[]' <<< $THUNDERSTORE_PLUGINS | 
    while read -r plugin
    do
        namespace=$(jq -r '.namespace' <<< "$plugin");
        name=$(jq -r '.name' <<< "$plugin");
        version=$(jq -r '.version' <<< "$plugin");
        #printf '%s\t%s\t%s\n' "$namespace" "$name" "$version";
        downloadPlugin "$namespace" "$name" "$version"
    done
}

getInstalledVersion() {
    local _pluginFolder=$1
    local __installedVersion=$2;

    local manifestFile="${_pluginFolder}/manifest.json"
    
    #Exit if no manifest found
    [[ ! -f "$manifestFile" ]] && return 0

    local ___version=$(jq -r '.version_number' "${_pluginFolder}/manifest.json")

    eval "$__installedVersion=$___version"
}

getPluginFolder() {
    local _namespace=$1; local _name=$2
    local __pluginFolder=$3;

    local ___folder="${PLUGINS_PATH}/${_namespace}-${_name}"

    eval "$__pluginFolder=$___folder"
}

downloadPlugin() {
    local _namespace=$1; local _name=$2; local _version=$3
    
    local modName="${_namespace}-${_name}"

    #get directory path of the installed plugin
    local pluginFolder
    getPluginFolder $_namespace $_name pluginFolder

    local installedVersion
    getInstalledVersion $pluginFolder installedVersion

    [[ -n "$installedVersion" ]] && llog "Found installed plugin ${modName} version ${installedVersion}"

    if [[ -n "$installedVersion" ]] && [[ "$installedVersion" == "$_version" ]]; then
        llog "Installed version of mod ${modName} matches requested version ${_version}."
        return 0
    fi

    local packageJson=$(curl -sqLS -H "Accept: application/json" "${THUNDERSTORE_API_URL}/experimental/package/${_namespace}/${_name}/")
    
    local reqVersion
    
    if [[ -z "$_version" ]] || [[ "${_version,,}" == "latest" ]]; then
        reqVersion=$(jq -r .latest.version_number <<< "$packageJson")
    else
        reqVersion="$_version"
    fi

    if [[ "$installedVersion" != "$reqVersion" ]]; then
        if [[ -z "$installedVersion" ]]; then
            llog "Installing plugin ${modName} version ${reqVersion}"
        else
            llog "Upgrading plugin ${modName} to version ${reqVersion}"
        fi

        local downloadUrl=$(jq -r .latest.download_url <<< "$packageJson")
        local zipFile="${modName}.zip"

        #Download, unzip, copy files to server folder and clean up
        local tmpDir=$( mktemp -d --suffix $modName )
        local modDir="${PLUGINS_PATH}/${modName}"
        mkdir -p "$tmpDir/$modName"
        mkdir -p "$modDir"
        
        llog "Downloading new version from $downloadUrl"
        curl -sL $downloadUrl --output "$tmpDir/$zipFile" \
            && unzip -q -C "$tmpDir/$zipFile" -d "$tmpDir/$modName"

        # Merge into mod directory
        (cd "$tmpDir/$modName" && tar c .) | (cd "$modDir" && tar xf -)
        rm -r "$tmpDir"
        #printf -- "$version" > "$versionFile"
    fi
}

main