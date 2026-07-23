# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.storage_account_name)}${count.index + 1}"
  count                    = var.storage_account_count
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}