// modules/keyvault.bicep
param env string
param location string
param keyVaultName string
param secretName string
param secretValue string
param principalId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: secretName
  properties: {
    value: secretValue
  }
}

output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultNameOutput string = keyVault.name
