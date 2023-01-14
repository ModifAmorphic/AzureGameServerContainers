variable "container_name" {
    description = "Name of the running Valheim Server container"
    type        = string
    default     = "valheim-server"
}

variable "container_image" {
    description = "Repo of the docker image to run"
    type        = string
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

variable "azure_saves_share" {
    description = "Storage account share name for mounting the /home/steam/.config/unity3d/IronGate/Valheim directory"
    type        = string
    default     = "valheim-saves"
}

variable "azure_server_share" {
    description = "Storage account share name for mounting the /home/steam/valheim directory"
    type        = string
    default     = "valheim-server-install"
}

variable "azure_backups_share" {
    description = "Storage account share name for mounting the /home/steam/backups directory"
    type        = string
    default     = "valheim-backups"
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