using GameServers.Scheduler.Discord;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace GameServers.Scheduler
{
    public class ContainerGroupFuncs
    {
        [FunctionName("startGameServer")]
        public static async Task<IActionResult> StartGameServer(
                [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "resourceGroups/{resourceGroup}/servers/{serverName}/start")]
                HttpRequest req, string resourceGroup, string serverName, ILogger log)
        {
            var status = await AciHelper.StartServerAsync(resourceGroup, serverName, log);

            if (status == AciStatus.Pending)
                return new OkObjectResult($"Starting Server " + serverName);
            else if (status == AciStatus.Running)
                return new OkObjectResult($"Server " + serverName + " is already running");
            else
                return new StatusCodeResult(503);
        }

        [FunctionName("getGameServer")]
        public static async Task<IActionResult> GetGameServer(
                [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "resourceGroups/{resourceGroup}/servers/{serverName}")]
                HttpRequest req, string resourceGroup, string serverName, ILogger log)
        {
            try
            {
                var status = await AciHelper.GetServerStatusAsync(resourceGroup, serverName, log);
                return new OkObjectResult(status);
            }
            catch
            {
                return new StatusCodeResult(503);
            }
        }
        
    }
}
