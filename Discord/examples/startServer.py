import requests

## Captured request from discord - requires Validation be disabled in the function.

url = "https://gameservers-scheduler2.azurewebsites.net/api/resourcegroups/gaming/servers/start"

# This is an example CHAT_INPUT or Slash Command, with a type of 1
json =  {
  "app_permissions":"1071698665025",
  "application_id":"1059929709108011028",
  "channel_id":"1060345847839199232",
  "data":{
    "id":"1060313552138817637",
    "name":"startserver",
    "options": [
        {
          "name":"game","type":3,"value":"vm-games-host"
        }
      ],
      "type":1
      },
  "entitlement_sku_ids":[],
  "guild_id":"176837910417506304",
  "guild_locale":"en-US",
  "id":"1060371892164362281",
  "locale":"en-US",
  "member":{"deaf":False,"flags":0,"is_pending":False,"joined_at":"2016-05-02T23:30:43.503000+00:00","mute":False,"pending":False,"permissions":"4398046511103","roles":[],"user":{"discriminator":"1629","id":"176836692030783498","public_flags":0,"username":"Test-User"}},
  "token":"abcdefg",
  "type":2,
  "version":1
}

r = requests.post(url, json=json)

print(r.status_code)
print(r.content)