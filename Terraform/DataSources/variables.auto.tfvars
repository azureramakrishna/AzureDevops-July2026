resource_group_name = "saanvikit-rg"
location            = "eastus"
tags = {
  environment = "development"
  owner       = "azureramakrishna@gmail.com"
  project     = "terraform-datasources"
}
network_security_group_name = "saanvikit-nsg"
public_ip_name              = "saanvikit-pip"
network_interface_name      = "saanvikit-nic"
virtual_machine_name        = "saanvikit-vm"
virtual_machine_size        = "Standard_DS1_v2"