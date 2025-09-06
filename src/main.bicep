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

var appServicePlanResourceName = '${appServicePlanName}-${env}-${uniqueString(resourceGroup().id)}'
var keyVaultUniqueName = 'kv${env}${take(uniqueString(resourceGroup().id),6)}'

//  Storage
module StorageAccount './modules/storage.bicep' = {
  name: 'storage${env}${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    skuName: skuName
    kind: storageKind
    storageAccountName: '${storageAccountName}${env}${uniqueString(resourceGroup().id)}'
    owner: owner
    environment: env
    costCenter: costCenter
  }
}

module KeyVault './modules/keyvault.bicep' = {
  name: 'kv'
  params: {
    env: env
    location: location
    keyVaultName: keyVaultUniqueName
    secretName: secretName
    secretValue: secretValue
    principalId: ''
  }
}

//  Appservice
module AppService './modules/appservice.bicep' = {
  name: 'app${env}${uniqueString(resourceGroup().id)}'
  params: {
    appServiceName: '${appServiceName}${env}'
    appServicePlanName: appServicePlanResourceName
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
  name: 'kv-access${env}${uniqueString(resourceGroup().id)}'
  params: {
    keyVaultName: KeyVault.outputs.keyVaultNameOutput
    principalId: AppService.outputs.appServicePrincipalId
    secretName: secretName
  }
  // dependsOn: [
  //   KeyVault
  //   AppService
  // ]
}

//  Autoscale ( prod)
module Autoscale './modules/autoscale.bicep' = if (env == 'prod') {
  name: 'autoscale${env}${uniqueString(resourceGroup().id)}'
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
  dependsOn: [
    AppService
  ]
}

output webAppUrl string = AppService.outputs.appServiceURL
