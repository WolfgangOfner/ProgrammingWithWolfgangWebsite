---
title: Speaking about the Kubernetes Gateway API at the Warsaw IT Days 2026
date: 2026-03-05
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress]
description: Learn to master the Kubernetes Gateway API at Warsaw IT Days 2026. Explore traffic engineering, compare proxies, and automate HTTPS with cert-manager.
---

I am pleased to announce another session I will be presenting at [Warsaw IT Days 2026](https://warszawskiedniinformatyki.pl/en/). This technical deep dive into the evolution of Kubernetes networking will be available as a Video on Demand (VOD) starting **March 19, 2026**.

For years, Kubernetes Ingress has been the standard for managing external access to services. However, as requirements grow more complex, teams often find themselves managing a fragile web of vendor-specific annotations. The Kubernetes Gateway API addresses these challenges by offering an expressive, role-oriented standard that fundamentally rethinks the networking stack.

In my session, **"Beyond Ingress: Mastering the Kubernetes Gateway API,"** we will look at how this modular resource model provides a cleaner separation of concerns between infrastructure, DevOps, and development teams.

## What We Will Cover

This presentation is designed to provide practical, implementation-ready insights into modern traffic management. Key topics include:

* **Modular Resource Models:** Breaking down the Gateway API structure to understand how it differs from traditional Ingress.
* **Controller Comparisons:** A technical look at in-cluster proxies like Traefik, Envoy, and Nginx versus managed solutions like Azure Application Gateway for Containers.
* **Traffic Engineering:** How to implement native patterns such as canary splits and path-based routing without complex workarounds.
* **Automated Security:** The specific technical steps for automating HTTPS via cert-manager within the Gateway API framework.

## Why Join This Session?

The goal of this session is to move beyond the theory and ensure you understand exactly how the Gateway API functions in a real-world environment. You will walk away with the knowledge required to implement a fully automated, secure, and easier-to-manage networking stack.

You can catch this session and many others starting **March 19, 2026**, on the [Warsaw IT Days platform](https://warszawskiedniinformatyki.pl/en/).

Check out the session on **March 19, 2026**, via the
<href="https://warszawskiedniinformatyki.pl/en/" target="_blank" rel="noopener noreferrer">Warsaw IT Days portal</a>.

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Warsaw%20IT%20Days/Beyond%20Ingress%20-%20Mastering%20the%20Kubernetes%20Gateway%20API" target="_blank" rel="noopener noreferrer">GitHub</a>.

<!-- ## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Beyond Ingress: Mastering the Kubernetes Gateway API

For years, Kubernetes Ingress has been the default, yet it often forces teams into a fragile web of vendor-specific "annotation hell" to handle modern traffic requirements. The Gateway API moves beyond these limitations, offering an expressive, role-oriented standard that fundamentally rethinks the networking stack. 

This session demonstrates why the Gateway API is the superior choice by breaking down its modular resource model, from core infrastructure components to granular routing definitions, and showing how it resolves the friction between platform, DevOps, and development teams.

This session compares in-cluster proxies like Traefik, Envoy, and Nginx against managed controllers like Azure Application Gateway for Containers. The presentation provides practical insights into native traffic engineering patterns, such as canary splits and path-based routing, alongside the specific technical steps for automating HTTPS via cert-manager. 

By breaking down the integration between these components, the session ensures participants understand exactly how the Gateway API functions and how to implement a fully automated, secure, and easier-to-manage networking stack independently.