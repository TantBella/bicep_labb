targetScope = 'resourceGroup'

param location string
param skuName string
param kind string
param storageAccountName string
param owner string
param environment string
param costCenter string

resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  tags: {
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

output storageAccountName string = storage.name
output storageAccountId string = storage.id
