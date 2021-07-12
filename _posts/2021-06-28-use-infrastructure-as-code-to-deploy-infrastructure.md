---
title: Use Infrastructure as Code to deploy your Infrastructure with Azure DevOps
date: 2021-06-28
author: Wolfgang Ofner
categories: [Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, IaC]
description: Infrastructure as Code (IaC) enables you to deploy your infrastructure fast and reliable and helps to increase the quality of the deployments.
---

Back in the day developers had to go through a lengthy process to get new hardware deployed. Often it took several weeks and then there was still something missing or the wrong version of the needed software installed. This was one of my biggest pet peeves and it was a major reason why I left my first job.

Fortunately, we have a solution to these pains, Infrastructure as Code. This post will explain what it is and how you can easily set up all the services needed.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is Infrastructure as Code (IaC)?

As the name already suggests, Infrastructure as Code means that your infrastructure and its dependencies are defined in a file. Nowadays the configuration is often saved in a JSON or YAML file. IaC has many advantages over the old-school approach of an operation person creating the infrastructure:

- The definition can be reviewed and saved in version control
- Infrastructure can be deployed fast and reliable
- Deployments can be repeated as often as needed
- No (less) communication problems due to developers writing the configuration themselves
- Many tools available

If you are working with Azure, you might be familiar with ARM templates. There are also many popular tools out there like Puppet, Terraform, Ansible or Chef. My preferred way is Azure CLI. In the following sections, I will show you how to create an Azure DevOps YAML pipeline using Azure CLI and Helm to create an Azure Kubernetes Cluster with all its configurations like Nginx as Ingress Controller, Azure SQL Database, Azure Function, and Azure Service Bus.

## Azure CLI Documentation

I like using Azure CLI because it is easy to use locally and it is also quite intuitive. All commmands follow the same patter of az service command, for example, az aks create or az sql server update. This makes is very easy to google how to create or update services. Additionally, the documentation is very good. You can find all commands <a href="https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest" target="_blank" rel="noopener noreferrer">here</a>. 

## Create your first Infrastructure as Code Pipeline in Azure DevOps

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

Create a new pipeline and define the following variables:

```yaml
variables:  
  AksClusterName: microservice-aks
  AzureSubscription: AzureServiceConnection # replace with your subscription connection name
  AzureConnectionType: Azure Resource Manager 
  CertIssuerEmail: <your email>  # replace with your email
  CertManagerNamespace: cert-manager  
  FunctionName: OrderApiMessagingReceive # replace with unique name
  FunctionOs: Linux
  FunctionPlanName: MicroservicedemoFunctionPlan
  FunctionSku: B1  
  FunctionVersion: 3    
  HelmVersion: '3.5.0'
  Kubernetesversion: '1.19.9'
  KubectlVersion: '1.19.9'
  NetworkPlugin: kubenet
  NodeCount: 1  
  NginxNamespace: ingress-basic
  ResourceGroupLocation: westeurope
  ResourceGroupName: MicroserviceDemo  
  ServiceBusNamespaceName: microservicedemo # replace with unique name
  ServiceBusNamespaceSku: Basic
  ServiceBusQueueName: CustomerQueue
  ServiceBusQueueSasListenName: ReceiveKey
  ServiceBusQueueSasSendName: SendKey  
  SqlServerName: wolfgangmicroservicedemosql # replace with unique name
  StorageAccountName: orderreceivestorage # replace with unique name
```

The variables should be self-explanatory when you look at their usage later on. Also if you followed this series, you should have seen all names and services before already. You need an existing Azure Service Connection configured in Azure DevOps. If you don't have one yet, I explain in [Deploy to Azure Kubernetes Service using Azure DevOps YAML Pipelines](/deploy-kubernetes-azure-devops/#create-a-service-connection-in-azure-devops) how to create one.

Next, install Helm to use it later and create a resource group using the Azure CLI. This resource group will host all new services. 

```yaml
steps:
  - task: HelmInstaller@0
    displayName: Install Helm
    inputs:
      helmVersion: '$(HelmVersion)'
      checkLatestHelmVersion: false
      installKubectl: true
      kubectlVersion: '$(KubectlVersion)'
      checkLatestKubectl: false

  - task: AzureCLI@2
    displayName: "Create resource group"
    inputs:
      azureSubscription: '$(AzureSubscription)'
      scriptType: 'pscore'
      scriptLocation: 'inlineScript'
      inlineScript: |                
        az group create -g "$(ResourceGroupName)" -l "$(ResourceGroupLocation)"
```

If you are unfamiliar with Helm, see [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm) for more information.

### Create an Azure Kubernetes Cluster

Creating an AKS cluster is quite simple due to the names of the parameters. For example, you can configure the VM size, what Kubernetes version you want to install or the node count of your cluster. The full command looks as follows:

```yaml
- task: AzureCLI@2
  displayName: "Create AKS cluster"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |        
      az aks create `
          --resource-group "$(ResourceGroupName)" `
          --location "$(ResourceGroupLocation)"  `
          --name "$(AksClusterName)" `
          --network-plugin $(NetworkPlugin) `
          --kubernetes-version $(KubernetesVersion) `
          --node-vm-size Standard_B2s `
          --node-osdisk-size 0 `
          --node-count $(NodeCount)`
          --load-balancer-sku standard `
          --max-pods 110 `
          --dns-name-prefix microservice-aks-dns `
          --generate-ssh-keys
```

#### Install the Cert-Manager Addon

The Cert-Manager adds SSL certificates to your services running inside AKS to allow the usage of HTTPS. If you read [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes), then you will be familiar with the following code since it is identical.

```yaml
- task: HelmDeploy@0
  displayName: "Install cert manager"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'add jetstack https://charts.jetstack.io'

- task: HelmDeploy@0
  displayName: "Install cert manager"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'update'

- task: HelmDeploy@0
  displayName: "Install cert manager"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    namespace: '$(CertManagerNamespace)'
    command: 'upgrade'
    chartType: 'Name'
    chartName: 'jetstack/cert-manager'      
    releaseName: 'cert-manager'
    overrideValues: 'installCRDs=true,inodeSelector.kubernetes\.io/os=linux,webhook.nodeSelector.kubernetes\.io/os"=linux,cainjector.nodeSelector."kubernetes\.io/os"=linux'
    arguments: '--create-namespace'
```

#### Add the Certifcate Cluster Issuer

The SSL certificates need to be issued using the Cluster Issuer object. I am using the same YAML file as in [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes) except that this time it is applied as inline code and with the variable for the email address.

```yaml
- task: Kubernetes@1
  inputs:
    connectionType: 'Azure Resource Manager'
    azureSubscriptionEndpoint: 'AzureServiceConnection'
    azureResourceGroup: 'MicroserviceDemo'
    kubernetesCluster: 'microservice-aks'
    useClusterAdmin: true
    command: 'apply'
    useConfigurationFile: true
    configurationType: 'inline'
    inline: |
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt
      spec:
        acme:
          server: https://acme-v02.api.letsencrypt.org/directory
          email: $(CertIssuerEmail)
          privateKeySecretRef:
            name: letsencrypt
          solvers:
          - http01:
              ingress:
                class: nginx
                podTemplate:
                  spec:
                    nodeSelector:
                      "kubernetes.io/os": linux
    secretType: 'dockerRegistry'
    containerRegistryType: 'Azure Container Registry'
  displayName: 'Install Cluster Issuer'
```

#### Install Nginx and configure it as Ingress Controller

In [Set up Nginx as Ingress Controller in Kubernetes](/setup-nginx-ingress-controller-kubernetes), I added Nginx and configured it as Ingress Controller of my AKS cluster. To install Nginx in the IaC pipeline, add its Helm repository, update it and then install it with the following commands using Azure CLI:

```yaml
- task: HelmDeploy@0
  displayName: "Install ingress-nginx (Helm repo add)"    
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'add ingress-nginx https://kubernetes.github.io/ingress-nginx'

- task: HelmDeploy@0
  displayName: "Install ingress-nginx (Helm repo update)"    
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'update'

- task: HelmDeploy@0
  displayName: "Install ingress-nginx"    
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'upgrade'
    chartType: 'Name'
    chartName: 'ingress-nginx/ingress-nginx'      
    releaseName: 'ingress-nginx'
    overrideValues: 'controller.replicaCount=2,controller.nodeSelector."beta\.kubernetes\.io/os"=linux,defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux,controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux'
    namespace: $(NginxNamespace)
    arguments: '--create-namespace'
```

### Create a new Azure SQL Server

After the deployment of the AKS cluster is finished, let's add a new Azure SQL Server witht he following command:

```yaml
- task: AzureCLI@2
  displayName: "Create SQL Server"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az sql server create `
      --location $(ResourceGroupLocation) `
      --resource-group $(ResourceGroupName) `
      --name $(SqlServerName) `
      --admin-user $(SqlServerAdminUser) `
      --admin-password "$(SqlServerAdminPassword)"
```

You might miss the variables SqlServerAdminUser and SqlServerAdminPassword. Since these values are confidential, add them as secret variables to your Azure DevOps pipeline by clicking on Variables on the top-right corner of your pipeline window. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Add-the-database-variables-as-secret-variables.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Add-the-database-variables-as-secret-variables.jpg" alt="Add the database variables as secret variables" /></a>
  
  <p>
   Add the database variables as secret variables
  </p>
</div>

By default, the Azure SQL Server does not allow any connections. Therefore you have to add firewall rules to allow the access to the SQL Service. The following code enables Azure resources like Azure DevOps to access the SQL Server. 

```yaml
- task: AzureCLI@2
  displayName: "Create SQL Server Firewall rule"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |     
      az sql server firewall-rule create `
      --resource-group $(ResourceGroupName) `
      --server $(SqlServerName) `
      --name AllowAzureServices `
      --start-ip-address 0.0.0.0 `
      --end-ip-address 0.0.0.0
```

Feel free to add as many firewall rules as you need. All you have to do is to edit the start and end ip address parameters.

### Deploy an Azure Service Bus Queue

To create an Azure Service Bus Queue, you also have to create an Azure Service Bus Namespace first. I talked about these details in [Replace RabbitMQ with Azure Service Bus Queues](/replace-rabbitmq-azure-service-bus-queue).

```yaml
- task: AzureCLI@2
  displayName: "Create Azure Service Bus Namespace"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az servicebus namespace create `
      --name $(ServiceBusNamespaceName) `
      --sku $(ServiceBusNamespaceSku) `
      --resource-group $(ResourceGroupName) `
      --location $(ResourceGroupLocation)

- task: AzureCLI@2
  displayName: "Create Azure Service Bus Queue"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az servicebus queue create `
      --name $(ServiceBusQueueName) `
      --namespace-name $(ServiceBusNamespaceName) `
      --resource-group $(ResourceGroupName)
```

To allow applications to read or write to the queue, you have to create shared access signatures (SAS). The following commands create both a SAS for listening and sending messages.

```yaml
- task: AzureCLI@2
  displayName: "Create Azure Service Bus Queue Send SAS"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az servicebus queue authorization-rule create `
      --name $(ServiceBusQueueSasSendName) `
      --namespace-name $(ServiceBusNamespaceName) `
      --queue-name $(ServiceBusQueueName) `
      --resource-group $(ResourceGroupName) `
      --rights Send

- task: AzureCLI@2
  displayName: "Create Azure Service Bus Queue Listen SAS"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az servicebus queue authorization-rule create `
      --name $(ServiceBusQueueSasListenName) `
      --namespace-name $(ServiceBusNamespaceName) `
      --queue-name $(ServiceBusQueueName) `
      --resource-group $(ResourceGroupName) `
      --rights Listen
```

### Create an Azure Function

The last service I have been using in my microservice series (["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero)) is an Azure Function. Before you can create an Azure Function using Azure CLI, you have to create a Storage Account and an App Service Plan.

```yaml
- task: AzureCLI@2
  displayName: "Create Azure Storage Account"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az storage account create `
      --name $(StorageAccountName) `
      --resource-group $(ResourceGroupName)

- task: AzureCLI@2
  displayName: "Create Azure App Service Plan"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az functionapp plan create `
      --name $(FunctionPlanName) `
      --resource-group $(ResourceGroupName) `
      --sku $(FunctionSku) `
      --is-linux true
```

With the Azure Storage Account and App Service Plan set up, create the Azure Function.

```yaml
- task: AzureCLI@2
  displayName: "Create Azure Function"
  inputs:
    azureSubscription: '$(AzureSubscription)'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az functionapp create `
      --resource-group $(ResourceGroupName) `
      --plan $(FunctionPlanName) `
      --name $(FunctionName) `
      --storage-account $(StorageAccountName) `
      --functions-version $(FunctionVersion) `
      --os-type $(FunctionOs) `
      --runtime dotnet `
      --disable-app-insights true
```

## Create all your Infrastrucute using the IaC Pipeline

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

Infrastructure as Code (IaC) solves many problems with deployments and enables development teams to quickly and reliably deploy the infrastructure. You can choose between many tools like Ansible, Terraform or Chef. Alternatively, you can keep it simple like I did in the demo and use Azure CLI. The advantage of the Azure CLI is that you can easily use it locally for testing. 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).