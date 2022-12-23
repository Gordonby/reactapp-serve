param nameseed string = 'reactserve'
param location string = resourceGroup().location
param containerImage string = 'ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000'
param port int = 3000

var uniqueSuffix = uniqueString(resourceGroup().id, nameseed, deployment().name)

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${nameseed}'
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }	
  sku:  {
  	name: 'B1'
    tier: 'Basic'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${nameseed}-${uniqueSuffix}'
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '${port}'
        }
      ]
      healthCheckPath: '/'
      linuxFxVersion: 'DOCKER|${containerImage}'
    }
    serverFarmId: appServicePlan.id
  }
}
