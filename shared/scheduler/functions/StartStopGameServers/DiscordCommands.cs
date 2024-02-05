using GameServers.Scheduler.Discord;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace GameServers.Scheduler
{
    public class DiscordCommands
    {
        private static HashSet<string> _aciGameServers = new HashSet<string>()
        {
            "valheim-sanitysrefuge"
        };
        private static HashSet<string> _vmGameServers = new HashSet<string>()
        {
            "vm-games-host"
        };

        [FunctionName("startGameServerDiscordCmd")]
        public static async Task<HttpResponseMessage> StartGameServerDiscordCmd(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "resourceGroups/{resourceGroup}/servers/start")]
            HttpRequest req, string resourceGroup, ILogger log)
        {
            try
            {
                var body = await new StreamReader(req.Body).ReadToEndAsync();
                req.Body.Seek(0, SeekOrigin.Begin);
                //log.LogDebug("Received raw json body:\n{body}", body);

                if (!Authenticator.VerifySignatureAsync(req.Headers, body))
                {
                    log.LogDebug("Unable to authorize request.");
                    return new HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                }

                var interaction = await JsonSerializer.DeserializeAsync<InteractionRequest>(req.Body);

                var json = JsonNode.Parse(body);
                log.LogDebug("Received json body:\n{body}", json.ToString());

                //Check for ping request
                if (interaction.InteractionType == InteractionTypes.PING)
                {
                    log.LogDebug("Acknowledging ping request");
                    return HttpResponseHelper.GetPingAck();
                }

                if (interaction.InteractionType == InteractionTypes.APPLICATION_COMMAND)
                {
                    if (interaction.Data?.Options?.Length > 0)
                    {
                        var serverName = interaction.Data.Options.First().Value;
                        if (DiscordCommands._aciGameServers.Contains(serverName))
                        {
                            _ = AciHelper.StartServerAsync(resourceGroup, serverName, log);
                            return HttpResponseHelper.GetAciStartedResponse(serverName);
                        }
                        if (DiscordCommands._vmGameServers.Contains(serverName))
                        {
                            _ = VmManager.StartServerAsync(resourceGroup, serverName, log);
                            return HttpResponseHelper.GetVmStartedResponse(serverName);
                        }
                        log.LogError("Unknown action requested. serverName={serverName}, resourceGroup={resourceGroup}", serverName, resourceGroup);
                    }
                }

                return HttpResponseHelper.GetBadCmdResponse();
            }
            catch (Exception ex)
            {
                log.LogError("Error starting game server. Exception {Message}", ex.Message);
                return new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError);
            }
        }
    }
}
