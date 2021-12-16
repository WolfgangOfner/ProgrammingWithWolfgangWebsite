---
title: Deploy KEDA and an Autoscaler using Azure DevOps Pipelines
date: 2021-09-27
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Kiali, KEDA, Azure DevOps]
description: CI/CD YAML pipelines in Azure DevOps can be used to easily install KEDA using Helm charts and Azure CLI tasks.
---

In my last post, [KEDA - Kubernetes Event-driven Autoscaling](/keda-kubernetes-event-driven-autoscalling), I showed how to deploy a KEDA scaler to scale a microservice-based on the queue length of an Azure Service Bus Queue. The deployment of KEDA used Helm and the autoscaler was deployed using a simple YAML file. This is fine to learn new tools and technologies but in a modern DevOps environment, we want to have an automated deployment of KEDA itself and also of the scaler.

In today's post, I will show you how to deploy KEDA to Kubernetes using an Azure DevOps pipeline and how to add the KEDA scaler to the Helm charts of an existing microservice.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Deploy KEDA with an Azure DevOps Infrastructure as Code (IoC) Pipeline

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/Infrastructure/AzureResources/Azure-resource-install-pipeline.yml" target="_blank" rel="noopener noreferrer">GitHub</a>.

In one of my previous post, [Use Infrastructure as Code to deploy your Infrastructure with Azure DevOps](/use-infrastructure-as-code-to-deploy-infrastructure), I created a YAML pipeline in Azure DevOps to deploy my whole infrastructure to Azure. This included the Azure Kubernetes Service cluster, an SQL database server, several components for Kubernetes like a cert-manager and ingress controller, and many more. The pipeline uses YAML and Azure CLI to define the services. The big advantage of having such a pipeline is that I can easily create my whole infrastructure from scratch with a single button click. This makes it fast, and easily repeatable without worrying about forgetting anything.

This pipeline is perfect to create a new namespace in the Kubernetes cluster, add the Helm chart for KEDA and install it.

First, add the following two variables to the pipeline. This is not necessary but I like to have most of the configuration in variables at the beginning of the pipeline.

<script src="https://gist.github.com/WolfgangOfner/c7497cebf224895871251230fd69bfa5.js"></script>

Next, use the HelmDeploy task of Azure DevOps and add the Helm chart of KEDA to your Kubernetes cluster. 

<script src="https://gist.github.com/WolfgangOfner/1e1694d9c3146ac4aff5939b0843b17c.js"></script>

After adding the Helm chart, update it with the following lines of code:

<script src="https://gist.github.com/WolfgangOfner/3bc70be677273041da7c3aeddcf92c10.js"></script>

The last step is to install the previously added Helm chart. Use the --create-namespace argument to create the namespace if it does not exist and also make sure to add a version number. Without the version, the deployment will fail.

<script src="https://gist.github.com/WolfgangOfner/b754b7441da5d9759237f64452439a48.js"></script>

## Add the Azure Service Bus Queue Scaler to an existing Microservice Helm chart

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/KedaDemoApi" target="_blank" rel="noopener noreferrer">GitHub</a>. If you want to learn more about Helm see [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm).

Inside the demo application, you can find the KedaDemoApi, and inside there are the charts and kedademoapi folder. Helm reads the YAML files inside this folder and creates Kubernetes objects. To add the KEDA scaler to the Helm chart, create a new file and name it kedascaler.yaml. This file will contain the ScaledObject which configures the trigger. The file has the following content:

<script src="https://gist.github.com/WolfgangOfner/cbcbee3e2e0c9658a1834c9292a62029.js"></script>

Next, create a second file, called kedatriggerauthentication.yaml, which will contain the Trigger-Authentication. This file will configure the access of the Scaled Object to the Azure Service Bus Queue and references a secret in Kubernetes.

<script src="https://gist.github.com/WolfgangOfner/590f3da5fded3d00fcbe9c7d5c69a6b2.js"></script>

Helm is a template engine that replaces the placeholder in the double braces with the corresponding values in the values.yaml file. For example, {% raw %} {{ .Values.kedascaler.minReplicaCount }}{% endraw %} will be replaced with the value of the variable minReplicaCount in the kedascaler section of the values.yaml file. 

Add the following values at the bottom of the values.yaml file:

<script src="https://gist.github.com/WolfgangOfner/61404f73db903202c39a4453d3485a56.js"></script>

## Replace Variable Values during the Deployment in the Continous Deployment Pipeline

The values in the values.yaml file are hard-coded but it is also possible to pass variables. The secretKey value AzureServiceBus__ConnectionString is such a variable. You can set this variable in your CI or CD pipeline and use the Tokenizer task to replace AzureServiceBus__ConnectionString with the actual value of the variable. For more details, see [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

## Testing the Implementation

Run the Infrastructure pipeline and afterwards the CI pipeline of the KedaDemoApi. Both pipelines should finish successfully.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Install-KEDA-using-the-Infrastructure-Pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Install-KEDA-using-the-Infrastructure-Pipeline.jpg" alt="Install KEDA using the Infrastructure Pipeline" /></a>
  
  <p>
   Install KEDA using the Infrastructure Pipeline
  </p>
</div>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Microservice-with-the-Scaler-was-deployed-successfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Microservice-with-the-Scaler-was-deployed-successfully.jpg" alt="The Microservice with the Scaler was deployed successfully" /></a>
  
  <p>
   The Microservice with the Scaler was deployed successfully
  </p>
</div>

## Conclusion

CI/CD YAML pipelines in Azure DevOps can be used to easily install KEDA using Helm charts. This allows for fast, reproducible deployments which results in a low error rate. Helm can also be used to deploy the KEDA scaler with an existing microservice. This allows developers to quickly add the KEDA scaler to the Helm chart and also does not require any changes in the deployment pipeline to deploy the new scaler.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).