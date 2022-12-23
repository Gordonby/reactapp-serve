# reactapp-serve

This repo uses a standard react app that uses [serve](https://github.com/vercel/serve-handler).
Container images 

## first time setup

These are the commands that i used to  get a functioning, served react app.

```bash
npx create-react-app reactapp-serve
cd reactapp-serve
npm run build 
npx serve -s build
npm i --save serve
npm run publish
```

I then created a [Dockerfile](reactapp-serve/Dockerfile) for the app which takes 2 build args to vary the node base image and the port.

## Deploying the container

There are a lot of Azure services that can host a container.
In the bicep directory, i've created the Infrastructure as Code files for each.
The scripts below simply initiate a deployment using those files.

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

### Azure Web App for Container

```bash
az deployment group create -g innerloop -f .\bicep\webApp-Container.bicep

az deployment group create -g innerloop -f .\bicep\webApp-Container.bicep -p containerImage=ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 port=1025 nameseed=reactserve1025
```

### Azure Kubernetes Service

```bash
# Deploy template with in-line parameters
az deployment group create -g innerloop  --template-uri https://github.com/Azure/AKS-Construction/releases/download/0.9.6/main.json -p resourceName=reactserve JustUseSystemPool=true

az aks get-credentials -g innerloop -n aks-reactserve --admin --overwrite-existing

kubectl run react-serve --image=ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 --port 1025
kubectl expose pod react-serve --port=80 --type=LoadBalancer --target-port=1025
```

### Azure Spring Apps

> The IaC for Spring apps is Currently a `work in progress`

```bash
az deployment group create -g innerloop -f .\bicep\springapps.bicep
```

## Deploying to other non-containerised hosting services

In order to deploy without a container, there needs to be a build step where serve will create the static assets.

Viable Azure services would include Azure Static Web Apps and Azure Web Apps.
