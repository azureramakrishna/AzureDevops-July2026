variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "The tags for the resources"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create"
}

variable "storage_account_count" {
  type        = number
  description = "The number of storage accounts to create"
}