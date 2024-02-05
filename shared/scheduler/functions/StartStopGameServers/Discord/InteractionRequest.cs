using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    //From https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-type
    public enum InteractionTypes
    {
        PING = 1,
        APPLICATION_COMMAND = 2,
        MESSAGE_COMPONENT = 3,
        APPLICATION_COMMAND_AUTOCOMPLETE = 4,
        MODAL_SUBMIT = 5
    }

    internal class InteractionRequest
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("application_id")]
        public string ApplicationId { get; set; }

        [JsonPropertyName("type")]
        public InteractionTypes InteractionType { get; set; }

        [JsonPropertyName("data")]
        public InteractionData Data { get; set; }

        [JsonPropertyName("guild_id")]
        public string GuildId { get; set; }

        [JsonPropertyName("channel_id")]
        public string ChannelId { get; set; }

        [JsonPropertyName("token")]
        public string Token { get; set; }

        [JsonPropertyName("version")]
        public int Version { get; set; }

        [JsonPropertyName("app_permissions")]
        public string AppPermissions { get; set; }

        [JsonPropertyName("locale")]
        public string Locale { get; set; }

        [JsonPropertyName("guild_locale")]
        public string GuildLocale { get; set; }
    }
}
