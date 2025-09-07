targetScope = 'resourceGroup'

param appServicePlanName string
param appServiceName string
param location string
param skuName string
param skuCapacity int
param httpsOnly bool
param owner string
param environment string
param costCenter string

param keyVaultUri string
param secretName string

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource appService 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    httpsOnly: httpsOnly
  }
  tags: {
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

resource appSetting 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    MySecret: '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/${secretName})'
  }
  // dependsOn: [
  //   appService
  // ]
}

output appServicePlanNameOut string = appServicePlan.name

output appServiceURL string = 'https://${appService.properties.defaultHostName}'

output appServicePrincipalId string = appService.identity.principalId
