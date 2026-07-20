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