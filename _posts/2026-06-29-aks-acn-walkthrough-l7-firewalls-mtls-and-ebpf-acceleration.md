---
title: AKS ACNS Walkthrough - L7 Firewalls, mTLS, and eBPF Acceleration
date: 2026-06-29
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, AKS, Cilium, Advanced Container Networking Service, ACNS, mTLS, eBPF]
description: Discover how to supercharge your cluster using Azure Advanced Container Networking Services (ACNS) in AKS, featuring eBPF datapath acceleration, FQDN filtering, Layer 7 network policies, transparent mTLS, and native Hubble monitoring.
---

Kubernetes networking is widely considered one of the most complex domains in modern platform engineering. While basic container network interfaces handle essential pod communication, enterprise environments demand sophisticated security boundaries, granular protocol controls, and high-performance data planes. To bridge this gap, Microsoft introduced Advanced Container Networking Services (ACNS) for Azure Kubernetes Service (AKS). 

Building directly on top of the Azure CNI powered by Cilium, ACNS brings advanced eBPF capabilities, robust layer 7 enforcement, and out-of-the-box observability to production clusters. This analysis explores the structural features, performance advantages, and security capabilities offered by this advanced networking suite.

## Architectural Foundation and Cost Model

Before implementing ACNS, platform teams must account for specific underlying infrastructure prerequisites and licensing considerations:

* **Underlying Data Plane:** ACNS cannot operate in a vacuum. It requires an active Azure CNI powered by Cilium configuration underneath as its foundational networking layer.
* **Operating System Constraints:** The host nodes must leverage modern Linux kernels, specifically requiring either Azure Linux or Ubuntu 24.04 or newer to support the advanced eBPF hookpoints.
* **Commercial Model:** Unlike standard native CNI options, ACNS is a premium, paid platform add-on. Licensing is billed dynamically on a per-node basis, roughly equating to fifty dollars US per node per month. Platform architects should weigh this operational premium against the cost of manually configuring, upgrading, and maintaining open-source networking tools.

## Deep Dive: The Core Capabilities of ACNS

The primary value proposition of ACNS lies in its ability to inject advanced security policies and network acceleration directly into the kernel using eBPF, eliminating traditional proxy overhead.

### 1. Fully Qualified Domain Name (FQDN) Egress Filtering
Traditional network security practices rely heavily on locking down outbound traffic via static IP address blocks. In modern cloud ecosystems, this approach fails because cloud-native services use dynamic, shifting IP pools. 

ACNS addresses this friction by providing native FQDN and wildcard filtering. Instead of maintaining brittle IP tables, engineers can author Cilium Network Policies that explicitly allow egress to designated domain patterns, such as matching a core destination and its subdomains. The underlying eBPF data plane automatically hooks into cluster DNS routines to dynamically learn the shifting IP addresses associated with authorized domains, dropping unauthorized requests at the kernel level before they exit the cluster boundary.

### 2. Layer 7 HTTP Microsegmentation
Securing internal cluster traffic often requires inspecting more than just basic network layers and ports. ACNS provides true Layer 7 policy enforcement, giving administrators visibility into the application protocol payload.

With Layer 7 policies activated, platform engineers can restrict pod-to-pod traffic down to explicit HTTP methods and exact URI paths. For instance, a front-end service can be restricted to only issuing an HTTP GET request to a public root path of a back-end database service. If an unauthorized component attempts to issue an HTTP POST request or browse a restricted subpath like an administrative route, the ACNS engine intercepts the packet and returns a forbidden status code directly, completely isolating the target application container from unauthorized API interaction.

### 3. eBPF Datapath Host Routing Acceleration
Container networks typically route packets through virtual ethernet pairs, a mechanism that introduces measurable CPU overhead and packet encapsulation latency at scale. ACNS bypasses this bottleneck by enabling a specialized data path acceleration mode utilizing eBPF host routing.

By running traffic through an accelerated network datapath, cross-node communication bypasses standard host iptables rules and virtual routing overhead. Synthetic networking benchmarks confirm substantial enhancements:

* **Standard CNI Routing:** Standard overlay configurations without acceleration max out at lower transfer thresholds, averaging roughly nine and a half gigabits per second in common virtual machine environments.
* **ACNS Accelerated Datapath:** Enabling the advanced host routing mode elevates throughput significantly, pushing data transfers up over twelve gigabits per second under identical baseline cluster conditions. 
* **Enterprise Scaling:** Microsoft documents an estimated thirty-eight percent overall network throughput increase for busy clusters handling concurrent workloads, allowing applications to operate near physical line speeds.

### 4. Native Network Observability with Hubble and Grafana
Debugging network anomalies in a distributed cluster typically requires installing third-party agents or executing intrusive command-line capture tools. ACNS integrates network observability natively via Hubble flow logging.

By modifying standard monitoring configurations to target Hubble data capture, the platform automatically streams network flow metrics directly into Azure Monitor Managed Prometheus. This pipeline populates pre-built, out-of-the-box Grafana dashboards that surface deep architectural insights:

* Visual source-to-destination map paths detailing precisely how namespaces communicate.
* Real-time heat maps detailing data volume, request counts, and network latency anomalies.
* Instant visualization of network drops, highlighting exactly which network policies or structural bottlenecks are blocking packet delivery.

### 5. Transparent Mutual TLS (mTLS) Encryption
Encrypting east-west traffic between internal workloads usually involves deploying heavy service mesh control planes that add massive sidecar proxy overhead to every application pod. ACNS changes this paradigm by providing transparent mTLS powered by a native identity engine and integrated transport tunnels.

Instead of re-architecting applications or forcing sidecar configurations, platform teams can activate zero-trust encryption by simply applying a mutual TLS label directly to target namespaces. The infrastructure utilizes an embedded SPIRE server to automatically handle cryptographic identity issuance and validation behind the scenes. Traffic passing between labeled namespaces is automatically encrypted and decrypted at the node level using secure ztunnel components, meaning application developers get full cryptographic wire compliance without writing a single line of security logic or suffering proxy latency penalties.

## Navigating Public Preview Limitations

While ACNS delivers enterprise-grade performance and security, engineers must navigate specific structural limitations during its current preview phase:

* **Policy and Encryption Isolation:** At present, you cannot combine active Layer 7 network policies and transparent mTLS capabilities within the exact same cluster instance. 
* **Configuration Strategies:** To test or utilize both models simultaneously across an enterprise ecosystem, platform teams must maintain isolated clusters—one dedicated to Layer 7 URL and method filtering, and a separate dedicated cluster instance focused on namespace-wide mutual TLS boundaries. These validation boundaries will normalize as the platform transitions toward general availability.

## Strategic Implementation Recommendations

Advanced Container Networking Services represents a highly powerful addition to the Azure ecosystem, but it shouldn't necessarily be applied blindly to every single development environment. 

Because of the per-node financial premium and the inherent complexity of advanced eBPF routing rules, the ideal strategy is an iterative deployment model. Teams should begin by establishing standard clusters using base data planes. Only when workloads demand strict regulatory compliance—such as domain-based egress filtering, granular application protocol enforcement, or hardware-line throughput acceleration—should the flag be flipped to provision ACNS. By aligning the advanced features of the platform directly with defined security compliance boundaries and performance profiles, you ensure a cost-effective, hyper-optimized infrastructure plane.

## Conclusion

As cloud-native architectures mature, basic network isolation is no longer sufficient to meet enterprise compliance and performance demands. Advanced Container Networking Services lowers the barrier to entry for zero-trust engineering within Azure Kubernetes Service. By embedding critical security and routing mechanics directly within the Linux kernel via eBPF, ACNS elegantly solves the dual challenges of microsegmentation and network performance—all without saddling engineering teams with the operational burden of a traditional service mesh.

While platform architects must account for its per-node premium and pilot around current preview constraints, the long-term benefits are clear. Shifting from static IP constraints to dynamic FQDN rules, establishing seamless namespace-wide mTLS, and achieving near physical line-speed routing provides a hardened, highly scalable infrastructure foundation. For organizations running mission-critical enterprise workloads on AKS, ACNS is a compelling evolutionary step that shifts sophisticated cluster security from a complex engineering chore into a seamless platform capability.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20ACNS%20Walkthrough%20-%20L7%20Firewalls%2C%20mTLS%2C%20and%20eBPF%20Acceleration">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS ACNS Walkthrough - L7 Firewalls, mTLS, and eBPF Acceleration".

## Video - AKS ACNS Walkthrough - L7 Firewalls, mTLS, and eBPF Acceleration

<iframe width="560" height="315" src="https://www.youtube.com/embed/YlZkWeMRgGw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>