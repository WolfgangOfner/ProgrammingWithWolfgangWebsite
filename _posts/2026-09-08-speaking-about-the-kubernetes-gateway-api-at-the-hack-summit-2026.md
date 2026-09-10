---
title: Speaking about the Kubernetes Gateway API at The Hack Summit 2026
date: 2026-09-08
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress]
description: Watch my VOD session at The Hack Summit 2026 to master the Kubernetes Gateway API, ditch annotation hell, and automate HTTPS with cert-manager.
---

I am presenting at **[The Hack Summit 2026](https://thehacksummit.com/en)**! My session, **"Beyond Ingress: Mastering the Kubernetes Gateway API,"** goes live as a Video on Demand (VOD) session on **November 5th, 2026**.

For years, Kubernetes Ingress served as the default networking solution. However, as traffic management requirements grew more complex, teams quickly found themselves trapped in a web of vendor-specific "annotation hell." The Kubernetes Gateway API fundamentally rethinks this stack with an expressive, role-oriented standard that brings clean separation of concerns between platform teams, cluster operators, and developers.

In this deep-dive session, I unpack why the Gateway API is the superior choice for modern workloads and demonstrate how to transition to a flexible, fully automated networking architecture.

## Key Topics Covered

* **Architecture & Resource Model:** How Gateway API replaces brittle Ingress annotations with a modular, role-focused hierarchy.
* **In-Cluster vs. Managed Proxies:** A head-to-head evaluation of self-hosted options (Traefik, Envoy, Nginx) against managed cloud controllers like Azure Application Gateway for Containers.
* **Native Traffic Engineering:** Hands-on patterns for executing canary traffic splits and advanced path-based routing without third-party workarounds.
* **Automated TLS Security:** Step-by-step guidance on automating end-to-end HTTPS issuance and renewal using `cert-manager`.

Whether you are designing enterprise platform architecture or running applications in production, this presentation delivers a concrete blueprint for modernizing your Kubernetes networking.

Catch the on-demand stream on November 5th by registering at **[The Hack Summit 2026](https://thehacksummit.com/en)**.

<!-- ## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Warsaw%20IT%20Days/Beyond%20Ingress%20-%20Mastering%20the%20Kubernetes%20Gateway%20API" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/H7I6bHU_EOA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Beyond Ingress: Mastering the Kubernetes Gateway API

For years, Kubernetes Ingress has been the default, yet it often forces teams into a fragile web of vendor-specific "annotation hell" to handle modern traffic requirements. The Gateway API moves beyond these limitations, offering an expressive, role-oriented standard that fundamentally rethinks the networking stack. 

This session demonstrates why the Gateway API is the superior choice by breaking down its modular resource model, from core infrastructure components to granular routing definitions, and showing how it resolves the friction between platform, DevOps, and development teams.

This session compares in-cluster proxies like Traefik, Envoy, and Nginx against managed controllers like Azure Application Gateway for Containers. The presentation provides practical insights into native traffic engineering patterns, such as canary splits and path-based routing, alongside the specific technical steps for automating HTTPS via cert-manager. 

By breaking down the integration between these components, the session ensures participants understand exactly how the Gateway API functions and how to implement a fully automated, secure, and easier-to-manage networking stack independently.