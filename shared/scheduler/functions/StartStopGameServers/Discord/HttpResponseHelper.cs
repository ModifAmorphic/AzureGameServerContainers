using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    internal class HttpResponseHelper
    {
        public static HttpResponseMessage GetPingAck() =>
            new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(JsonSerializer.Serialize(new PingAck() { type = 1 }), Encoding.UTF8, "application/json")
            };

        public static HttpResponseMessage GetAciStartedResponse(string aciName)
        {
            var interactionResponse = new InteractionResponse()
            {
                ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE,
                Data = new ResponseData() { Content = $"Starting {aciName} server. This may take a few minutes.", Tts = false }
            };
            var responseJson = JsonSerializer.Serialize(interactionResponse);

            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseJson, Encoding.UTF8, "application/json")
            };
        }

        public static HttpResponseMessage GetVmStartedResponse(string vmName)
        {
            return GetVmStartedResponse(vmName, VmStates.Starting);
        }

        public static HttpResponseMessage GetVmStartedResponse(string vmName, VmStates vmState)
        {
            var interactionResponse = new InteractionResponse();
            switch (vmState)
            {
                case VmStates.StartRequested:
                case VmStates.Starting:
                    interactionResponse.ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE;
                    interactionResponse.Data = new ResponseData()
                    {
                        Content = "Starting game server. This may take a few minutes.",
                        Tts = new bool?(false)
                    };
                    break;
                case VmStates.Running:
                    interactionResponse.ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE;
                    interactionResponse.Data = new ResponseData()
                    {
                        Content = "Game server is already started.",
                        Tts = new bool?(false)
                    };
                    break;
                case VmStates.Stopping:
                case VmStates.Deallocating:
                    interactionResponse.ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE;
                    interactionResponse.Data = new ResponseData()
                    {
                        Content = "Game can not be started at this time. Please try again in a few minutes.",
                        Tts = new bool?(false)
                    };
                    break;
            }
            string str = JsonSerializer.Serialize<InteractionResponse>(interactionResponse, (JsonSerializerOptions)null);
            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = (HttpContent)new StringContent(str, Encoding.UTF8, "application/json")
            };
        }


        public static HttpResponseMessage GetBadCmdResponse()
        {
            var unknownCommand = JsonSerializer.Serialize(new InteractionResponse()
            {
                ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE,
                Data = new ResponseData() { Content = $"Unexpected command type requested.", Tts = false }
            });

            return new HttpResponseMessage(HttpStatusCode.BadRequest)
            {
                Content = new StringContent(unknownCommand, Encoding.UTF8, "application/json")
            };
        }
    }
}
