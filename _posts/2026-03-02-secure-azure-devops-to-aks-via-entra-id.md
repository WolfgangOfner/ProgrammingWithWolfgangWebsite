---
title: Secure Azure DevOps Access to AKS via Entra ID
date: 2026-03-02
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [Azure, AKS, Kubernetes, Azure DevOps, CI-CD, Entra ID]
description: Learn how to securely access AKS from Azure DevOps using Entra ID and Azure RBAC. This guide covers the steps to configure kubelogin for seamless, secure pipelines.
---

For a long time, the easiest way to access an Azure Kubernetes Service (AKS) cluster was through local accounts and Kubernetes RBAC. While convenient, this approach has a significant security downside: the tokens used for access are static and unencrypted, making them a liability if they are ever leaked or stolen.

In this post, we explore the transition to a more secure model: **Entra ID authentication paired with Azure RBAC**. This approach allows you to manage permissions using the same identity tools you use for all other Azure services.

## Why Choose Azure RBAC?

When setting up an AKS cluster, you generally have three choices for authentication:
1.  **Local Accounts:** The default method, which is simple but lacks the centralized security features of Azure.
2.  **Entra ID with Kubernetes RBAC:** A hybrid model that uses Entra for identity but handles permissions inside the cluster.
3.  **Entra ID with Azure RBAC:** The most secure and modern option. It allows you to assign built-in or custom roles—like Cluster Admin or Reader—directly within the Azure portal or via CLI.

By using Azure RBAC, you ensure that every access request is backed by a valid Entra ID token, matching the security posture of your entire cloud environment.

## The Challenge with Azure DevOps

The difficulty arises when you try to use standard Azure DevOps tasks, such as Helm deployments or Kubectl commands, against a cluster that has disabled local accounts. Out of the box, these tasks often expect a local credential. Because there is no official documentation clearly outlining the fix for this scenario, many developers find themselves stuck with "unauthorized" errors.

The solution requires adding a few specific steps to your pipeline to handle the identity handshake.

## The Solution: Tools and Configuration

To make this work on a Microsoft-hosted agent, you need to follow a specific workflow:

### 1. Identify the Pipeline Identity
Your pipeline runs using a service connection, which is backed by a service principal or managed identity. Before the pipeline can touch the cluster, you must assign the appropriate Azure RBAC role to that identity at the cluster level.

### 2. Prepare the Build Agent
Microsoft-hosted agents do not come with all the necessary tools installed by default. Specifically, you must install a utility called the "login tool" (kubelogin). This tool acts as the bridge between the Azure CLI and the Kubernetes configuration.

### 3. Fetch and Convert Credentials
Once the tool is installed, the pipeline must download the cluster credentials. However, instead of using them as-is, you use the login tool to convert the configuration. This conversion tells the system to use the Azure CLI's active login session to authenticate every Kubernetes command.

## Seamless Integration

The beauty of this setup is that once these preparatory steps are completed, your existing tasks—like Helm or Kubectl—work exactly as they did before. You don't have to change your deployment logic or your Helm charts; the underlying authentication layer handles everything transparently.

By following this method, you can successfully list namespaces, deploy applications, and manage your cluster resources while keeping local accounts completely disabled.

## Conclusion

Securing your infrastructure is a journey, and moving to Entra ID with Azure RBAC is a massive leap forward. While it requires a bit of extra configuration in your automation pipelines, the benefit of having centralized, encrypted, and auditable access control far outweighs the initial setup effort.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Secure%20Azure%20DevOps%20Access%20to%20AKS%20via%20Entra%20ID">GitHub</a>.

This post was AI-generated based on the transcript of the video "Secure Azure DevOps Access to AKS via Entra ID".

## Video - Secure Azure DevOps Access to AKS via Entra ID

<iframe width="560" height="315" src="https://www.youtube.com/embed/0PFpkZhJUgw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>