---
title: Automatically set Azure Service Bus Queue Connection Strings during the Deployment
date: 2021-11-08
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [Azure, Azure DevOps, Helm, Azure Service Bus, CI-CD]
description: Modern applications need to be deployed fast and often. This means that every aspect of the deployment, like reading connection strings should be automated.  
---

In a previous post, I showed how to add the connection string of an Azure Service Bus Queue to your application using Azure DevOps pipelines. This was done using variables. The solution works, but it is not dynamic. In a cloud environment, you often delete and re-create environments. Therefore, you will have different access tokens which results in changing connection strings.

In this post, I will show you how you can read the connection string using Azure CLI and then pass it to your application inside an Azure DevOps pipeline.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Use Azure CLI to read the Azure Service Bus Queue Connection String

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi/pipelines" target="_blank" rel="noopener noreferrer">GitHub</a>.

Using Azure CLI allows you to read the connection string of an Azure Service Bus Queue with a single command using the Azure CLI task in the Azure DevOps pipeline. After reading the connection string, use Write-Host to set it to the AzureServiceBusConnectionString variable.

<script src="https://gist.github.com/WolfgangOfner/8a85c6f0a696cae935cd07f6b79c3bc0.js"></script>

## Use a Template inside the Azure DevOps Pipeline

In [Improve Azure DevOps YAML Pipelines with Templates](/improve-azure-devops-pipelines-templates/), I explained how to use templates to make your pipeline clearer. To continue using templates, I placed the code from above in a separate template named GetServiceBusConnectionString. Then I call this template during the deployment and pass the needed variables as parameters.

<script src="https://gist.github.com/WolfgangOfner/9c185722604d1d86e2a05796cbc145d7.js"></script>

Note that I use this template during the deployment of the test and production environment. The finished template looks as follows:

<script src="https://gist.github.com/WolfgangOfner/d4d46d7ac0f33ffb0c1e3206e691ed30.js"></script>

Lastly, add the following variables to your pipeline. Note to replace my values with your corresponding ones.

<script src="https://gist.github.com/WolfgangOfner/435a38dea82c8a2a3c22e95b00504143.js"></script>

That's already all you have to change. You don't have to change more because the output variable of the GetServiceBusConnectionString template has the same name as the previously used one. The Tokenizer task will read the variable and add it to the Helm chart. You can read more about that in [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

Run your application and you should still be able to access your queue.

## Conclusion

Using a cloud environment allows your infrastructure and applications to be flexible. Therefore, your configuration also has to be flexible. This post showed how you can easily read the connection string of an Azure Service Bus Queue using Azure CLI. By doing so, your application will always read the correct connection string and will work no matter what happens to the underlying infrastructure (as long as the Azure Service Bus Queue exists obviously).

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi/pipelines" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).