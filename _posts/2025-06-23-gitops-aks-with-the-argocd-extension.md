---
title: GitOps on AKS - It Just Got Easier with the ArgoCD Extension
date: 2025-06-23
author: Wolfgang Ofner
categories: [DevOps]
tags: [AKS, GitOps, ArgoCD, DevOps, GitHub]
description: Simplify GitOps for Azure Kubernetes Service (AKS) using the ArgoCD Extension. Deploy and manage apps seamlessly! 
---

This post introduces the AKS GitOps Argo CD extension, a powerful tool designed to simplify Kubernetes application management. We'll explore its ease of use and discuss how it streamlines deployments, configuration management, and rollbacks.

## What is GitOps?

GitOps uses a Git repository as the single source of truth for your Kubernetes application's desired state. An operator within the Kubernetes cluster continuously monitors this repository, automatically applying any changes and detecting/remediating configuration drifts. This approach significantly enhances security by allowing you to block inbound connections to the Kubernetes API, as the GitOps agent operates from within the cluster.

## Preparing Your Environment

Before installing the Argo CD extension, you'll need to prepare your environment. This involves:

- Installing the Azure CLI and the `aks-preview` and `k8s-configuration` extensions.
- Registering the `Microsoft.Kubernetes`, `Microsoft.ContainerService`, and `Microsoft.KubernetesConfiguration` service providers.
- Defining environment variables for your resource group name, location, and AKS cluster name.
- Deploying a resource group and an AKS cluster using basic configuration.
- Downloading your cluster's configuration using `aks get-credentials`.

## Installing the Argo CD GitOps Extension

Installing the Argo CD extension is straightforward using the Azure CLI:

<script src="https://gist.github.com/WolfgangOfner/d6f398ec464589df0eb5f4785545af02.js"></script>

You can also configure high availability and namespace installation settings during this process.

## Accessing the Argo CD UI

To access the Argo CD UI, you'll need the admin password, which can be retrieved by decoding a base64 secret using Linux:

<script src="https://gist.github.com/WolfgangOfner/4f6aed78408105f94191d67ff177834d.js"></script>

or Windows:

<script src="https://gist.github.com/WolfgangOfner/86d6897b81a9f9ef6187df2c0162277c.js"></script>

Then, enable port forwarding `kubectl port-forward svc/argocd-server -n argocd 8080:443` to access the UI via `localhost:8080`. Log in using `admin` as the username and the decoded password.

## Deploying Applications with Argo CD

Deploying applications with Argo CD involves providing a YAML configuration that specifies:

- The application's name
- The Git repository URL
- The branch
- The path to the Kustomize file
- The destination namespace

Argo CD then monitors the repository and automatically synchronizes the application's state with the cluster.

## Customizing and Updating Applications

Argo CD leverages Kustomize files to manage Kubernetes resources. You can modify application parameters, such as the replica count or service type, directly in these YAML files. When you commit these changes to your Git repository, Argo CD automatically detects and applies them to your cluster.

## Rolling Back to Previous Versions

Argo CD simplifies rollbacks by allowing you to select previous application versions directly from the UI. This temporarily disables auto-sync, allowing you to review the previous state before re-enabling synchronization.

## Conclusion

The Argo CD extension provides a powerful and user-friendly way to manage Kubernetes applications on AKS. Its intuitive UI and GitOps-centric approach streamline deployments, configuration management, and rollbacks, making it an invaluable tool for any Kubernetes environment.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/GitOps%20on%20AKS%20It%20Just%20Got%20Easier%20with%20the%20ArgoCD%20Extension" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "GitOps on AKS - It Just Got Easier with the ArgoCD Extension" and reviewed by me.

## Video - GitOps on AKS - It Just Got Easier with the ArgoCD Extension

<iframe width="560" height="315" src="https://www.youtube.com/embed/LAUlAlg988I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>