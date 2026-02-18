---
title: AKS Application Gateway for Containers Addon - Part 18
date: 2026-02-16
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers]
description: Master the new AKS Add-on for Application Gateway for Containers. Learn how to simplify your Gateway API setup with managed infrastructure on Azure.
---

I originally planned for this series to conclude with a summary, but Microsoft recently released a feature that was too important to skip: the **AKS Add-on for Application Gateway for Containers (AGFC)**. 

If you followed the earlier parts of this series, you know that setting up AGFC manually involves several complex steps, including manual Helm installations, creating managed identities, and configuring federated credentials. The new AKS Add-on changes the game by automating that "heavy lifting," making it significantly faster to get your managed Gateway API up and running.

## Why Use the AKS Add-on?

The primary benefit of the Add-on is **simplicity**. Instead of managing the lifecycle of the Application Load Balancer (ALB) controller yourself, the Add-on handles the core infrastructure requirements automatically.

Specifically, the Add-on manages the deployment of the ALB controller pods into your system namespace and takes care of the identity management by creating the required Managed Identity and setting up Workload Identity federation. It also streamlines the permission logic by assigning necessary RBAC roles, such as Network Contributor, and handles the provisioning and delegation of the dedicated subnet required for traffic.

## Getting Started: Requirements and Setup

Since this is currently a preview feature, there are a few prerequisites to keep in mind before you flip the switch. First, ensure your AKS cluster is in a region that supports AGFC. You also need to be using a modern networking stack like Azure CNI or Azure CNI Overlay. 

Finally, Workload Identity must be enabled on your cluster. This is the bridge that allows the controller to communicate with Azure APIs securely without needing to manage static secrets or long-lived service principal keys.

## From Infrastructure to Gateway

Once the Add-on is enabled, the ALB controller is ready to work. Your primary task moves from "managing infrastructure" to "defining intent." You simply create the Application Load Balancer resource in Kubernetes, which triggers the actual provisioning of the AGFC resource in your Azure subscription.

One of the best parts of using the Add-on is that it pre-configures the GatewayClass for you. This means you can go from a blank cluster to a live, CNAME-accessible endpoint in just a few minutes, leveraging the official Azure ALB external configuration.

## The Verdict: Preview vs. Production

As with any preview feature, there can be occasional "hiccups"—such as timeouts during the configuration of overlay extensions. However, in my testing, these usually resolve themselves with a bit of patience or a simple retry. 

The move toward a managed Add-on reflects a clear shift: Microsoft is making the Gateway API the standard for Kubernetes networking on Azure. It removes the operational burden from developers and allows teams to focus on their applications rather than the underlying networking plumbing.

## Conclusion

With the managed infrastructure now simplified, the path is clear for full-scale automation. This sets the stage perfectly for the final steps of our journey, where we look at how to wrap these managed services into a production-ready deployment pipeline.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Application%20Gateway%20for%20Containers%20Addon%20-%20Part%2018">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Application Gateway for Containers Addon - Part 18" and reviewed by me.

## Video - AKS Application Gateway for Containers Addon - Part 18

<iframe width="560" height="315" src="https://www.youtube.com/embed/5arGrivpen8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>