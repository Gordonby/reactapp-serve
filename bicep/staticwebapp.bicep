param nameseed string = 'reactserve'
param location string = 'eastus2'

resource swa 'Microsoft.Web/staticSites@2022-03-01' = {
  name: nameseed
  location: location
  properties: {
    
  }
  sku: {
    tier: 'Standard'
    name: 'Standard'
  }
}
