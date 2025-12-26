---
title: AKS Traffic Splitting Canary and A-B Deployments - Part 10
date: 2025-12-22
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Routing]
description: Configure Canary, A/B, and Blue-Green deployments on AKS using the Kubernetes Gateway API. Learn to split traffic safely with weighted rules.
---

Modern deployment strategies focus on reducing risk and ensuring a seamless user experience. By utilizing the **Kubernetes Gateway API** on **Azure Kubernetes Service (AKS)**, you can gain fine-grained control over how traffic is distributed between different versions of your applications. 

One of the most effective ways to manage this is through **Traffic Splitting**, a technique that allows you to route specific percentages of incoming requests to different backend services using weighted load balancing.

## Understanding the Use Cases

Traffic splitting is the foundation for several modern DevOps patterns:

* **A/B Testing:** This strategy involves running two versions of an application simultaneously to see which one performs better. For example, you might test a new UI feature or marketing copy to determine which leads to higher user engagement.
* **Canary Deployments:** Named after the "canary in a coal mine," this approach involves rolling out a new version to a tiny percentage of users (e.g., 5%). You monitor the performance; if everything looks good, you gradually increase the traffic until the new version reaches 100%. This limits the "blast radius" if the new version has a bug.
* **Blue-Green Deployments:** Here, you have two identical environments. One is "Blue" (the current production version) and the other is "Green" (the new version). Once the Green version is ready, you switch 100% of the traffic over. If an issue arises, you can instantly revert traffic back to the Blue environment.

## The Power of Weighted Load Balancing

The Kubernetes Gateway API implements traffic splitting through a simple `weight` parameter within the `HTTPRoute` resource. 

The weight is a **positive integer** that defines the relative proportion of traffic sent to a specific backend. It’s important to remember that these numbers are relative:
* A **50/50** split is the same as **1/1** or **500/500**.
* A **20/80** split means 20% of traffic goes to the first service and 80% to the second.

To keep your configuration readable, it is generally recommended to use weights that add up to 100, representing percentages (e.g., 5 and 95 for a canary release).

## Implementing Dynamic Traffic Shifts

One of the key advantages of using the Gateway API with **Azure Application Gateway for Containers (AGFC)** is the ability to update these weights on the fly. 

By simply modifying the `weight` values in your `HTTPRoute` manifest and applying the change, the gateway updates its routing logic immediately. This happens without downtime; users are simply routed to the new target as soon as the configuration is processed. This responsiveness is critical for quickly rolling back a failed deployment or accelerating a successful canary rollout.

## Conclusion

Traffic splitting is a foundational capability for any team looking to implement advanced deployment strategies on Kubernetes. Whether you are performing surgical A/B tests or managing high-stakes canary rollouts, the `weight` parameter in the Gateway API provides a simple, powerful, and reliable way to control your traffic flow. By offloading this logic to the infrastructure layer, you can focus on building better software while maintaining a safe and stable environment for your users.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Traffic%20Splitting%20Canary%20and%20A-B%20Deployments%20-%20Part%2010">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Traffic Splitting Canary and A-B Deployments - Part 10" and reviewed by me.

## Video - AKS Traffic Splitting Canary and A-B Deployments - Part 10

<iframe width="560" height="315" src="https://www.youtube.com/embed/HG5Qyfu_rSk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>