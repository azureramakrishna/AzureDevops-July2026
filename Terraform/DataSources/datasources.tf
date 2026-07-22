# Use this data source to access information about an existing Virtual Network.
data "azurerm_virtual_network" "example" {
  name                = "terraform-vnet"
  resource_group_name = "datasource-rg"
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
data "azurerm_subnet" "example" {
  name                 = "terraform-snet"
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_virtual_network.example.resource_group_name
}

# Use this data source to access information about an existing Key Vault.
data "azurerm_key_vault" "example" {
  name                = "terraform-kv-864"
  resource_group_name = "datasource-rg"
}

# Use this data source to access information about an existing Key Vault Secret.
data "azurerm_key_vault_secret" "example" {
  name         = "win-vm-password"
  key_vault_id = data.azurerm_key_vault.example.id
}