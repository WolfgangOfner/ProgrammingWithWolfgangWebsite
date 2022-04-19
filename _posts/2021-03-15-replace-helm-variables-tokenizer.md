---
title: Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer
date: 2021-03-15
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [AKS, Helm, Kubernetes, YAML, Azure]
description: Tokenizer is a simple Azure DevOps extension with which you can replace variables in Helm charts inside an Azure DevOps CI/CD pipeline.
---

Helm is a great tool to deploy your application into Kubernetes. In my post, [Helm - Getting Started](/helm-getting-started), I also mentioned the values.yaml file which can be used to replace variables in the Helm chart. The problem with this approach is that the values.yaml file is hard-coded.

In this post, I want to introduce Tokenizer which is a simple Azure DevOps extension with which you can replace variables in the values.yaml file. 

## Why would I replace variables in my Helm Charts?

Currently the values.yaml file looks as follows:

<script src="https://gist.github.com/WolfgangOfner/f75c7798c44d6a381019223031720350.js"></script>

As you can see, the replica count or the tag is hard-coded as 1 and latest respectively. One replica might be fine for my test environment but definitely not for my production environment. In my post [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container), I talked about the disadvantages of using the latest tag and that it would be better to use a specific version number. Though, this version number is changing with every build and therefore needs to be inserted automatically.

Another use case of dynamic variables would be the connection string to your database. The connection string will be different for each of your environments. 

### Install Tokenizer in Azure DevOps

You can download the Tokenizer extension for free from the [Marketplace](https://marketplace.visualstudio.com/items?itemName=4tecture.Tokenizer). To download the extension, open the page of the extension in the marketplace and click on Get it free.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Get-the-Tokenizer-extension.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Get-the-Tokenizer-extension.jpg" alt="Get the Tokenizer extension" /></a>
  
  <p>
   Get the Tokenizer extension
  </p>
</div>

This opens a new page where you can either select your Azure DevOps Services organization to install it or download the extension if you want to install it on an Azure DevOps server.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Install-the-Tokenizer-extension.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Install-the-Tokenizer-extension.jpg" alt="Install the Tokenizer extension" /></a>
  
  <p>
   Install the Tokenizer extension
  </p>
</div>

This extension looks for variables starting and ending with a double underscore, for example, \_\_MyVariable\_\_ and replaces it with the value of the variable MyVariable.

## Add the Tokenizer Task to the Azure DevOps Pipeline

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines" target="_blank" rel="noopener noreferrer">GitHub</a>.

Add the following task before the HelmInstall task to your pipeline:

<script src="https://gist.github.com/WolfgangOfner/f2b5fafd6444c4b0d77d3325e1a60270.js"></script>

Note that I am using templates in my pipeline and added the task to the HelmInstall.yaml file. You can find more information about templates in [Improve Azure DevOps YAML Pipelines with Templates](/improve-azure-devops-pipelines-templates). These templates also use parameters. The task looks as follows:

<script src="https://gist.github.com/WolfgangOfner/febd71355c2c6ca52068901be0bffbbc.js"></script>

It is the same code as above except that the source file pattern is passed as a parameter.

All files matching the sourceFilesPattern will be searched for tokens to be replaced. In my post [Helm - Getting Started](/helm-getting-started), I talked about overriding Helm chart values using the values.yaml file. For now, all I want to update is the repository and tag variable of the values.yaml file:

<script src="https://gist.github.com/WolfgangOfner/7fe51f6151ab5d6c8f1bb91ed9be697d.js"></script>

Here I want to replace the repository with the ImageName variable and the tag with the BuildNumber variable. 

## Testing the Tokenizer

I have the following variables in my pipeline:

<script src="https://gist.github.com/WolfgangOfner/c007f3aa5240f26914cf476f879c25f3.js"></script>

The GitVersion variable sets the version number. You can read more in my post [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container). Run the pipeline and then check what image got deployed. You can use kubectl or a dashboard to check if the right image got loaded. For more information about using a dashboard, see my post [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started). 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/The-correct-image-got-loaded.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/The-correct-image-got-loaded.jpg" alt="The correct image got loaded" /></a>
  
  <p>
   The correct image got loaded
  </p>
</div>

## Conclusion

Automatically replacing configuration values for different environments is crucial. This post showed how to use the Tokenizer extension and how to easily replace values in your CI/CD pipeline.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).