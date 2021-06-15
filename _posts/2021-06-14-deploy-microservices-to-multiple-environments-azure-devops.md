---
title: Deploy Microservices to multiple Environments using Azure DevOps
date: 2021-06-14
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes]
description: CD Pipelines enable you to easily deploy your application and databases to multiple environments, each having a valid SSL certificate and unique URL.
---

A nice feature of Kubernetes is that you can easily set up new environments like test, QA, or production. Especially when you already have a CD pipeline, it is easy to extend it and deploy it to additional environments.

In the following post, I will add a deployment to the production environment, set up a unique URL, and also deploy the database for the environment.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Update the existing Deployment to the Test Environment

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

So far, I have used the CD pipeline to deploy to a stage called test. I plan to change the URL of the test environment and then add a deployment of the Helm package and the database to a production environment. 

First, add a new subdomain to the URL of the test environment. You don't have to use a subdomain but this makes the configuration of the DNS settings easier. For the test environment, I will use test as a subdomain which means the URL will be teast.customer.programmingwithwolfgang.com 

```yaml
- stage: Test  
  condition: ne(variables['Build.Reason'], 'PullRequest')
  variables:
    DeploymentEnvironment: 'test'
    K8sNamespace: '$(ApiName)-$(DeploymentEnvironment)'
    ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName)-$(DeploymentEnvironment);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    URL: $(DeploymentEnvironment).customer.programmingwithwolfgang.com # replace with your service url
```

Additionally, add the environment name also to the database so you can distinguish the test and production databases. That is everything you have to update for the test environment. 

## Add the Production environment to the CD Pipeline

Adding a new environment is quite easy. Copy the deployment of the test environment and copy it beneath it. Next up replace test with prod, for example, the DeploymentEnvironment variable is now prod.

```yaml
DeploymentEnvironment: 'prod'
```

Since I don't want to use a subdomain for my production URL, remove it which means the URL will be customer.programmingwithwolfgang.com

```yaml
URL: customer.programmingwithwolfgang.com # replace with your service url
```

Lastly, we only want to deploy to production when the deployment to the test environment is finished and was successful. To achieve that, add the dependsOn keyword and the following condition.

```yaml
- stage: Prod
  dependsOn: Test
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
```

In the future, you could add an approval before the production gateway. This means that the production deployment is only executed when a human approves the deployment.

## The finished CD Pipeline

The finished CD pipeline looks as follows:

```yaml
name : CustomerApi-CD
trigger: none
resources:
  containers:
  - container: linuxsqlpackage
    image: wolfgangofner/linuxsqlpackage:1.0
  pipelines:
   - pipeline: CustomerApiBuild
     source: CustomerApi-CI
     trigger:
      branches:
       include:
         - master         
         - pull/*
         - refs/pull/*

pool:
  vmImage: 'ubuntu-latest'

variables:  
  AzureSubscription: 'AzureServiceConnection' # Name of the Service Connection
  ApiName: 'customerapi'
  ArtifactName: 'CustomerApi'      
  ClusterResourceGroup: MicroserviceDemo  
  ChartPackage: '$(Pipeline.Workspace)/CustomerApiBuild/CustomerApi/customerapi-$(RESOURCES.PIPELINE.CustomerApiBuild.RUNNAME).tgz'  
  DatabaseName: Customer
  HelmVersion: 3.5.0    
  KubernetesCluster: 'microservice-aks'
  ReleaseValuesFile: '$(Pipeline.Workspace)/CustomerApiBuild/CustomerApi/values.release.yaml'
  SQLServerName: wolfgangmicroservicedemosql.database.windows.net # replace with your server url  
  IngressEnabled: true
  TlsSecretName: customerapi-tls  

stages:
- stage: Test  
  condition: ne(variables['Build.Reason'], 'PullRequest')
  variables:
    DeploymentEnvironment: 'test'
    K8sNamespace: '$(ApiName)-$(DeploymentEnvironment)'
    ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName)-$(DeploymentEnvironment);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    URL: $(DeploymentEnvironment).customer.programmingwithwolfgang.com # replace with your service url
  jobs:
  - deployment: Web_Test
    displayName: 'Deploy CustomerApi to the customerapi-test environment'
    environment: customerapi-test
    strategy:
      runOnce:
        deploy:
          steps:
          - download: CustomerApiBuild
            artifact: $(ArtifactName)
          - template: templates/DeployHelmPackage.yml
            parameters:
              apiName: $(ApiName)
              azureSubscription: '$(AzureSubscription)'
              clusterResourceGroup: '$(ClusterResourceGroup)'
              chartPackage: '$(ChartPackage)'              
              helmVersion: $(HelmVersion)
              k8sNamespace: $(K8sNamespace)
              kubernetesCluster: $(KubernetesCluster)
              releaseValuesFile: '$(ReleaseValuesFile)' 
 
  - deployment: Database_Test
    dependsOn: Web_Test    
    displayName: 'Deploy the test database'   
    environment: database-test
    container: linuxsqlpackage
    strategy:
      runOnce:
        deploy:
          steps:
          - download: CustomerApiBuild
            artifact: dacpacs
          - template: templates/DatabaseDeploy.yml
            parameters:          
                connectionString: $(ConnectionString)
                dacpacPath: "$(Pipeline.Workspace)/CustomerApiBuild/dacpacs/$(ArtifactName).Database.Build.dacpac"

- stage: Prod
  dependsOn: Test
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
  variables:
    DeploymentEnvironment: 'prod'
    K8sNamespace: '$(ApiName)-$(DeploymentEnvironment)'
    ConnectionString: "Server=tcp:$(SQLServerName),1433;Initial Catalog=$(DatabaseName)-$(DeploymentEnvironment);Persist Security Info=False;User ID=$(DbUser);Password=$(DbPassword);MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    URL: customer.programmingwithwolfgang.com # replace with your service url
  jobs:
  - deployment: Web_Prod
    displayName: 'Deploy CustomerApi to the customerapi-prod environment'
    environment: customerapi-prod
    strategy:
      runOnce:
        deploy:
          steps:
          - download: CustomerApiBuild
            artifact: $(ArtifactName)
          - template: templates/DeployHelmPackage.yml
            parameters:
              apiName: $(ApiName)
              azureSubscription: '$(AzureSubscription)'
              clusterResourceGroup: '$(ClusterResourceGroup)'
              chartPackage: '$(ChartPackage)'              
              helmVersion: $(HelmVersion)
              k8sNamespace: $(K8sNamespace)
              kubernetesCluster: $(KubernetesCluster)
              releaseValuesFile: '$(ReleaseValuesFile)' 
 
  - deployment: Database_Prod
    dependsOn: Web_Prod    
    displayName: 'Deploy the prod database'   
    environment: database-prod
    container: linuxsqlpackage
    strategy:
      runOnce:
        deploy:
          steps:
          - download: CustomerApiBuild
            artifact: dacpacs
          - template: templates/DatabaseDeploy.yml
            parameters:          
                connectionString: $(ConnectionString)
                dacpacPath: "$(Pipeline.Workspace)/CustomerApiBuild/dacpacs/$(ArtifactName).Database.Build.dacpac"
```

## Configure the DNS for the Test Environment

You have to add the new subdomain in your DNS settings before you can use it. To make changes easier for the future, add a wildcard subdomain in your DNS settings. You can see my settings for both my microservices on the following screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Configure-the-DNS-settings-for-the-subdomain.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Configure-the-DNS-settings-for-the-subdomain.jpg" alt="Configure the DNS settings for the subdomain" /></a>
  
  <p>
   Configure the DNS settings for the subdomain
  </p>
</div>

For more information about setting up the DNS configuration, see my post [Configure custom URLs to access Microservices running in Kubernetes](/configure-custom-urls-to-access-microservices-running-in-kubernetes).

## Testing the new Deployment

Run the pipeline and after the Helm upgrade task, you will see the URL of the test environment printed to the output window in Azure DevOps.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Azure-DevOps-prints-the-URL-after-the-deployment.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Azure-DevOps-prints-the-URL-after-the-deployment.jpg" alt="Azure DevOps prints the URL after the deployment" /></a>
  
  <p>
   Azure DevOps prints the URL after the deployment
  </p>
</div>

Click on the URL and you will see that the microservice is running and also using HTTPS with a valid SSL certificate.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-test-environment-is-up-and-running.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-test-environment-is-up-and-running.jpg" alt="The test environment is up and running" /></a>
  
  <p>
   The test environment is up and running
  </p>
</div>

For more information about setting up HTTPS and creating SSL certificates automatically using Let's Encrypt, see [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes).

Azure DevOps gives you a nice overview of the different environments and stages which gives you a nice overview of the status of all the deployments. As you can see, everything finished successfully.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-deployment-was-successful.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-deployment-was-successful.jpg" alt="The deployment was successful" /></a>
  
  <p>
   The deployment was successful
  </p>
</div>

Enter your URL without the subdomain into your browser and you will see that your production microservice is also running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-Microservice-is-running.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-Microservice-is-running.jpg" alt="The Microservice is running" /></a>
  
  <p>
   The Microservice is running
  </p>
</div>

Lastly, connect to your SQL Server and you will see all four databases after the deployment (the OrderApi and CustomerApi have two databases each).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/All-databases-got-deployed.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/All-databases-got-deployed.jpg" alt="All databases got deployed" /></a>
  
  <p>
   All databases got deployed
  </p>
</div>

For more information on how to deploy databases in a CD pipeline, see [Automatically Deploy your Database with Dacpac Packages using Linux and Azure DevOps](/deploy-dacpac-linux-azure-devops).

## Conclusion

Having a CD pipeline in place enables you to easily add new environments to your deployment. A typical CD pipeline consists of test and production deployments but you can easily add QA or other environments.

In my next post, I will show you how to deploy every pull request into a new environment and automatically create a unique URL.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).