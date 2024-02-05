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
        public static async Task<VmStates> StartServerAsync(
            string resourceGroupName,
            string vmName,
            ILogger log)
        {
            try
            {
                var vm = (VirtualMachineResource) await ComputeExtensions.GetVirtualMachineAsync(await GetResourceGroup(resourceGroupName), vmName, new InstanceViewType?(), new CancellationToken());
                var serverStateAsync = await GetServerStateAsync(vm);
                log.LogInformation("VM {Name} current state is {vmState}.", (object)vm.Data.Name, (object)serverStateAsync);
                switch (serverStateAsync)
                {
                    case VmStates.Starting:
                    case VmStates.Running:
                        log.LogInformation("{Name} is starting or already running. Current Status is {vmState}.", (object)vm.Data.Name, (object)serverStateAsync);
                        return serverStateAsync;
                    case VmStates.Stopped:
                    case VmStates.Deallocated:
                        log.LogInformation("Starting VM {Name}.", (object)vm.Data.Name);
                        _ = await vm.PowerOnAsync(WaitUntil.Started, new CancellationToken());
                        return VmStates.StartRequested;
                    default:
                        log.LogInformation("Attempting to starting VM {Name}.", (object)vm.Data.Name);
                        _ = await vm.PowerOnAsync(WaitUntil.Started, new CancellationToken());
                        return VmStates.StartRequested;
                }
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error starting VM {vmName}. Exception: {Message}", (object)vmName, (object)ex.Message);
                throw;
            }
        }

        public static async Task<VmStates> GetServerStateAsync(VirtualMachineResource virtualMachine)
        {
            var statuses = ((VirtualMachineResource)await virtualMachine.GetAsync(new InstanceViewType?(), new CancellationToken()))?.Data?.InstanceView?.Statuses;
            var serverStateAsync = VmStates.Unknown;
            if (statuses == null || !statuses.Any<InstanceViewStatus>())
                return serverStateAsync;
            if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/starting", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Starting;
            else if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/running", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Running;
            else if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/stopping", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Stopping;
            else if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/stopped", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Stopped;
            else if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/deallocating", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Deallocating;
            else if (statuses.Any<InstanceViewStatus>((Func<InstanceViewStatus, bool>)(s => s.Code.Equals("PowerState/deallocated", StringComparison.InvariantCultureIgnoreCase))))
                serverStateAsync = VmStates.Deallocated;
            return serverStateAsync;
        }

        public static async Task<ResourceGroupResource> GetResourceGroup(string resourceGroup)
        {
            var armClient = Authenticator.GetClient();
            var subscription = await armClient.GetDefaultSubscriptionAsync();
            return await subscription.GetResourceGroupAsync(resourceGroup);
        }
    }
}
