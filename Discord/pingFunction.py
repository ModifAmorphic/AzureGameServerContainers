import requests

## Captured request from discord - requires Validation be disabled in the function unless correct headers are added.

url = "https://gameservers-scheduler.azurewebsites.net/api/resourceGroups/gaming/servers/start"


json =  {
  "application_id": "1059929709108011028",
  "id": "1060323985637777489",
  "token": "abcdefg",
  "type": 1,
  "user": {
    "discriminator": "1629",
    "id": "176836692030783498",
    "public_flags": 0,
    "username": "Test-User"
  },
  "version": 1
}

r = requests.post(url, json=json)

print(r.content)
