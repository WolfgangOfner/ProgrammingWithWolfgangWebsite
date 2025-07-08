---
title: Deploying Apps with Helm Charts in ArgoCD UI
date: 2025-07-07
author: Wolfgang Ofner
categories: [DevOps]
tags: [AKS, GitOps, ArgoCD, DevOps, GitHub, Helm]
description: Learn how to install ArgoCD with its Helm Chart and then deploy applications also using Helm Charts. 
---

This post provides a comprehensive guide on deploying applications using Helm charts within Argo CD, covering both public and private repository scenarios. If you're looking to streamline your Kubernetes deployments with GitOps, this is for you.

## Key Topics Covered:

**1. Installing Argo CD with Helm**
The video demonstrates the simplicity and speed of installing Argo CD itself using its official Helm chart. This quick setup gets you started with your GitOps journey efficiently.

**2. Deploying Public Helm Charts (e.g., Bitnami Redis)**
Learn how to effortlessly deploy a public Helm chart, specifically the Bitnami Redis chart, directly through the Argo CD UI. The tutorial highlights the ease of configuring and overriding values, allowing for quick customization of your deployments.

**3. Creating and Configuring Argo CD Projects**
The video explains the crucial step of creating new projects in Argo CD and configuring their access permissions. This includes setting up access for specific repositories, destination clusters, and namespaces, as well as defining allowed or denied cluster resources. This granular control is vital for managing deployments across different environments (e.g., development, testing, production) securely.

**4. Deploying Custom Helm Charts from Git Repositories**
Discover how to deploy your own custom Helm charts stored in a Git repository. Argo CD's flexibility allows it to pull charts directly from Git, not just traditional Helm repositories, making it ideal for managing your internal application charts.

**5. Understanding Argo CD's Helm Integration**
A significant insight from the video is how Argo CD interacts with Helm. Unlike a direct `helm install`, Argo CD executes `helm template` and then applies the generated Kubernetes YAML files. This means that Helm charts deployed via Argo CD will not appear when you run `helm ls` directly, as Argo CD manages the resulting Kubernetes resources, not the Helm release itself.

**6. UI and CLI Workflow**
The video showcases the convenience of the Argo CD UI for initial setup and exploration. However, it also emphasizes the power of exporting configurations as YAML files for Command-Line Interface (CLI) deployment, promoting robust infrastructure-as-code practices and enabling automation.

## Conclusion

Deploying applications with Helm charts in Argo CD offers a powerful and streamlined approach to GitOps. From easy installation of Argo CD itself to deploying complex applications from both public and private Git repositories, Argo CD provides the tools needed for efficient and secure Kubernetes deployments. Its intuitive UI combined with the flexibility for CLI-driven automation makes it an excellent choice for modern cloud-native environments.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Deploying%20Apps%20with%20Helm%20Charts%20in%20ArgoCD%20UI" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Deploying Apps with Helm Charts in ArgoCD UI" and reviewed by me.

## Video - Deploying Apps with Helm Charts in ArgoCD UI

<iframe width="560" height="315" src="https://www.youtube.com/embed/m6e0WvkR4fY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>