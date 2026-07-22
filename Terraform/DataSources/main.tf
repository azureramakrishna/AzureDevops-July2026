# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate the Network Security Group with the Subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  depends_on                = [azurerm_network_security_group.nsg, data.azurerm_subnet.example]
  subnet_id                 = data.azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a Public IP Address
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = var.tags
}

# Create a Network Interface
resource "azurerm_network_interface" "nic" {
  depends_on          = [data.azurerm_subnet.example, azurerm_public_ip.pip]
  name                = var.network_interface_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Create a Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = var.virtual_machine_size
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.example.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    name                 = "${var.virtual_machine_name}-osdisk" # terraform-vm-osdisk
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "example" {
  name                 = "terraform-datadisk"
  location             = azurerm_resource_group.rg1.location
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadOnly"
}


