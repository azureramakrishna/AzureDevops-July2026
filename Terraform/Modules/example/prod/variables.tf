variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create"
}

variable "tags" {
  type        = map(string)
  description = "The tags for the resources"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network to create"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "The address space for the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to create"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "The address prefix for the subnet"
}

variable "network_security_group_name" {
  type        = string
  description = "The name of the network security group to create"
}

variable "public_ip_name" {
  type        = string
  description = "The name of the public IP to create"
}

variable "network_interface_name" {
  type        = string
  description = "The name of the network interface to create"
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the virtual machine to create"
}

variable "virtual_machine_size" {
  type        = string
  description = "The size of the virtual machine to create"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the virtual machine"
}

variable "admin_password" {
  type        = string
  description = "The admin password for the virtual machine"
}