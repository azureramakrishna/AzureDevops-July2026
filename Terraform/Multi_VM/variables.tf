variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-multi-windows-vms"
}

variable "vm_names" {
  description = "List of VM names to create"
  type        = list(string)
  default     = ["winvm01", "winvm02", "winvm03", "winvm04", "winvm05"]
}

variable "admin_username" {
  description = "Administrator username for the Windows VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Administrator password for the Windows VMs"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd1234!"
}

variable "vm_size" {
  description = "Size of the Windows VMs"
  type        = string
  default     = "Standard_B2s"
}
