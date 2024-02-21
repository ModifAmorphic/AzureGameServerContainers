import requests
import subprocess
import sys

url = "https://discord.com/api/v10/applications/1059929709108011028/commands"

# This is an example CHAT_INPUT or Slash Command, with a type of 1
json = {
    "name": "startserver",
    "type": 1,
    "description": "Start a game server",
    "options": [
        {
            "name": "game",
            "description": "The game server",
            "type": 3,
            "required": True,
            "choices": [
                {
                    "name": "Valheim",
                    "value": "valheim-sanitysrefuge"
                },
                {
                    "name": "Minecraft",
                    "value": "vm-games-host"
                },
                {
                    "name": "Palworld",
                    "value": "palworld"
                }
                # ,{
                #     "name": "Astroneer",
                #     "value": "game_astroneer"
                # },
            ]
        }
    ]
}

bottoken = subprocess.check_output('az keyvault secret show --name DiscordServerStarterBotToken --vault-name gaming-keyvault --query value -otsv', shell=True)

# For authorization, you can use either your bot token
headers = {
    "Authorization": "Bot " + bottoken.decode(sys.stdout.encoding).strip()
}

# or a client credentials token for your app with the applications.commands.update scope
# headers = {
#     "Authorization": "Bearer <my_credentials_token>"
# }

r = requests.post(url, headers=headers, json=json)

print(r.status_code)
print(r.content)