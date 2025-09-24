---
title: Quick Guide to Managed Namespaces in AKS
date: 2025-09-22
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, Security, AKS]
description: Simplify multi-tenancy in Azure AKS with Managed Namespaces. Learn how to enforce security, RBAC, and quotas to protect your Kubernetes cluster.
---

Managing a Kubernetes cluster in a multi-tenant environment can be an administrative challenge. When multiple teams or applications share a single cluster, enforcing resource limits, controlling access, and ensuring network security requires significant manual effort. Azure Kubernetes Service (AKS) is tackling these challenges with a new preview feature called Managed Namespaces.

This feature is designed to simplify cluster management, providing a cleaner and more secure way to handle multi-tenant workloads. It offers a new layer of control that allows administrators to delegate permissions and enforce policies at the namespace level, without giving users full cluster access.

## The Core Idea: Simplifying Management and Security

At its heart, a Managed Namespace is an isolated environment within your AKS cluster that you can manage as a distinct Azure resource. This brings several key benefits:

- **Granular Permissions:** You can assign specific Azure RBAC permissions to users or groups, granting them access to only their designated namespace. This eliminates the need for full cluster-level permissions and enforces the principle of least privilege.
- **Enforced Resource Governance:** Administrators can set and enforce resource quotas for each namespace. This ensures that no single team can consume all of the cluster's CPU or memory, preventing "noisy neighbor" issues and ensuring fair resource distribution.
- **Built-in Network Policies:** You can easily define ingress and egress policies to control communication. This allows you to restrict traffic to only within a single namespace or allow it to flow freely, depending on your security requirements.

## How to Get Started

Implementing Managed Namespaces is a straightforward process that integrates with the Azure CLI and your existing AKS workflows. While the feature is in preview, the steps provide a clear path to setting it up:

1. Prepare your environment by installing the necessary Azure CLI extension and enabling the preview feature flag for your subscription.
2. Create your AKS cluster with Azure AD integration and Azure RBAC enabled. These settings are essential for handling the authentication and authorization required by Managed Namespaces.
3. Create the Managed Namespace as a separate Azure resource. During this step, you define its name, associate it with your cluster, and set up your initial resource quotas and labels.
4. Assign permissions by using Azure role assignments. You grant specific roles to users, scoping their permissions to the Managed Namespace's resource ID. This ensures they can only operate within that designated area of the cluster.

A significant benefit of this model is that when a user downloads their kubeconfig file, it is automatically scoped to their namespace. This prevents them from performing cluster-wide operations and keeps your overall cluster management clean.

## Advanced Configuration Options

Managed Namespaces also offer powerful configuration parameters to customize behavior:

- **Ingress Policy:** Defaulting to "allow within the same namespace," this can be changed to "allow all" or "deny all" to suit your specific networking needs.
- **Egress Policy:** The default is "allow all" outbound traffic, but you can tighten this to "allow within the same namespace" or "deny all" for enhanced security.
- **Adoption Policy:** This controls what happens if you try to create a Managed Namespace with the same name as an existing Kubernetes namespace. You can choose to fail the deployment, convert the existing namespace if it's identical, or force a complete takeover.
- **Deletion Policy:** This is a critical setting that determines the lifecycle of your namespaces. When you delete the Managed Namespace resource, you can choose to either keep the underlying Kubernetes namespace and its contents, or delete everything entirely.

## Conclusion

Managed Namespaces in AKS represent a promising step toward a more efficient and secure "cluster as a service" model. A central admin team can manage the core cluster, while individual development teams can operate within their own dedicated, governed namespaces. This approach allows for:

- **Optimal Resource Utilization:** By enforcing quotas, you can densely pack applications on your worker nodes, maximizing your investment.
- **Streamlined Operations:** Developers can focus on their applications without needing deep knowledge of cluster-wide administration.
- **Enhanced Security:** The ability to grant least-privilege access and enforce network policies at the namespace level significantly reduces your attack surface.

While still in preview, this feature holds great potential for any organization looking to scale its use of AKS in a more controlled and secure manner.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Quick%20Guide%20to%20Managed%20Namespaces%20in%20AKS" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Quick Guide to Managed Namespaces in AKS" and reviewed by me.

## Video - Quick Guide to Managed Namespaces in AKS

<iframe width="560" height="315" src="https://www.youtube.com/embed/DkRZEru_gww" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>