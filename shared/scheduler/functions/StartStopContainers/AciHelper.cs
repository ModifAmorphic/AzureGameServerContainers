using Azure.ResourceManager.ContainerInstance;
using Azure.ResourceManager.Resources;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GameServers.Scheduler
{
    public enum AciStatus
    {
        Running,
        Stopped,
        Pending,
        Succeeded,
        Failed
    }
    internal class AciHelper
    {
        public static async Task<bool> StartAllAsync(string resourceGroup, ILogger log)
        {
            try
            {
                ResourceGroupResource resourceGroupResource = await GetResourceGroup(resourceGroup);
                await foreach (var group in resourceGroupResource.GetContainerGroups())
                {
                    ContainerGroupResource groupResource = await group.GetAsync();
                    var groupState = groupResource?.Data?.InstanceView?.State;
                    log.LogInformation("Container Group {Name}'s current state is {groupState}", group.Data.Name, groupState);
                    if (groupState == "Stopped" || groupState == "Failed")
                    {
                        log.LogInformation("Starting Container Group {Name}.", group.Data.Name);
                        await group.StartAsync(Azure.WaitUntil.Started);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error starting container instances. Exception: {Message}", ex.Message);
                throw;
            }
        }

        public static async Task<AciStatus> StartServerAsync(string resourceGroup, string aciGroupName, ILogger log)
        {
            try
            {
                ResourceGroupResource resourceGroupResource = await GetResourceGroup(resourceGroup);

                ContainerGroupResource aciGroup = await resourceGroupResource.GetContainerGroupAsync(aciGroupName);
                
                ContainerGroupResource groupResource = await aciGroup.GetAsync();
                var groupState = groupResource?.Data?.InstanceView?.State;
                log.LogInformation("Container Group {Name}'s current state is {groupState}", aciGroup.Data.Name, groupState);
                if (groupState == "Stopped" || groupState == "Failed")
                {
                    log.LogInformation("Starting Container Group {Name}.", aciGroup.Data.Name);
                    var status = await aciGroup.StartAsync(Azure.WaitUntil.Started);
                    return AciStatus.Pending;
                }
                else if (groupState == "Pending")
                    return AciStatus.Pending;
                else if (groupState == "Running")
                    return AciStatus.Running;
                else
                    return AciStatus.Failed;
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error starting container instances. Exception: {Message}" + ex.Message);
                throw;
            }
        }

        public static async Task<string> GetServerStatusAsync(string resourceGroup, string aciGroupName, ILogger log)
        {
            try
            {
                ResourceGroupResource resourceGroupResource = await GetResourceGroup(resourceGroup);

                ContainerGroupResource aciGroup = await resourceGroupResource.GetContainerGroupAsync(aciGroupName);

                ContainerGroupResource groupResource = await aciGroup.GetAsync();
                return groupResource?.Data?.InstanceView?.State;
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error starting container instances. Exception: {Message}", ex.Message);
                throw;
            }
        }

        public static async Task<bool> StopAllAsync(string resourceGroup, ILogger log)
        {
            try
            {
                ResourceGroupResource resourceGroupResource =await GetResourceGroup(resourceGroup);
                await foreach (var group in resourceGroupResource.GetContainerGroups())
                {
                    ContainerGroupResource groupResource = await group.GetAsync();
                    var groupState = groupResource?.Data?.InstanceView?.State;
                    log.LogInformation("Container Group {Name}'s current state is {groupState}", group.Data.Name, groupState);
                    if (groupState != "Stopped" && groupState != "Failed")
                    {
                        log.LogInformation("Stopping Container Group {Name}.", group.Data.Name);
                        await group.StopAsync();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error stopping container instances. Error: {Message}", ex.Message);
                throw;
            }
        }

        public static async Task<ResourceGroupResource> GetResourceGroup(string resourceGroup)
        {
            var armClient = Authenticator.GetClient();
            var subscription = await armClient.GetDefaultSubscriptionAsync();
            return await subscription.GetResourceGroupAsync(resourceGroup);
        }
    }
}
