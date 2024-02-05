using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    public enum ApplicationCommandTypes
    {
        CHAT_INPUT = 1,
        USER = 2,
        MESSAGE = 3
    }

    internal class InteractionData
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("type")]
        public ApplicationCommandTypes CommandType { get; set; }

        [JsonPropertyName("options")]
        public Option[] Options { get; set; }

        [JsonPropertyName("guild_id")]
        public string GuildId { get; set; }

        [JsonPropertyName("target_id")]
        public string TargetId { get; set; }
    }
}
