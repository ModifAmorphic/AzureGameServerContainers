import requests
import subprocess
import sys

url = "https://discord.com/api/v10/channels/808015740648947764/webhooks"

# This is an example CHAT_INPUT or Slash Command, with a type of 1
json = {
    "name": "ServerStarter"
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