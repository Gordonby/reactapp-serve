param nameseed string = 'reactservenc'
param location string = resourceGroup().location

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
  name: 'web-${nameseed}-${uniqueSuffix}'
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'SCM_REPOSITORY_PATH'
          value: 'reactapp-serve'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: 'reactapp-serve'
        }
        {
          name: 'SCM_REPOSITORY_PATH'
          value: 'reactapp-serve'
        }
      ]
      nodeVersion: '~18'
      phpVersion: 'OFF'
      healthCheckPath: '/'
    }
    serverFarmId: appServicePlan.id
  }
}

param repoUrl string = 'https://github.com/Gordonby/reactapp-serve.git'
param repoBranchProduction string = 'main'
resource codeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = if (!empty(repoUrl)) {
  parent: webApp
  name: 'web'
  properties: {
    repoUrl: repoUrl
    branch: repoBranchProduction
    isManualIntegration: true
  }
}
