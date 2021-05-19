---
title: Deploy Azure Functions with Azure DevOps YAML Pipelines
date: 2021-05-10
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

```yaml
name : NetCore-CI-azure-pipeline.yml
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - AzureFunctions/OrderApi.Messaging.Receive/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'
  SolutionPath: 'AzureFunctions/OrderApi.Messaging.Receive/*.sln'
  
stages:
- stage: Build
  displayName: Build solution
  jobs:  
  - job: Build
    displayName: Build and publish solution
    steps:
    - task: UseDotNet@2      
      inputs:
        packageType: 'sdk'
        version: '3.x'
      displayName: 'Use .NET Core SDK 3.x'

    - task: DotNetCoreCLI@2
      inputs:
        command: 'restore'
        projects: '$(SolutionPath)'
      displayName: 'Restore NuGet packages'
 
    - task: DotNetCoreCLI@2
      inputs:
        command: 'build'
        projects: '$(SolutionPath)'
      displayName: 'Build solution'
        
    - task: DotNetCoreCLI@2
      inputs:
        command: 'publish'
        publishWebProjects: false
        projects: '$(SolutionPath)'
        arguments: '--configuration $(buildConfiguration) --output $(Build.ArtifactStagingDirectory)/$(buildConfiguration)'
      displayName: 'Publish solution'
```

The pipeline above runs automatically when changes are detected on the master branch inside the AzureFunctions/OrderApi.Messaging.Receive/ folder and uses the newest Ubuntu VM to run the build. Next, I configure a couple of variables and then run the restore, build and publish of the solution.

## Deploy the Azure Function

Before you can deploy to Azure, you need a service connection. If you don't have one yet, see [Deploy to Azure Kubernetes Service using Azure DevOps YAML Pipelines](/deploy-kubernetes-azure-devops/#create-a-service-connection-in-azure-devops) to set up one.

With the service connection in place, add the following task to the pipeline:

```yaml
- task: AzureFunctionApp@1
  inputs:
    azureSubscription: 'AzureServiceConnection'
    appType: 'functionAppLinux'
    appName: 'microservicedemoOrderApiMessagingReceive' # replace with the name of your Azure Function
    package: '$(Build.ArtifactStagingDirectory)/**/*.zip'
  displayName: Deploy Azure Function
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
```

This task takes the previously created .zip file (during the publish) and deploys it to an existing Azure Function. All you have to do is replace the appName with your Azure Function name. Note that the Azure Function has to exist, otherwise the task will fail. If you Azure Function runs on Windows, use functionApp as appType.

## Update the Azure Function Settings

The Azure Function can be deployed but it won't work because it has no access to the Azure Service Bus Queue or database. To provide access, you have to update the service settings. First add secrets to your Azure Pipeline by using the Variables button on the right side.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/Add-secret-variables-to-the-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/Add-secret-variables-to-the-pipeline.jpg" alt="Add secret variables to the pipeline" /></a>
  
  <p>
   Add secret variables to the pipeline
  </p>
</div>

Next, add the following variables to your pipeline:

```yaml
variables:
  buildConfiguration: 'Release'
  ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  DatabaseName: Order
  SolutionPath: 'AzureFunctions/OrderApi.Messaging.Receive/*.sln'
  SQLServerName: wolfgangmicroservicedemosql.database.windows.net # replace with your server url
```

Lastly, add the Azure App Service Settings task to update the service settings:

```yaml
- task: AzureAppServiceSettings@1
  inputs:
    azureSubscription: 'AzureServiceConnection'
    appName: 'microservicedemoOrderApiMessagingReceive'
    resourceGroupName: 'MicroserviceDemo'
    appSettings: |
      [
        {
          "name": "QueueConnectionString",
          "value": "$(QueueConnectionString)",
          "slotSetting": false
        },
        {
          "name": "DatabaseConnectionString",
          "value": "$(ConnectionString)", 
          "slotSetting": false
        }
      ]
  displayName: Update App Settings
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
```

For more information about the Azure Service Bus Queue, see my post [Replace RabbitMQ with Azure Service Bus Queues](/replace-rabbitmq-azure-service-bus-queue). The pipeline is finsihed. Deploy the Azure Function and test it.

## Testing the deployed Azure Function

If you followed this series (["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero)), you know that I am using a Customer microservice which writes updates into a queue and the Azure Function takes these messages to update the database of the Order microservice.

To test that the Azure Function works, first check the orders, especially the names in the Order database.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-orders-before-the-update.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-orders-before-the-update.jpg" alt="The orders before the update" /></a>
  
  <p>
   The orders before the update
  </p>
</div>

Next, update a customer name, for example, from Wolfgang Ofner to Name Changed. The Customer microservice write this update in the queue (or you add the message manually into the queue). The Azure Function sees the new messages, reads it and then updates the orders in the database. After the Azure Function ran, check the orders in the database and you will see the changed name.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-name-was-updated.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-name-was-updated.jpg" alt="The name was updated" /></a>
  
  <p>
   The name was updated
  </p>
</div>

## Conclusion

Deploying Azure Functions with Azure DevOps only takes a couple of lines of code and should never be done manually. Additionally, it is very easy to update the existing settings wihtout exposing any sensitve data. In my next post, [Deploy a Docker Container to Azure Functions using an Azure DevOps YAML Pipeline](/deploy-docker-container-azure-functions), I will show you how to deploy an Azure Function inside a Docker container.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).