---
title: Deploy to Azure Kubernetes Service using Azure DevOps YAML Pipelines
date: 2021-01-25
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [Azure DevOps, CI, YAML, AKS, Azure, Helm]
description: Microservices are becoming more and more popular these days. I will show how to deploy to Kubernetes (more precisely Azure Kubernetes Service (AKS)) using Helm and Azure DevOps pipelines.
---

Microservices are becoming more and more popular these days. These microservices run most of the time in Kubernetes. A goal we want to achieve with microservices is a quick and reliable deployment. 

In this post, I will show how to deploy to Kubernetes (more precisely Azure Kubernetes Service (AKS)) using Helm and Azure DevOps pipelines.

## Create a Kubernetes Cluster in Azure 

If you are new to Kubernetes or want instructions on how to install an Azure Kubernetes Service (AKS) cluster, see my post ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started).

## Create a Service Connection in Azure DevOps

Before you can deploy to AKS, you have to create a service connection so Azure DevOps can access your Azure resources. To create a new service connection go to Project settings --> Service connections and click on New service connection.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Create-a-new-service-connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Create-a-new-service-connection.jpg" alt="Create a new service connection" /></a>
  
  <p>
   Create a new service connection
  </p>
</div>

This opens a flyout where you have to select Azure Resource Manager and then click Next.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Choose-a-service-connection-type.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Choose-a-service-connection-type.jpg" alt="Choose a service connection type" /></a>
  
  <p>
   Choose a service connection type
  </p>
</div>

Select Service principal (automatic) as your authentication method and click Next.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Service-connection-authentication-method.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Service-connection-authentication-method.jpg" alt="Service connection authentication method" /></a>
  
  <p>
   Service connection authentication method
  </p>
</div>

On the next step, select a scope level, your subscription, the resource group, and provide a name. For example, you could configure that the service connection is only allowed to access the subscription ABC and in this subscription access only the resource group XYZ. I want my service connection to access all resource groups. Therefore, I don't select any.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Configure-the-service-connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Configure-the-service-connection.jpg" alt="Configure the service connection" /></a>
  
  <p>
   Configure the service connection
  </p>
</div>

Click on Save and the service connection gets created. Note that the service connection name will be used in the pipeline to reference this connection.

## Configure the Azure DevOps YAML Pipeline to Deploy to Azure Kubernetes Service

I created already a YAML pipeline in my previous posts which I will extend now. You can find this pipeline on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/CustomerApi-CI.yml" target="_blank" rel="noopener noreferrer">Github</a>.

Since I already have a Docker image on Docker hub, I only have to add Helm charts and a couple of variables to the pipeline.

## Define Variables for the Deployment

First, I add the following variables at the beginning of the pipeline:

```yaml
variables:
  AzureSubscription: 'AzureServiceConnection' # Name of the Service Connection
  ApiName: 'customerapi'
  ClusterResourceGroup: MicroserviceDemo  
  ChartPackage: '$(Build.ArtifactStagingDirectory)/$(ApiName)-$(Build.BuildNumber).tgz'  
  ChartPath: 'CustomerApi/CustomerApi/charts/$(ApiName)'
  HelmVersion: 3.5.0
  ImageName: 'wolfgangofner/$(ApiName):$(Build.BuildNumber)'
  K8sNamespace: '$(ApiName)-test'
  KubernetesCluster: 'microservice-aks'
```

The variables should be self-explaining. They configure the previously created service connection, set some information about the AKS cluster like its name, resource group, and what namespace I want to use, and some information for Helm. For more information about Helm see my post ["Helm - Getting Started"](/helm-getting-started).

## Deploy to Azure Kubernetes Service

Since I am using Helm for the deployment, I only need three tasks for the whole deployment. First I have to install Helm in my Kubernetes cluster. I use the HelmInstaller task and provide the Helm version which I previously configured in a variable.

```yaml
- task: HelmInstaller@0
  displayName: 'Install Helm $(HelmVersion)'
  inputs:
    helmVersion: $(HelmVersion)
    checkLatestHelmVersion: false
    installKubectl: true
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
```

Next, I have to create a Helm package from my Helm chart. To do that, I use the HelmDeploy task and the package command. For this task, I have to provide the service connection, the information about my Kubernetes cluster, the path to the Helm chart, and a version. I calculate the version at the beginning of the pipeline and set it in the Build.BuildNumber variable. Therefore, I provide this variable as the version.

```yaml
- task: HelmDeploy@0
  displayName: 'helm package'
  inputs:
    azureSubscriptionEndpoint: $(AzureSubscription)
    azureResourceGroup: $(ClusterResourceGroup)
    kubernetesCluster: $(KubernetesCluster)
    command: 'package'
    chartPath: $(ChartPath)
    chartVersion: $(Build.BuildNumber)
    save: false
    namespace: '$(K8sNamespace)'
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
```
The last step is to install the Helm package.  Therefore, I use HelmDeploy again but this time I use the upgrade command. Upgrade installs the package if no corresponding deployment exists and updates it if a deployment already exists. Additionally, I prove the --create-namespace argument to create the Kubernetes namespace if it doesn't exist. 

```yaml
- task: HelmDeploy@0
  displayName: 'Helm upgrade release'
  inputs:
    connectionType: 'Azure Resource Manager'
    azureSubscription: $(AzureSubscription)
    azureResourceGroup: '$(ClusterResourceGroup)'
    kubernetesCluster: '$(KubernetesCluster)'
    useClusterAdmin: true
    namespace: '$(K8sNamespace)'
    command: 'upgrade'
    chartType: 'FilePath'
    chartPath: '$(ChartPackage)'
    releaseName: '$(ApiName)-$(K8sNamespace)'  
    arguments: '--create-namespace'
```
That's already everything you need to deploy to Kubernetes. Run the pipeline to test that everything works as expected.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/The-deployment-to-kubernetes-was-successful.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/The-deployment-to-kubernetes-was-successful.jpg" alt="The deployment to Kubernetes was successful" /></a>
  
  <p>
   The deployment to Kubernetes was successful
  </p>
</div>

For practice, try to add the deployment to another namespace, for example, prod.

### Test the deployed Microservice

Use the dashboard of Kubernetes ([see here how to use Octant](/azure-kubernetes-service-getting-started/#access-aks-cluster)) or use the Azure portal to find the URL of the previously created microservice.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Find-the-external-URL-of-the-microservice.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Find-the-external-URL-of-the-microservice.jpg" alt="Find the external URL of the microservice" /></a>
  
  <p>
   Find the external URL of the microservice
  </p>
</div>

Open the external URL in your browser and you will see the Swagger UI of the microservice.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Swagger-UI-of-the-microservice-running-in-AKS.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Swagger-UI-of-the-microservice-running-in-AKS.jpg" alt="Swagger UI of the microservice running in AKS" /></a>
  
  <p>
   Swagger UI of the microservice running in AKS
  </p>
</div>

## The finished Pipeline

The full YAML pipeline looks as follows:

```yaml
name : CustomerApi-CI
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - CustomerApi/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  AzureSubscription: 'AzureServiceConnection' # Name of the Service Connection
  ApiName: 'customerapi'
  ClusterResourceGroup: MicroserviceDemo  
  ChartPackage: '$(Build.ArtifactStagingDirectory)/$(ApiName)-$(Build.BuildNumber).tgz'  
  ChartPath: 'CustomerApi/CustomerApi/charts/$(ApiName)'
  HelmVersion: 3.5.0
  ImageName: 'wolfgangofner/$(ApiName):$(Build.BuildNumber)'
  K8sNamespace: '$(ApiName)-test'
  KubernetesCluster: 'microservice-aks'

stages:
- stage: Build
  displayName: Build image
  jobs:  
  - job: Build
    displayName: Build and push Docker image
    steps:
    
    - task: BuildVersioning@0
      displayName: 'Build Versioning'
      inputs:
        versionSource: 'gitversion'
        doInstallGitVersion: true
        GitVersionInstallerSource: 'choco'
        GitVersionInstallerVersion: '5.0.1'
        doUseLatestGitVersionInstallerVersion: false
        paramAssemblyVersion: '7'
        paramAssemblyFileVersion: '7'
        paramAssemblyInformationalVersion: '6'
        paramOverwriteFourthDigitWithBuildCounter: false
        paramVersionCode: '2'
        doAssemblyInfoAppendSuffix: false
        doConvertAssemblyInfoToLowerCase: true
        buildNumberVersionFormat: '3'
        buildNumberAction: 'replace'
        doReplaceAssemblyInfo: false
        doReplaceNuspec: false
        doReplaceNpm: false
        doReplaceDotNetCore: true
        filePatternDotNetCore: |
          **\*.csproj
          **\*.props
        paramDotNetCoreVersionType: '3'
        doReplaceAndroid: false
        doReplaceiOS: false
        doReplaceCustom: false
        doShowWarningsForUnmatchedRegex: false
        excludeFilePattern: |
          !**/bin/**
          !**/obj/**
          !**/node_modules/**
          !**/packages/**

    - task: Docker@1      
      inputs:
        containerregistrytype: 'Container Registry'
        dockerRegistryEndpoint: 'Docker Hub'
        command: 'Build an image'
        dockerFile: '**/CustomerApi/CustomerApi/Dockerfile'
        arguments: '--build-arg BuildId=$(Build.BuildId) --build-arg PAT=$(PatMicroserviceDemoNugetsFeed)'
        imageName: '$(ImageName)'
        useDefaultContext: false
        buildContext: 'CustomerApi'
      displayName: 'Build the Docker image'

    - pwsh: |
       $id=docker images --filter "label=test=$(Build.BuildId)" -q | Select-Object -First 1
       docker create --name testcontainer $id
       docker cp testcontainer:/testresults ./testresults
       docker rm testcontainer
      displayName: 'Copy test results' 
    
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'VSTest'
        testResultsFiles: '**/*.trx'
        searchFolder: '$(System.DefaultWorkingDirectory)/testresults'
      displayName: 'Publish test results'

    - task: PublishCodeCoverageResults@1
      inputs:
        codeCoverageTool: 'Cobertura'
        summaryFileLocation: '$(System.DefaultWorkingDirectory)/testresults/coverage/coverage.cobertura.xml'
        reportDirectory: '$(System.DefaultWorkingDirectory)/testresults/coverage/reports'
      displayName: 'Publish code coverage results'

    - task: Docker@1      
      inputs:
        containerregistrytype: 'Container Registry'
        dockerRegistryEndpoint: 'Docker Hub'
        command: 'Push an image'
        imageName: '$(ImageName)'
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
      displayName: 'Push the Docker image to Dockerhub'
    
    - task: HelmInstaller@0
      displayName: 'Install Helm $(HelmVersion)'
      inputs:
        helmVersion: $(HelmVersion)
        checkLatestHelmVersion: false
        installKubectl: true
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
      
    - task: HelmDeploy@0
      displayName: 'helm package'
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureResourceGroup: $(ClusterResourceGroup)
        kubernetesCluster: $(KubernetesCluster)
        command: 'package'
        chartPath: $(ChartPath)
        chartVersion: $(Build.BuildNumber)
        save: false
        namespace: '$(K8sNamespace)'
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
    
    - task: HelmDeploy@0
      displayName: 'Helm upgrade release'
      inputs:
        connectionType: 'Azure Resource Manager'
        azureSubscription: $(AzureSubscription)
        azureResourceGroup: '$(ClusterResourceGroup)'
        kubernetesCluster: '$(KubernetesCluster)'
        useClusterAdmin: true
        namespace: '$(K8sNamespace)'
        command: 'upgrade'
        chartType: 'FilePath'
        chartPath: '$(ChartPackage)'
        releaseName: '$(ApiName)-$(K8sNamespace)'
        arguments: '--create-namespace'
```

## Shortcommings of my Implementation

This implementation is more a proof of concept than a best practice. In a real-world project, you should use different stages, for example, build, deploy-test, and deploy-prod. Right now, every build (if it's not a pull request) deploys to test and prod. Usually, you want some tests or checks after the test deployment. 

The pipeline is also getting quite long and it would be nice to move different parts to different files using templates.

I will implement all these best practices and even more over the next couple of posts.

## Conclusion

Using an Azure DevOps pipeline to deploy to Kubernetes is quite simple. In this example, I showed how to use Helm to create a Helm package and then deploy it to an Azure Kubernetes Service cluster. Over the next couple of posts, I will improve the pipeline and extend its functionality to follow all best practices.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).