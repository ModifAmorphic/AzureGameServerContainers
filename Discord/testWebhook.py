import requests
import subprocess
import sys

urlbytes = subprocess.check_output('az keyvault secret show --name ValheimSanitysRefugeDiscordWebhook --vault-name gaming-keyvault --query value -otsv', shell=True)
url = urlbytes.decode(sys.stdout.encoding).strip()
print (url)
# This is an example CHAT_INPUT or Slash Command, with a type of 1
json = {
    "content": "Sanity's Refuge Valheim server is running and ready for players!"
}

headers = {
    "Content-Type": "application/json"
}

r = requests.post(url, headers=headers, json=json)

print(r.status_code)
print(r.content)