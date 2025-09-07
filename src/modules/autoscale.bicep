param env string
param location string
param appServicePlanName string
param autoscaleMinInstance int
param autoscaleMaxInstance int
param autoscaleDefaultInstance int
param owner string
param costCenter string

resource autoscale 'Microsoft.Insights/autoscaleSettings@2021-05-01-preview' = {
  name: 'prod-autoscale'
  location: location
  properties: {
    enabled: true
    targetResourceUri: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    profiles: [
      {
        name: 'ProdAutoscaleProfile'
        capacity: {
          minimum: string(autoscaleMinInstance)
          maximum: string(autoscaleMaxInstance)
          default: string(autoscaleDefaultInstance)
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 70
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 30
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
  tags: {
    owner: owner
    environment: env
    costCenter: costCenter
  }
}
