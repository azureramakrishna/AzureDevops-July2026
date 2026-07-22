variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
  default     = "terraform-rg"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "The tags for the resources"
  default = {
    environment = "development"
    owner       = "azureramkarishna@gmail.com"
    project     = "terraform"
  }
}

variable "network_security_group_name" {
  type        = string
  description = "The name of the network security group to create"
  default     = "terraform-nsg"
}

variable "public_ip_name" {
  type        = string
  description = "The name of the public IP to create"
  default     = "terraform-pip"
}

variable "network_interface_name" {
  type        = string
  description = "The name of the network interface to create"
  default     = "terraform-nic"
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the virtual machine to create"
  default     = "terraform-vm"
}

variable "virtual_machine_size" {
  type        = string
  description = "The size of the virtual machine to create"
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the virtual machine"
  default     = "azureuser"
}