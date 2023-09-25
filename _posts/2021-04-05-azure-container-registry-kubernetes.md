---
title: Use Azure Container Registry in Kubernetes
date: 2021-04-05
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [DevOps, CI-CD, Azure DevOps, Azure, Kubernetes, AKS, Helm, ACR, Azure Container Registry]
description: Azure Container Registry has some advantages over Docker Hub and I will show you how to configure your microservice and Kubernetes cluster to run images from ACR and run them in your cluster.
---

<a href="https://hub.docker.com/" target="_blank" rel="noopener noreferrer">Docker Hub</a> is like GitHub for Docker containers. You can sign up for free and get unlimited public repos and one private repo. This is great for developers like me who want to make their containers easily accessible for everyone. Enterprises probably don't want to have their containers on a public share. They can either buy an enterprise plan or they can use a private registry like Azure Container Registry (ACR).

In this post, I will talk about the advantages of Azure Container Registry and show you how to configure your microservice and Kubernetes cluster to run images from ACR and run them in your cluster.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is Azure Container Registry (ACR)

Azure Container Registry is a private container registry that allows you to build and store your images, replicate them around the globe and also scan for vulnerabilities. ACR comes in three pricing tiers: Basic, Standard, and Premium. The main difference between them is the amount of included storage and the number of webhooks you can use. Additionally, the premium tier supports geo-replication. This means that your images are still available when a data center goes down. Furthermore, it allows for faster startup times because the needed image is closer to the destination. This is only the case if you operate globally.

Microsoft recommends using the premium tier. At first glance, you might think that the price difference is massive (0.141€ for Basic, 0.563€ for Standard, 1.406€ for Premium per day) but in the end, you pay 4.37€ for the Basic tier compared to 43.59€ for the Premium tier. 

## Create an Azure Container Registry in the Azure Portal

In the Azure Portal, search for Container registries and then click on Create container registry.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-new-Azure-Container-Registry.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-new-Azure-Container-Registry.jpg" alt="Create a new Azure Container Registry" /></a>
  
  <p>
   Create a new Azure Container Registry
  </p>
</div>

Select a subscription, resource group, location, and SKU. For the demo, I am using Basic. Provide a unique name for your ACR and then click on Create.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Configure-the-new-ACR.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Configure-the-new-ACR.jpg" alt="Configure the new ACR" /></a>
  
  <p>
   Configure the new ACR
  </p>
</div>

## Upload an Image to the Azure Container Registry

To upload an image to the new ACR, you have two options: importing the image from Docker Hub or uploading it from a CI/CD pipeline (or manually).

### Import an Image from Docker Hub into ACR

Importing an image is a good way to get started fast but I would recommend using the CI/CD pipeline approach in the next section. To import the image, use the following Azure CLI command:

<script src="https://gist.github.com/WolfgangOfner/9f78fbe4917a26a0761d8b9395833cf3.js"></script>

The first line logs you into your Azure subscription and the second one takes the name of your ACR, the source image from Docker Hub, and the image name which will be created in ACR.

### Upload a Docker Image using Azure DevOps Pipelines

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

The better approach to uploading is an automated Azure DevOps pipeline. In my previous demos, I already created tasks to build and publish the image to Docker Hub. I will update these tasks to a new version (v2 instead of v1) and add more parameters, so you can easily switch between ACR and Docker Hub.

### Create a Service Connection to your ACR

Before you can upload images to ACR, you have to create a Service Connection. In your Azure DevOps project, click on Project settings and then on Service connections.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-new-Service-Connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-new-Service-Connection.jpg" alt="Create a new Service Connection" /></a>
  
  <p>
   Create a new Service Connection
  </p>
</div>

On the Service connections tab, click on New service connection and search for docker registry. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Add-a-Docker-registry-connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Add-a-Docker-registry-connection.jpg" alt="Add a Docker registry connection" /></a>
  
  <p>
   Add a Docker registry connection
  </p>
</div>

On the next tab, select Azure Container Registry, your subscription, and your ACR. Provide a name and remember it because you will need it later in your pipeline.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Configure-the-ACR-Service-Connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Configure-the-ACR-Service-Connection.jpg" alt="Configure the ACR Service Connection" /></a>
  
  <p>
   Configure the ACR Service Connection
  </p>
</div>

#### Update the CI/CD Pipeline to use the new Service Connection

You can find the Docker tasks in the <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/templates/DockerBuildAndPush.yml" target="_blank" rel="noopener noreferrer">DockerBuildAndPush.yml template</a>. The original Docker build task looks as follow:

<script src="https://gist.github.com/WolfgangOfner/73a2360e4f33241570abf26ad490ab2a.js"></script>

I replaced the parameters and the Docker v1 task with the following code:

<script src="https://gist.github.com/WolfgangOfner/906dea3e64581e886e90d61eb6fe0ad2.js"></script>

As you can see, I added a couple of new parameters and updated the Docker task to v2. The v2 task takes a containerRegistry instead of dockerRegistryEndpoint and also a repository. Additionally, it supports multiple tags so you can build the same image as before and additionally always update the latest tag. 

The Docker publish looked originally as follows:

<script src="https://gist.github.com/WolfgangOfner/1f07051e63ef39fa574a9db82014c73c.js"></script>

I updated this task also to version 2 and added the new parameters.

<script src="https://gist.github.com/WolfgangOfner/a4a4f1740df64f40b518a87136a5ee18.js"></script>

Lastly, I have to update my pipeline to pass values for the new parameters:

<script src="https://gist.github.com/WolfgangOfner/fb513f4c0839006a3b14676f9b958874.js"></script>

Additionally, I renamed the ImageName variable to Repository. If you want to deploy to Docker Hub instead, use 'Docker Hub' for the containerRegistry and wolfgangofner/customerapi for the repository (you have to replace wolfgangofner with your Docker Hub repository name). For more information about pushing images to Docker Hub, see my post [Build Docker in an Azure DevOps CI Pipeline](/build-docker-azure-devops-ci-pipeline).

#### Update the Image Source in the Helm package

The microservice uses Helm for the configuration. For more information about Helm, see my post [Helm - Getting Started](/helm-getting-started).

The values.yaml file contains the configuration for the image and tag Kubernetes should use. Currently, this is:

<script src="https://gist.github.com/WolfgangOfner/11e48d64374ccc942ef64780caf19621.js"></script>

Since I renamed ImageName to Repository, you also have to rename it here:

<script src="https://gist.github.com/WolfgangOfner/69adcc3369d649cc5a8310e5ccbb0408.js"></script>

That's it. The pipeline is configured to push the image to your new ACR and Kubernetes should then pull the new image from ACR and run. Let's see if everything works.

## Test the Switch to ACR

Run the pipeline and you should see that the build and push of the Docker image works. Go to your ACR and under Repositories, you will see the customerapi repository. But the pipeline will fail due to a timeout in the Helm upgrade release task.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Helm-upgrade-timed-out.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Helm-upgrade-timed-out.jpg" alt="Helm upgrade timed out" /></a>
  
  <p>
   Helm upgrade timed out
  </p>
</div>

Connect to the K8s dashboard and check the pod to see the error message. For more information about accessing the dashboard, see my previous post [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started/#access-aks-cluster).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/ACR-authentication-required.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/ACR-authentication-required.jpg" alt="ACR authentication required" /></a>
  
  <p>
   ACR authentication required
  </p>
</div>

As you can see on the screenshot above, the pull failed because Kubernetes is not authorized to pull the image. This is because ACR is a private container registry and you have to give Kubernetes permission to pull images.

## Allow Kubernetes to pull ACR Images

To allow Kubernetes to pull images from ACR, you first have to create a service principal and give it the acrpull role. Use the following bash script to create the service principal and assign it the acrpull role.

<script src="https://gist.github.com/WolfgangOfner/085612d16ac9ed9c47dd5b6e9d091f80.js"></script>

Don't worry if the creation of the role assignment needs a couple of retries.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-new-service-principal-with-the-acrpull-role.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-new-service-principal-with-the-acrpull-role.jpg" alt="Create a new service principal with the acrpull role" /></a>
  
  <p>
   Create a new service principal with the acrpull role
  </p>
</div>

Next, create an image pull secret with the following command:

<script src="https://gist.github.com/WolfgangOfner/7c0b1cc0071aa050dfdfe7a79b4fc543.js"></script>

Note that you have to use the username and password from the previously created service principal. The namespace is the Kubernetes namespace in which your microservice is running. If you also want to deploy the OrderApi microservice from the demo repository, you have to repeat the command for the orderapi-test namespace.

### Use the Image Pull Secret in your Microservice

After the image pull secret was created, you have to tell your microservice to use it. The image pull secret is part of the deployment but it is empty. In my last posts, I used the values.yaml file for values that I want to set during the deployment. Therefore, I add the name of the secret there:

<script src="https://gist.github.com/WolfgangOfner/25026b07f81d371a74abf64efb11db8b.js"></script>

If you used a different name for your secret in the kubectl create secret docker-registry, then you have to use your name instead of acr-secret.

### Deploy the Image from ACR to Kubernetes

Run the pipeline again and this time it will succeed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/The-deployment-using-ACR-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/The-deployment-using-ACR-succeeded.jpg" alt="The deployment using ACR succeeded" /></a>
  
  <p>
   The deployment using ACR succeeded
  </p>
</div>

Connect to the dashboard and check the events to make sure that the image was pulled from your ACR.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/The-image-was-successfully-pulled-from-ACR.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/The-image-was-successfully-pulled-from-ACR.jpg" alt="The image was successfully pulled from ACR" /></a>
  
  <p>
   The image was successfully pulled from ACR
  </p>
</div>

## Conclusion

Azure Container Registry (ACR) is a private container registry and a great alternative to Docker Hub, especially for companies. ACR allows you to build your images but also to distribute them globally. Due to the private nature of ACR, Kubernetes needs an image pull secret to allow deployments to access ACR and pull images from there.

Note: By default, my demo code is using Docker Hub because it is more accessible and I want to make it easier for people who want to try the demo. I left the code for ACR as comments in the pipeline.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).