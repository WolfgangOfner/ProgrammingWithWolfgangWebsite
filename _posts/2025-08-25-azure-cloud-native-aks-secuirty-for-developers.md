---
title: Azure Cloud Native - AKS Security for Developers
date: 2025-08-25
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Security, Azure Bastion]
description: Transcript of my talk at the Azure Cloud Native Meetup about AKS Security for Developers.
---

In the world of cloud-native development, securing your Kubernetes environment is no longer just a task for operations teams—it's a critical responsibility for every developer. This post provides a comprehensive overview of essential security features in Azure Kubernetes Service (AKS), highlighting how to avoid common mistakes and leverage Azure's native tools to build a more secure and resilient platform for your applications.

1. **Authentication and Authorization: Centralizing with Entra ID**
The most critical step in securing your cluster is proper authentication and authorization.

- **The Insecure Method (Local Accounts):** This is the default but most insecure option. It operates as a standalone cluster with no link to Entra ID (formerly Azure Active Directory), making user management complex and storing unencrypted access tokens in `kubeconfig` files.
- **The Recommended Method (Entra ID with Azure RBAC):** This is the most secure and streamlined approach. It integrates directly with Azure Role-Based Access Control (RBAC), allowing you to manage cluster permissions using familiar Azure tools and roles. This simplifies management and provides a transparent, auditable system.

2. **Entra Workload Identity: Password-Free Application Access**
Hard-coding passwords for applications is a common security risk. Entra Workload Identity provides a better way.

- **How it Works:** Instead of passwords, you assign a managed identity to an individual pod. The application running in that pod can then use this identity to securely access other Azure services like a database or Key Vault. This eliminates the risk of password leaks and the need for manual secret rotation.
- **Technical Implementation:** Your AKS cluster must have the OpenID Connect (OIDC) issuer enabled. You then use labels and annotations on your pods and service accounts to link them to the managed identity, adhering to the principle of least privilege.

3. **Private AKS Clusters: Hiding from the Public Internet**
By default, the Kubernetes API server is public, which can be a significant security vulnerability.

- **The Benefit of Going Private:** A private AKS cluster removes the public endpoint for the API, preventing attackers from directly trying to access it. All communication between master and worker nodes occurs over a secure, private connection within the Microsoft network.
- **Accessing the Private Cluster:** A new feature simplifies access by allowing you to use Azure Bastion to create a secure tunnel. This allows you to manage the cluster directly from the Azure CLI without needing a separate jump box VM or complex network configurations.

4. **Securing Your Container Registry: Protecting Your Images**
Just as your cluster should be private, your container registry should be as well.

- **The How and Why:** By adding a private endpoint to your Azure Container Registry (ACR), your AKS cluster can pull images over a private connection, increasing both security and speed. This prevents unauthorized access and potential manipulation of your container images.
- **Pipeline Consideration:** With a private registry, your CI/CD pipelines (e.g., Azure DevOps) will need to use a self-hosted agent within the same virtual network to push new images.

5. **Managing Secrets with Azure Key Vault**
For any secrets that are still necessary, such as API keys for third-party services, avoid storing them manually in Kubernetes secrets.

- **Azure Key Vault Provider for AKS:** This AKS extension provides a secure, automated solution. It mounts secrets, keys, and certificates directly from an Azure Key Vault into your pods. This simplifies secret management for developers, allows for automatic rotation, and ensures that sensitive data is managed in a centralized, secure location.

## Conclusion

Securing an AKS cluster is not a single task but a layered process. By adopting these key practices—centralizing authentication with Entra ID, using workload identities, implementing private clusters and registries, and automating secret management with Key Vault—you can build a highly secure and resilient cloud-native platform. These steps empower developers to focus on building applications while providing peace of mind that their environment is protected against modern threats.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Azure%20Cloud%20Native%20-%20AKS%20Security%20for%20Developers" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Video - Azure Cloud Native - AKS Security for Developers" and reviewed by me.

## Video - Azure Cloud Native - AKS Security for Developers

<iframe width="560" height="315" src="https://youtu.be/GsazJl_HeFY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>