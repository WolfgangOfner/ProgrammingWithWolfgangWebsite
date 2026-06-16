---
title: Azure CNI Powered by Cilium - Getting Started with eBPF
date: 2026-06-15
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Cilium, Azure CNI, eBPF]
description: Learn how to get started with Azure CNI powered by Cilium on AKS. Discover the benefits of eBPF, identity-based microsegmentation, and cluster-wide policies.
---

Networking in Azure Kubernetes Service (AKS) stands out as one of the most intricate and challenging components of cloud infrastructure management. Navigating pod communication, external routing, and network security requires a clear understanding of your cluster's data plane. The native Azure CNI powered by Cilium offers a powerful, built-in solution to modern container networking by shifting traffic management into the Linux kernel using eBPF.

## The Shift from Kube-Proxy to eBPF

In a standard Kubernetes setup, networking tasks rely on kube-proxy, which processes routing rules sequentially via legacy iptables. As clusters scale to hundreds or thousands of pods, updating massive tables becomes slow and resource-intensive. 

Azure CNI powered by Cilium replaces kube-proxy entirely by utilizing Extended Berkeley Packet Filter (eBPF) technology. This architecture provides critical advantages for production workloads:

* **Accelerated Pod Creation:** Pods are provisioned faster because the cluster bypasses traditional IP-allocation delays and immediate table re-generations.
* **Identity-Based Security:** Instead of routing traffic strictly by transient IP addresses, Cilium assigns distinct security identities to pods based on their cryptographic properties and metadata.
* **Enhanced Observability:** Network traces display logical service and application names rather than cryptic IP addresses, simplifying infrastructure debugging.

> **Note:** This specific data plane is natively supported exclusively on Linux nodes running Ubuntu or Azure Linux.

## Azure CNI Cilium vs. Advanced Container Networking Services (ACNS)

While the default Azure CNI powered by Cilium is fully open-source and free, Microsoft offers an enterprise upgrade path known as Advanced Container Networking Services (ACNS). Understanding where the free tier stops is essential for planning platform architecture:

| Feature | Azure CNI Cilium (Free) | ACNS (Paid Upgrade) |
| :--- | :--- | :--- |
| **Network Layer Support** | Layer 3 and Layer 4 | Layers 3, 4, and Layer 7 |
| **Egress Filtering** | Explicit CIDR blocks only | FQDN / Friendly URL filtering |
| **Encryption** | Standard routing | Automated mTLS (SPIRE) & WireGuard |
| **Observability** | Node-locked CLI commands | Cluster-wide UI & Metrics (Hubble) |

## Implementing Identity-Based Microsegmentation

In a default Kubernetes state, any pod can communicate with any other pod across any namespace. Establishing microsegmentation ensures that frontend applications can connect to backends, while isolating sensitive workloads from unauthorized or compromised neighbor pods.

Cilium network policies use endpoint selectors to isolate workloads using labels rather than managing shifting IP ranges. A massive benefit of this setup is revealed during application scaling or restarts: when a pod is destroyed and spun back down, its brand-new IP address is instantly bound back to its persistent Cilium security identity. Your security enforcement doesn't need to flush, recalculate, or experience cold start latency.

## Enforcing Strict Egress Isolation

Securing outbound traffic is a fundamental security requirement for minimizing data exfiltration risks. Cilium lets you implement egress rules that lock down pods from reaching untrusted external networks.

However, when utilizing the free Cilium tier, platform engineers face a distinct limitation: egress rules cannot be declared via friendly domain names like github.com. Instead, configurations must define explicit public Classless Inter-Domain Routing (CIDR) blocks to authorize traffic. Friendly FQDN-based filtering remains gated behind the advanced ACNS paid upgrade. Platform engineers must also structure egress rules carefully, as poorly defined egress boundaries can inadvertently cut off internal pod-to-pod communications by overriding broader rules.

## Inspecting the eBPF Data Plane

When connections drop unexpectedly, digging into the kernel data plane becomes necessary. Cilium allows you to check active cluster policies directly from the terminal by running commands inside specialized Cilium agents managed within the kube-system namespace.

Using endpoint identification lookups, you can verify how security identities map down to runtime system components. Engineers can track active networking blocks in real-time by launching an execution trace to monitor drops directly. 

A major caveat to note in the standard free tier is that monitoring traces are node-locked; you can only observe packet rejections occurring on the specific underlying virtual machine node housing that specific agent pod. Gathering a unified, cluster-wide view of multi-node traffic anomalies requires the deployment of Hubble analytics via ACNS.

## Overriding Local Boundaries with Cluster-Wide Policies

As engineering organizations scale, governing networking boundaries across hundreds of individual application teams becomes messy. Local policies are limited to explicit namespaces, which introduces the risk of configuration blind spots if application developers neglect security parameters.

To build permanent guardrails, you can implement Cilium Cluster-Wide Network Policies. These policies apply a uniform security baseline globally across the entire cluster without needing namespace designations. 

It is critical to understand the hierarchy of concerns when combining these manifests: cluster-wide policies permanently override local, namespace-specific specifications. If a global rule establishes a baseline protocol, it will actively trump a more restrictive rule defined inside a single namespace. Managing this inheritance model correctly is key to keeping cloud infrastructures secure and predictable.

## Conclusion

Migrating from traditional kube-proxy infrastructure to Azure CNI powered by Cilium represents a massive leap forward for AKS cluster performance and security management. By substituting shifting IP addresses with immutable cryptographic identities, platform teams can design reliable microsegmentation and enforce predictable global guardrails via cluster-wide network policies. 

While the open-source tier comes with specific visibility and configuration limits, it provides a robust foundation for building high-scale, secure cloud architectures before evaluating advanced enterprise upgrades like ACNS. The best way to master this data plane is to start small: deploy a basic frontend-to-backend isolation scenario, practice debugging drops from the agent terminals, and iteratively scale out your network boundaries from there.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Azure%20CNI%20Powered%20by%20Cilium%20-%20Getting%20Started%20with%20eBPF">GitHub</a>.

This post was AI-generated based on the transcript of the video "Azure CNI Powered by Cilium - Getting Started with eBPF".

## Video - Azure CNI Powered by Cilium - Getting Started with eBPF

<iframe width="560" height="315" src="https://www.youtube.com/embed/sYOd3kiRMcU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>