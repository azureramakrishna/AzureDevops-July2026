using 'main.bicep'

param storage_account_name = 'saanvikitbicep'
// param storage_account_kind = 'StorageV2'
// param storage_account_sku = 'Standard_LRS'
//param location = resourceGroup().location
param virtual_network_name = 'vnet-saanvikit'
param virtual_network_address_space = ['10.0.0.0/24']
param network_security_group_name = 'nsg-saanvikit'
param public_ip_name = 'pip-saanvikit'
param network_interface_name = 'nic-saanvikit'
param virtual_machine_name = 'vm-saanvikit'
param virtual_machine_size = 'Standard_B1s'
param admin_username = 'azureuser'
param admin_password = 'REPLACE_ME'
