---
title: Use Infrastructure as Code to deploy your Infrastructure with Azure DevOps
date: 2021-06-28
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, IaC]
description: Infrastructure as Code (IaC) enables you to deploy your infrastructure fast and reliable and helps to increase the quality of the deployments.
---

Back in the day developers had to go through a lengthy process to get new hardware deployed. Often it took several weeks and then there was still something missing or the wrong version of the needed software installed. This was one of my biggest pet peeves and it was a major reason why I left my first job.

Fortunately, we have a solution to these pains, Infrastructure as Code. This post will explain what it is and how you can easily set up all the services needed.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is Infrastructure as Code (IaC)?

As the name already suggests, Infrastructure as Code means that your infrastructure and its dependencies are defined in a file as code. Nowadays the configuration is often saved in a JSON or YAML file. IaC has many advantages over the old-school approach of an operation person creating the infrastructure:

- The definition can be reviewed and saved in version control
- Infrastructure can be deployed fast and reliable
- Deployments can be repeated as often as needed
- No (less) communication problems due to developers writing the configuration themselves
- Many tools are available

If you are working with Azure, you might be familiar with ARM templates. There are also many popular tools out there like Puppet, Terraform, Ansible and Chef. My preferred way is Azure CLI. In the following sections, I will show you how to create an Azure DevOps YAML pipeline using Azure CLI and Helm to create an Azure Kubernetes Cluster with all its configurations like Nginx as Ingress Controller, Azure SQL Database, Azure Function, and Azure Service Bus.

## Azure CLI Documentation

I like using Azure CLI because it is easy to use locally and it is also quite intuitive. All commands follow the same pattern of "az service command", for example, az aks create or az sql server update. This makes it very easy to google how to create or update services. Additionally, the documentation is very good. You can find all commands <a href="https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest" target="_blank" rel="noopener noreferrer">here</a>. 

## Create your first Infrastructure as Code Pipeline in Azure DevOps

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

Create a new pipeline and define the following variables:

<script src="https://gist.github.com/WolfgangOfner/4c008011147ad58560e38d151091f025.js"></script>

The variables should be self-explanatory when you look at their usage later on. Also if you followed this series, you should have seen all names and services before already. You need an existing Azure Service Connection configured in Azure DevOps. If you don't have one yet, I explain in [Deploy to Azure Kubernetes Service using Azure DevOps YAML Pipelines](/deploy-kubernetes-azure-devops/#create-a-service-connection-in-azure-devops) how to create one.

Next, install Helm to use it later and create a resource group using the Azure CLI. This resource group will host all new services. 

<script src="https://gist.github.com/WolfgangOfner/d04b083e667c4471ae665e05a0427091.js"></script>

If you are unfamiliar with Helm, see [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm) for more information.

### Create an Azure Kubernetes Cluster

Creating an AKS cluster is quite simple due to the names of the parameters. For example, you can configure the VM size, what Kubernetes version you want to install, or the node count of your cluster. The full command looks as follows:

<script src="https://gist.github.com/WolfgangOfner/404ffb1a00477da4dea5c062d57e3586.js"></script>

#### Install the Cert-Manager Addon

The Cert-Manager adds SSL certificates to your services running inside AKS to allow the usage of HTTPS. If you read [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes), then you will be familiar with the following code since it is identical.

<script src="https://gist.github.com/WolfgangOfner/7176f6e951717697d165f272f1ae5e00.js"></script>

#### Add the Certificate Cluster Issuer

The SSL certificates need to be issued using the Cluster Issuer object. I am using the same YAML file as in [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes) except that this time it is applied as inline code and with the variable for the email address.

<script src="https://gist.github.com/WolfgangOfner/08f4aa0160702ea68bd4932b7068b895.js"></script>

#### Install Nginx and configure it as Ingress Controller

In [Set up Nginx as Ingress Controller in Kubernetes](/setup-nginx-ingress-controller-kubernetes), I added Nginx and configured it as Ingress Controller of my AKS cluster. To install Nginx in the IaC pipeline, add its Helm repository, update it and then install it with the following commands using Azure CLI:

<script src="https://gist.github.com/WolfgangOfner/fad23a93de550bc27e13cd49558793a8.js"></script>

### Create a new Azure SQL Server

After the deployment of the AKS cluster is finished, let's add a new Azure SQL Server with the following command:

<script src="https://gist.github.com/WolfgangOfner/77eff33e4b0ef026697b3175bd62e0d9.js"></script>

You might miss the variables SqlServerAdminUser and SqlServerAdminPassword. Since these values are confidential, add them as secret variables to your Azure DevOps pipeline by clicking on Variables in the top-right corner of your pipeline window. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Add-the-database-variables-as-secret-variables.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Add-the-database-variables-as-secret-variables.jpg" alt="Add the database variables as secret variables" /></a>
  
  <p>
   Add the database variables as secret variables
  </p>
</div>

By default, the Azure SQL Server does not allow any connections. Therefore you have to add firewall rules to allow access to the SQL Service. The following code enables Azure resources like Azure DevOps to access the SQL Server. 

<script src="https://gist.github.com/WolfgangOfner/0561b8ae25e02484d2c53aa1e7ff9581.js"></script>

Feel free to add as many firewall rules as you need. All you have to do is to edit the start and end IP address parameters.

### Deploy an Azure Service Bus Queue

To create an Azure Service Bus Queue, you also have to create an Azure Service Bus Namespace first. I talked about these details in [Replace RabbitMQ with Azure Service Bus Queues](/replace-rabbitmq-azure-service-bus-queue).

<script src="https://gist.github.com/WolfgangOfner/df73e1d50da81bd4c77d5c741d8b7146.js"></script>

To allow applications to read or write to the queue, you have to create shared access signatures (SAS). The following commands create both a SAS for listening and sending messages.

<script src="https://gist.github.com/WolfgangOfner/71c0a1139bc53ecc5eb5b30a340391d6.js"></script>

### Create an Azure Function

The last service I have been using in my microservice series (["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero)) is an Azure Function. Before you can create an Azure Function using Azure CLI, you have to create a Storage Account and an App Service Plan.

<script src="https://gist.github.com/WolfgangOfner/62243241c2a3bef5d41b6ce31f14b6cc.js"></script>

With the Azure Storage Account and App Service Plan set up, create the Azure Function.

<script src="https://gist.github.com/WolfgangOfner/0a73b0e93a0b5503e98e15056cb8a694.js"></script>

## Create all your Infrastructure using the IaC Pipeline

Run the pipeline in Azure DevOps and all your services will be created in Azure. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Run-the-IaC-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Run-the-IaC-pipeline.jpg" alt="Run the IaC pipeline" /></a>
  
  <p>
   Run the IaC pipeline
  </p>
</div>

As you can see, the pipeline ran for less than 10 minutes and deployed all my services. This is probably faster than you can click and configure all the services in the Azure Portal. If you want to deploy the services to a different Azure subscription or with different names, all you have to do is to change the variables and run the pipeline again.

This makes it very safe and fast to set up all the infrastructure you need for your project.

## Conclusion

Infrastructure as Code (IaC) solves many problems with deployments and enables development teams to quickly and reliably deploy the infrastructure. You can choose between many tools like Ansible, Terraform, or Chef. Alternatively, you can keep it simple like I did in the demo and use Azure CLI. The advantage of the Azure CLI is that you can easily use it locally for testing. 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).