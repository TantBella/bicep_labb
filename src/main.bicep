targetScope = 'resourceGroup'

param env string
param location string
param storageAccountName string
param appServicePlanName string
param appServiceName string
param skuName string
param storageKind string
param appSkuName string
param skuCapacity int
param httpsOnly bool
param owner string
param costCenter string

//  Storage
module StorageAccount './modules/storage.bicep' = {
  name: 'storage-${env}'
  params: {
    location: location
    skuName: skuName
    kind: storageKind
    storageAccountName: '${storageAccountName}${uniqueString(resourceGroup().id)}'
    owner: owner
    environment: env
    costCenter: costCenter
  }
}

//  App Service
module AppService './modules/appservice.bicep' = {
  name: 'app-${env}'
  params: {
    appServiceName: '${appServiceName}-${env}'
    appServicePlanName: '${appServicePlanName}-${env}-${uniqueString(resourceGroup().id)}'
    httpsOnly: httpsOnly
    location: location
    skuCapacity: skuCapacity
    skuName: appSkuName
    owner: owner
    environment: env
    costCenter: costCenter
  }
}
