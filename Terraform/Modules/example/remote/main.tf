module "remote_vm" {
  source = "git::https://github.com/azureramakrishna/AzureDevops-July2026.git//Terraform/Modules/VM?ref=main"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  tags                          = var.tags
  storage_account_name          = var.storage_account_name
  virtual_network_name          = var.virtual_network_name
  virtual_network_address_space = var.virtual_network_address_space
  subnet_name                   = var.subnet_name
  subnet_address_prefix         = var.subnet_address_prefix
  network_security_group_name   = var.network_security_group_name
  public_ip_name                = var.public_ip_name
  network_interface_name        = var.network_interface_name
  virtual_machine_name          = var.virtual_machine_name
  virtual_machine_size          = var.virtual_machine_size
  admin_username                = var.admin_username
  admin_password                = var.admin_password
}