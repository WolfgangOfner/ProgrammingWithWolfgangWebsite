---
title: Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer
date: 2021-02-22
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [AKS, Helm, Kubernetes, YAML, Azure]
description: Tokenizer which is a simple Azure DevOps extension with which you can replace variables in Helm charts inside an Azure DevOps CI/CD pipeline.
---

Helm is a great tool to deploy your application into Kubernetes. In my post, [Helm - Getting Started](/helm-getting-started), I also mentioned the values.yaml file which can be used to replace variables in the Helm chart. The problem with this approach is that the values.yaml file is hard-coded.

In this post, I want to introduce Tokenizer which is a simple Azure DevOps extension with which you can replace variables in the values.yaml file. 

## Why would I replace variables in my Helm Charts?

Currently the values.yaml file looks as following:

```yaml
fullnameOverride: customerapi
replicaCount: 1
image:
  repository: wolfgangofner/customerapi
  tag: latest
  pullPolicy: IfNotPresent
```

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

This extension looks for variables starting and ending with a double underscore, for example, \_\_MyVariable\_\_ and replace it with the value of the variable MyVariable.

## Add the Tokenizer Task to the Azure DevOps Pipeline

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines" target="_blank" rel="noopener noreferrer">Github</a>.

Add the following task before the Helm install to your pipeline:

```yaml
- task: Tokenizer@0
  displayName: 'Run Tokenizer'
  inputs:
    sourceFilesPattern: 'CustomerApi/CustomerApi/values.release.yaml'
```

Note that I am using templates in my pipeline and added the task to the HelmInstall.yaml file. You can find more information about templates in [Improve Azure DevOps YAML Pipelines with Templates](/improve-azure-devops-pipelines-templates). These templates also use parameters. The task looks as follows:

```yaml
- task: Tokenizer@0
  displayName: 'Run Tokenizer'
  inputs:
    sourceFilesPattern: ${{ parameters.releaseValuesFile }}
```

It is the same code as above except that the source file pattern is passed as a parameter.

All files matching the sourceFilesPattern will be searched for tokens to be replaced. In my post [Helm - Getting Started](/helm-getting-started), I talked about overriding Helm chart values using the values.yaml file. For the tokenizer, I am using the values.release.yaml file. This is a new file in the root folder of my project. I use this file instead of the values.yaml file because if I added tokens to the values.yaml file, it wouldn't be possible to deploy locally. The developer would have to replace all the tokens manually before deploying the Helm chart.

Additionally, the values.release.yaml file contains only tokens I want to replace and therefore is very simple and small. My file looks as follows:

```yaml
image:
  repository: __ImageName__
  tag: __BuildNumber__
```

Here I want to replace the repository with the ImageName variable and the tag with the BuildNumber variable. 

The values.yaml file stays untouched:

```yaml
image:
  repository: wolfgangofner/customerapi
  tag: latest
```

## Testing the Tokenizer

I have the following variables in my pipeline:

```yaml
ApiName: 'customerapi'
BuildNumber: $(GitVersion.NuGetVersionV2)
ImageName: 'wolfgangofner/$(ApiName)'
```

The GitVersion variable sets the version number. You can read more in my post [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container). Run the pipeline and then check what image got deployed. You can use kubectl or a dashboard to check if the right image got loaded. For more information about using a dashboard, see my post [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started). 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/The-correct-image-got-loaded.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/The-correct-image-got-loaded.jpg" alt="The correct image got loaded" /></a>
  
  <p>
   The correct image got loaded
  </p>
</div>

If you see the image with the latest tag loaded, you know that something went wrong. When I don't use Helm to deploy locally, I replace the values in the values.yaml file with VALUE_TO_OVERRIDE. If I see this after the deployment, I immediately know that something went wrong the with tokenizer.

## Conclusion

Automatically replacing configuration values for different environments is crucial. This post showed how to use the Tokenizer extension and how to easily replace values in your CI/CD pipeline.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).