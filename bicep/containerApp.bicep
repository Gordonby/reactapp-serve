param nameseed string = 'reactserve'

@description('Specifies the name of the container app.')
param containerAppName string = 'app-${nameseed}'

@description('Specifies the name of the container app environment to target, must be in the same resourceGroup.')
param containerAppEnvName string = 'env-${nameseed}'

@description('Specifies the location for all resources.')
param location string = resourceGroup().location

@description('Specifies the docker container image to deploy.')
param containerImage string = 'ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000'

@description('Specifies the container port.')
param targetPort int = 3000

@allowed([
  'Single'
  'Multiple'
])
@description('Controls how active revisions are handled for the Container app')
param revisionMode string = 'Single'

@description('Number of CPU cores the container can use. Can be with a maximum of two decimals places. Max of 2.0. Valid values include, 0.5 1.25 1.4')
param cpuCore string = '0.5'

@description('Amount of memory (in gibibytes, GiB) allocated to the container up to 4GiB. Can be with a maximum of two decimals. Ratio with CPU cores must be equal to 2.')
param memorySize string = '1'

@description('Minimum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param minReplicas int = 1

@description('Maximum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param maxReplicas int = 3

@description('Should the app be exposed on an external endpoint')
param externalIngress bool = true

@description('Does the app expect traffic, or should it operate headless')
param enableIngress bool = true

@description('Revisions to the container app need to be unique')
param revisionSuffix string = uniqueString(utcNow())

@description('Any environment variables that your container needs')
param environmentVariables array = []

@description('Will create a user managed identity for the application to access other Azure resoruces as')
param createUserManagedId bool = false

@description('Any tags that are to be applied to the Container App')
param tags object = {}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: containerAppEnvName
  location: location
  properties: {
  }
  tags: tags
}

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: containerAppName
  location: location
  identity: createUserManagedId ? {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uai.id}': {}
    }
  } : {
    type: 'None'
  }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: enableIngress ? {
        external: externalIngress
        targetPort: targetPort
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      } : null
      activeRevisionsMode: revisionMode
    }
    template: {
      revisionSuffix: revisionSuffix
      containers: [
        {
          name: containerAppName
          image: containerImage
          resources: {
            cpu: json(cpuCore)
            memory: '${memorySize}Gi'
          }
          env: environmentVariables
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
  tags: tags
}

resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' =  if(createUserManagedId) {
  name: 'id-${containerAppName}'
  location: location
}


@description('If ingress is enabled, this is the FQDN that the Container App is exposed on')
output containerAppFQDN string = enableIngress ? containerApp.properties.configuration.ingress.fqdn : ''

@description('The Principal Id of the Container Apps Managed Identity')
output userAssignedIdPrincipalId string = createUserManagedId ? uai.properties.principalId : ''
