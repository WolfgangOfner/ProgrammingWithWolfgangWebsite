---
title: How to Connect to a Private AKS Cluster - The Easy Way
date: 2025-08-11
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Security, Azure Bastion]
description: Access your private AKS cluster easily and securely through Azure Bastion.
---

In a world where security is paramount, running a private Azure Kubernetes Service (AKS) cluster is a crucial step to protect your workloads. A private cluster removes the public endpoint for the Kubernetes API, significantly reducing its attack surface. However, this raises a new challenge: how do you, as a developer or administrator, securely access and manage the cluster?

This post, based on a recent video demonstration, outlines a straightforward and cost-effective solution: using Azure Bastion as a secure jump host to tunnel into your private AKS cluster.

## The Problem with Public Clusters

By default, an AKS cluster's API server is accessible over the public internet. While you can secure it with firewalls and IP restrictions, this still leaves a publicly available endpoint that could be a target for attackers. The best practice is to make the API server private.

The Solution: Azure Bastion as a Secure Jump Host
Azure Bastion is a fully managed PaaS (Platform as a Service) that provides secure and seamless RDP/SSH connectivity to your virtual machines directly from the Azure portal over SSL. When combined with virtual network (VNET) peering, it can be used as a secure, browser-based jump host to access your private AKS cluster. This approach is more secure, simpler, and more cost-effective than managing your own jump box VM.

## Step-by-Step Guide: Implementing the Solution
1. **Create a Private AKS Cluster**
The first step is to create a private AKS cluster using the Azure CLI. The key parameter here is `--enable-private-cluster`, which ensures the Kubernetes API server is not assigned a public IP address.

<script src="https://gist.github.com/WolfgangOfner/b84562de666350300abc188b7c362333.js"></script>

2. **Deploy Azure Bastion**
Next, set up the Azure Bastion service in a separate VNET. This VNET will act as the secure gateway to your private network.

- **Create a Public IP:** Bastion requires a public IP address for secure, inbound management traffic.
- **Create a VNET and Subnet:** Create a new virtual network and a dedicated subnet within it named `AzureBastionSubnet`. This is a required naming convention for the service.
- **Deploy Azure Bastion:** Deploy the Bastion instance, ensuring you enable the `tunneling` feature to support native client connections (like `kubectl`).

3. **Configure VNET Peering**
This is the crucial step that connects your Bastion and AKS networks.

- **Create VNET Peering:** Establish a VNET peering connection between the VNET where your Bastion is deployed and the VNET where your private AKS cluster resides. This allows resources in both networks to communicate with each other over the private Azure network.
- **Configure DNS:** Ensure that DNS resolution is correctly configured so that Bastion can resolve the private IP address of the AKS API server.

## Benefits of This Approach

- **Enhanced Security:** The cluster's API is completely hidden from the public internet, significantly reducing its attack surface.
- **Simplified Access:** You eliminate the need to manage a separate jump box VM, simplifying your operational overhead and reducing costs.
- **Seamless Developer Experience:** After the initial setup, developers can connect to the cluster and run `kubectl` commands as if it were a public cluster, with the secure tunneling handled transparently by Azure Bastion.
- **Cost-Effectiveness:** A single Bastion instance can be used to access multiple private clusters, allowing you to centralize your access management and share the cost.

## Conclusion

Transitioning to a private AKS cluster is a crucial step for securing your cloud-native environment. By leveraging Azure Bastion as a secure jump host and utilizing VNET peering, you effectively hide your cluster's API from the public internet without sacrificing usability. This method not only enhances security by eliminating a public endpoint but also simplifies the developer experience and proves to be a more cost-effective and efficient solution than managing traditional jump box VMs. Ultimately, this approach provides a robust and scalable way to protect your workloads while maintaining seamless access for your team.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/How%20to%20Connect%20to%20a%20Private%20AKS%20Cluster%20-%20The%20Easy%20Way" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Video - How to Connect to a Private AKS Cluster - The Easy Way" and reviewed by me.

## Video - How to Connect to a Private AKS Cluster - The Easy Way

<iframe width="560" height="315" src="https://www.youtube.com/embed/GgbjdVsvoYw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>