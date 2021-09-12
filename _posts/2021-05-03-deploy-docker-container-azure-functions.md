---
title: Deploy a Docker Container to Azure Functions using an Azure DevOps YAML Pipeline
date: 2021-05-03
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [DevOps, Azure DevOps, Azure, Azure Functions, YAML, CI-CD, Docker]
description: Build and Deploy an Azure Function inside a Docker container and deploy it using an Azure DevOps YAML pipeline.
---

[In my last post](/deploy-azure-functions-azure-devops-pipelines), I created a YAML pipeline to build and deploy an Azure Function to Azure. Today, I will build the same Azure Function inside a Docker container and deploy the container to Azure.

## Add Docker to the Azure Function

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

To add Docker to the Azure Function, right-click the project in Visual Studio and click Add --> Docker Support. Visual Studio automatically creates the Dockerfile for you.

<script src="https://gist.github.com/WolfgangOfner/0ca89543d1e5c6db25f46f64a0f7e406.js"></script>

If you want to learn more about adding Docker to a .NET 5 project, see my post [Dockerize an ASP .NET Core Microservice and RabbitMQ](/dockerize-an-asp-net-core-microservice-and-rabbitmq).

## Build a Docker Container inside a YAML Pipeline in Azure DevOps

In Azure DevOps, create a new pipeline (or edit the one form last post) and add the following variables:

<script src="https://gist.github.com/WolfgangOfner/a642e59452edfb93940d105deb70289f.js"></script>

Additionally, add DbUser, DbPassword, and QueueConnectionString as secret variables to the pipeline. These variables contain the database user and password and the connection string to the Azure Service Bus Queue. If you want to deploy your own Azure Function without a connection to other services, then you obviously don't have to add the variables.

Next, add a job inside a stage and create a build version using GitVersion. If you want to learn more about versioning, see my post [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container).

<script src="https://gist.github.com/WolfgangOfner/525bb10ae789b5ef82a432109e6c169d.js"></script>

With the version number in place, add two more tasks to build the Docker container and then push it to a registry. In this demo, I am pushing it to DockerHub. 

<script src="https://gist.github.com/WolfgangOfner/7831e4199e4e12db38b240d039e098d3.js"></script>

The last step is to deploy the previously created Docker container to the Azure Function and then pass the database and queue connection string to its settings. For more information about deploying an Azure Function with Azure DevOps see my last post, [Deploy Azure Functions with Azure DevOps YAML Pipelines](/deploy-azure-functions-azure-devops-pipelines). Note that the Azure Function must exist, otherwise the deployment will fail.

<script src="https://gist.github.com/WolfgangOfner/1bc734315b10ec70ac68dd417dd88eec.js"></script>

The full pipeline looks as follows:

<script src="https://gist.github.com/WolfgangOfner/e7c6ace4d53621360f95c305e16c7042.js"></script>

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