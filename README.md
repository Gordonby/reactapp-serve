# reactapp-serve

## first time setup

These are the commands run to get a functioning, served react app.

```bash
npx create-react-app reactapp-serve
cd reactapp-serve
npm run build 
npx serve -s build
npm i --save serve
npm run publish
```

## Deploying the container

### Azure Container Instances

```bash
#deploys the port 3000 container image (which is the default)
az deployment group create -g innerloop -f .\aci.bicep

#deploys the port 1025 container image
az deployment group create -g innerloop -f .\aci.bicep -p image=ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 port=1025 --query properties.outputs.fqdn.value -o tsv
```

### Azure Container Apps

```bash
#deploys the port 3000 container image (which is the default)
az deployment group create -g innerloop -f .\containerApp.bicep

az deployment group create -g innerloop -f .\containerApp.bicep -p containerImage=ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 targetPort=1025
```