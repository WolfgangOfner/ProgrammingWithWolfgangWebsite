---
title: Azure Arc - Getting Started
date: 2021-12-13
author: Wolfgang Ofner
categories: [Cloud]
tags: [Azure, Azure Arc, GitOps, SQL, Kubernetes, Postgre SQL]
description: Azure Arc is a bridge to the cloud to project your on-premise, or in another cloud, resources into Azure and allows you to use Azure features for these resources.
---

Today, many companies use cloud services but there is also still a big group of companies that can't use cloud services for various reasons. Modern software becomes more and more complex and therefore managing your applications in your own data center becomes quite daunting. This is where Azure Arc comes into play to help you to administer your on-premise, or multi-cloud applications and also helps you to govern your data.

Over the next couple of posts, I will dive into Azure Arc and show you how it can enable you to modernize and manage your on-premise applications and databases. Today, I would like to give you an overview of the features, pricing, and capabilities of Azure Arc.

## What is Azure Arc

Azure Arc helps you to govern and manage your on-premise and multi-cloud applications. It offers the following features to do so:

- Use Azure services and management features like Azure policies for your resources, no matter where they are deployed.
- Manage any CNCF certified Kubernetes cluster, virtual machines, and databases as if they were running in Azure.
- Manage your application by projecting them into the Azure Resource Manager.
- Introduce DevOps practices to modernize your existing applications.

The following resources are supported by Azure Arc:

- Any CNCF certified Kubernetes cluster
- Physical or virtual machines running either Windows or Linux
- SQL Server running 2012 R2 or higher
- Azure data services like Azure SQL Managed Instance and PostgreSQL Hyperscale services

Azure Arc is a bridge to the cloud to project your on-premise (or in another cloud) resources into Azure. Having all your resources, whether on-premise or in another cloud, projected into Azure allows you to gain central visibility of all your resources and also helps with regulatory compliance and data sovereignty since your data can stay in your data center while being managed via Azure.

The offered features are mostly used in hybrid scenarios. You can have your SQL server on-prem and use Azure Arc for additional security like providing security best practices using Azure Sentinel and Azure Defender. Additionally, Azure Advisor can give you recommendations for more best practices. Being able to run Azure services everywhere will enable you to modernize your applications and data center while keeping full control over your data.

No other cloud provider has an offering like Azure Arc and therefore it shouldn't be surprising that Microsoft puts a heavy focus on extending its capabilities.

This is a very high-level overview of the features provided by Azure Arc. Let's take a more detailed look into each offering in the next sections.

## Azure Arc Services

Currently, Azure Arc supports the following resources:

- Server
- Kubernetes Cluster
- Databases
- Data Services

### Azure Arc-enabled Servers

Azure Arc for physical or virtual servers allows you to manage or monitor these servers using Azure Monitor, Azure Policy, or Azure Automation. Additionally, it gives you security features with Azure Sentinel and Defender for Cloud. To enable Azure Arc for your servers, you have to install an agent. This agent sends regular heartbeat messages to Azure Arc to make sure that it is still connected. It does not matter where your servers reside. This can be on-premise, with another cloud provider, or something mixed.

Having your server project to Azure allows you to use analytics or logging features of Azure like Azure Insights or the Dependency Map. Besides the logging capabilities, Azure Arc provides the possibility for a unified management experience as you can schedule updates on your server or track changes of software or licenses. All this can be done in one place.

For more details see <a href="https://docs.microsoft.com/en-us/azure/azure-arc/servers/overview" target="_blank" rel="noopener noreferrer">About Azure Arc-enabled servers</a>.

### Azure Arc-enabled Kubernetes

Azure Arc for Kubernetes installed its agent in the azure-arc namespace in your Kubernetes cluster. Installing the agent will place your K8s cluster in a resource group and also allow you to add tags to it. The agent can be installed on any CNCF certified Kubernetes cluster. In a later post, I will show you how to connect an on-premise k3s cluster to Azure Arc.

Connecting your K8s cluster to Azure Arc allows you to manage your cluster in the Azure portal. There, you have an overview of all namespaces, workloads, and services (it is the same view as if you were using an AKS cluster). You can also use Application Insights, create alerts, or monitor your containers with Container Insights. 

Another neat feature is the GitOps operator. This operator can be installed in your Kubernetes cluster and then will manage your deployments automatically for you. This will enable you to provide continuous deployment even if your cluster is behind a firewall and not accessible from the internet. The Gitops operator can use YAML files of Helm charts and polls every 5 minutes (configurable) for changes in your repository. 

For more details see <a href="https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/overview" target="_blank" rel="noopener noreferrer">About Azure Arc-enabled Kubernetes</a>.

### SQL Server on Azure Arc-enabled Servers

The Azure Arc agent can be installed on SQL Server that runs on a physical or virtual machine running Windows or Linux. As the other Arc offers, Azure Arc for SQL enables you to use advanced logging and security features of Azure like Log Analytics or Azure Security Center and Azure Sentinel.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/azure-arc-sql-architecture.png"><img loading="lazy" src="/assets/img/posts/2021/12/azure-arc-sql-architecture.png" alt="Azure-Arc-SQL-Architecture" /></a>
  
  <p>
   Azure Arc SQL Architecture
  </p>
</div>

For more details see <a href="https://docs.microsoft.com/en-us/sql/sql-server/azure-arc/overview" target="_blank" rel="noopener noreferrer">SQL Server on Azure Arc-enabled servers</a>.

### Azure Arc-enabled Data Services

I have never used Azure Arc-enabled data services so I can't tell you too much about it. According to the documentation, it helps you to manage your SQL managed instances and PostgreSQL Hyperscale services by providing policies and regular updates using the Microsoft Container Registry. Additionally, you can use cloud-like elasticity on your on-premise databases and scale them dynamically, as if they were running in the cloud. 

Azure Arc provides a unified management experience and speeds up the deployment which can be done in seconds using either the Azure portal or the Azure CLI.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/azure-arc-kubernetes-overview.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/azure-arc-kubernetes-overview.jpg" alt="Azure Arc Kubernetes Overview" /></a>
  
  <p>
   Azure Arc Kubernetes Overview
  </p>
</div>

For more details see <a href="https://docs.microsoft.com/en-us/azure/azure-arc/data/overview" target="_blank" rel="noopener noreferrer">What are Azure Arc-enabled data services</a>.

## Pricing

Every Azure Arc service has a different pricing schema. The control plane is free for the server and Kubernetes offering and then you pay for each additional server or on a per CPU basis. Azure Arc-enabled SQL managed instance is billed on a per CPU base whereas you can get discounts if you can use Azure Hybrid Benefit.

The Kubernetes pricing is not bad at all as you get the first 6 CPUs for free and pay $2 per month for each additional CPU. The pricing is worth it as I use it to have a unified management view of the cluster and I also use the GitOps operator to integrate continuous deployment although the cluster is not accessible from the internet or my Azure DevOps Server.

For more details see <a href="https://azure.microsoft.com/en-us/pricing/details/azure-arc/#pricing" target="_blank" rel="noopener noreferrer">Azure Arc pricing</a>.

Additional features of Azure like Azure Monitor or Log Analytics have the same costs as if you used them without Azure Arc.

## Getting Started

Microsoft offers the <a href="https://azurearcjumpstart.io/" target="_blank" rel="noopener noreferrer">Azure Arc Jumpstart</a> and the <a href="https://azure.microsoft.com/en-us/migration/migration-modernization-program/#overview" target="_blank" rel="noopener noreferrer">Azure Migration and Modernization Program</a> to help you get started with Azure Arc.

Both platforms should give you an overview of the services and some samples the get started. The Azure Arc Jumpstart is more developer-focused whereas the Azure Migration and Modernization Program is more business-oriented. Nevertheless, I would recommend you to take a look at both websites. 

## Conclusion

Azure Arc is a great offering that allows you to bring Azure services to your on-premise solutions. This allows you to modernize your applications without changing your operations processes. Additionally, you have a central management platform for your services, no matter where they reside. All these features, compared with the relatively low costs (the SQL offering seems a bit expensive to me) will help you to streamline your operations processes and modernize your data center.

In my next post, I will show you how to install a k3s cluster on-premise and then use Azure Arc to manage it via Azure. 

No other cloud provider offers a feature like Azure Arc. 