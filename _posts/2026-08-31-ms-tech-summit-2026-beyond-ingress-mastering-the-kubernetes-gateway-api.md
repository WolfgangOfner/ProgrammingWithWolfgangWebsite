---
title: MS Tech Summit 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API
date: 2026-08-31
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Gateway API, Envoy Gateway API]
description: An architectural guide comparing traditional Kubernetes Ingress with the modern Gateway API. Explore core resource models, modular role separation, advanced traffic splitting, controller implementations, and migration recommendations for cloud-native applications.
---

For years, the standard Kubernetes Ingress resource has served as the default gateway for routing external HTTP and HTTPS traffic into containerized workloads. While Ingress simplified cluster entry points compared to exposing multiple public IP addresses, modern enterprise architectures have exposed its fundamental structural limits. 

At MS Tech Summit 2026, Microsoft MVP and Cloud Architect Wolfgang presented a deep dive into the **Kubernetes Gateway API**—the official successor to Ingress that reached General Availability (GA) in late 2023. This post explores the architectural evolution from traditional Ingress to the Gateway API, breaks down its core components, compares available controllers, and provides guidance on when to migrate.

## The Limitations of Traditional Kubernetes Ingress

To understand why the Gateway API was created, it helps to examine where traditional Ingress falls short in production environments.

* **Monolithic Object Design:** Ingress combines infrastructure definition, TLS configuration, and routing rules into a single API object. In large clusters with dozens of application teams, this creates a single point of failure where a single typo can disrupt routing across the entire cluster.
* **Over-reliance on Annotations:** Because the core Ingress API specification is limited, vendor-specific features (such as rewrite target rules, rate limiting, or custom timeouts) rely heavily on annotations. Switching from an NGINX Ingress controller to Traefik or an enterprise load balancer often requires rewriting annotations across every application manifest.
* **Lack of Role Separation:** In real-world organizations, cluster infrastructure (managed by Ops or Platform teams) and application routing logic (managed by Application Developers) are handled by different roles. Ingress forces both personas to edit the exact same manifest files.
* **Strict Namespace Boundaries:** Traditional Ingress requires TLS secrets to reside in the same namespace as the Ingress resource, making enterprise-wide TLS certificate management with tools like cert-manager unnecessarily complex.
* **Protocol Restrictions:** Ingress was designed primarily for HTTP and HTTPS traffic, offering weak or non-standard support for protocols like TCP, UDP, or gRPC.

## Architectural Breakdown of the Kubernetes Gateway API

The Kubernetes Gateway API addresses these challenges by introducing a modular, role-oriented resource model. Instead of forcing all routing logic into one manifest, it decouples infrastructure management from application routing using three primary custom resource definitions (CRDs).

### 1. GatewayClass (Infrastructure Provider Role)
Managed by the Cluster Operator or Cloud Administrator, the `GatewayClass` defines the underlying controller implementation running in the cluster (e.g., Envoy Gateway, NGINX Gateway Fabric, or Azure Application Gateway for Containers). 

Application manifests reference the `GatewayClass` by name. If the platform team decides to swap the underlying controller, application teams do not need to alter their routing manifests—only the single `GatewayClass` reference is updated.

### 2. Gateway (Platform/Ops Team Role)
The `Gateway` resource defines the entry point for traffic entering the cluster. Managed by infrastructure operators, it binds to a specific `GatewayClass` and specifies:
* **Listeners:** Active ports (e.g., port 80 for HTTP, port 443 for HTTPS) and accepted protocols.
* **Allowed Namespaces:** Restrictions on which namespaces are permitted to attach routes to the gateway.
* **TLS Termination & Certificates:** Connections to certificate management systems like cert-manager to automatically generate and renew TLS certificates stored in dedicated secrets.

### 3. Routes (Application Developer Role)
`Route` objects are created by application developers to attach application-specific routing rules to a `Gateway`. Because routes are decoupled from the gateway infrastructure, developers can safely manage their own application endpoints inside their own namespaces without risk of corrupting cluster-wide routing.

The Gateway API provides protocol-specific route resources:
* **HTTPRoute:** Handles HTTP/HTTPS traffic, URL path matching (prefix or exact), header matching, query parameters, HTTP method matching, URL rewriting, and redirects.
* **GRPCRoute:** Native support for gRPC microservice routing.
* **TLSRoute / TCPRoute / UDPRoute:** Direct layer 4 routing for non-HTTP services.

## Advanced Traffic Management Features

Beyond role separation, the Gateway API brings advanced traffic control features into standard Kubernetes custom resources without relying on custom vendor annotations:

### Path Matching & URL Rewriting
Developers can configure exact or prefix-based path rules to route traffic to specific microservices. For example, requests starting with administrative paths can be directed to dedicated backend services with restricted network policies, while public web traffic routes to front-end deployments. URL path rewrite capabilities allow seamless migration of legacy endpoint structures without breaking external links.

### Weighted Traffic Splitting (Canary Deployments & A/B Testing)
Within an `HTTPRoute` definition, developers can specify relative weights for multiple backend services. By distributing traffic proportionally (e.g., 80% to an existing production version and 20% to a canary release), teams can perform live validation of new releases and roll back instantly by updating traffic weights—without restarting pods or reconfiguring DNS records.

## Controller Ecosystem & Cloud Integration

The Gateway API ecosystem has matured rapidly, offering both open-source and cloud-native controller options:

* **Envoy Gateway:** A highly popular open-source choice that offers simple Helm-based deployment, lightweight pod footprints, and clean integration with cloud load balancers.
* **NGINX Gateway Fabric & Traefik:** Native Gateway API implementations from established ingress vendors, allowing teams to leverage familiar underlying proxies.
* **Azure Application Gateway for Containers (ALB):** A fully managed cloud solution where an in-cluster ALB controller provisions and manages off-cluster Azure Application Gateway resources. This offloads traffic processing overhead from cluster nodes while providing native integration with Azure Web Application Firewall (WAF), autoscaling, and Azure Monitor / Managed Prometheus.

## Ingress vs. Gateway API: Detailed Comparison

| Feature | Traditional Ingress | Kubernetes Gateway API |
| :--- | :--- | :--- |
| **Architecture** | Monolithic object model | Decoupled & modular (GatewayClass, Gateway, Route) |
| **Role Separation** | None (Ops & Devs edit same spec) | Native (Cluster Ops manage Gateway, Devs manage Routes) |
| **Portability** | Low (heavy reliance on vendor annotations) | High (standardized spec across all controllers) |
| **Protocol Support** | HTTP, HTTPS | HTTP, HTTPS, gRPC, TCP, UDP, TLS |
| **Traffic Splitting** | Requires custom controller annotations | Native weighted backend references |
| **Namespace Scope** | Single namespace for secrets/ingress | Cross-namespace route binding & certificate resolution |
| **Ecosystem Maturity** | Legacy standard (widely used) | GA standard (future direction of Kubernetes) |

## Migration Strategy & Recommendations

Should you immediately migrate your existing production workloads to the Gateway API?

1. **For Existing, Stable Applications:** If your current Ingress configuration is stable, simple, and meeting team needs, there is no immediate necessity to rewrite working manifests.
2. **For Growing & Multi-Tenant Clusters:** If you manage large enterprise clusters with separate infrastructure and application development teams, adopting the Gateway API eliminates configuration collisions and simplifies RBAC permissions.
3. **For New Kubernetes Deployments:** All new Kubernetes clusters and greenfield projects should standardize on the Gateway API to take advantage of portable routing definitions, native protocol support, and forward-compatible tooling.

## Conclusion

The Kubernetes Gateway API represents a major evolutionary leap for cloud-native networking. By separating infrastructure responsibilities from application routing, standardizing advanced capabilities like canary traffic splitting, and expanding native support beyond basic HTTP traffic, it solves the long-standing maintenance and vendor lock-in issues of traditional Ingress. As controller implementations across open-source tools and cloud providers continue to mature, adopting the Gateway API ensures your Kubernetes platforms remain modular, secure, and ready for modern enterprise scale.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/MS%20Tech%20Summit%202026%20-%20Beyond%20Ingress%20-%20Mastering%20the%20Kubernetes%20Gateway%20API">GitHub</a>.

This post was AI-generated based on the transcript of the video "MS Tech Summit 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API".

## Video - MS Tech Summit 2026 - Beyond Ingress - Mastering the Kubernetes Gateway API

<iframe width="560" height="315" src="https://www.youtube.com/embed/Bw3BM0D7XXw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>