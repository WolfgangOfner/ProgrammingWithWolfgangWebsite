---
title: Speaking about scaling Kubernetes Workloads with KEDA at the Welsh Azure User Group
date: 2023-02-27
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Kubernetes, DevOps, KEDA]
description: Learn how to scale your applications with Azure Kubernetes Service and KEDA. Also use KEDA to scale your Azure DevOps Agents running inside a Kubernetes cluster.
---

I'm excited to announce that I'll be giving a talk at the Welsh Azure User Group meetup on March 15th, 2023! The topic of my session is "Scaling Your Applications with Azure Kubernetes Service and KEDA"

In today's world, it's important for service-oriented applications to be able to handle varying loads. This is crucial for providing users with a good experience and for keeping costs under control. Kubernetes offers a solution to this problem through the Horizontal Pod Autoscaler, but what about applications that need to respond to external events? That's where KEDA comes in.

During my talk, we'll explore how to use Azure Kubernetes Service and KEDA to create and configure autoscalers for your applications. We'll go over practical examples and cover everything from responding to new messages in a queue to metrics in Azure Monitor. I'll also be discussing how to configure Kubernetes for "scale to 0" to run your application only when needed.

If you're an application developer or operations manager looking to ensure that your applications can respond to events and scale accordingly, this talk is for you! So, mark your calendars and sign up on <a href="https://www.meetup.com/msft-stack/events/290761064/?_xtd=gqFyqTMxMDU3NzA5N6Fwo2FwaQ%253D%253D&from=ref" target="_blank" rel="noopener noreferrer">Meetup</a>. I can't wait to see you there!

The abstract for my session is as follows:

## Level Up your Kubernetes Scaling with KEDA

Whether it is a normal workday or Black Friday, service-oriented applications must be able to handle varying loads. This is the only way to ensure that users are provided with a good experience and that costs are kept to a minimum.

Kubernetes offers a way to vary the number of application instances running based on CPU or RAM utilization with the Horizontal Pod Autoscaler. However, modern applications often depend on a variety of components and should be able to respond to external events. These may include new messages in a queue or metrics in Azure Monitor.
As an application developer or operation manager, what do I need to consider to ensure that my application can respond to these events? How can I configure Kubernetes for “scale to 0” to run my application only when needed?

Using Azure Kubernetes Service and KEDA (Kubernetes Event-driven Autoscaling), this session will show with practical examples how to create and configure autoscalers to respond to external events and scale applications in Kubernetes accordingly.

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/blob/main/2023%20-%20Welsh%20Azure%20User%20Group/Level%20Up%20your%20Kubernetes%20Scaling%20with%20KEDA.pdf" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the meetup on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/dXjTw7OeEiU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>