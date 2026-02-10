---
title: Envoy Gateway API Setup and Installation on AKS - Part 15
date: 2026-01-26
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Envoy, Envoy Gateway API]
description: Learn how to install Envoy Gateway as your Kubernetes Gateway API implementation on AKS. Ditch cloud lock-in and save on costs with this quick installation guide.
---

The Kubernetes Gateway API has rapidly become the standard for modern traffic management. While managed services like the Azure Application Gateway for Containers (AGFC) are powerful, they often introduce vendor lock-in and fixed monthly costs. In this guide, we explore why **Envoy Gateway** is a top-tier choice for those who want a portable, cloud-agnostic implementation that runs directly inside their cluster.

## Why Envoy Gateway is the Standout Choice

After testing multiple implementations, including Nginx and Traefik, Envoy Gateway often emerges as a favorite for several reasons:

* **Superior Documentation:** The project provides exceptionally clear guides and well-structured documentation, making it accessible for both beginners and experienced engineers.
* **Developer Experience:** Envoy offers built-in demo apps and sample configurations that allow you to see the Gateway API in action within minutes of installation.
* **Unified Installation:** Its Helm chart is comprehensive, automatically deploying the required Gateway API Custom Resource Definitions (CRDs) so you don't have to manage them separately.
* **Cloud Agnostic:** Because Envoy Gateway runs as a set of pods within your cluster, your configuration remains identical whether you are running on AKS, AWS EKS, or on-premises hardware.

## Key Benefits of In-Cluster Gateways

Moving your gateway inside the cluster—rather than using a cloud-managed service—offers two primary advantages:

1. **Cost Savings:** You avoid the hourly base fees associated with managed cloud gateway tiers. You only pay for the standard load balancer and the compute resources (pods) your cluster already uses.
2. **No Vendor Lock-in:** By using a standardized implementation like Envoy, you can migrate your entire traffic management setup between different cloud providers without changing a single manifest.

## Setting Up Envoy Gateway

The installation process is streamlined through Helm, making it much faster to get started compared to the lengthy provisioning times of managed cloud resources.

### 1. Deployment via Helm
The installation involves adding the Envoy Gateway Helm repository and deploying the chart. This process sets up the controller and the necessary backend services inside a dedicated namespace. 

### 2. Defining the GatewayClass
The GatewayClass serves as the template for your gateways. It links the Kubernetes API to the Envoy implementation. Once the class is accepted by the cluster, you are ready to provision actual gateways.

### 3. Creating the Gateway Resource
The Gateway resource defines the entry point for your traffic. On a cloud provider like Azure, creating this resource triggers the creation of a standard Load Balancer with a Public IP address. By configuring the listener to allow routes from all namespaces, you can manage traffic for your entire cluster from a single, centralized point.

## Testing Your Configuration

Once the gateway is "Programmed" and has received its external IP, you can begin routing traffic. This is achieved through the **HTTPRoute** resource, which maps incoming requests to your backend services.

Because Envoy Gateway is highly extensible, this basic setup is just the beginning. The implementation also supports advanced features like:
* **Rate Limiting:** Protect your services from excessive traffic.
* **Security Policies:** Implement sophisticated authentication and authorization rules.
* **Observability:** Gain deep insights into how traffic is flowing through your cluster.

## Conclusion

Envoy Gateway provides a high-performance, cost-effective, and highly portable solution for Kubernetes traffic management. Its combination of excellent documentation and ease of use makes it a perfect starting point for anyone looking to master the Gateway API without being tied to a specific cloud vendor's ecosystem.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Envoy%20Gateway%20API%20Setup%20and%20Installation%20on%20AKS%20-%20Part%2015">GitHub</a>.

This post was AI-generated based on the transcript of the video "Envoy Gateway API Setup and Installation on AKS - Part 15" and reviewed by me.

## Video - Envoy Gateway API Setup and Installation on AKS - Part 15

<iframe width="560" height="315" src="https://www.youtube.com/embed/ypl7Bu9zQUM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>