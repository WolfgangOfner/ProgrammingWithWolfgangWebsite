---
title: Deploy Azure Functions with Azure DevOps YAML Pipelines
date: 2021-04-26
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [DevOps, Azure DevOps, Azure, Azure Service Bus, Azure Functions, YAML, CI-CD]
description: Deploy an Azure Function using Azure DevOps YAML pipelines and automatically update its settings safely inside the pipeline.
---

[In my last post](/azure-functions-process-queue-messages), I created an Azure Function that reads messages from an Azure Service Bus Queue and then updates a database. The deployment of the Azure Function was manual using Visual Studio. 

Since I am a big fan of DevOps, I will create an Azure DevOps pipeline today to automate the deployment,

## Create a basic YAML pipeline in Azure DevOps

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

Create a basic YAML pipeline in Azure DevOps where you restore the NuGet packages, build the solution and publish it. For more information about Azure DevOps YAML pipelines, see my post [Build .NET Core in a CI Pipeline in Azure DevOps](/build-net-core-in-ci-pipeline-in-azure-devops).

Your basic pipeline should look something like this:

<script src="https://gist.github.com/WolfgangOfner/9f19386d061df55ec253af595ba5d73e.js"></script>

The pipeline above runs automatically when changes are detected on the master branch inside the AzureFunctions/OrderApi.Messaging.Receive/ folder and uses the newest Ubuntu VM to run the build. Next, I configure a couple of variables and then run the restore, build and publish of the solution.

## Deploy the Azure Function

Before you can deploy to Azure, you need a service connection. If you don't have one yet, see [Deploy to Azure Kubernetes Service using Azure DevOps YAML Pipelines](/deploy-kubernetes-azure-devops/#create-a-service-connection-in-azure-devops) to set up one.

With the service connection in place, add the following task to the pipeline:

<script src="https://gist.github.com/WolfgangOfner/adef83b53f9f4861017e230dac7070df.js"></script>

This task takes the previously created .zip file (during the publish) and deploys it to an existing Azure Function. All you have to do is replace the appName with your Azure Function name. Note that the Azure Function has to exist, otherwise the task will fail. If you Azure Function runs on Windows, use functionApp as appType.

## Update the Azure Function Settings

The Azure Function can be deployed but it won't work because it has no access to the Azure Service Bus Queue or database. To provide access, you have to update the service settings. First add secrets to your Azure Pipeline by using the Variables button on the right side.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Add-secret-variables-to-the-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Add-secret-variables-to-the-pipeline.jpg" alt="Add secret variables to the pipeline" /></a>
  
  <p>
   Add secret variables to the pipeline
  </p>
</div>

Next, add the following variables to your pipeline:

<script src="https://gist.github.com/WolfgangOfner/a555eae3b8afaa7e5c957c7abfe1987b.js"></script>

Lastly, add the Azure App Service Settings task to update the service settings:

<script src="https://gist.github.com/WolfgangOfner/1ac65017380c1d617da80b6eaeda62ac.js"></script>

For more information about the Azure Service Bus Queue, see my post [Replace RabbitMQ with Azure Service Bus Queues](/replace-rabbitmq-azure-service-bus-queue). The pipeline is finsihed. Deploy the Azure Function and test it.

## Testing the deployed Azure Function

If you followed this series (["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero)), you know that I am using a Customer microservice which writes updates into a queue and the Azure Function takes these messages to update the database of the Order microservice.

To test that the Azure Function works, first check the orders, especially the names in the Order database.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/The-orders-before-the-update.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/The-orders-before-the-update.jpg" alt="The orders before the update" /></a>
  
  <p>
   The orders before the update
  </p>
</div>

Next, update a customer name, for example, from Wolfgang Ofner to Name Changed. The Customer microservice write this update in the queue (or you add the message manually into the queue). The Azure Function sees the new messages, reads it and then updates the orders in the database. After the Azure Function ran, check the orders in the database and you will see the changed name.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/The-name-was-updated.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/The-name-was-updated.jpg" alt="The name was updated" /></a>
  
  <p>
   The name was updated
  </p>
</div>

## Conclusion

Deploying Azure Functions with Azure DevOps only takes a couple of lines of code and should never be done manually. Additionally, it is very easy to update the existing settings wihtout exposing any sensitve data. In my next post, [Deploy a Docker Container to Azure Functions using an Azure DevOps YAML Pipeline](/deploy-docker-container-azure-functions), I will show you how to deploy an Azure Function inside a Docker container.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).