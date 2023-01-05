using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    internal class HttpResponseHelper
    {
        public static HttpResponseMessage GetPingAck() =>
            new HttpResponseMessage(System.Net.HttpStatusCode.OK)
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

            return new HttpResponseMessage(System.Net.HttpStatusCode.OK)
            {
                Content = new StringContent(responseJson, Encoding.UTF8, "application/json")
            };
        }

        public static HttpResponseMessage GetBadCmdResponse()
        {
            var unknownCommand = JsonSerializer.Serialize(new InteractionResponse()
            {
                ResponseType = InteractionResponseTypes.CHANNEL_MESSAGE_WITH_SOURCE,
                Data = new ResponseData() { Content = $"Unexpected command type requested.", Tts = false }
            });

            return new HttpResponseMessage(System.Net.HttpStatusCode.BadRequest)
            {
                Content = new StringContent(unknownCommand, Encoding.UTF8, "application/json")
            };
        }
    }
}
