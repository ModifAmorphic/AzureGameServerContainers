using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    public enum CommandOptionType
    {
        SUB_COMMAND = 1,
        SUB_COMMAND_GROUP= 2,
        STRING = 3,
        INTEGER	= 4,
        BOOLEAN	= 5,
        USER = 6,
        CHANNEL = 7,
        ROLE = 8,
        MENTIONABLE	= 9,
        NUMBER = 10,
        ATTACHMENT = 11
    }
    internal class Option
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("type")]
        public CommandOptionType OptionType { get; set; }

        [JsonPropertyName("value")]
        public string Value { get; set; }
    }
}
