variable "containerName" {
    description = "Name of the running Valheim Server container"
    type        = string
    default     = "minecraft-server"
}

variable "dnsName" {
    description = "Name of the running Valheim Server container"
    type        = string
    default     = "minecraft"
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

variable "dataShare" {
    description = "Storage account share name for mounting the /data directory"
    type        = string
    default     = "minecraft-data"
}

variable "containerImage" {
    description = "Container Image the Container Group will run for the server."
    type        = string
    default     = "itzg/minecraft-bedrock-server"
}

variable "envVars" {
  description = "Env Variables for Valheim server startup"
  type        = map
  default     = {}
}