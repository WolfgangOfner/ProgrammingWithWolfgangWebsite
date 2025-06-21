---
title: Secure your Kubernetes Secrets with Azure Key Vault Secrets Provider
date: 2025-03-31
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Kubernetes, Azure Key Vault]
description: Secure your Kubernetes secrets with Azure Key Vault! Learn to install and configure the Key Vault Secret CSI Driver in AKS for automatic secret synchronization.
---

This post provides a comprehensive guide on integrating Azure Key Vault secrets with Kubernetes clusters using the Azure Key Vault Secrets Provider extension. This extension allows you to mount secrets, keys, and certificates from Azure Key Vault directly into pods running in Kubernetes, enhancing the security and management of your secrets.

## Why Use the Azure Key Vault Secrets Provider Extension?

The Azure Key Vault Secrets Provider extension offers several key benefits:

- **Auto-rotation of secrets:** Secrets updated in Key Vault are automatically updated in the Kubernetes cluster, ensuring your applications always use the latest versions.
- **Synchronization with Kubernetes secrets:** The extension can create Kubernetes secrets from Key Vault secrets, making them easily accessible to your applications.
- **Mounting multiple objects:** Secrets, keys, and certificates can be mounted into a single volume for easy consumption by applications.
- **Separation of concerns:** Developers can focus on using secrets, while cluster administrators manage their secure storage and synchronization.

## How it Works

The Secret Store CSI Driver, in conjunction with the Azure Key Vault Secrets Provider extension, fetches and mounts secrets from Azure Key Vault to your pods. This process ensures that your applications have secure and up-to-date access to the necessary secrets.

## Setting up the Environment

Before installing the extension, you'll need to set up your Azure environment:

1. **Configure Variables:** Define necessary variables for resource groups, Kubernetes clusters, Key Vaults, and service accounts.
2. **Create Resource Group:** Create an Azure resource group to contain your resources.
3. **Create Azure Key Vault:** Create an Azure Key Vault with RBAC authorization enabled and assign the Key Vault administrator role.
4. **Add a Secret to Key Vault:** Add a secret to the Key Vault for testing purposes.

## Creating and Configuring the AKS Cluster

Next, you'll create and configure your AKS cluster:

1. **Create AKS Cluster:** Create an AKS cluster with OIDC issuer and workload identity enabled.
2. **Configure Entra Workload ID:** Configure Entra Workload ID by querying the OIDC issuer URL, creating a managed identity, and assigning it the "Key Vault Secrets User" role in Key Vault.
3. **Kubernetes Configuration:** Download the kubeconfig, create a new namespace, set the context, and create a service account linked to the managed identity.
4. **Create Federated Identity Credentials:** Create federated identity credentials to link the service account to the managed identity.

## Installing the Key Vault Secrets Provider Extension

Install the extension on your AKS cluster using the Azure CLI:

<script src="https://gist.github.com/WolfgangOfner/d7bf1bdddc51712c1495084ba0e4b69e.js"></script>

Verify the installation by checking the running pods in the `kube-system` namespace.

## Configuring and Testing Secret Synchronization

1. **Configure SecretProviderClass:** Create a `SecretProviderClass` to specify the provider as Azure, the client ID of the managed identity, the Key Vault name, and the objects (secrets) to synchronize.
2. **Deploy a Pod:** Deploy a simple pod, such as a busybox pod, mounting the secrets to a specified path.
3. **Verify Secrets:** Use `kubectl exec` commands to verify the mounted secret's presence and value within the pod.

## Synchronizing with Kubernetes Secrets

1. **Update SecretProviderClass:** Update the `SecretProviderClass` to include `secretObjects`, which instructs the extension to create Kubernetes secrets from the synchronized Key Vault secrets.
2. **Delete and Recreate Pod:** Delete and recreate the pod to trigger the secret synchronization and the creation of Kubernetes secrets.
3. **Verify Kubernetes Secret:** Use `kubectl get secrets` and `kubectl describe secret` to check the newly created Kubernetes secret and its decoded value.

## Auto-Rotation and Automatic Updates

1. **Enable Secret Rotation:** Enable secret rotation on the AKS add-on and configure the polling interval using the Azure CLI:

<script src="https://gist.github.com/WolfgangOfner/ea6f83c6374e8e9e9b6db87c09323d4f.js"></script>

2. **Update Key Vault Secret:** Update a secret's value in Azure Key Vault.
3. **Verify Automatic Synchronization:** Verify the updated secret's value in the pod's mounted volume and the Kubernetes secret. The changes should be reflected without restarting the pod.

For applications that don't read secrets on the fly (e.g., .NET environment variables), consider using tools like "Reloader" to automatically and gracefully restart pods when secrets are updated.

## Conclusion

The Azure Key Vault Secrets Provider extension simplifies the process of securely accessing secrets in Kubernetes. By leveraging this extension, you can ensure that your applications have access to the latest secrets without the need for manual intervention.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Secure%20your%20Kubernetes%20Secrets%20with%20Azure%20Key%20Vault%20Secrets%20Provider" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Secure your Kubernetes Secrets with Azure Key Vault Secrets Provider" and reviewed by me.

## Video - Secure your Kubernetes Secrets with Azure Key Vault Secrets Provider

<iframe width="560" height="315" src="https://www.youtube.com/embed/FXEuo-6X3zA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>