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

resource storage_account_name_resource 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storage_account_name
  location: location
  sku: {
    name: storage_account_sku
  }
  kind: storage_account_kind
}
