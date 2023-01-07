variable "resource_group" {
    description = "Resource group bastion resources will be created in."
    type        = string
    default     = "bastion"
}
variable "bastion_sku" {
    description = "Sku for the Bastion VM."
    type        = string
    default     = "Basic"
}
variable "subnet_addresses" {
    description = "Private subnet"
    type        = list
}
