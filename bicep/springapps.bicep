param nameseed string = 'reactserv2'
param location string = resourceGroup().location
param containerImage string = 'ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025'

resource springAppEnv 'Microsoft.AppPlatform/Spring@2022-11-01-preview' = {
  name: 'spr-${nameseed}'
  location: location
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
  
  resource app 'apps' = {
    name: nameseed
    properties: {
      public: true
      httpsOnly: false
    }
    
    resource deploy 'deployments' = {
      name: nameseed
      properties: {
        active: true
        deploymentSettings: {
          resourceRequests: {
            cpu: '1'
            memory: '1Gi'
          }
          environmentVariables: {}
          startupProbe: {
            disableProbe: true
          }
          livenessProbe: {
            disableProbe: true
          }
          readinessProbe: {
            disableProbe: true
          }
        }
        source: {
          type: 'Container'
          customContainer: {
            containerImage: last(split(containerImage,'/'))
            server: '${split(containerImage,'/')[0]}/${split(containerImage,'/')[1]}'
          }
        }
      }
    }
  }
}

resource log 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${nameseed}-${location}'
  location: location
  properties : {
      retentionInDays: 30
    }
}

resource diags 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diags'
  scope: springAppEnv
  properties: {
    workspaceId: log.id
    logs: [
      {
        enabled: true
        category: 'ApplicationConsole'
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        timeGrain: 'PT1M'
      }
    ]
  }
}
