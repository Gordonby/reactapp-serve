param location string = resourceGroup().location
param nameseed string = 'reactserve'
param image string = 'ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000'
param port int = 3000

var uniqueSuffix = uniqueString(resourceGroup().id, nameseed, deployment().name)

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2022-09-01' = {
  name: 'aci-${nameseed}'
  location: location
  properties: {
    containers: [
      {
        name: nameseed
        properties: {
          image: image
          ports: [
            {
              port: port
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 4
            }
          }
        }
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: 'nameseed-${uniqueSuffix}'
      ports: [
        {
          protocol: 'TCP'
          port: port
        }
      ]
    }
  }
}
