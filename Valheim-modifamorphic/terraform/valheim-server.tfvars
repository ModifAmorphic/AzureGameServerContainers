container_name = "valheim-sanitysrefuge"
container_image = "modifamorphic/valheim-bepinex"
dns-name = "sanitysrefuge"
cpu = "2"
memory = "4"

azure_saves_share = "valheim-sanitysrefuge-saves"
azure_server_share = "valheim-sanitysrefuge-server"
azure_backups_share = "valheim-sanitysrefuge-backups"
#azure_logs_share = "valheim-sanitysrefuge-logs"

env_vars = {
    SERVER_NAME="Sanity's Refuge"
    WORLD_NAME="TheWilds"
    PORT=2456
    IS_PUBLIC=0
    SAVE_INTERVAL=1200
    #THUNDERSTORE_MODS="[{ \"namespace\": \"ValheimModding\", \"name\": \"Jotunn\", \"version\": \"latest\" }, { \"namespace\": \"Digitalroot\", \"name\": \"Heightmap_Unlimited_Remake\", \"version\": \"latest\" }, { \"namespace\": \"Nextek\", \"name\": \"SpeedyPaths\", \"version\": \"latest\" }, { \"namespace\": \"OdinPlus\", \"name\": \"CraftyCartsRemake\", \"version\": \"latest\" }]"
    THUNDERSTORE_MODS=<<-EOT
                [
                    { "namespace": "Smoothbrain", "name": "Network", "version": "latest" },
                    { "namespace": "ValheimModding", "name": "Jotunn", "version": "latest" },
                    { "namespace": "Nextek", "name": "SpeedyPaths", "version": "latest" }, 
                    { "namespace": "OdinPlus", "name": "CraftyCartsRemake", "version": "latest" },
                    { "namespace": "Advize", "name": "PlantEverything", "version": "latest" },
                    { "namespace": "Vapok", "name": "AdventureBackpacks", "version": "latest" },
                    { "namespace": "Smoothbrain", "name": "Farming", "version": "latest" },
                    { "namespace": "NexusTransfer", "name": "ValheimRAFT", "version": "latest" },
                    { "namespace": "Digitalroot", "name": "Heightmap_Unlimited_Remake", "version": "latest" },
                    { "namespace": "bonesbro", "name": "FloorsAreRoofs", "version": "latest" },
                    { "namespace": "NexusPort", "name": "SeafloorWalkingBoots", "version": "latest" },
                    { "namespace": "RandyKnapp", "name": "AdvancedPortals", "version": "latest" },
                    { "namespace": "Smoothbrain", "name": "DualWield", "version": "latest" },
                    { "namespace": "OdinPlus", "name": "ServerSyncDeathTweaks", "version": "latest" }
                ]
                EOT
    PRUNE_MODS=1
}

discord_starting_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is starting...\\\"}"
discord_ready_json = "{\\\"content\\\":\\\"Sanity's Refuge Valheim server is running and ready for players!\\\"}"

                # { "namespace": "ValheimModding", "name": "Jotunn", "version": "latest" },
                # { "namespace": "Digitalroot", "name": "Heightmap_Unlimited_Remake", "version": "latest" }, 