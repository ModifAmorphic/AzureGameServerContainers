container_name  = "palworld"
container_image = "modifamorphic/palworld"
location        = "southcentralus"
dns-name        = "palworld"
cpu             = "4"
memory          = "16"

azure_server_share = "palworld-server"

ports = [
  {
    port = 8211
    protocol = "UDP"
  },
  {
    port = 27015
    protocol = "UDP"
  },
]


env_vars = {
  PORT = 8211
  PAL_ServerName =  "Palworld Dedicated Server"
  PAL_BuildObjectDeteriorationDamageRate =  "0.000000"
  PAL_DeathPenalty =  "ItemAndEquipment"
  PAL_PalEggDefaultHatchingTime =  "2"
  PAL_bEnableNonLoginPenalty =  "False"
  ENGINE_LanServerMaxTickRate =  "/script/onlinesubsystemutils.ipnetdriver/LanServerMaxTickRate=120"
  ENGINE_NetServerMaxTickRate =  "/script/onlinesubsystemutils.ipnetdriver/NetServerMaxTickRate=120"
  ENGINE_ConfiguredInternetSpeed =  "/script/engine.player/ConfiguredInternetSpeed=104857600"
  ENGINE_ConfiguredLanSpeed =  "/script/engine.player/ConfiguredLanSpeed=104857600"
  ENGINE_bUseFixedFrameRate =  "/script/engine.engine/bUseFixedFrameRate=true"
  ENGINE_bSmoothFrameRate =  "/script/engine.engine/bSmoothFrameRate=true"
  ENGINE_SmoothedFrameRateRange =  "/script/engine.engine/SmoothedFrameRateRange=(LowerBound=(Type=Inclusive,Value=30.000000),UpperBound=(Type=Exclusive,Value=120.000000))"
  ENGINE_MinDesiredFrameRate =  "/script/engine.engine/MinDesiredFrameRate=60.000000"
  ENGINE_FixedFrameRate =  "/script/engine.engine/FixedFrameRate=120.000000"
  ENGINE_NetClientTicksPerSecond =  "/script/engine.engine/NetClientTicksPerSecond=120"
  ENGINE_TimeBetweenPurgingPendingKillObjects =  "/Script/Engine.GarbageCollectionSettings/TimeBetweenPurgingPendingKillObjects=120"
  ENGINE_r_ThreadedRendering =  "/Script/Engine.RendererSettings/r.ThreadedRendering=True"
  ENGINE_r_ThreadedPhysics =  "/Script/Engine.RendererSettings/r.ThreadedPhysics=True"
  DISCORD_STARTING_MESSAGE =  "$${PAL_ServerName} is starting..."
  DISCORD_READY_MESSAGE = "$${PAL_ServerName} is ready for players!\\nServer: $${SERVER_PUBLIC_IP}:$${PORT}\\nPassword: $${PAL_ServerPassword}"
}