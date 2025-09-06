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
param secretValue string

param autoscaleMinInstance int
param autoscaleMaxInstance int
param autoscaleDefaultInstance int

var appServicePlanResourceName = '${appServicePlanName}-${env}-${uniqueString(resourceGroup().id)}'

//  Storage
module StorageAccount './modules/storage.bicep' = {
  name: 'storage-${env}'
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

// Keyvault
module KeyVault './modules/keyvault.bicep' = {
  name: 'keyvault-${env}'
  params: {
    env: env
    location: location
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: secretValue
    principalId: ''
  }
}

//  App Service
module AppService './modules/appservice.bicep' = {
  name: 'app-${env}'
  params: {
    appServiceName: '${appServiceName}-${env}'
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

//  Autoscale (only for prod)
module Autoscale './modules/autoscale.bicep' = if (env == 'prod') {
  name: 'autoscale-${env}'
  params: {
    env: env
    location: location
    appServicePlanName: AppService.outputs.appServicePlanNameOut
    autoscaleMinInstance: autoscaleMinInstance
    autoscaleMaxInstance: autoscaleMaxInstance
    autoscaleDefaultInstance: autoscaleDefaultInstance
  }
  dependsOn: [
    AppService
  ]
}

// az deployment group create `
//   --name prod-deployment `
//   --resource-group rg-bellasolomonfalkfrii `
//   --template-file "./src/main.bicep" `
//   --parameters "./parameters/prod.json" `
//   --output json `
//   --debug
