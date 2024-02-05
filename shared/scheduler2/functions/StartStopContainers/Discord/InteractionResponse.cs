using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    //From https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-type
    public enum InteractionResponseTypes
    {
        PONG = 1,
        CHANNEL_MESSAGE_WITH_SOURCE = 4,
        DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE = 5,
        DEFERRED_UPDATE_MESSAGE = 6,
        UPDATE_MESSAGE = 7,
        APPLICATION_COMMAND_AUTOCOMPLETE_RESULT = 8,
        MODAL = 9
    }
    internal class InteractionResponse
    {
        [JsonPropertyName("type")]
        public InteractionResponseTypes ResponseType { get; set; }

        [JsonPropertyName("data")]
        public ResponseData Data { get; set; }
    }
}
