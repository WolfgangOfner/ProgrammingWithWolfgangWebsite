---
title: Multi Master K3s - Using k3sup for Highly Available Kubernetes
date: 2026-03-16
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Kubernetes, k3s, On-premises, High Availability]
description: Learn how to set up a highly available k3s cluster using k3sup. I walk through bootstrapping master nodes and joining VMs for a robust on-premise setup.
---

While managed environments like AKS are the standard for many, on-premise Kubernetes training requires a different approach. The biggest challenge for self-hosted clusters is ensuring high availability without getting lost in manual configuration. 

In this post, I explain how to use **k3s** and the **k3sup** utility to bootstrap a production-ready, multi-master cluster quickly.

## Why k3s and k3sup?

**k3s** is a lightweight, fully compliant Kubernetes distribution perfect for edge or on-premise workloads. While the initial install is simple, managing a multi-node cluster with high availability (HA) requires coordination.

**k3sup** (pronounced "ketchup") is a utility that uses SSH to install k3s on remote servers and join additional nodes as either workers or masters. It handles the complexity of the control plane setup for you.

## The HA Setup Strategy

For a robust control plane, you need at least three master nodes. This ensures that the cluster remains operational even if one node fails.

### 1. Prerequisites
* **Management Machine:** A local machine or a jumpbox VM with kubectl and k3sup installed.
* **Target VMs:** At least three Linux VMs (Ubuntu 24.04 recommended) with SSH access.
* **SSH Keys:** Ensure your management user has passwordless sudo rights on the target nodes.

### 2. Bootstrapping the First Master
The process starts by initializing the cluster on your primary node. You run the k3sup install command while providing the node IP, your username, and the path to your SSH key. Using the cluster flag is essential here, as it tells k3s to initialize with an embedded ETCD database for high availability.

### 3. Joining Additional Masters
To add redundancy, you join the next two nodes as servers rather than just agents. By running the k3sup join command and specifying the server-ip of your first master, these nodes become part of the control plane. 

## Operations and Taints

By default, k3s master nodes also act as worker nodes. To separate your control plane from your application workloads, you can apply a NoExecute taint to the master nodes. This ensures your application pods aren't scheduled on the masters, keeping the control plane stable and dedicated to management tasks.

## Conclusion

High availability on-premise is much more manageable with the right tools. **k3sup** bridges the gap between the simplicity of the cloud and the control of local hardware.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Multi-Master%20K3s%20Using%20k3sup%20for%20Highly%20Available%20Kubernetes">GitHub</a>.

This post was AI-generated based on the transcript of the video "Multi Master K3s - Using k3sup for Highly Available Kubernetes".

## Video - Multi Master K3s - Using k3sup for Highly Available Kubernetes

<iframe width="560" height="315" src="https://www.youtube.com/embed/gvmxBc3kynY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>