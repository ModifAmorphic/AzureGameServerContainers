variable "vmName" {
    description = "Name of the VM"
    type        = string
    default     = "docker-host"
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

variable "adminUsername" {
    description = "Local admin user for the new VM"
    type        = string
    default     = "gameadmin"
}