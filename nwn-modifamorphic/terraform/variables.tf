variable "container_name" {
    description = "Name of the running Game Server container"
    type        = string
    default     = "nwnee-server"
}

variable "container_image" {
    description = "Repo of the docker image to run"
    type        = string
}

variable "dns-name" {
    description = "DNS Name of the running Game Server container"
    type        = string
    default     = "nwnee"
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

variable "azure_home_share" {
    description = "Storage account share name for mounting /home/nwn"
    type        = string
    default     = "nwn-user"
}

variable "env_vars" {
  description = "Env Variables for Game server startup"
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