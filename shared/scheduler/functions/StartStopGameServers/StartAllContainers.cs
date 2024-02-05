using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Azure.ResourceManager.Resources;
using Azure.ResourceManager.ContainerInstance;
using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;

namespace GameServers.Scheduler
{
    public class StartAllContainers
    {
        //[FunctionName("startAllContainers")]
        public static async Task TimedRun([TimerTrigger("0 0 15 * * *")] TimerInfo myTimer, ILogger log)
        {
            await AciHelper.StartAllAsync("gaming", log);
        }

        [FunctionName("startGameServers")]
        public static async Task<IActionResult> Run(
                [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]
                HttpRequest req, ILogger log)
        {
            var isStarting = await AciHelper.StartAllAsync("gaming", log);
            if (isStarting)
                return new OkObjectResult($"Starting Server(s)");
            else
                return new StatusCodeResult(503);
        }
    }
}
