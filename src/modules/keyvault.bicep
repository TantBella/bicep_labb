// modules/keyvault.bicep
param env string
param location string
param keyVaultName string
param secretName string
param secretValue string
param principalId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${keyVaultName}-${env}-${uniqueString(resourceGroup().id)}'
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

// resource kvAccess 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
//   name: '${keyVault.name}/add'
//   properties: {
//     accessPolicies: [
//       {
//         tenantId: subscription().tenantId
//         objectId: principalId
//         permissions: {
//           secrets: ['get']
//         }
//       }
//     ]
//     enableSoftDelete: true
//   }
//   dependsOn: [
//     keyVault
//     kvSecret
//   ]
// }

output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultNameOutput string = keyVault.name
