---
title: AKS Internal Load Balancers - Setup and Access Walkthrough
date: 2025-05-19
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Private Endpoint, Load Balancer]
description: Learn to set up AKS internal load balancers for private, secure access to your Kubernetes services. Enhance security and network efficiency.
---

This post provides a detailed guide on setting up and accessing Azure Kubernetes Service (AKS) internal load balancers. Internal load balancers are crucial for keeping your AKS resources private and enhancing overall security.

## Understanding Kubernetes Service Types

Before diving into internal load balancers, let's briefly recap the different Kubernetes service types:

- **Load Balancer**: This type provides external access to your AKS cluster, typically using a public IP address.
- **Cluster IP**: This offers internal access to services, but only from within the cluster itself.
- **NodePort and ExternalName**: While other service types exist, they are not the focus of this discussion.

## The Power of Internal Load Balancers

The primary focus here is the internal load balancer. It enables private connections to your AKS services from resources outside the cluster, such as virtual machines (VMs). This is essential for scenarios where you need secure and private communication between your AKS services and other components within your Azure environment.

## Accessing Internal Load Balancers

There are two main scenarios for accessing services exposed through an internal load balancer:

- **Access within the Same VNET**: If your VM resides in the same virtual network (VNET) as your AKS cluster, you can establish a private connection through a private link service. This service connects your AKS service to the VNET, allowing seamless private communication.
- **Access from a Different VNET**: When your VM is located in a separate VNET, you have a couple of options:
  - **VNET Peering**: While possible, this approach is less emphasized.
  - **Private Endpoint**: The recommended method involves creating a private endpoint. This endpoint is attached to the separate VNET, allowing the VM within that VNET to communicate with the AKS service over a private IP address.

## Practical Implementation

Setting up internal load balancers involves a few key steps using the Azure CLI and YAML files:

1. **AKS Cluster Setup**: You will need an AKS cluster.
2. **Service Deployment**: Deploy your application (e.g., Nginx) as a service. To make it an internal load balancer, use the annotation azure-load-balancer-internal: "true" in your service's YAML file.
3. **Static IP Configuration (Optional)**: You can assign a specific private IP address to your internal load balancer using the annotation service.beta.kubernetes.io/azure-load-balancer-ipv4.

## Testing the Access

- **Same VNET**: Create a VM within the same VNET as your AKS cluster. You should be able to access the service using curl or similar tools, confirming the private connection.
- Different VNET with Private Endpoint:
1. Create a new VNET and subnet.
2. Deploy a VM into this new VNET.
3. Apply a service file with the annotation service.beta.kubernetes.io/azure-pls-create: "true" to enable the private link service.
4. Create a private endpoint, attaching it to the newly created VNET and linking it to the AKS private link service.
5. Use the private endpoint's IP address (which will be in the new VNET's IP range) to access the AKS service from the second VM.

## Conclusion

Internal load balancers and private endpoints are powerful tools for securing and optimizing access to your AKS services. They provide increased security through private connections and can potentially improve performance. By following these steps, you can effectively implement and manage internal load balancers in your AKS environment.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Internal%20Load%20Balancers%20-%20Setup%20and%20Access%20Walkthrough" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Internal Load Balancers - Setup and Access Walkthrough" and reviewed by me.

## Video - AKS Internal Load Balancers - Setup and Access Walkthrough

<iframe width="560" height="315" src="https://www.youtube.com/embed/kuXd9yBakt8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>