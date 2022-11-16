param location string = resourceGroup().location

param planName string = 'app-plan-linux'
param planTier string = 'P1v2'

param webappName string = 'python-demoapp'
param webappImage string = 'ghcr.io/benc-uk/python-demoapp:latest'
param weatherKey string = ''
param releaseInfo string = 'Released on ${utcNow('f')}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: planName
  location: location
  kind: 'linux'
  sku: {
    name: planTier
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2020-10-01' = {
  name: webappName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'DOCKER|${webappImage}'
    }
  }
}
