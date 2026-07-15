// parameters
param storage_account_name string 
param location string = resourceGroup().location

@description('The SKU of the storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storage_account_sku string = 'Standard_LRS'

@description('The kind of the storage account.')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param storage_account_kind string = 'StorageV2'

param virtual_network_name string
param virtual_network_address_space array
param network_security_group_name string
param public_ip_name string
param network_interface_name string
param virtual_machine_name string
param virtual_machine_size string
param admin_username string
@secure()
param admin_password string

// variables
var subnet_name = 'saanvikit-subnet'
var subnet_address_prefix = '10.0.0.0/24'

// Create a storage account
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_account_name
  location: location
  kind: storage_account_kind
  sku: {
    name: storage_account_sku
  }
}

// Create a VNET
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtual_network_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: virtual_network_address_space
    }
    subnets: [
      {
        name: subnet_name
        properties: {
          addressPrefix: subnet_address_prefix
          // Associate the NSG with the subnet
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

// Create a NSG
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: network_security_group_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP-Allow'
        properties: {
          description: 'Allow RDP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTP-Allow'
        properties: {
          description: 'Allow HTTP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Create a public IP address
resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: public_ip_name
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Crate a network interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: network_interface_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'nic-ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // Associate the NIC with the subnet
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          // Associate the public IP address with the NIC
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
  }
}

// Create a windows virtual machine
resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtual_machine_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtual_machine_size
    }
    osProfile: {
      computerName: virtual_machine_name // hostname max length is 15 characters  
      adminUsername: admin_username
      adminPassword: admin_password
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${virtual_machine_name}-osdisk' // vm-saanvikit-osdisk
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri:  storageaccount.properties.primaryEndpoints.blob
      }
    }
  }
}





