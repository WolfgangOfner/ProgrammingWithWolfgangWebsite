---
title: Azure Kubernetes Service - Getting Started
date: 2020-11-30
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [AKS, Kubernetes, Docker, YAML, Azure]
---

In my eyes, the two biggest inventions in the last years are the cloud and Kubernetes (K8s). Today, I want to combine both and give you a high-level over of Kubernetes using Microsoft's Azure Kubernetes Service (AKS). At the end of this post, you will know why Kubernetes is awesome and how to deploy your first application and even load balance it.

## Introduction to Kubernetes

Kubernetes is a container orchestrator. This means that it runs your containers, usually Docker containers, and also comes with the following nice features:

- Service Discovery and Load Balancing
- Self-healing
- Automated Deployments
- Certificate Management
- Declarative Configuration

Kubernetes can be configured with yaml files, which means that you can store all your configuration in your source control. The smallest unit in Kubernetes is not a container, instead, it uses pods. A pod can contain one or more containers. Additionally, K8s can be easily extended with your own objects.

### Service Discovery and Load Balancing

Load balancing and especially service discovery has always been complicated and required some skills to set up. Both can be achieved in Kubernetes with a Service. This service takes all requests for an application (often a microservice) and load balances this request to all available pods. Further down, I will show how to deploy an application to three pods and use the Service to load balance between these pods.

### Self-healing

Another complex problem for, especially, on-premise applications is self-healing. This means if an application crashes, it gets automatically restarted. Kubernetes does this with health checks. You can provide an URL, often /health and K8s will check if this URL returns a request with the status code 200. If the code is not 200, Kubernetes restarts the pod and marks it as unavailable during the restart. Therefore, no user will be routed to the restarting pods which means that from a user's perspective everything looks fine.

### Automated Deployments

Kubernetes supports two deployment modes out-of-the-box: rolling deployments and blue-green deployments. Requests are only routed to new pods, once they are marked as running. K8s checks this by using readiness probes. They work the same way as health probes, except that they are only used to check if a pod is ready to serve requests.

The rolling deployment mode starts a new pod and once this one is running, it deletes an old one. This process is repeated until all old pods are replaced. You can configure how many pods you want to replace at the same time. This deployment mode is the default.

The blue-green deployment starts all pods of the new version. Once all are running, Kubernetes switches the traffic from all old pods to all new ones. Afterwards, K8s deletes the old pods. 

### Certificate Management

Certificate management has been a problem for a long time. When a new application is deployed, a new certificate needs to be ordered and then installed. Kubernetes does all that for you. In K8s you can run a certificate manager, for example, let's encrypt which creates certificates during the deployment and applies them to your application.

### Declarative Configuration

Every configuration is done in yaml in a declarative way. This means that you can check-in your files in source control. A declarative configuration means that you tell Kubernetes what you want and it takes care of achieving this. For example, run 10 copies of my application and load balance all incoming traffic. K8s then creates a service and starts 10 pods of your application.

## Why use Azure Kubernetes Service (AKS)
Azure Kubernetes Service is a managed service for Kubernetes. In a simplified way, Kubernetes consists of two parts, the control plane, and the worker node. The control plane does all the tasks necessary to manage the Kubernetes cluster. The worker nodes are running your applications and everything needed for that, like load balancing. AKS manages the control plane for you, this means that you don't have to care what's going on in the background. You can create an AKS cluster and just use it for your applications.

## Setup AKS

Microsoft did a lot of work on AKS in the last year and greatly improved the deployment of a new Azure Kubernetes Cluster. 

In the Azure Portal, search for aks and select Kubernetes service.

Save the changes and run the CI pipeline. After the build is finished, you will see the Code Coverage tab in the summary overview where you can see the coverage of each of your projects.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Search-for-aks.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Search-for-aks.jpg" alt="Search for aks" /></a>
  
  <p>
    Search for aks
  </p>
</div>

Next, select a resource group, provide a name and a region. For the node size, I would recommend using Standard B2s since this is the cheapest VM size at the moment. Also decrease the count to one, which will also save costs. In a production environment, you should use at least three nodes.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Create-a-Kubernetes-cluster.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Create-a-Kubernetes-cluster.jpg" alt="Create a Kubernetes cluster" /></a>
  
  <p>
    Create a Kubernetes cluster
  </p>
</div>

On the next tabs, leave everything as it is and click Create on the last tab to start the deployment. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Start-the-AKS-deployment.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Start-the-AKS-deployment.jpg" alt="Start the AKS deployment" /></a>
  
  <p>
    Start the AKS deployment
  </p>
</div>

The deployment should be finished in a couple of minutes.
## Access AKS Cluster

You can access your new AKS cluster using PowerShell and the [Azure CLI module](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli). 

After you installed the az module, you can log into your Azure subscription:

```powershell  
az login
```

This opens a browser window where you can enter your username and password. After you are successfully logged in, connect to your AKS cluster. If you are following my example, you can use the following command.

```powershell  
az aks get-credentials --resource-group MicroserviceDemo --name microservice-aks
```
Perhaps, you have to change the resource group or name of your aks cluster, depending on what you entered during the deployment.

Azure is not deploying the Kubernetes dashboard anymore. As an alternative, I am using [Octant](https://github.com/vmware-tanzu/octant) which is an open-source tool from VMWare. If you are on windows, you can install it using Chocolatey.

```powershell  
choco install octant --confirm
```

Once you installed Octant, open it and it will automatically forward your request and open the dashboard.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/The-Ocant-Kubernetes-dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/The-Ocant-Kubernetes-dashboard.jpg" alt="The Ocant Kubernetes dashboard" /></a>
  
  <p>
    The Ocant Kubernetes dashboard
  </p>
</div>

## Deploy the first Application 

To deploy your first application to Kubernetes, you have to define a Service and a deployment. The Service will act as an ingress controller and does the load balancing and the deployment will deploy the defined container with the desired replica count. 

You can define both objects inside a single yaml file. First, let's create the service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubernetesdeploymentdemo
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: kubernetesdeploymentdemo
```

This service defines itself as load balancer and redirects to port 80 on pods with the label kubernetesdeploymentdemo. Labels are used as a selector, therefore the Service knows to which pod it should forward a request.

Next, create the Deployment object.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubernetesdeploymentdemo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kubernetesdeploymentdemo
  template:
    metadata:
      labels:
        app: kubernetesdeploymentdemo
    spec:
      containers:
      - name: kubernetesdeploymentdemo
        image: wolfgangofner/kubernetesdeploymentdemo
        ports:
        - containerPort: 80
```

This object might look a bit complicated in the beginning but it's quite simple. It defines a Deployment with the name kubernetesdeploymentdemo and sets the label kubernetesdeploymentdemo. Next, it configures three replicas, which means that three pods will be created and in the container section, it defines what container it should download and on what port it should be run.

Save this yaml file, for example, as demo.yml and run the following command:

```powershell  
kubectl apply -f demo.yml
```

If you don't have kubectl installed, installed it with the following Powershell command:

```powershell  
Install-Script -Name 'install-kubectl' -Scope CurrentUser -Force
install-kubectl.ps1 [-DownloadLocation <path>]
```

After you applied the demo.yml file, you will see a new Service, kubernetesdeploymentdemo, in the Kubernetes dashboard.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/The-Service-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/The-Service-got-created.jpg" alt="The Service got created" /></a>
  
  <p>
    The Service got created
  </p>
</div>

You can also see the external IP of your Service there. Remember this IP for later to test the application. Next up, we can see the Deployment and that 3/3 pods are running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/A-Deployment-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/A-Deployment-got-created.jpg" alt="A Deployment got created" /></a>
  
  <p>
    A Deployment got created
  </p>
</div>

Lastly, see the three pods running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/All-pods-are-running.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/All-pods-are-running.jpg" alt="All pods are running" /></a>
  
  <p>
    All pods are running
  </p>
</div>

There you can see that all pods are healthy and that they are all running on the same node. In a production environment, they would be running on different nodes to ensure high-availability.

### Testing the Deployment

Open the URL from the Service and you will see a Swagger UI. This application is very simple and all it does is to return the name of its host machine. You can also see the name in the headline.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Testing-the-deployed-container.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Testing-the-deployed-container.jpg" alt="Testing the deployed container" /></a>
  
  <p>
    Testing the deployed container
  </p>
</div>

If you refresh the page a couple of times, you will see different names in the headline. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Different-names-due-to-the-load-balancing.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Different-names-due-to-the-load-balancing.jpg" alt="Different names due to the load balancing" /></a>
  
  <p>
    Different names due to the load balancing
  </p>
</div>

## Cleanup

When you are finished, don't forget the delete all created resources. AKS creates three additional resource groups. Make sure to delete them too.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Delete-all-resource-groups.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Delete-all-resource-groups.jpg" alt="Delete all resource groups" /></a>
  
  <p>
    Delete all resource groups
  </p>
</div>

## Conclusion

Today, I gave a high-level overview of Kubernetes using Azure Kubernetes Service. Kubernetes helps you to run your container and manages deployments and load balancing. Keep in mind that this was a very simple demo and hasn't talked about any downsides of Kubernetes and its steep learning curve.