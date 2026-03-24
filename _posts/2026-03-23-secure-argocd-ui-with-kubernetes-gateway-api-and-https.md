---
title: Secure ArgoCD UI with Kubernetes Gateway API and HTTPS
date: 2026-03-23
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [Azure, AKS, Kubernetes, Cert-Manager, Gateway API, Envoy Gateway API, ArgoCD]
description: Learn how to secure your ArgoCD UI using the Kubernetes Gateway API and Cert-Manager for fully automated HTTPS and certificate management.
---

Securing the management interface of your continuous delivery tools is a critical step in hardening any Kubernetes environment. ArgoCD provides a powerful UI for managing deployments, but by default, it requires a bit of intentional configuration to achieve a robust, production-ready HTTPS setup. By leveraging the Kubernetes Gateway API and Cert-Manager, you can move away from manual certificate management and implement a "set it and forget it" solution where encryption is handled automatically.

## The Evolution of Traffic Management

For years, the Ingress API was the standard for managing external access to cluster services. However, as infrastructure requirements have grown more complex, the Kubernetes Gateway API has emerged as a more expressive and role-oriented successor. It allows for better separation of concerns between infrastructure providers and application developers, making it the ideal choice for modern traffic routing and TLS termination.

## Establishing the Gateway Infrastructure

The process begins with a Gateway controller, such as Envoy, which acts as the entry point for your cluster. Unlike traditional setups where each application might handle its own certificates, the Gateway API allows you to define listeners for both HTTP and HTTPS at the infrastructure level. This centralized approach simplifies how you manage public IP addresses and DNS records, as all traffic flows through a unified, high-performance entry point.

## Automating Trust with Cert-Manager

To avoid the operational burden of manual certificate renewals, Cert-Manager is integrated into the workflow. By configuring a ClusterIssuer—typically using Let's Encrypt—you establish a system that can automatically prove domain ownership and request TLS certificates. 

When using the Gateway API, Cert-Manager monitors your Gateway resources. Once a listener is defined with a specific hostname, Cert-Manager coordinates with the ACME server to fulfill the challenge, retrieves the certificate, and stores it as a Kubernetes Secret. From that point forward, the system handles renewals 30 days before expiration without any manual intervention.

## Optimizing ArgoCD for Gateway Integration

A common point of confusion when securing ArgoCD is how it handles internal traffic. By default, ArgoCD expects encrypted communication. However, when a Gateway or Load Balancer is terminating TLS at the edge of the cluster, the internal traffic from the Gateway to the ArgoCD service typically switches to standard HTTP.

To accommodate this, ArgoCD must be configured to run in an insecure mode. This doesn't mean your connection is unsafe; rather, it signals to ArgoCD that it should stop expecting HTTPS on its local port because the encryption is already being managed by the Gateway. This configuration is essential for preventing "too many redirects" errors and ensuring a smooth handshake between your infrastructure and the application.

## Routing Traffic via HTTPRoute

The final piece of the architecture is the HTTPRoute resource. This resource serves as the bridge between the Gateway and the ArgoCD service. It defines the specific hostname and routing rules required to send traffic to the correct backend. By pointing the HTTPRoute to the ArgoCD server service, you complete the chain: external HTTPS traffic hits the Gateway, the certificate is validated, and the request is securely forwarded to the UI.

## Conclusion

Transitioning to the Kubernetes Gateway API for securing ArgoCD not only modernizes your traffic management but also drastically reduces the risk of downtime caused by expired certificates. Once the initial handshake between the Gateway, Cert-Manager, and the HTTPRoute is established, your administrative UI remains secure and accessible, allowing you to focus on deploying software rather than managing infrastructure secrets.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Secure%20ArgoCD%20UI%20with%20Kubernetes%20Gateway%20API%20and%20HTTPS">GitHub</a>.

This post was AI-generated based on the transcript of the video "Secure ArgoCD UI with Kubernetes Gateway API and HTTPS".

## Video - Secure ArgoCD UI with Kubernetes Gateway API and HTTPS

<iframe width="560" height="315" src="https://www.youtube.com/embed/Of8z4glEFVk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>