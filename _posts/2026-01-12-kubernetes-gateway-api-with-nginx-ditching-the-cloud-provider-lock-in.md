---
title: Kubernetes Gateway API with Nginx - Ditching the Cloud Provider Lock-in - Part 13
date: 2026-01-12
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Nginx, Nginx Gateway API]
description: Learn how to install Nginx Gateway Fabric for the Kubernetes Gateway API. Ditch cloud provider lock-in and save on costs with this step-by-step guide.
---

Kubernetes traffic management has historically been tied to specific cloud provider implementations or legacy Ingress controllers. While managed services like Azure Application Gateway for Containers (AGFC) offer great features, they often come with significant provisioning wait times, fixed costs, and a degree of vendor lock-in.

The Kubernetes Gateway API changes this landscape by providing a standardized set of resources. By moving the gateway implementation directly into your cluster using Nginx Gateway Fabric, you gain portability and speed without sacrificing the power of the Gateway API.

## Why Choose a Cluster-Native Gateway?

Shifting from a managed cloud service to a cluster-native implementation like Nginx Gateway Fabric offers several immediate advantages:

* Portability: Your configuration is no longer cloud-specific.
* Consistency: Whether you are running on AKS, EKS, or on-premises, your Gateway and HTTPRoute manifests remain the same.
* Cost Management: You avoid the hourly "base fee" associated with many managed gateway services.
* Resource Efficiency: You only pay for the underlying compute (the pods) and the standard load balancer.
* Rapid Deployment: Unlike managed resources that can take 20–30 minutes to provision, Nginx Gateway Fabric installs and is ready to route traffic in just a few minutes.

## Core Concepts

Nginx Gateway Fabric is an implementation of the Gateway API that uses Nginx as the data plane. It consists of a controller (the control plane) that watches for Gateway API resources and automatically configures Nginx pods to handle traffic according to your rules.

**1. The Gateway API CRDs**
Since the Gateway API is an evolving standard, many Kubernetes distributions do not include the required Custom Resource Definitions (CRDs) by default. The first step in any implementation is applying these definitions so the cluster understands the new resource types.

**2. Installation via Helm**
The most efficient way to deploy the controller is through Helm. This process sets up the controller pods and a GatewayClass that acts as the template for your gateways.

**3. Defining the GatewayClass**
The GatewayClass is the bridge between the API and the implementation. When you install Nginx Gateway Fabric, a class (usually named nginx) is created. Any Gateway resource you deploy must reference this class to be handled by Nginx.

## Routing Traffic

Once the infrastructure is in place, you can begin defining how traffic enters the cluster.

**The Gateway Resource**
The Gateway defines where the controller should listen. On a cloud provider like Azure (AKS), creating this resource will trigger the creation of a standard Load Balancer with a Public IP.

**The HTTPRoute Resource**
The HTTPRoute defines the actual routing logic—mapping specific hostnames or paths to backend services.

## Conclusion

Nginx Gateway Fabric provides a powerful, fast, and cost-effective alternative to cloud-managed gateways. By utilizing the standardized Kubernetes Gateway API, you ensure that your routing logic is decoupled from your infrastructure provider. This approach not only simplifies local development and testing but also ensures your application is truly portable across any Kubernetes environment.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Kubernetes%20Gateway%20API%20with%20Nginx%20Ditching%20the%20Cloud%20Provider%20Lock-in-%20Part%2013">GitHub</a>.

This post was AI-generated based on the transcript of the video "Kubernetes Gateway API with Nginx - Ditching the Cloud Provider Lock-in - Part 13" and reviewed by me.

## Video - Kubernetes Gateway API with Nginx - Ditching the Cloud Provider Lock-in - Part 13

<iframe width="560" height="315" src="https://www.youtube.com/embed/zp-5m88I2wE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>