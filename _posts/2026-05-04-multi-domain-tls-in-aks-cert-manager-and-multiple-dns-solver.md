---
title: Multi Domain TLS in AKS - Cert Manager & Multiple DNS Solvers
date: 2026-05-04
author: Wolfgang Ofner
categories: [Youtube, Kubernetes, Cloud]
tags: [Azure, AKS, Cert-Manager, Azure DNS Zone]
description: Master Multi-Domain TLS in AKS using Gateway API, cert-manager, and DNS-01. Secure Azure DNS with passwordless Entra Workload Identity integration.
---

Managing TLS certificates for a single domain is a solved problem. However, as you scale an internal engineering platform, handling dozens of subdomains across multiple Azure DNS zones requires a more robust strategy.

In this guide, we move beyond legacy Ingress controllers and leverage the **Kubernetes Gateway API** along with **cert-manager** to automate certificate lifecycles via the DNS-01 challenge.

## The Modern Networking Stack
The Kubernetes Gateway API provides a more expressive, role-oriented way to manage traffic. By using **Envoy Gateway**, we gain a high-performance data plane that integrates natively with the Gateway API specification.

### Key Benefits:
*   **Role-Oriented:** Clear separation of concerns between infrastructure management and application routing.
*   **Expressiveness:** Native support for shared infrastructure and complex routing requirements.
*   **Scalability:** Streamlined management of multiple hostnames and TLS certificates within a single cluster.

## Secure Identity with Entra
Security should be a foundational element, not an afterthought. Instead of relying on long-lived secrets or service principal keys, this implementation utilizes **Entra Workload Identity**.

By linking the cert-manager ServiceAccount to an Azure Managed Identity through Federated Credentials, we grant cert-manager passwordless, fine-grained access. This allows it to solve DNS-01 challenges across your Azure DNS zones securely and automatically.

## The Multi-Solver ClusterIssuer
A common hurdle in multi-domain environments is routing the ACME challenge to the correct DNS zone. We address this by configuring a single **ClusterIssuer** equipped with multiple **DNS-01 solvers**.

Using selectors, we define exactly which Azure DNS zone should be used for specific domains. This approach centralizes your certificate logic while providing the flexibility to support a diverse range of DNS environments.

## Conclusion
Transitioning to a multi-domain TLS setup using the Gateway API standardizes your security posture and eliminates manual overhead. Whether you are supporting internal development teams or external-facing services, this architecture provides the consistency and security required for modern cloud-native platforms.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Multi-Domain%20TLS%20in%20AKS%20-%20Cert-Manager%20%26%20Multiple%20DNS%20Solvers">GitHub</a>.

This post was AI-generated based on the transcript of the video "Multi Domain TLS in AKS - Cert Manager & Multiple DNS Solvers".

## Video - Multi Domain TLS in AKS - Cert Manager & Multiple DNS Solvers

<iframe width="560" height="315" src="https://www.youtube.com/embed/k28q5bsKfwI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>