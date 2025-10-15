---
title: AKS Pod Scheduling 101
date: 2025-10-13
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes]
description: Master AKS Pod Scheduling - Learn about Resource Quotas, Node Selectors, Taints/Tolerations, Affinity/Anti-Affinity, and Spread Constraints for optimal workload control.
---

When running containerized applications on Azure Kubernetes Service (AKS), simply deploying your Pods and letting them land wherever is inefficient and risky. Mastering Pod scheduling ensures high availability, cost efficiency, and optimal performance by giving you granular control over exactly where your Pods are placed on your cluster's Nodes.

## Resource Quotas: Setting Boundaries for Namespaces

Resource Quotas are a governance tool used to limit resource consumption within a specific Namespace. This is critical in multi-tenant clusters to prevent one application or team from monopolizing all cluster resources (the "noisy neighbor" problem).

You can enforce limits on:

- **Compute Resources:** Define the maximum total CPU and Memory that all Pods in the Namespace can request (guaranteed) and limit (maximum burst).
- **Object Count:** Limit the total number of Kubernetes objects, such as Pods, Services, and ReplicaSets, that can be created in the Namespace.

If a deployment attempts to exceed the defined quota, the scheduler will reject the new Pods, preventing resource exhaustion for others.

## Node Selector: Simple, Direct Placement

The Node Selector is the most straightforward method for directing a Pod to a specific Node. It relies on a simple, mandatory key-value label match.

1. **Label the Node:** First, you apply a custom label to one or more Nodes (e.g., gpu: nvidia).
2. **Select the Label in the Pod Spec:** You then configure your Pod's deployment manifest to include a nodeSelector that demands that specific label (gpu: nvidia).

The Pod will only be scheduled on a Node that possesses the exact matching label. This is ideal for dedicating workloads that require specialized hardware (like GPUs or high-memory machines) to specific Nodes.

## Taints and Tolerations: Repelling and Permitting Pods

While Node Selectors attract Pods, Taints and Tolerations work by repelling them from a Node unless the Pod explicitly tolerates the taint.

1. **Taint on the Node:** A Node can be marked with a taint (e.g., disktype=ssd:NoSchedule). The "NoSchedule" effect means no Pod can land on that Node unless it has the corresponding toleration.
2. **Toleration in the Pod Spec:** A Pod's configuration must include a toleration that matches the Node's taint.

Taints are commonly used to isolate specialized hardware (like dedicated GPU Nodes) or to reserve Nodes for core system services, ensuring that general-purpose workloads do not consume their resources.

## Affinity and Anti-Affinity: Flexible Placement Preferences

Affinity rules offer a more flexible and expressive way to influence scheduling than the mandatory Node Selector. They define "soft" preferences or "hard" requirements based on Node characteristics or the location of other Pods.

### Node Affinity (Pod-to-Node)

This specifies preferences for where a Pod should land based on Node labels:

- **Hard Affinity (Required):** The scheduler must find a matching Node for the Pod to be scheduled. If no match exists, the scheduling fails.
- **Soft Affinity (Preferred):** The scheduler tries to find a matching Node, but if none is available, the Pod will still be scheduled elsewhere. You can use a weight value to prioritize different soft preferences.

### Pod Anti-Affinity (Pod-to-Pod)

This is crucial for high availability. It prevents the scheduler from placing two specific Pods (such as two replicas of a database) on the same Node. By ensuring replicas are spread across different Nodes or Availability Zones, the failure of a single Node does not take down the entire service.

## Topology Spread Constraints: Even Distribution

Topology Spread Constraints guarantee that Pods of a Deployment are distributed evenly across defined physical or logical domains within your cluster.

- **Control Metric:** You define the maximum acceptable difference (max skew) in the number of matching Pods between any two domains (e.g., the busiest Node and the least busy Node).
- **Topology Key:** You define the domain across which the Pods must be spread (e.g., kubernetes.io/hostname for Node-level distribution, or a label representing an Availability Zone).

This feature is the most modern and robust way to achieve high availability and efficient resource utilization by ensuring Pods are perfectly balanced across your infrastructure.

## Conclusion

Effective Pod scheduling is the key to managing a healthy, cost-optimized, and resilient AKS cluster. While you can start simple with Resource Quotas and Node Selectors, leveraging advanced features like Affinity/Anti-Affinity and Topology Spread Constraints provides the granular control necessary to meet the demands of production workloads. By mastering these concepts, you move beyond basic deployment to truly managing your containerized applications within Kubernetes.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Pod%20Scheduling%20101" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Pod Scheduling 101" and reviewed by me.

## Video - AKS Pod Scheduling 101

<iframe width="560" height="315" src="https://www.youtube.com/embed/29vNQm3K3f4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>