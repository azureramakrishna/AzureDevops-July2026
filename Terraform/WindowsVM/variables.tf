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

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create"
  default     = "Terraformsa200726"
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

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network to create"
  default     = "terraform-vnet"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "The address space for the virtual network"
  default     = ["10.0.0.0/24"]
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to create"
  default     = "terraform-snet"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "The address prefix for the subnet"
  default     = ["10.0.0.0/24"]
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

variable "admin_password" {
  type        = string
  description = "The admin password for the virtual machine"
}