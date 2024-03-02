import collections
import configparser
import uuid
import pandas as pd
from io import StringIO
from typing import Dict
import os
import argparse
import re
import ueconfigparser

parser = argparse.ArgumentParser(description='Process config file updates from environment variables.')
parser.add_argument('-c', '--config-directory'
                    , required=True
                    , help='Path to the directory containing the ini configuration files for the server.')
args = parser.parse_args()

PAL_ENV_PREFIX="PAL_"
ENGINE_ENV_PREFIX="ENGINE_"
_palworldsettings_ini_file=os.path.join(args.config_directory, 'PalWorldSettings.ini')
PALWORLDSETTINGS_SECTION='/Script/Pal.PalGameWorldSettings'
_engine_ini_file=os.path.join(args.config_directory, 'Engine.ini')


pal_world_settings_file = os.path.join(args.config_directory, 'PalWorldSettings.ini')
engine_file = os.path.join(args.config_directory, 'Engine.ini')
ini_env_value_pattern = re.compile(r"(.+)\/([^=]+)=(.+)")

def first(iterable):
    return next((x for x in iterable), None)

def parse_ini_env_item(env_var_item):
    value=env_var_item[-1]
    if value is None or not value.strip():
        return None

    match = ini_env_value_pattern.match(value)
    if match is None or len(match.groups()) != 3:
        print(f"Warning - Could not parse environment variable: {first(env_var_item)}={value}")
        return None

    return {
        "section": match.groups()[0],
        "name": match.groups()[1],
        "value": match.groups()[2],
    }

def get_ini_settings(ini_file):
    # config = configparser.ConfigParser(strict=False, 
    #                                    empty_lines_in_values=False, 
    #                                    interpolation=UEInterpolation(),
    #                                    dict_type=ConfigParserMultiValues, 
    #                                    converters={"list": ConfigParserMultiValues.getlist})
    config = ueconfigparser.ConfigParser()
    config.read(ini_file)
    return config

def get_env_vars(prefix, remove_prefix=False):
    env_settings = {}
    for key, value in os.environ.items():
        if key.startswith(prefix):
            if remove_prefix:
                env_settings[key.removeprefix(prefix)] = value
            else:
                env_settings[key] = value
    return env_settings

def get_palworld_settings():
    assert os.path.isfile(_palworldsettings_ini_file)
    config = get_ini_settings(_palworldsettings_ini_file)

    option_settings=StringIO(config[PALWORLDSETTINGS_SECTION]['OptionSettings'] [1:-1])
    df = pd.read_csv(option_settings, header=None)
    settings = df.tail(1)
    
    pal_settings = {}
    for colId in settings.columns:
        key, value = first(settings[colId].values).split('=', 1)
        pal_settings[key] = value
    
    return pal_settings

def update_pal_ini(pal_settings):
    print(f"Updating {_palworldsettings_ini_file} file.")
    ini_settings = get_palworld_settings()
    for setting in pal_settings:
        if setting in ini_settings:
            ini_settings[setting] = pal_settings[setting]

    option_settings="(" + ",".join("=".join(_) for _ in ini_settings.items()) + ")"
    config = get_ini_settings(_palworldsettings_ini_file)
    config[PALWORLDSETTINGS_SECTION]['OptionSettings'] = option_settings
    
    new_file = pal_world_settings_file + ".new"
    with open(new_file, 'w') as fileio:
      config.write(fileio)
    
    os.replace(pal_world_settings_file, pal_world_settings_file + '.bak')
    os.replace(new_file, pal_world_settings_file)

    # print("Pal ini Settings: ", str(option_settings))

def update_engine_ini(eng_env_vars):
    print(f"Updating {_engine_ini_file} file.")
    config = get_ini_settings(_engine_ini_file)
    # print("Updating Engine.ini with: " + str(eng_env_vars))
    config_updated=False
    for env_var in eng_env_vars.items():
        setting = parse_ini_env_item(env_var)
        if setting is None:
            continue
        section = setting["section"]
        # add section if missing
        if not config.has_section(section):
            # print("Adding section " + section)
            config.add_section(section)
        config[section][setting["name"]] = setting["value"]
        config_updated = True
        # print ("[", setting["section"], "]", sep="")
        # print (setting["name"], setting["value"], sep="=")
    
    # If no updates, don't write to the file
    if not config_updated: return
    
    new_file = _engine_ini_file + ".new"
    with open(new_file, 'w') as fileio:
      config.write(fileio)
    
    os.replace(_engine_ini_file, _engine_ini_file + '.bak')
    os.replace(new_file, _engine_ini_file)

def main():
    pal_env_settings = get_env_vars(PAL_ENV_PREFIX, True)
    engine_env_settings = get_env_vars(ENGINE_ENV_PREFIX, False)
    update_pal_ini(pal_env_settings)
    
    update_engine_ini(engine_env_settings)
    # eng_setting = parse_ini_env_item(first(engine_env_settings.items()))
    # print ("[", eng_setting["section"], "]", sep="")
    # print (eng_setting["setting"], eng_setting["value"], sep="=")

main()

def displaymatch(match):
    if match is None:
        return None
    return '<Match: %r, groups=%r>' % (match.group(), match.groups())




# input_string_1 = '/script/onlinesubsystemutils.ipnetdriver/LanServerMaxTickRate=120'
# input_string_2 = '/script/engine.engine/SmoothedFrameRateRange=(LowerBound=(Type=Inclusive,Value=30.000000),UpperBound=(Type=Exclusive,Value=120.000000))'
# # pattern = re.compile(r"^\/([^=]+)=.+")

# # Three matches
# #   '(.+\/)\/' ini section excluding the last backslash
# #   '([^=]+)=' setting name excluding the =
# #   '(.+)' setting value
# pattern = re.compile(r"(.+)\/([^=]+)=(.+)")

# match_1 = pattern.match(input_string_1)
# match_2 = pattern.match(input_string_2)

# # print(displaymatch(match_1))
# # print(displaymatch(match_2))
# print ("[", match_2.groups()[0], "]", sep="")
# print (match_2.groups()[1], match_2.groups()[2], sep="=")
