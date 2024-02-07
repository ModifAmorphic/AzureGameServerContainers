using Azure;
using Azure.ResourceManager;
using Azure.ResourceManager.Compute;
using Azure.ResourceManager.Compute.Models;
using Azure.ResourceManager.Resources;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace GameServers.Scheduler
{
    internal class VmManager
    {
        public static async Task<VmStates> StartServerAsync(string resourceGroupName, string vmName, ILogger log)
        {
            try
            {
                ResourceGroupResource resourceGroup = await GetResourceGroup(resourceGroupName);
                VirtualMachineResource vm = await resourceGroup.GetVirtualMachineAsync(vmName);

                //TODO: State is always empty
                var vmState = await GetServerStateAsync(vm);

                log.LogInformation("VM {Name} current state is {vmState}.", vm.Data.Name, vmState);
                if (vmState == VmStates.Stopped || vmState == VmStates.Deallocated)
                {
                    log.LogInformation("Starting VM {Name}.", vm.Data.Name);
                    _ = await vm.PowerOnAsync(Azure.WaitUntil.Started);
                    return VmStates.StartRequested;
                }
                else if (vmState == VmStates.Starting || vmState == VmStates.Running)
                {
                    log.LogInformation("{Name} is starting or already running. Current Status is {vmState}.", vm.Data.Name, vmState);
                }
                else
                {
                    log.LogInformation("Attempting to start VM {Name}.", vm.Data.Name);
                    _ = await vm.PowerOnAsync(Azure.WaitUntil.Started);
                    return VmStates.StartRequested;
                }

                return vmState;
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error starting VM {vmName}. Exception: {Message}", vmName, ex.Message);
                throw;
            }
        }

        public static async Task<VmStates> GetServerStateAsync(VirtualMachineResource virtualMachine)
        {
            VirtualMachineResource vm = await virtualMachine.GetAsync();
            var statuses = vm?.Data?.InstanceView?.Statuses;
            var vmState = VmStates.Unknown;
            if (statuses == null || !statuses.Any())
                return vmState;

            if (statuses.Any(s => s.Code.Equals("PowerState/starting", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Starting;
            else if (statuses.Any(s => s.Code.Equals("PowerState/running", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Running;
            else if (statuses.Any(s => s.Code.Equals("PowerState/stopping", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Stopping;
            else if (statuses.Any(s => s.Code.Equals("PowerState/stopped", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Stopped;
            else if (statuses.Any(s => s.Code.Equals("PowerState/deallocating", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Deallocating;
            else if (statuses.Any(s => s.Code.Equals("PowerState/deallocated", StringComparison.InvariantCultureIgnoreCase)))
                vmState = VmStates.Deallocated;

            return vmState;
        }
        
        public static async Task<ResourceGroupResource> GetResourceGroup(string resourceGroup)
        {
            var armClient = Authenticator.GetClient();
            var subscription = await armClient.GetDefaultSubscriptionAsync();
            return await subscription.GetResourceGroupAsync(resourceGroup);
        }

        //public static async Task<bool> StartAllAsync(string resourceGroup, ILogger log)
        //{
        //    try
        //    {
        //        ResourceGroupResource resourceGroupResource = await GetResourceGroup(resourceGroup);
        //        await foreach (var group in resourceGroupResource.GetContainerGroups())
        //        {
        //            ContainerGroupResource groupResource = await group.GetAsync();
        //            var groupState = groupResource?.Data?.InstanceView?.State;
        //            log.LogInformation("Container Group {Name}'s current state is {groupState}", group.Data.Name, groupState);
        //            if (groupState == "Stopped" || groupState == "Failed")
        //            {
        //                log.LogInformation("Starting Container Group {Name}.", group.Data.Name);
        //                await group.StartAsync(Azure.WaitUntil.Started);
        //            }
        //        }
        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.LogError(ex, "Error starting container instances. Exception: {Message}", ex.Message);
        //        throw;
        //    }
        //}
        
        //public static async Task<bool> StopAllAsync(string resourceGroup, ILogger log)
        //{
        //    try
        //    {
        //        ResourceGroupResource resourceGroupResource =await GetResourceGroup(resourceGroup);
        //        await foreach (var group in resourceGroupResource.GetContainerGroups())
        //        {
        //            ContainerGroupResource groupResource = await group.GetAsync();
        //            var groupState = groupResource?.Data?.InstanceView?.State;
        //            log.LogInformation("Container Group {Name}'s current state is {groupState}", group.Data.Name, groupState);
        //            if (groupState != "Stopped" && groupState != "Failed")
        //            {
        //                log.LogInformation("Stopping Container Group {Name}.", group.Data.Name);
        //                await group.StopAsync();
        //            }
        //        }
        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.LogError(ex, "Error stopping container instances. Error: {Message}", ex.Message);
        //        throw;
        //    }
        //}

    }
}
