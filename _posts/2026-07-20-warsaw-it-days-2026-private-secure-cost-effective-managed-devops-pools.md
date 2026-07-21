---
title: Warsaw IT Days 2026 - Private, Secure, and Cost Effective - The Trifecta of Managed DevOps Pools
date: 2026-07-20
author: Wolfgang Ofner
categories: [Youtube, Speaking, DevOps]
tags: [Youtube, Video, Azure DevOps, Managed DevOps Pools, Speaking, Public Speaking, Conference, Private Endpoint, Private DNS-Zone]
description: Recording of my session at the Warsaw IT Days 2026 where I talk about Managed DevOps Pools delivering secure, cost-effective self-hosted Azure DevOps agents with private VNET access and zero OS overhead.
---

Securing enterprise cloud infrastructure often requires completely closing off public internet endpoints. By placing databases, storage accounts, and key vaults behind Virtual Networks (VNets) and Private Endpoints, organizations significantly harden their attack surface. However, this introduces a classic DevOps challenge: how can continuous integration and continuous deployment (CI/CD) pipelines deploy application artifacts or manage infrastructure inside private network boundaries without compromising speed, security, or operational costs?

Managed DevOps Pools (MDP) in Azure solve this problem by combining the zero-maintenance operational model of cloud-hosted runners with the deep networking and customization capabilities of self-hosted infrastructure.

## The Limitations of Traditional Agent Paradigms

To understand why Managed DevOps Pools are a game-changer, it helps to examine the trade-offs of existing build agent options in Azure DevOps.

### 1. Microsoft-Hosted Agents
* **Pros:** Fully managed by Microsoft, pre-configured with popular development tools, and require zero infrastructure maintenance.
* **Cons:** Run on public IP addresses outside your private network. They cannot access private endpoints, Azure Key Vaults with public access disabled, or internal virtual networks. Hardware specs are also fixed at modest tiers, making resource-intensive builds slow.

### 2. Self-Hosted Virtual Machines or Scale Sets
* **Pros:** Can be injected directly into a VNet to reach private endpoints over internal IP addresses. Supports custom software installations and scalable VM sizes.
* **Cons:** High operational overhead. Cloud engineering teams must manage OS updates, patch security vulnerabilities, install build tooling updates, and maintain monitoring. VMs often run continuously, incurring costs even during non-working hours.

### 3. Containerized Agents
* **Pros:** Ideal for environments running Kubernetes or Azure Container Apps with existing container workflows.
* **Cons:** Running container builds inside containerized agents (Docker-in-Docker) adds permissions complexity and maintenance overhead as tools and runtime support evolve.

## What Are Managed DevOps Pools?

Managed DevOps Pools provide a hybrid model that captures the strengths of both Microsoft-hosted and self-hosted runners while eliminating their primary drawbacks.

Azure fully manages the underlying Virtual Machine lifecycle, provisioning, OS updates, and agent bootstrapping on demand. At the same time, the pool can be connected to your network infrastructure and assigned Azure Managed Identities.

### Key Capabilities

* **Private VNet Integration:** Inject agents directly into a dedicated subnet within your Azure Virtual Network. Agents communicate with private endpoints (Key Vault, databases, container registries) entirely over internal private IP addresses, allowing public network access on target resources to remain strictly disabled.
* **Passwordless Authentication with Managed Identities:** Assign a System-Assigned or User-Assigned Managed Identity directly to the pool. Pipelines can authenticate to Azure resources via Azure CLI using the pool's identity, removing the need to store static client secrets, service principal credentials, or connection strings in pipeline variables.
* **Flexible Scaling & Pay-Per-Use:** Pay only for the compute runtime when pipelines are actively executing, rather than maintaining 24/7 virtual machines.
* **Custom Hardware & Tooling Options:** Choose from standard Microsoft build images or custom images hosted in an Azure Compute Gallery. Select small or massive VM stock-keeping units (SKUs) equipped with dozens of CPU cores and hundreds of gigabytes of RAM for heavy compilation tasks.

## Core Architectural Components for Secure Private Deployments

Implementing a private deployment workflow using Managed DevOps Pools relies on several foundational Azure concepts working in harmony:

1. **Private Endpoints & Private DNS:** A private endpoint assigns an internal private IP address from a VNet subnet to a target service (such as Key Vault). A linked Private DNS zone redirects internal requests to this private IP, ensuring traffic stays on the Microsoft backbone network.
2. **Subnet Delegation:** Managed DevOps Pools require a dedicated subnet within the VNet. The subnet must be delegated specifically to `Microsoft.DevOpsInfrastructure/pools`, granting Azure permission to inject agent instances into the network.
3. **Role-Based Access Control (RBAC):** Using Azure RBAC, the Managed Identity assigned to the pool receives minimal required privileges (e.g., Key Vault Secrets Officer or Network Contributor) on target resources.
4. **Management Plane vs. Data Plane Isolation:** Disabling public access blocks data plane connections (reading/writing secrets or querying databases) from external networks, while management plane operations (creating or scaling resources via Azure Resource Manager) continue to function under strict governance.

## Optimizing Pipeline Performance and Cost

While provision-on-demand architectures save money, creating a fresh virtual machine for every pipeline run can introduce a cold-start delay of three to five minutes. Managed DevOps Pools offer configuration settings to eliminate this friction without exploding operational costs:

* **Agent Reuse & Grace Periods:** Configure a post-execution grace period (such as 5 minutes). When a pipeline finishes, the agent remains idle in a warm state. If additional jobs or pipelines trigger within that window, they reuse the warm agent immediately. If no new jobs arrive, the agent is automatically deprovisioned.
* **Standby Agents:** Set schedule-based standby pools (e.g., 9 AM to 5 PM during peak business hours) to keep a baseline number of warm agents ready for instant execution, ensuring developer velocity remains high throughout the workday.
* **Automated Lifecycle Synchronization:** Deleting a Managed DevOps Pool resource in Azure automatically cleans up its corresponding agent pool inside Azure DevOps, preventing dangling administrative configurations.

## Summary

Managed DevOps Pools bridge the gap between strict enterprise network security and efficient DevOps workflows. By enabling VNet injection, passwordless Managed Identity authentication, and flexible VM scaling on a pay-as-you-go basis, organizations can maintain robust private security perimeters without burdening engineering teams with VM maintenance or slowing down delivery cycles.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Warsaw%20IT%20Days%202026%20-%20Private%2C%20Secure%2C%20and%20Cost-Effective%20-%20The%20Trifecta%20of%20Managed%20DevOps%20Pools">GitHub</a>.

This post was AI-generated based on the transcript of the video "Warsaw IT Days 2026 - Private, Secure, and Cost Effective - The Trifecta of Managed DevOps Pools".

## Video - Warsaw IT Days 2026 - Private, Secure, and Cost Effective - The Trifecta of Managed DevOps Pools

<iframe width="560" height="315" src="https://www.youtube.com/embed/wU2oAdjdkzs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>