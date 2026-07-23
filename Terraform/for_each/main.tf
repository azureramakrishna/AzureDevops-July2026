# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#Create a storage account
resource "azurerm_storage_account" "sa" {
  for_each                 = toset([for name in var.storage_account_name : lower(name)])
  name                     = each.value
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}