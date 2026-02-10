---
title: Video - NGINX Ingress & Cert Manager - The Legacy Way vs Gateway API - Part 17
date: 2026-02-09
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Nginx Ingress, Ingress, Cert-Manager]
description: Discover how to automate HTTPS for Kubernetes with Envoy Gateway and Cert-Manager. Learn to provision TLS certificates without manual certificate objects.
---

As we approach the end of our deep dive into the Kubernetes Gateway API, it's important to look back at the standard that paved the way: **NGINX Ingress**. For years, Ingress has been the go-to solution for routing traffic and managing TLS certificates with Cert-Manager. But with the rise of the Gateway API, is the "Legacy Way" still relevant?

In this part of the series, we provide a direct comparison by setting up a classic NGINX Ingress environment, complete with automated HTTPS via Cert-Manager, to see how it stacks up against the modern standards we've explored.

## The "Magic" of Ingress Annotations

One of the most notable differences when working with NGINX Ingress is the heavy reliance on **Annotations**. In a traditional Ingress setup, a few lines of metadata tell the controller everything it needs to know—from which ingress class to use to which Cert-Manager issuer should handle the TLS certificate.

For many, this feels like "magic." You deploy a single Ingress object, and the controller handles the routing and security in the background. While this simplicity is attractive, it can also make troubleshooting difficult. When things go wrong, the lack of explicit resources can leave you digging through logs to understand why a certificate wasn't issued or a route wasn't created.

## Gateway API: Transparency over Magic

The Gateway API takes a different approach by breaking down these responsibilities into distinct, manageable resources: **GatewayClasses**, **Gateways**, and **HTTPRoutes**. 

While this may seem like more "boilerplate" YAML at first, it offers a level of transparency that Ingress lacks. Each object has its own status and events, making it much easier to pinpoint exactly where a configuration error lies. Furthermore, the Gateway API supports multi-namespace configurations out of the box, allowing for a clean separation of concerns between infrastructure and development teams—a feat that is much more cumbersome with standard Ingress.

## Is it Time to Migrate?

With NGINX Ingress (specifically the community version) reaching its End of Life (EOL) in March 2026, the question of migration is more relevant than ever. 

If you are starting a fresh project today, the **Gateway API** is the clear choice. It is the future-proof standard designed to handle the complexities of modern, multi-team Kubernetes environments. However, for those already running stable Ingress setups, the transition doesn't need to happen overnight—but understanding the differences is the first step toward a more robust networking architecture.

## Conclusion

This comparison serves as a reminder of how far Kubernetes networking has come. While NGINX Ingress helped us get to where we are, the Gateway API provides the structure and scalability needed for what comes next. As we wrap up this series, we'll take these lessons and summarize the best practices for moving your production workloads to the new standard.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Nginx%20Ingress%20%26%20Cert-Manager%20-%20The%20Legacy%20Way%20vs.%20Gateway%20API%20-%20Part%2017">GitHub</a>.

This post was AI-generated based on the transcript of the video "NGINX Ingress & Cert Manager - The Legacy Way vs Gateway API - Part 17" and reviewed by me.

## Video - NGINX Ingress & Cert Manager - The Legacy Way vs Gateway API - Part 17

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZLUCt4yhe0Q" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>