variable "container_name" {
  description = "Name of the running Game Server container"
  type        = string
}

variable "container_image" {
  description = "Repo of the docker image to run"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "dns-name" {
  description = "Name of the running Game Server container"
  type        = string
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

variable "priority" {
  description = "(Optional) The priority of the Container Group. Possible values are Regular and Spot."
  type        = string
  default     = "Regular"
}

variable "azure_server_share" {
  description = "Storage account share name for mounting the container"
  type        = string
  default     = "game-server"
}

variable "ports" {
  description = "Ports to open and their protocol"
  type        = list(object(
    {
      port = number,
      protocol = string
    }
  ))
}

variable "env_vars" {
  description = "Env Variables for game server startup"
  type        = map(any)
  default     = {}
}