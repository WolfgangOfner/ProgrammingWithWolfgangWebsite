---
title: Speaking about the Kubernetes Gateway API at the Azure Cloud Commanders Meetup
date: 2026-04-27
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress]
description: Learn to master the Kubernetes Gateway API at the Azure Cloud Commanders Meetup. Explore traffic engineering, compare proxies, and automate HTTPS with cert-manager.
---

For years, Kubernetes Ingress has been the default standard for traffic management. But as clusters grow, teams often find themselves trapped in a fragile web of vendor-specific "annotation hell" just to handle modern routing requirements. 

I recently sat down with the **Azure Cloud Commanders** community to discuss why it’s time to move past legacy Ingress limitations and embrace the **Kubernetes Gateway API**. 

If you missed the live broadcast on May 25th, you can find the event details, community discussion, and resources over on the Microsoft Tech Community portal.

[Access the Azure Cloud Commanders Event Page](https://techcommunity.microsoft.com/event/905f6364-959b-4f0a-bb85-10c14d665ed6/mastering-the-kubernetes-gateway-api/4518588)

### What We Covered:
* **Rethinking the Networking Stack:** Why the Gateway API offers a fundamentally superior, expressive, and role-oriented standard for modern traffic engineering.
* **The Modular Resource Model:** Breaking down the clean separation of duties between platform engineers (infrastructure/Gateways) and developers (routing rules/HTTPRoutes).
* **Resolving Multi-Tenant Friction:** How this structural split eliminates configuration cross-talk and empowers application teams without breaking cluster-wide security boundaries.

Whether you are looking to simplify your platform architecture or searching for a more secure way to manage multi-tenant routing, this talk breaks down the exact mechanics behind the shift.

👉 Read the event overview and connect with the community here: [Microsoft Tech Community Event Hub](https://techcommunity.microsoft.com/event/905f6364-959b-4f0a-bb85-10c14d665ed6/mastering-the-kubernetes-gateway-api/4518588)

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Azure%20Cloud%20Commanders/Beyond%20Ingress%20-%20Mastering%20the%20Kubernetes%20Gateway%20API" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/cpzYH_Xk_xw?si=f85WjKS_qI9zHTxx" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

The abstract for my session is as follows:

## Beyond Ingress: Mastering the Kubernetes Gateway API

For years, Kubernetes Ingress has been the default, yet it often forces teams into a fragile web of vendor-specific "annotation hell" to handle modern traffic requirements. The Gateway API moves beyond these limitations, offering an expressive, role-oriented standard that fundamentally rethinks the networking stack. 

This session demonstrates why the Gateway API is the superior choice by breaking down its modular resource model, from core infrastructure components to granular routing definitions, and showing how it resolves the friction between platform, DevOps, and development teams.

This session compares in-cluster proxies like Traefik, Envoy, and Nginx against managed controllers like Azure Application Gateway for Containers. The presentation provides practical insights into native traffic engineering patterns, such as canary splits and path-based routing, alongside the specific technical steps for automating HTTPS via cert-manager. 

By breaking down the integration between these components, the session ensures participants understand exactly how the Gateway API functions and how to implement a fully automated, secure, and easier-to-manage networking stack independently.