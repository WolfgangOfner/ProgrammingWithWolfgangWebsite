---
title: The Hack Summit 2025 - AKS Security for Developers
date: 2025-10-06
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, Security, AKS, DevOps, Private Endpoint, Kubernetes, Azure Container Registry, Azure Key Vault]
description: Recording of my talk "AKS Security for Developers" at The Hack Summit 2025 about securing an AKS cluster from a developer's perspective.
---

Securing a Kubernetes cluster can feel overwhelming, especially for developers who are primarily focused on application logic. Since the default configuration for an Azure Kubernetes Service (AKS) cluster is often insecure, adopting a few key best practices is critical to protecting your workloads.

This post simplifies AKS security by focusing on four major areas that offer the highest return on security investment, allowing developers to secure their clusters without becoming Kubernetes security experts.

## Authentication and Authorization: Ditch Local Accounts

The single most significant security improvement you can make is changing the default authentication mode.

AKS offers a few different authentication modes, and you should always choose the one that integrates seamlessly with your organizational identity management system:

- **Avoid Local Accounts with Kubernetes RBAC:** This default configuration creates a critical security risk because it has no link to Microsoft Entra ID (formerly Azure AD). Credentials often remain valid even after an employee leaves the company, and user management requires complex, native Kubernetes RBAC knowledge.
- **The Best Practice: Entra ID Authentication with Azure RBAC (Recommended):** This is the easiest and most secure option. It manages both authentication and authorization using familiar Azure tools and roles. Permissions for the entire cluster or specific namespaces can be assigned to Entra ID users and groups directly via Azure RBAC, leveraging existing corporate governance.

## Workload Identity: Eliminate Passwords from Your Code

Traditional application development often requires storing passwords, connection strings, or keys in configuration files to access other services like Azure Key Vault or Azure SQL. This creates leakage risk and requires constant manual rotation.

Entra Workload Identity is the modern solution that addresses this by assigning a secure identity to a Kubernetes Pod or Deployment.

- **How it Works:** The application uses an automatically generated token (via a federated credential linked to a Managed Identity in Azure) to securely access other Azure resources. No secrets are stored in your cluster or code.
- **Benefit:** This provides granular, least-privilege access, ensuring, for example, that your test application can only access the test database, not the production database.

## Private AKS Clusters: Secure the Control Plane

A private AKS cluster restricts access to the master node's API server, making it only available over a private network connection. This is a fundamental step in preventing external attackers from compromising the "brain" of your cluster.

When enabling a private cluster, you must ensure internal users and automated tools can still communicate with the API:

- **Developer Access:** The most modern and cost-effective way is often to use Azure Bastion to connect directly to the AKS cluster's API without needing to deploy and manage a separate jump box VM.
- **CI/CD Access:** The safest pattern is often GitOps, which uses agents running inside the cluster (like Argo CD or Flux CD) to pull changes from a Git repository, eliminating the need for the external build pipeline to connect directly to the private API.

## Secret Management: Sync Secrets Securely

While Workload Identities eliminate most secrets, some third-party API keys or certificates remain necessary.

The Azure Key Vault Provider for Secret Store CSI Driver extension is the solution for managing these remaining sensitive values:

- **How it Works:** This extension securely synchronizes keys, certificates, and secrets from your Azure Key Vault directly into your Kubernetes Pods, mounting them as volumes or exposing them as environment variables.
- **Key Advantage:** It separates the concern of secret management (handled by operations in Key Vault) from secret consumption (handled easily by the developer via environment variables), reducing risk and code complexity. It also supports automatic secret rotation and can make secrets available even during highly disconnected operations.

## Conclusion

Securing an AKS cluster doesn't require a deep, specialized knowledge of every Kubernetes internal component. By focusing on these four core pillars—adopting Azure RBAC for identity, utilizing Entra Workload Identity to eliminate secrets in code, enforcing network security with Private AKS Clusters, and centralizing remaining credentials with the Key Vault CSI Driver—developers and small teams can achieve a significantly hardened and compliant security posture. Implementing these best practices moves you far beyond the vulnerable default configuration, allowing you to focus on building applications with confidence.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/The%20Hack%20Summit%202025%20-%20AKS%20Security%20for%20Developers" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "The Hack Summit 2025 - AKS Security for Developers" and reviewed by me.

## Video - The Hack Summit 2025 - AKS Security for Developers

<iframe width="560" height="315" src="https://www.youtube.com/embed/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>