---
title: Speaking about scaling Workloads and Azure DevOps Agents running in Kubernetes with KEDA at the DevOps Pro Europe 2023 Conference
date: 2023-04-24
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Kubernetes, DevOps, KEDA, Azure DevOps]
description: Learn how to scale your applications with Azure Kubernetes Service and KEDA. Also use KEDA to scale your Azure DevOps Agents running inside a Kubernetes cluster.
---

I'm excited to announce that I will be speaking at the upcoming DevOps Pro Europe 2023 conference in Vilnius, Lithuania. My session, titled "Level Up your Kubernetes Scaling with KEDA", will be held online on May 24, 2023.

In my session, we will discuss the importance of handling varying loads in service-oriented applications and the challenges modern applications face. We will explore how Kubernetes offers a way to vary the number of application instances running based on CPU or RAM utilization with the Horizontal Pod Autoscaler, but how this may not be enough. We will dive into how external events can impact application scaling and how we can configure Kubernetes for "scale to 0" to run applications only when needed.

Throughout the session, I will provide practical examples of how to create and configure autoscalers using Azure Kubernetes Service and KEDA (Kubernetes Event-driven Autoscaling) to respond to external events and scale applications in Kubernetes accordingly.

You can find my session <a href="https://events.pinetool.ai/2928/#sessions/99181" target="_blank" rel="noopener noreferrer">here</a>. Don't miss out on this opportunity to learn about Kubernetes scaling with KEDA. I hope to see you there!

The abstract for my session is as follows:

## Bring DevOps to the Swiss Alps

Whether it is a normal workday or Black Friday, service-oriented applications must be able to handle varying loads. This is the only way to ensure that users are provided with a good experience and that costs are kept to a minimum. 

Kubernetes offers a way to vary the number of application instances running based on CPU or RAM utilization with the Horizontal Pod Autoscaler. However, modern applications often depend on a variety of components and should be able to respond to external events. These may include new messages in a queue or metrics in Azure Monitor. As an application developer or operation manager, what do I need to consider to ensure that my application can respond to these events? How can I configure Kubernetes for “scale to 0” to run my application only when needed? 

Using Azure Kubernetes Service and KEDA (Kubernetes Event-driven Autoscaling), this session will show practical examples of how to create and configure autoscalers to respond to external events and scale applications in Kubernetes accordingly. 

<!-- ## Slides of the Talk

You can find the slides of the talk on <a href="XXX" target="_blank" rel="noopener noreferrer">GitHub</a>. -->