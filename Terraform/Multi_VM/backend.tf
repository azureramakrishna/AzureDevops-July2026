# Terrraform backend configuration for storing state in Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstetesa"
    container_name       = "tfstate"
    key                  = "vmforeach.terraform.tfstate" # Name of your state file
  }
}