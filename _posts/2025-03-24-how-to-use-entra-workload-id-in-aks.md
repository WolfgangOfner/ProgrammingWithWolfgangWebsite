---
title: How to use Entra Workload ID in Azure Kubernetes Service
date: 2025-03-24
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Kubernetes, Security, Entra Workload Identity, Entra]
description: Improve AKS security by using Entra Workload Identity for identity-based access to Azure services, eliminating the need for usernames and passwords.
---

This post provides a comprehensive guide on configuring Entra Workload Identity in Azure Kubernetes Service (AKS) clusters to securely access Azure resources. It explains the authentication workflow and demonstrates how to create an AKS cluster with workload identity enabled, followed by testing access to an Azure Key Vault.

## Understanding Workload Identity

Traditional methods of accessing Azure resources often rely on usernames and passwords. However, this approach poses security risks due to the potential for leaks and the complexities of secure storage.  Entra Workload Identity offers a more secure alternative by using identities for authentication. While a managed identity can be assigned to an entire AKS cluster, Entra Workload Identity allows individual pods within the cluster to have their own identities. This provides granular control over permissions, enabling different applications (e.g., test vs. production environments) to have distinct access rights.

## Authentication Workflow

With Entra Workload Identity, pods can securely access Azure resources without the need for usernames or passwords. To enable this, simply add the `azure.workload.identity/use: "true"` label to the pod's configuration. Additional labels can be used to configure token expiration times.

## Practical Demonstration

The following steps demonstrate how to configure and use Entra Workload Identity:

1. **Define Variables:** Set up variables for resource names, locations, and IDs.
2. **Create Resources:** Create a Resource Group and an Azure Key Vault with RBAC authorization enabled.
3. **Assign Key Vault Permissions:** Assign the Key Vault administrator role and create a secret within the Key Vault.
4. **Create AKS Cluster:** Create an AKS cluster with OIDC issuer and workload identity enabled.
5. **Configure Entra Workload ID:** Query the OIDC issuer URL and create a managed identity.
6. **Assign Managed Identity Permissions:** Assign the Key Vault Secrets User role to the managed identity.
7. **Configure Kubernetes Access:** Create a new namespace and define a service account linked to the Azure identity.
8. **Establish Federated Identity Credentials:** Link Kubernetes with Microsoft Entra ID, eliminating the need for secret management.
9. **Deploy Test Application:** Deploy a test application pod with the necessary workload identity label and service account.
10. **Verify Access:** Confirm successful access to the Key Vault secret from the pod logs.

## Simplified Workflow Explanation

The authentication process involves the Kubelet projecting a service account to the pod. The pod then sends an account token to Microsoft Entra. Entra validates the token using the OIDC discovery document and issues a new token back to the pod, granting it access to Azure resources like Key Vault.

## Conclusion

Entra Workload Identity provides a simple yet powerful solution for managing access to diverse Azure resources without the complexities of handling passwords and secrets. It offers a secure and granular approach to controlling access within your AKS clusters.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/How%20to%20use%20Entra%20Workload%20ID%20in%20Azure%20Kubernetes%20Service" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "How to use Entra Workload ID in Azure Kubernetes Service" and reviewed by me.

## Video - How to use Entra Workload ID in Azure Kubernetes Service

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZEn2Zh9o1hQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>