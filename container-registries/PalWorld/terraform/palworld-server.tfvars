container_name  = "palworld"
container_image = "modifamorphic/palworld"
location        = "southcentralus"
dns-name        = "palworld"
cpu             = "4"
memory          = "16"

azure_server_share = "palworld-server"

env_vars = {
  SERVER_NAME = "Palworld Dedicated Server"
}