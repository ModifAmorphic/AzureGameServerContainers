#! /bin/bash

# Reads in the "PAL_" environment variables to a PAL_ENV_SETTINGS global key value pair
readPalEnvSettings() {
    declare -gA PAL_ENV_SETTINGS
    
    while IFS='=' read -r -d '' k v; do
        if [[  $k == PAL_* ]]; then
            key="${string#"$prefix"}"
            PAL_ENV_SETTINGS[${k}]=${v}
        fi
    done < <(env --null)

    # llog "PAL_ENV_SETTINGS keys: ${!PAL_ENV_SETTINGS[@]}"
    # llog "PAL_ENV_SETTINGS values: ${PAL_ENV_SETTINGS[@]}"
}

updateSetting() {
    local settingName="$1"
    local settingValue="$2"
}

