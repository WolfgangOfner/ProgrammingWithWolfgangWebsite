---
title: Speaking about the Kubernetes Gateway API at the MS Tech Summit 2026
date: 2026-04-12
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress]
description: Learn to master the Kubernetes Gateway API at the MS Tech Summit 2026. Explore traffic engineering, compare proxies, and automate HTTPS with cert-manager.
---

If you have ever spent hours debugging a fragile web of vendor-specific YAML annotations just to get basic path routing or a canary split working in Kubernetes, you know the pain of legacy Ingress. It’s messy, it scales poorly, and it forces platform teams and developers to step on each other's toes.

I am excited to announce that I will be speaking at [MS Tech Summit 2026](https://mstechsummit.pl/en/)! 

My session, **"Beyond Ingress: Mastering the Kubernetes Gateway API,"** will be dropping as a Video on Demand (VOD) on **June 15, 2026**. If you want to move past "annotation hell" and build a modern, role-oriented networking stack, you won’t want to miss it.

## What the Session is About

The Gateway API isn't just an upgrade to Ingress; it’s a complete rethinking of the Kubernetes networking stack. It introduces an expressive, modular resource model that separates infrastructure management from application routing, bringing true sanity to multi-tenant clusters.

In this deep dive, we skip the high-level fluff and get straight into the implementation mechanics. Here is exactly what we are covering:

* **The Modular Resource Model:** How the Gateway API cleanly divides responsibilities between platform engineers, cluster operators, and application developers.
* **In-Cluster vs. Managed Controllers:** A direct comparison of in-cluster proxies like **Traefik, Envoy, and Nginx** against managed cloud controllers like **Azure Application Gateway for Containers**.
* **Advanced Traffic Engineering:** Practical, hands-on insights into native routing patterns, including path-based routing and zero-friction canary splits.
* **Automated Security:** The specific technical steps required to wire up **cert-manager** for fully automated HTTPS and certificate lifecycle management.

## Why This Matters for Teams using Kubernetes

As platforms scale, the friction between infrastructure owners and development teams usually increases. The Gateway API resolves this by giving platform engineers control over the entry points (Gateways) while allowing developers to safely manage their own routing rules (HTTPRoutes) without breaking the cluster.

By the end of this presentation, you will have a clear, step-by-step understanding of how the Gateway API functions under the hood and exactly how to implement a secure, fully automated, and easier-to-manage infrastructure layer on your own.

## Mark Your Calendar

* **Event:** [MS Tech Summit 2026](https://mstechsummit.pl/en/)
* **Session Type:** Video on Demand (VOD)
* **Release Date:** June 15, 2026

Keep an eye on the summit portal, and get ready to leave legacy Ingress configs behind for good!

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20MS%20Tech%20Summit" target="_blank" rel="noopener noreferrer">GitHub</a>.

<!-- ## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Beyond Ingress: Mastering the Kubernetes Gateway API

For years, Kubernetes Ingress has been the default, yet it often forces teams into a fragile web of vendor-specific "annotation hell" to handle modern traffic requirements. The Gateway API moves beyond these limitations, offering an expressive, role-oriented standard that fundamentally rethinks the networking stack. 

This session demonstrates why the Gateway API is the superior choice by breaking down its modular resource model, from core infrastructure components to granular routing definitions, and showing how it resolves the friction between platform, DevOps, and development teams.

This session compares in-cluster proxies like Traefik, Envoy, and Nginx against managed controllers like Azure Application Gateway for Containers. The presentation provides practical insights into native traffic engineering patterns, such as canary splits and path-based routing, alongside the specific technical steps for automating HTTPS via cert-manager. 

By breaking down the integration between these components, the session ensures participants understand exactly how the Gateway API functions and how to implement a fully automated, secure, and easier-to-manage networking stack independently.