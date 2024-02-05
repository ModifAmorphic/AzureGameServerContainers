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
    public class StopAllContainers
    {
        [FunctionName("stopAllContainers")]
        public static async Task TimedStop([TimerTrigger("0 32 6 * * *")] TimerInfo myTimer, ILogger log)
        {
            await AciHelper.StopAllAsync("gaming", log);
        }

        [FunctionName("stopGameServers")]
        public static async Task<IActionResult> Run(
                [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)]
                HttpRequest req, ILogger log)
        {
            var isStopping = await AciHelper.StopAllAsync("gaming", log);
            if (isStopping)
                return new OkObjectResult($"Stopping Server(s)");
            else
                return new StatusCodeResult(503);
        }
    }
}
