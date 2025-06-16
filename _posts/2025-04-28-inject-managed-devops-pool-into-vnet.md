---
title: Inject your Managed DevOps Pool into a VNet
date: 2025-04-28
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, VNet, Private Endpoint, Pirvate DNS-Zone]
description: Inject your Managed DevOps Pool agent to access private Azure resources, such as an Azure Key Vault with Private Endpoint
---

This post explains how to securely access Azure resources by integrating your Azure DevOps pools with a private Azure VNet. This approach eliminates public access to resources like Azure Key Vault, enhancing security and allowing for secure deployments.

## The Problem: Publicly Accessible Resources

Traditionally, accessing private resources like databases or key vaults from Azure DevOps pipelines often involved exposing those resources to the internet. This creates a potential security risk.

## The Solution: VNet Integration

By integrating your managed DevOps pool into a VNet, you establish a private network connection, removing the need for public access. This video demonstrates how to set up this private network and connect it to a managed DevOps pool.

## Setting Up a Secure Environment

The process involves these key steps:

1. Network Configuration: VNet and Subnets: You'll set up the virtual network infrastructure, creating a VNet, an initial subnet, and a dedicated subnet for the managed DevOps pools. This dedicated subnet is crucial for security.
2. Granting Access to DevOps Infrastructure: The DevOps infrastructure provider needs specific access to the subnet to create and manage DevOps pools. You'll grant the necessary roles (Reader and Network Contributor) to the VNet.
3. Azure Key Vault Setup and Private Access: An Azure Key Vault is created to store sensitive information. Crucially, public network access to the Key Vault is disabled, and a private endpoint is created within the VNet.
4. Private Endpoint and DNS Configuration for Key Vault: A private DNS zone is established to handle name resolution for the Key Vault within the VNet. This ensures that resources within the VNet can communicate with the Key Vault using private IP addresses.
5. Deploying Managed DevOps Pool: The managed DevOps pool is deployed and linked to the dedicated subnet within the VNet. This ensures that agents provisioned by the pool reside within the private network.
6. Testing the Private Connection with a Pipeline: Finally, a pipeline is executed to verify that the managed DevOps pool can securely access the Key Vault over the private connection.

Detailed Steps:

1. Network Configuration: VNet and Subnets
  - Create a Resource Group for all resources.
  - Create a VNet and an initial subnet with specified IP addresses.
  - Create a dedicated subnet specifically for managed DevOps pools. This subnet is delegated for exclusive use by managed DevOps pools.
2. Granting Access to DevOps Infrastructure
  - Retrieve the service principal ID for the Azure DevOps infrastructure provider.
  - Assign the "Reader" and "Network Contributor" roles to the VNet for this service principal.
3. Azure Key Vault Setup and Private Access
  - Create an Azure Key Vault within the resource group, configured for Azure RBAC authorization.
  - Disable public network access to the Key Vault.
  - Set "allow trusted Microsoft services to bypass this firewall" to "none."
  - Grant the Azure DevOps service connection the "Key Vault Secrets Officer" role.
4. Private Endpoint and DNS Configuration for Key Vault
  - Create a private DNS zone for name resolution within the VNet.
  - Link the VNet to the private DNS zone.
  - Create a private endpoint connected to the Key Vault within the specified subnet.
  - Add the private endpoint to a DNS zone group within the private DNS zone.
5. Deploying Managed DevOps Pool
  - Create a Dev Center to manage the infrastructure for the DevOps pools.
  - Create a project within the Dev Center.
  - Create the managed DevOps pool, linking it to the Dev Center project.
  - Configure the pool's network profile to use the dedicated subnet.
  - The video references three configuration files: Agent Profile, Organization Profile, and Fabric Profile.
6. Testing the Private Connection with a Pipeline
  - Create a pipeline with variables for the Azure service connection and Key Vault name.
  - The pipeline performs these steps:
  - Creates a secret in the Key Vault.
  - Reads all secrets from the Key Vault.
  - Writes the secret's value to a text file.
  - Publishes the text file as a pipeline artifact.
  - Download and open the artifact to verify the secret's value.

## Conclusion

Successfully injecting your Managed DevOps Pool into a VNet significantly enhances the security posture of your Azure deployments. By leveraging private networking, you eliminate the risks associated with public exposure of sensitive resources like Azure Key Vault. This detailed walkthrough provides a clear path to implementing a secure and efficient DevOps pipeline that respects the privacy of your cloud resources, making your deployment process more robust and compliant.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Inject%20your%20Managed%20DevOps%20Pool%20into%20a%20VNet" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Inject your Managed DevOps Pool into a VNet" and reviewed by me.

## Video - Inject your Managed DevOps Pool into a VNet

<iframe width="560" height="315" src="https://www.youtube.com/embed/BFyHbRKQonI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>