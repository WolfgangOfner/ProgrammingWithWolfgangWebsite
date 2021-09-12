---
title: Debug Microservices running inside a Kubernetes Cluster with Bridge to Kubernetes
date: 2021-07-12
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes]
description: Bridge to Kubernetes allows developers to easily debug microservices running in an existing Kubernetes cluster.
---

Kubernetes and new tools and technologies, in general, are great to build new products and applications. An important aspect of using them is how easy it is to find and fix problems. Tracing and debugging a microservice architecture can be quite hard and is perhaps the biggest downside of it. 

Microsoft allows developers to route traffic from a Kubernetes cluster to their local environment to debug microservices without the need to deploy a full cluster on your developer machine.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is Bridge to Kubernetes

Bridge to Kubernetes, formerly known as Azure Dev Spaces, is a tool that allows to test and debug microservices on a developer's machine while using dependencies and configurations of an existing Kubernetes cluster. This is especially useful when you have a bug in a production environment which you can not replicate in your development environment. This bug might only occur in high-load scenarios. See the <a href="https://devblogs.microsoft.com/visualstudio/bridge-to-kubernetes-ga" target="_blank" rel="noopener noreferrer">Bridge to Kubernetes GA announcement</a>.

## Configure Bridge to Kubernetes

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

In this demo, I will change one of my microservices and debug it with requests from my AKS cluster. If you don't have a cluster running yet, see ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero) for all the tutorials to create a microservice, AKS cluster, and how to deploy it.

### Install the Visual Studio Code Extensions

Open the microservice you want to debug in Visual Studio code and open the Extensions tab. Search for Kubernetes and install the Kubernetes and Bridge to Kubernetes extensions.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Install-the-Bridge-to-Kubernetes-Extension.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Install-the-Bridge-to-Kubernetes-Extension.jpg" alt="Install the Bridge to Kubernetes Extension" /></a>
  
  <p>
   Install the Bridge to Kubernetes Extension
  </p>
</div>

### Configure the Kubernetes Namespace for Debugging

After installing the Extensions, press CRTL + Shift + P, type in Bridge, and select Bridge to Kubernetes: Open Menu.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Open-the-Kubernetes-Menu.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Open-the-Kubernetes-Menu.jpg" alt="Open the Kubernetes Menu" /></a>
  
  <p>
   Open the Kubernetes Menu
  </p>
</div>

This opens the Kubernetes menu where you can see your clusters. Open the Namespace tab of the cluster you want to debug and make sure the right namespace is select. The selected namespace has an asterisk (*) at the beginning. If the wrong namespace is selected, right-click the namespace you want to use and select "Use Namespace"

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Configure-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Configure-the-Namespace.jpg" alt="Configure the Namespace" /></a>
  
  <p>
   Configure the Namespace
  </p>
</div>

### Configure Bridge to Kubernetes

After setting the namespace, press CRTL + Shift + P again and type Kubernetes: Debug. From the drop-down, select Kubernetes: Debug (Local Tunnel).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Start-configuring-the-Bridge-to-Kubernetes.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Start-configuring-the-Bridge-to-Kubernetes.jpg" alt="Start configuring the Bridge to Kubernetes" /></a>
  
  <p>
   Start configuring the Bridge to Kubernetes
  </p>
</div>

This opens the configuration assist for the connection into the Kubernetes cluster. First, select the service you want to debug. Since my namespace only has one service, I only see the customerapi service in the drop-down.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Select-the-service-to-debug.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Select-the-service-to-debug.jpg" alt="Select the service to debug" /></a>
  
  <p>
   Select the service to debug
  </p>
</div>

Next, enter the port on which your microservice is running on your local machine. You can either start your application and check the port, or you can open the launchSettings.json file in the Properties folder and check there. 

<script src="https://gist.github.com/WolfgangOfner/ba6568f6ab123933078ef960906fde99.js"></script>

The port is 5001 in my case.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Configure-the-port-of-your-local-microservice.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Configure-the-port-of-your-local-microservice.jpg" alt="Configure the port of your local microservice" /></a>
  
  <p>
   Configure the port of your local microservice
  </p>
</div>

In the next step, select a launch config for your microservice. If you use my demo, you can find this config under CustomerApi/CustomerApi/.vscode. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Select-a-launch-config.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Select-a-launch-config.jpg" alt="Select a launch config" /></a>
  
  <p>
   Select a launch config
  </p>
</div>

In the last step, configure if you want to redirect all requests to your machine or only specific ones. In a production environment, you would want to only redirect your requests but for this demo, select No to redirect all requests to your machine.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Configure-what-requests-get-redirected.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Configure-what-requests-get-redirected.jpg" alt="Configure what requests get redirected" /></a>
  
  <p>
   Configure what requests get redirected
  </p>
</div>

### Start debugging your Microservice

Let's imagine that there is a new feature for the microservice and from now on the PrimeNumber controller should not calculate a prime number anymore but rather return the double of the entered number (I know it is a stupid example but that's fine for this demo). Change the code of the Index action in the PrimeNumber controller to return the entered number * 2 and set a break-point to debug the code later.

Now you are ready to start the microservice. Press CRTL + Shift + D or select the debug tab and then start the application with the launch setting with the Kubernetes configuration.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Start-with-the-Kubernetes-settings.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Start-with-the-Kubernetes-settings.jpg" alt="Start with the Kubernetes settings" /></a>
  
  <p>
   Start with the Kubernetes settings
  </p>
</div>

If Visual Studio Code can establish a connection to the Kubernetes cluster, the bar on the bottom will turn orange.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/The-bar-turns-orange-when-connected-to-K8s.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/The-bar-turns-orange-when-connected-to-K8s.jpg" alt="The bar turns orange when connected to K8s" /></a>
  
  <p>
   The bar turns orange when connected to K8s
  </p>
</div>

### Debug Requests from your Kubernetes Cluster

After starting the microservice, open the public URL of the application running in your Kubernetes cluster. In my case that's test.customer.programmingwithwolfgang.com. This request displays the Swagger UI. There, open the PrimeNumber method, enter a number and execute the request.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/The-request-was-redirect-to-your-local-machine.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/The-request-was-redirect-to-your-local-machine.jpg" alt="The request was redirect to your local machine" /></a>
  
  <p>
   The request was redirect to your local machine
  </p>
</div>

You can see that the breakpoint in the application running locally on your machine was hit with that request. When you continue the execution, you will also see that the return value is what you expected from your new feature (the user entered 11, 11 * 2 = 22).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/The-request-was-processed-in-your-microservice-running-locally.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/The-request-was-processed-in-your-microservice-running-locally.jpg" alt="The request was processed in your microservice running locally" /></a>
  
  <p>
   The request was processed in your microservice running locally
  </p>
</div>

When you stop the application on your machine and execute the request again, you will see that the return value changed to 31 (which is the 11th prime number).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/The-request-without-debugging.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/The-request-without-debugging.jpg" alt="The request without debugging" /></a>
  
  <p>
   The request without debugging
  </p>
</div>

## Conclusion

Modern applications become more and more complex and therefore get harder to debug. Bridge to Kubernetes allows developers to redirect requests inside a running Kubernetes cluster onto their own machine to debug microservices. This allows debugging code without the need to set up a whole environment and also allows using the dependencies and configuration of the running K8s cluster. 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).