using '../src/main.bicep'

param env = 'test'
param location = 'swedencentral'

param storageAccountName = 'stbella'

param appServiceName = 'BicepLabb-bellasofa'

param appServicePlanName = 'BicepLabb-asp-bellasofa'

param skuName = 'Standard_LRS'
param appSkuName = 'B1'
param httpsOnly = true
param skuCapacity = 1
param storageKind = 'StorageV2'

param owner = 'bellasolomonfalkfrii'
param costCenter = 'biceplabb'

// testade  detta då jag läste att json var legacy
