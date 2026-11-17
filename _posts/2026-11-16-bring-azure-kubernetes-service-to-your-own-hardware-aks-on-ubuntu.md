---
title: Bring Azure Kubernetes Service to Your Own Hardware (AKS on Ubuntu)
date: 2026-11-16
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, AKS, Azure Arc]
description: Run Azure Kubernetes Service (AKS) on bare-metal Ubuntu servers using Azure Arc for on-premises cloud-native container workloads.
---

Running Kubernetes on-premises no longer requires building custom cluster infrastructure from scratch. With Azure Arc and the hybrid capabilities of Azure Kubernetes Service (AKS), you can deploy and manage fully managed Kubernetes clusters directly on your own bare-metal Ubuntu hardware.

## Why Run AKS on Bare Metal Ubuntu?

* **Unified Management:** Manage your on-premises physical servers alongside cloud resources directly through the Azure Portal and Azure CLI.
* **Consistent Kubernetes Experience:** Leverage familiar tools like kubectl and standard AKS workflows on local hardware.
* **Optimized Performance:** Run high-performance container workloads on dedicated physical machines without virtualization overhead.
* **Hybrid Cloud Flexibility:** Bridge local data centers with Azure services seamlessly using Azure Arc and hybrid connectors.

## Current Preview Limitations and Prerequisites

Before diving into deployment, it is important to note the current constraints of the preview release:
* **Supported Operating System:** Currently limited to Ubuntu 24.04.3 and 24.04.4.
* **Hardware Architecture:** Requires x86_64 CPUs; ARM CPUs are not supported in this preview.
* **Resource Requirements:** Minimum of 2 cores and 4 GB of RAM, though 4 cores and 8 GB to 16 GB of RAM are recommended.
* **Cluster Topology:** Each physical bare-metal server acts as a single-node AKS cluster during the preview.
* **Regional Availability:** Must be deployed in the East US Azure region.

## Deployment Workflows

You can deploy AKS on bare-metal Ubuntu using two primary approaches:

1. **Quick Deployment Script:** Execute a streamlined one-line installation script that handles Azure CLI installation, Azure Arc agent registration, resource group creation, and cluster deployment automatically.
2. **Manual Step-by-Step Installation:** Manually install the Azure Connected Machine Agent, log into Azure, register required hybrid resource providers, install the aksarc CLI extension, and trigger the deployment command.

## Step-by-Step Implementation Guide

### 1. Prepare Your Ubuntu Server and Environment
Ensure your Ubuntu server meets the hardware specifications. If you are using an Azure VM for testing, apply the necessary test environment variables and firewall rules to restrict access to the local metadata service endpoint.

### 2. Connect Your Server to Azure Arc
Register the necessary Azure hybrid resource providers (including HybridCompute, HybridContainerService, Kubernetes, ExtendedLocation, and HybridConnectivity) and connect your physical or virtual machine to your designated Azure resource group using the Azure Connected Machine agent.

### 3. Deploy AKS Using the Extension
Add the preview aksarc Azure CLI extension and execute the deployment command referencing your registered machine name and target resource group. 

### 4. Connect and Validate Your Cluster
Once deployment completes, retrieve your cluster credentials using the Azure CLI credentials command for AKS Arc. Use standard validation commands like `kubectl get nodes` and `kubectl get ns` to verify that your on-premises cluster is fully operational. If connecting through restricted network boundaries, utilize the Azure Arc proxy connection tool.

## Summary

Deploying AKS on bare-metal Ubuntu with Azure Arc bridges the gap between physical on-premises hardware and cloud-native management. By following these workflows, platform engineers can run enterprise-grade Kubernetes anywhere while maintaining centralized visibility and control through Azure.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Bring%20Azure%20Kubernetes%20Service%20to%20Your%20Own%20Hardware%20(AKS%20on%20Ubuntu)">GitHub</a>.

This post was AI-generated based on the transcript of the video "Bring Azure Kubernetes Service to Your Own Hardware (AKS on Ubuntu)".

## Video - Bring Azure Kubernetes Service to Your Own Hardware (AKS on Ubuntu)

<iframe width="560" height="315" src="https://www.youtube.com/embed/hOLdYl_Hy1M" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>