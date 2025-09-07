targetScope = 'subscription'

param resourceGroupName string

@allowed(['swedencentral', 'northeurope', 'westeurope'])
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

output rgNameOutput string = resourceGroup.name
output rgLocationOutput string = resourceGroup.location
