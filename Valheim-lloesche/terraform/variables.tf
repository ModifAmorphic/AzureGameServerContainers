variable "container_name" {
    description = "Name of the running Valheim Server container"
    type        = string
    default     = "valheim-server"
}

variable "dns-name" {
    description = "Name of the running Valheim Server container"
    type        = string
    default     = "valheim"
}

variable "memory" {
    description = "Memory in GB the container will be assigned"
    type        = string
    default     = "4"
}

variable "cpu" {
    description = "CPU Cores the container will be assigned"
    type        = string
    default     = "2"
}

variable "config-share" {
    description = "Storage account share name for mounting the /config directory"
    type        = string
    default     = "valheim-config"
}

variable "server-share" {
    description = "Storage account share name for mounting the /opt/valheim directory"
    type        = string
    default     = "valheim-server"
}

variable "env_vars" {
  description = "Env Variables for Valheim server startup"
  type        = map
  default     = {}
}

variable "discord_starting_json" {
    description = "Escaped json message to post to discord when the server is starting"
    type        = string
}
variable "discord_ready_json" {
    description = "Escaped json message to post to discord when the server is ready for connections"
    type        = string
}