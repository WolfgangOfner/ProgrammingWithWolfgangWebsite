---
title: Simplified AKS with AKS Automatic
date: 2025-09-22
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, Security, AKS]
description: Introducing AKS Automatic - Deploy a production-ready Kubernetes cluster in minutes with Microsoft's best practices, automatic scaling, and built-in monitoring.
---

Azure Kubernetes Service (AKS) is the backbone for countless cloud-native applications, but setting up a production-ready cluster with all the necessary best practices can be complex. Microsoft recently introduced AKS Automatic, a configuration option designed to simplify this process by pre-configuring your cluster according to Microsoft's recommended best practices.

AKS Automatic is not a new pricing tier but rather a preconfigured Standard tier cluster that automates critical setup tasks, making it ideal for newcomers to AKS or small teams looking for a quick, robust deployment.

## What is AKS Automatic?

AKS Automatic provides a "production-ready" cluster out-of-the-box by automatically enabling and configuring a host of essential features:

- **Networking:** It defaults to the Azure CNI Overlay with Cilium, providing advanced networking and security capabilities.
- **Node Management:** Node pools are automatically provisioned and managed, using Azure Linux as the operating system for improved security and performance.
- **Scaling Tools:** It includes a suite of scaling solutions:
    - **KEDA (Kubernetes Event-Driven Autoscaling):** For scaling based on external data sources like message queues.
    - **Horizontal Pod Autoscaler (HPA)** and **Vertical Pod Autoscaler (VPA)**.
- **Monitoring & Observability:** It comes pre-configured with Azure Container Logs, Prometheus, and Grafana, including pre-built dashboards, significantly reducing initial setup time.
- **Upgrades:** It takes care of scheduling Kubernetes version upgrades automatically.

## Key Limitations to Consider

While AKS Automatic is convenient, it comes with a few limitations due to its heavily managed nature:

1. **Regional Availability:** You can only create a cluster in a region that supports three Availability Zones and where API server VNet integration is Generally Available.
2. **Node Pool Control:** You cannot add your own custom node pools; all pools must have auto-provisioning enabled, as they are managed by AKS Automatic.
3. **OS Requirement:** Clusters must use Azure Linux as the underlying operating system.
4. **Pricing Tier Restriction:** It is currently restricted to the Standard tier, limiting scalability to 1,000 nodes, which might not be sufficient for hyper-scale environments.

## Deployment Methods

AKS Automatic can be deployed through two primary methods:

1. **Azure Portal:** The portal offers a simplified deployment wizard titled "Automatic Kubernetes cluster," where many configuration steps (like networking and security) are removed because they are managed for you.
2. **Azure CLI:** Deploying via the command line is simple, requiring only one additional parameter: --aks-automatic.

## Switching from Automatic to Standard

A crucial feature of AKS Automatic is its flexibility. You can easily switch an Automatic cluster back to a normal Standard cluster via the Azure portal. This conversion does not delete any of your resources—it only converts the master node (control plane) configuration. After the switch, you regain full control over elements like node pools and security configurations.

## Conclusion: Is AKS Automatic Right for You?

AKS Automatic is an excellent feature for learning the current best practices endorsed by Microsoft. Deploying an Automatic cluster reveals the security and performance settings you should be applying to your own custom clusters (e.g., disabling local accounts and enabling image cleaner).

However, for experienced administrators who demand complete, granular control over every aspect of their infrastructure, a manually configured Standard or Premium AKS cluster might still be preferable.

Ultimately, AKS Automatic delivers on its promise: a production-ready, highly observable cluster in minutes, with no additional cost beyond the Standard tier, making it a valuable tool for those seeking simplified cloud infrastructure.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Simplified%20AKS%20with%20AKS%20Automatic" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Simplified AKS with AKS Automatic" and reviewed by me.

## Video - Simplified AKS with AKS Automatic

<iframe width="560" height="315" src="https://www.youtube.com/embed/pjbn2YSNQz0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>