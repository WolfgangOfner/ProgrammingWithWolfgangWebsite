---
title: Secure your AKS Deployments with a private Azure Container Registry
date: 2025-03-17
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [AKS, Kubernetes, Security, Azure Container Registry, ACR, Private Endpoint]
description: Learn to secure AKS deployments by configuring Azure Container Registry for private connections, ensuring protection from external threats.
---

This post explains how to deploy images from a private container registry into a Kubernetes cluster, focusing on enhancing security by preventing internet exposure of resources.

## The Importance of Private Container Registries

Using public container registries introduces security risks. Even when your Azure Kubernetes Service (AKS) cluster is in the same Azure location as the public registry, images are still pulled over the internet, potentially exposing your cluster to attacks. A private Azure Container Registry (ACR) mitigates these risks by restricting access to within a virtual network (VNet). This means connections are only possible from within the same VNet or a peered VNet.

## Setting up a Private Azure Container Registry (ACR)

1. **Create a Private Endpoint:** A private endpoint for ACR is created and attached to a VNet, which also generates a private DNS Zone. This allows images to be pulled over a private connection, eliminating the need for internet access by the Kubernetes cluster.
2. **Use the Premium Tier:** It's essential to use the premium tier of ACR to disable public network access.

## Configuration Options for Private Endpoints

There are two main configuration options:

- **Same VNet as AKS Cluster:** The private endpoint is attached directly to the AKS VNet. The private DNS automatically resolves the public ACR URL to a private IP address.
- **Different VNet:** A private endpoint is created in a new VNet, and VNet peering is configured between this new VNet and the AKS VNet. Additionally, the AKS VNet must be added to the private DNS Zone to resolve requests privately.

## Practical Implementation

1. **Set up AKS Cluster:** Create an AKS cluster with private cluster features enabled.
2. **Create Private ACR:** Create an Azure Container Registry using the premium tier and import your images.
3. **Disable Public Access:** Disable public network access for the ACR.
4. **Create Repository Token:** Create a repository token with pull permissions for authentication.
5. **Configure Private Endpoint:** Configure a private endpoint for the ACR, linking it to the AKS VNet. This automatically sets up the private DNS Zone.
6. **Deploy Images:** After a short waiting period for DNS propagation, your deployments should successfully pull images over the private connection.

## Conclusion

This setup ensures that all resources remain within a VNet, inaccessible from the internet, significantly enhancing security. However, it's important to note that deployment pipelines, especially those using Microsoft-hosted agents, will require an agent running within the same VNet to access the container registry.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Secure%20your%20AKS%20Deployments%20with%20a%20private%20Azure%20Container%20Registry" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Secure your AKS Deployments with a private Azure Container Registry" and reviewed by me.

## Video - Secure your AKS Deployments with a private Azure Container Registry

<iframe width="560" height="315" src="https://www.youtube.com/embed/6ECPV2Imtac" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Managed by Microsoft
Ubuntu, Windows and MacOS agents
Ease of use
Pre-installed software
Cost-effective
