---
title: Deploy a Docker Container to Azure Functions using an Azure DevOps YAML Pipeline
date: 2021-05-17
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [DevOps, Azure DevOps, Azure, Azure Functions, YAML, CI-CD, Docker]
---

[In my last post](/deploy-azure-functions-azure-devops-pipelines), I created a YAML pipeline to build and deploy an Azure Function to Azure. Today, I will build the same Azure Function inside a Docker container and deploy the container to Azure.

## Add Docker to the Azure Function

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

To add Docker to the Azure Function, right-click the project in Visual Studio and click Add --> Docker Support. Visual Studio automatically creates the Dockerfile for you.

```shell
FROM mcr.microsoft.com/azure-functions/dotnet:3.0 AS base
WORKDIR /home/site/wwwroot
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["OrderApi.Messaging.Receive/OrderApi.Messaging.Receive.csproj", "OrderApi.Messaging.Receive/"]
RUN dotnet restore "OrderApi.Messaging.Receive/OrderApi.Messaging.Receive.csproj"
COPY . .
WORKDIR "/src/OrderApi.Messaging.Receive"
RUN dotnet build "OrderApi.Messaging.Receive.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OrderApi.Messaging.Receive.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /home/site/wwwroot
COPY --from=publish /app/publish .
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true
```
If you want to learn more about adding Docker to a .NET 5 project, see my post [Dockerize an ASP .NET Core Microservice and RabbitMQ](/dockerize-an-asp-net-core-microservice-and-rabbitmq).

## Build a Docker Container inside a YAML Pipeline in Azure DevOps

In Azure DevOps, create a new pipeline (or edit the one form last post) and add the following variables:

```yaml
variables:
  ArtifactName: 'OrderApi.Messaging.Receive'  
  ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ContainerRegistry: 'Docker Hub'
  DatabaseName: Order  
  SQLServerName: wolfgangmicroservicedemosql.database.windows.net # replace with your server url
  Repository: 'wolfgangofner/orderapimessagingreceive'
  Tag: $(GitVersion.NuGetVersionV2)
```

Additionally, add DbUser, DbPassword, and QueueConnectionString as secret variables to the pipeline. These variables contain the database user and password and the connection string to the Azure Service Bus Queue. If you want to deploy your own Azure Function without a connection to other services, then you obviously don't have to add the variables.

Next, add a job inside a stage and create a build version using GitVersion. If you want to learn more about versioning, see my post [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container).

```yaml
stages:
- stage: Build_and_Publish
  displayName: Build and Publish container
  jobs:
  - job: 'Build_and_Publish'
    displayName: Build and publish the container
    steps:
    - task: gitversion/setup@0
      displayName: Install GitVersion
      inputs:
        versionSpec: '5.5.0'
        
    - task: gitversion/execute@0
      displayName: Determine Version
```

With the version number in place, add two more tasks to build the Docker container and then push it to a registry. In this demo, I am pushing it to DockerHub. 

```yaml
- task: Docker@2  
  inputs:
    containerRegistry: $(ContainerRegistry)
    repository: $(Repository)
    command: 'build'
    Dockerfile: '**/$(ArtifactName)/$(ArtifactName)/Dockerfile'
    buildContext: 'AzureFunctions/$(ArtifactName)'
    tags: |      
      $(Tag)
      latest   
  displayName: 'Build Docker Container'

- task: Docker@2  
  inputs:
    containerRegistry: $(ContainerRegistry)
    repository: $(Repository)
    command: 'push'
    tags: |      
      $(Tag)
      latest
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
  displayName: 'Push Docker Container'
```

The last step is to deploy the previously created Docker container to the Azure Function and then pass the database and queue connection string to its settings. For more information about deploying an Azure Function with Azure DevOps see my last post, [Deploy Azure Functions with Azure DevOps YAML Pipelines](/deploy-azure-functions-azure-devops-pipelines). Note that the Azure Function must exist, otherwise the deployment will fail.

```yaml
- task: AzureFunctionAppContainer@1 
  inputs:
    azureSubscription: 'AzureServiceConnection'
    appName: 'microservicedemoOrderApiMessagingReceive'
    imageName: '$(Repository):$(Tag)'

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

The full pipeline looks as follows:

```yaml
name : OrderApi.Messaging.Receive-Docker-CI-azure-pipeline.yml
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
  ArtifactName: 'OrderApi.Messaging.Receive'  
  ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ContainerRegistry: 'Docker Hub'
  DatabaseName: Order  
  SQLServerName: wolfgangmicroservicedemosql.database.windows.net # replace with your server url
  Repository: 'wolfgangofner/orderapimessagingreceive'
  Tag: $(GitVersion.NuGetVersionV2)

stages:
- stage: Build_and_Publish
  displayName: Build and Publish container
  jobs:
  - job: 'Build_and_Publish'
    displayName: Build and publish the container
    steps:
    - task: gitversion/setup@0
      displayName: Install GitVersion
      inputs:
        versionSpec: '5.5.0'
        
    - task: gitversion/execute@0
      displayName: Determine Version

    - task: Docker@2
      displayName: 'Build Docker Container'
      inputs:
        containerRegistry: $(ContainerRegistry)
        repository: $(Repository)
        command: 'build'
        Dockerfile: '**/$(ArtifactName)/$(ArtifactName)/Dockerfile'
        buildContext: 'AzureFunctions/$(ArtifactName)'
        tags: |      
          $(Tag)
          latest        
  
    - task: Docker@2
      displayName: 'Push Docker Container'
      inputs:
        containerRegistry: $(ContainerRegistry)
        repository: $(Repository)
        command: 'push'
        tags: |      
          $(Tag)
          latest
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))

    - task: AzureFunctionAppContainer@1 
      inputs:
        azureSubscription: 'AzureServiceConnection'
        appName: 'microservicedemoOrderApiMessagingReceive'
        imageName: '$(Repository):$(Tag)'

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

Save the pipeline and run it. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-pipeline-ran-sucessfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-pipeline-ran-sucessfully.jpg" alt="The pipeline ran sucessfully" /></a>
  
  <p>
   The pipeline ran sucessfully
  </p>
</div>

You can see the Docker container with its two tags on DockerHub after the build is finished.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-Azure-Function-Container-got-pushed-to-DockerHub.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-Azure-Function-Container-got-pushed-to-DockerHub.jpg" alt="The Azure Function Container got pushed to DockerHub" /></a>
  
  <p>
   The Azure Function Container got pushed to DockerHub
  </p>
</div>

Testing the Azure Function is exactly the same as in my last post, [Deploy Azure Functions with Azure DevOps YAML Pipelines](/deploy-azure-functions-azure-devops-pipelines/#testing-the-deployed-azure-function).

## Conclusion

This short post showed how to create a Docker container of an Azure Function inside an Azure DevOps YAML pipeline. The Docker image was published to DockerHub and then deployed to an existing Azure Function.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).