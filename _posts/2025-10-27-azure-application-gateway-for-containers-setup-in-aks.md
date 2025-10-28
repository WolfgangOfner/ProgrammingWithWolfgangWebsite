---
title: Azure Application Gateway for Containers Setup in AKS - Part 2
date: 2025-10-27
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers]
description: Step-by-step guide to setting up Azure Application Gateway for Containers (AGFC) on AKS. Learn to integrate the Gateway API with Azure resources.
---

Setting up an advanced traffic management layer on Kubernetes can be complex, involving the coordination of resources both inside and outside the cluster. Part 2 of this series dives into the crucial foundation: deploying the Azure Application Gateway for Containers (AGFC).

This video provides a complete, step-by-step walkthrough, designed to make the process clear despite the inherent complexity of integrating the Kubernetes Gateway API with Azure's managed services.

## Understanding the Architecture

The setup involves four key components that work together to expose your applications:

- **AKS Cluster:** The host for your applications and the ALB Controller.
- **ALB Controller (Inside AKS):** This component acts as the bridge. It is installed inside the AKS cluster and, using a Managed Identity, contacts the Azure Resource Manager (ARM) to provision the necessary external Azure resources.
- **Application Gateway for Containers (AGFC) (In Azure):** The external, managed Azure resource that handles intensive tasks like load balancing and TLS termination, offloading work from your AKS nodes.
- **Gateway Kubernetes Resource (Inside AKS):** The internal entry point that references the external AGFC, giving it the hostname and listener configuration for incoming traffic.

This separation of concerns—processing traffic outside the cluster while controlling configuration inside the cluster—is the key benefit of using AGFC.

## Prerequisites and Azure Setup

The initial setup requires meticulous configuration within Azure, ensuring the Kubernetes resources have the necessary permissions:

- **Provider Registration:** Key Azure resource providers (like Microsoft.ContainerService and Microsoft.Network) must be registered in your subscription.
- **AKS Cluster Creation:** The cluster must be created with the Azure CNI network plugin and have OIDC Issuer and Workload Identity enabled. These features are essential for securely linking Kubernetes Service Accounts to Azure Managed Identities without using static secrets.
- **Managed Identity & Role Assignment:** A dedicated Managed Identity (e.g., Azure-ALB-Identity) is created and granted the necessary permissions (such as Application Gateway for Containers Configuration Manager) to allow the ALB Controller to deploy and manage the AGFC resource on your behalf.

## Deploying the ALB Controller and AGFC

Once the groundwork is laid, the deployment is managed through Helm and kubectl:

- **ALB Controller Deployment:** The Application Load Balancer (ALB) Controller is installed via a Helm chart, configured with the ID of the Managed Identity. This connects the Kubernetes Service Account to the Azure permissions.
- **VNET and Subnet Configuration:** A dedicated subnet is created and delegated specifically for the AGFC. This "association" link is a billed component in Azure that connects the AGFC network to your AKS VNET, allowing traffic to flow back into your services.
- **Creating the Gateway:** The final step involves creating a Gateway Kubernetes resource, which references the Azure-provided GatewayClass (e.g., azure-alb-external). This resource receives a public hostname that serves as the single point of entry to your cluster.

The end result is a fully provisioned AGFC instance in Azure and a functional Kubernetes Gateway resource inside your cluster, ready to accept routing configurations.

## Conclusion

Successfully deploying the Azure Application Gateway for Containers lays the essential infrastructure foundation for the rest of the series. While integrating Kubernetes, the Gateway API, and Azure components can be complex, establishing this robust traffic layer is the only way to unlock advanced capabilities like automated TLS, CI/CD integration, and Web Application Firewall (WAF) support demonstrated in later videos. This setup ensures that your AKS cluster is optimized for resilience and security.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Azure%20Application%20Gateway%20for%20Containers%20Setup%20in%20AKS%20-%20Part%202" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Azure Application Gateway for Containers Setup in AKS - Part 2" and reviewed by me.

## Video - Azure Application Gateway for Containers Setup in AKS - Part 2

<iframe width="560" height="315" src="https://www.youtube.com/embed/O6k-L6oBCMc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>