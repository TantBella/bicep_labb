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

param keyVaultName string
param secretName string
@secure()
param secretValue string

param autoscaleMinInstance int
param autoscaleMaxInstance int
param autoscaleDefaultInstance int

//  Storage
module StorageAccount './modules/storage.bicep' = {
  name: 'storage${env}${take(uniqueString(resourceGroup().id),6)}'
  params: {
    location: location
    skuName: skuName
    kind: storageKind
    storageAccountName: '${storageAccountName}${env}${take(uniqueString(resourceGroup().id), 6)}'
    owner: owner
    environment: env
    costCenter: costCenter
  }
}

// Keyvault
module KeyVault './modules/keyvault.bicep' = {
  name: 'kv-${env}${take(uniqueString(resourceGroup().id),6)}'
  params: {
    location: location
    keyVaultName: 'kv${keyVaultName}-${env}${take(uniqueString(resourceGroup().id), 6)}'
    secretName: secretName
    secretValue: secretValue
  }
}

//  Appservice
module AppService './modules/appservice.bicep' = {
  name: 'app${appServiceName}-${env}${take(uniqueString(resourceGroup().id),6)}'
  params: {
    appServiceName: 'app${appServiceName}-${env}${take(uniqueString(resourceGroup().id), 6)}'
    appServicePlanName: '${appServicePlanName}-${env}${take(uniqueString(resourceGroup().id), 6)}'
    httpsOnly: httpsOnly
    location: location
    skuCapacity: skuCapacity
    skuName: appSkuName
    owner: owner
    environment: env
    costCenter: costCenter
    keyVaultUri: KeyVault.outputs.keyVaultUri
    secretName: secretName
  }
}

// KeyVault access policy
module KeyVaultAccess './modules/keyvault-access.bicep' = {
  name: 'kvAccess-${env}${take(uniqueString(resourceGroup().id), 6)}'
  params: {
    keyVaultName: KeyVault.outputs.keyVaultNameOutput
    principalId: AppService.outputs.appServicePrincipalId
  }
  // dependsOn: [
  //   KeyVault
  //   AppService
  // ]
}

//  Autoscale ( prod)
module Autoscale './modules/autoscale.bicep' = if (env == 'prod') {
  name: 'autoscale-${take(uniqueString(resourceGroup().id), 6)}'

  params: {
    env: env
    location: location
    appServicePlanName: AppService.outputs.appServicePlanNameOut
    autoscaleMinInstance: autoscaleMinInstance
    autoscaleMaxInstance: autoscaleMaxInstance
    autoscaleDefaultInstance: autoscaleDefaultInstance
    owner: owner
    costCenter: costCenter
  }
}

output webAppUrl string = AppService.outputs.appServiceURL
