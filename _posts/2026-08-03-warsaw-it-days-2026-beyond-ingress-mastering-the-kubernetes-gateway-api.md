---
title: Warsaw IT Days 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API
date: 2026-08-03
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Gateway API, Ingress, Envoy Gateway API]
description: Learn how GatewayClass, Gateway, and HTTPRoute replace standard Ingress for modular routing and canary deployments.
---

Managing TLS certificates across dynamic cloud environments can quickly become an operational headache. While traditional Kubernetes Ingress handles basic routing and SSL termination, modern platform architectures demand a cleaner separation of concerns and stronger multi-tenant governance. That is where the Kubernetes Gateway API comes in, and pairing ListenerSet with cert-manager creates an elegant, fully automated TLS architecture.

## The Evolution Beyond Traditional Ingress

Traditional Ingress resources bind routing rules, hostnames, and TLS configurations into a single monolithic object. This approach forces platform teams to grant application developers access to sensitive TLS secret configurations or requires platform engineers to manually touch every routing rule. 

The Kubernetes Gateway API solves this by splitting responsibilities into distinct resources managed by different roles:

* **GatewayClass**: Defined by infrastructure providers to specify the underlying controller implementation.
* **Gateway**: Managed by platform engineers to define physical entry points, network boundaries, and listening ports.
* **HTTPRoute**: Managed by application developers to route traffic to specific backend microservices.

## Where ListenerSet Enters the Picture

As environments scale, managing port definitions and listener configurations on a single Gateway resource can still create friction between teams. The ListenerSet custom resource allows platform teams to dynamically compose and attach listeners to an existing Gateway without modifying the central Gateway object itself.

Key benefits of using ListenerSet include:

* **Modular Listener Management**: Add or modify ports and protocol configurations independently.
* **Decoupled Security Policies**: Define distinct TLS termination settings per listener scope.
* **Team Autonomy**: Enable different operational units to expose endpoints without touching central cluster configurations.

## Automating TLS with cert-manager

Integrating cert-manager into this architecture brings hands-off lifecycle management for your certificates. By attaching Issuer references or annotations directly to your listener configurations, cert-manager automatically provisions, validates, and rotates TLS certificates using ACME providers like Let's Encrypt or an internal Certificate Authority.

The end-to-end operational workflow functions seamlessly:

1. A platform engineer defines the Gateway and attaches a ListenerSet requesting a secure TLS listener.
2. cert-manager detects the new listener definition and generates a Certificate resource.
3. The certificate authority validates the domain challenge and issues the x509 certificate.
4. The generated TLS secret is automatically bound to the Gateway for encrypted traffic termination.

## Conclusion

Combining the modular governance of the Gateway API and ListenerSet with the hands-free automation of cert-manager gives platform engineering teams a robust, production-grade edge architecture. Decoupling routing definitions from certificate management eliminates manual updates, prevents downtime from expired SSL certificates, and establishes clear operational boundaries across scaling engineering teams.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Warsaw%20IT%20Days%202026%20-%20Beyond%20Ingress%20-%20Mastering%20the%20Kubernetes%20Gateway%20API">GitHub</a>.

This post was AI-generated based on the transcript of the video "Warsaw IT Days 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API".

## Video - Warsaw IT Days 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API

<iframe width="560" height="315" src="https://www.youtube.com/embed/H7I6bHU_EOA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>