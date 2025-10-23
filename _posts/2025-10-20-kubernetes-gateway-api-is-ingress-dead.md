---
title: Kubernetes Gateway API - Is Ingress dead? - Part 1
date: 2025-10-20
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers]
description: Understand why the Kubernetes Gateway API replaces Ingress. Learn about its modular design, role separation, and how it standardizes traffic management.
---

For years, the Kubernetes Ingress API has been the standard way to expose applications to the external world, providing features like HTTP routing and automated TLS. It was a significant step up from simply using a LoadBalancer service, but as Kubernetes matured and enterprise needs grew, its limitations became clear.

The new Gateway API has emerged as the true successor to Ingress. While it may not kill off Ingress immediately—especially for small teams—it is undeniably the path forward for secure, complex, and standardized traffic management in cloud-native environments.

## The Limitations of the Ingress API

The Ingress API, while simple, suffered from a few critical flaws that made it difficult to scale and maintain in larger organizations:

- **Vendor Lock-In:** The Ingress specification was too minimal, forcing controller vendors (like NGINX, Traefik, etc.) to rely heavily on annotations to expose unique features. These annotations are unique to each vendor, meaning switching controllers requires rewriting every single Ingress resource in your cluster.
- **Security and Modularity:** The Ingress object forces operators and developers to configure networking rules in the same place. This lack of role separation can be a security risk and leads to giant, complex configuration files that are difficult to manage in large, multi-team clusters.
- **Namespace Constraints:** It often required TLS secrets to live in the same namespace as the application, complicating security boundaries and secret management.

These issues ultimately made the Ingress API less of a portable standard and more of a common configuration pattern with vendor-specific strings attached.

## The Gateway API: A Standardized Solution

The Gateway API was designed as an evolution of Ingress, specifically addressing the pain points above by focusing on modularity and role separation.

The biggest advantage is the API’s commitment to standardization. It uses flexible, built-in resources for routing that eliminate the reliance on vendor-specific annotations. This ensures that a routing rule written for one Gateway controller (or "implementation") will work for any other, promoting true portability and preventing vendor lock-in.

Furthermore, the Gateway API is designed to be Namespace-independent, allowing platform teams to manage core security components like TLS certificates in a secure infrastructure namespace, while application developers reference them from their own application namespaces.

## A New, Role-Based Structure

The Gateway API achieves this separation of concerns by introducing three primary, modular resources, clearly defining responsibilities for different teams (Infrastructure, Security, and Application):

- **GatewayClass:** This is the highest-level, global resource. It defines the specific controller or service that will handle the traffic (e.g., Azure Application Gateway for Containers, NGINX, or Traefik). It acts as a blueprint for all Gateway resources.
- **Gateway:** This resource defines the actual network listening point—the "front door." It is configured by the Infrastructure or Security team, specifying listeners (ports, protocols) and referencing the TLS certificates used for termination.
- **Routes (e.g., HTTPRoute):** Configured by the Application team, this object defines the rules for incoming traffic. It binds to a Gateway and dictates how requests are forwarded to backend services based on advanced criteria like path, HTTP headers, or query parameters.

By splitting the configuration across these three resources, the Gateway API ensures that a change to an application’s routing rules cannot accidentally impact the core network infrastructure, and vice versa.

## Conclusion

The Kubernetes Gateway API is not a simple version 2.0 of Ingress; it's a fundamental redesign built for the complexity of modern cloud-native applications.

For smaller teams with simple routing needs, the Ingress API remains a viable, easy-to-use option. However, for organizations dealing with multiple development teams, strict security requirements, complex routing logic, or a desire to future-proof their infrastructure, the Gateway API is the superior standard. Its standardized nature, strong role separation, and modularity make it the clear long-term choice for traffic management on Kubernetes.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Kubernetes%20Gateway%20API%20-%20Is%20Ingress%20dead%20-%20Part%201" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Kubernetes Gateway API - Is Ingress dead? - Part 1" and reviewed by me.

## Video - Kubernetes Gateway API - Is Ingress dead? - Part 1

<iframe width="560" height="315" src="https://www.youtube.com/embed/dgQQpJq1asc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>