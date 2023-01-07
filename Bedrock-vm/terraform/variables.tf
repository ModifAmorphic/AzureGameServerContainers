variable "vmName" {
    description = "Name of the VM"
    type        = string
    default     = "minecraft-server"
}

variable "dnsName" {
    description = "DNS Prefix for the VM"
    type        = string
    default     = "minecraft"
}

variable "storageAccount" {
    description = "Storage account in which to create the {fileShareName} file share"
    type        = string
    default     = "persistantgamestorage"
}

variable "storageAccountRg" {
    description = "Resource group containing the {storageAccount} Storage account"
    type        = string
    default     = "gaming"
}

variable "fileShareName" {
    description = "Storage account share name for mounting the {worldsMountPath} directory"
    type        = string
    default     = "minecraft-data"
}

variable "adminUsername" {
    description = "Local admin user for the new VM"
    type        = string
    default     = "gameadmin"
}

variable "worldsMountPath" {
    description = "Storage account share name for mounting the /data directory"
    type        = string
    default     = "/data"
}

variable "containerImage" {
    description = "The docker container image to run on the VM."
    type        = string
    default     = "itzg/minecraft-bedrock-server"
}

variable "envVars" {
  description = "Env Variables for container image."
  type        = map
  default     = {}
}