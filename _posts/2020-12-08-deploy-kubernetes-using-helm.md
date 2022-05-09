---
title: Deploy to Kubernetes using Helm Charts
date: 2020-12-08
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Helm, AKS, Microservice, Kubernetes]
description: Helm is a package manager that helps you to deploy your application easily to Kubernetes. In this post, I will show you how to deploy an application to Kubernetes using Helm and how to avoid some pitfalls.
---
[In my last post](/helm-getting-started), I explained how Helm works and how to add it to your microservice. This post is going to be more practical. Helm is a package manager that helps you to deploy your application easily to Kubernetes. 

In this post, I will show you how to deploy an application to Kubernetes using Helm and how to avoid some pitfalls.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Deploy the Microservice with Helm

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

### Set up
To follow along with this demo, you have to have a Kubernetes cluster running. This can be on your local machine or in the cloud. I am using Azure Kubernetes Service. If you haven't set up Kubernetes yet, read my post about AKS ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started) to set up a cluster on Azure.

Before you can deploy your application with Helm, you have to install Helm. You can use chocolatey on Windows to install it:

<script src="https://gist.github.com/WolfgangOfner/faad97940ad7a42fbf5eb6ce991ccc10.js"></script>

For all other operating systems, see the <a href="https://helm.sh/docs/intro/install" target="_blank" rel="noopener noreferrer">Helm download page</a> to download the right version for your system.

### Deploy your Microservice with Helm
After you have installed Helm, open to charts folder of your application. In the demo application, the path is CustomerApi/CustomerApi/charts. There you can see a folder named customerapi. This folder contains the Helm package. To install this package use helm install [Name] [ChartName]. For the demo application this can be done with the following code:

<script src="https://gist.github.com/WolfgangOfner/fd2c611b2b018bceaf69304f4afdd9ca.js"></script>

The package gets deployed within seconds. After it is finished, connect to the dashboard of your cluster. If you don't know how to do that, see my post ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started). There I explain how I use Octant and how to access your Kubernetes cluster with it.

In the dashboard, open the customerapi pod and you will see that there is an error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-pod-can't-start.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-pod-can't-start.jpg" alt="The pod can't start" /></a>
  
  <p>
    The pod can't start
  </p>
</div>

The error message reads: "Failed to pull image customerapi:stable". The image can't be pulled because it doesn't exist with the stable tag. Another reason why the image can't be pulled is that the repository can't be found. My repository is wolfgangofner/customerapi, not customerapi. Let's update the repository and tag and update the application with Helm.  

### Change the Configuration of the Helm Chart
You can find the values.yaml file inside the customerapi Helm chart. This file provides a way to override the values of the configuration. Under the image section, edit the repository and the tag to use the correct ones:

<script src="https://gist.github.com/WolfgangOfner/8c6c8eed8110392085bccdab137777e2.js"></script>

It is a best practice to always use a version number as the tag and not latest. Using the latest tag might end up in problems with the container cache but more important you can't exactly know what version of the application you are running. For example, you are running latest but tomorrow I update latest to a new version. The next time your container gets restarted, it loads the new image and this might break your application.

## Update a Helm Deployment
The configuration is updated and we can re-deploy the Helm chart. To update an existing deployment use helm upgrade [Name] [ChartName]:

<script src="https://gist.github.com/WolfgangOfner/ff39d5805455c58626b73920865e78a1.js"></script>

### Test the deployed Application
After the Helm upgrade is completed, connect to the dashboard and open the pod again. There you can see that the pod is running now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-pod-is-running.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-pod-is-running.jpg" alt="The pod is running" /></a>
  
  <p>
    The pod is running
  </p>
</div>

The application is running but how can you access it? The dashboard allows you to enable port forwarding for the pod by clicking the button "Start Port Forward". Click it and you will get an URL that will forward to your application.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Enable-port-forwarding.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Enable-port-forwarding.jpg" alt="Enable port forwarding" /></a>
  
  <p>
    Enable port forwarding
  </p>
</div>

Open the URL and you will see the Swagger UI of the Customer API microservice.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-Customer-API-Swagger-UI.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-Customer-API-Swagger-UI.jpg" alt="The Customer API Swagger UI" /></a>
  
  <p>
    The Customer API Swagger UI
  </p>
</div>

That's nice to see but impractical since our customers won't connect to our Kubernetes cluster before they access our applications. [In my last post](/helm-getting-started), I said that the Service object works as a load balancer and offers an external endpoint to access the application. Go to Services and check the external IP for the customerapi.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-Service-has-no-external-IP.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-Service-has-no-external-IP.jpg" alt="The Service has no external IP" /></a>
  
  <p>
    The Service has no external IP
  </p>
</div>

The Service has no external IP. This is because the type of the service is ClusterIP. ClusterIP only publishes an internal IP but no external one. This means we have to update the Service to enable the external endpoint and then publish the application again. This works because Azure creates an Azure Loadbalancer and assignes it a public IP Address. If you run your K8s cluster on-premises, you have to point the public IP to the endpoint yourself.

## Expose the Application to the Outside
To update the Service type, open the values.yaml file again and find the service section. Update the type from ClusterIP to LoadBalancer and save the file.

<script src="https://gist.github.com/WolfgangOfner/33a834340d888f7427dc15c0bc4be162.js"></script>

Update the deployment with Helm upgrade again.

<script src="https://gist.github.com/WolfgangOfner/ff39d5805455c58626b73920865e78a1.js"></script>

After the upgrade is finished, you can use either use kubectl to get the service IP or look it up in the dashboard. To use kubectl use the following command in Powershell:

<script src="https://gist.github.com/WolfgangOfner/56ffdfbc8827130242528f41ef81dddf.js"></script>

Alternatively, open the Service in the dashboard again, and there you can see the external IP.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-Service-has-an-external-IP-now.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-Service-has-an-external-IP-now.jpg" alt="The Service has an external IP now" /></a>
  
  <p>
   The Service has an external IP now
  </p>
</div>

Enter his IP address in your browser and you will see the Swagger UI of the Customer API Microservice.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-microservice-is-publicly-accessible.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-microservice-is-publicly-accessible.jpg" alt="The microservice is publicly accessible" /></a>
  
  <p>
   The microservice is publicly accessible
  </p>
</div>

## Conclusion
Helm is a package manager for Kubernetes and can be used to easily deploy and update your applications. I showed how to quickly update the configuration with the values.yaml file and how to make your application publicly accessible with the Kubernetes Service object. 

[In my next post](/override-appsettings-in-kubernetes), I will show how to override values in the appsetting.json file with environment variables to allow for more dynamic configurations.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).