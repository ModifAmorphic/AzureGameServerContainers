using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GameServers.Scheduler.Discord
{
    //Partial implementation of https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-messages
    internal class ResponseData
    {
        [JsonPropertyName("tts")]
        public bool? Tts { get; set; }

        [JsonPropertyName("content")]
        public string Content { get; set; }

        //[JsonPropertyName("flags")]
        //public int? Flags { get; set; }
    }
}
