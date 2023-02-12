variable "resource_group" {
  default = "decrentralizeddeals"
}

variable "location" {
  default = "West Europe"
}

variable "vnet_address_space" {
  default = "10.0.0.0/8"
}

variable "subnet_address_space" {
  default = "10.1.0.0/16"
}

variable "vm_size" {
  default = "Standard_B2s"
}