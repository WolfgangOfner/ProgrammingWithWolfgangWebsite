---
title: Welsh Azure User Group - From Vms to Managed DevOps Pools
date: 2025-07-14
author: Wolfgang Ofner
categories: [DevOps]
tags: [Video, Azure DevOps, Managed DevOps Pools]
description: Recording of my talk at the Welsh Azure User Group June 2025 where I talk about the different options in Azure DevOps to host agents.
---

Managing and optimizing your Azure DevOps pipeline agents is crucial for efficient and cost-effective CI/CD workflows. As development practices evolve, so do the options for hosting these critical components. This post explores the various approaches to hosting Azure Pipeline agents, from traditional virtual machines to the cutting-edge Managed DevOps Pools, helping you understand which solution best fits your organization's needs.

## What are Azure Pipeline Agents and Why Do We Need Them?

Azure Pipeline agents are the executors of your CI/CD workflows. They're essential for:

- Running code, scripts, and commands independently.
- Installing necessary software and tools for builds and deployments.
- Automating your entire build, test, and deploy process.
- Scaling compute power to handle demanding workloads and large teams.
- Providing crucial audit logs for every deployment.

## The Agent Hosting Spectrum

There are several ways to host your Azure DevOps agents, each with its own set of advantages and limitations:

**1. Microsoft-Hosted Agents**

- **Pros:** Extremely easy to use, fully managed by Microsoft, come with a wide range of pre-installed software, and offer a cost-effective entry point for basic needs.
- **Cons:** No file caching between jobs (leading to slower builds), limited resources (2 CPU cores, 7 GB RAM), inability to integrate with private networks, and capped execution times (60 minutes for free tier, 6 hours for paid/open-source).
- **Cost:** One free parallel job with 1,800 minutes/month. Additional parallel jobs cost $40/month.
**2. Self-Hosted Agents**
- **Pros:** Provide full control over the operating system, installed software, and underlying hardware. They allow for integration with private networks, which is vital for accessing internal resources. There are no execution time limits.
- **Cons:** You're responsible for all maintenance, updates, security patching, infrastructure costs, and managing scalability and monitoring.
- **Cost:** One free parallel job. Additional parallel jobs cost $15/month, plus your infrastructure and maintenance expenses.

## Self-Hosted Agent Options: VMs vs. Containers

When you choose self-hosted, you typically pick between VMs and containers:

### Virtual Machine (VM) Based Agents

- **Pros:** Offer robust control over the entire environment, support caching between pipeline steps, and are easy to integrate into existing networks. Azure Virtual Machine Scale Sets can help with scaling.
- **Cons:** Can lead to underutilized hardware and high costs, require significant manual management, and demand careful security efforts.

### Container-Based Agents

- **Pros:** Provide flexibility for software installation (via Dockerfiles) and enable easy local testing. They can be very cost-effective, as you can scale them to zero when not in use (e.g., with KEDA), meaning you only pay when pipelines are actively running.
- **Cons:** Require containerization knowledge, can present challenges with "Docker in Docker" scenarios, and typically lack built-in caching.

## Managed DevOps Pools: The Best of Both Worlds

This is highlighted as the most advantageous and modern option, truly combining the best aspects of VMs with Microsoft's operational management.

- **Serverless VM Experience:** You get the power and flexibility of a VM (including the ability to build Docker images directly) but pay only for the actual runtime, similar to a serverless model.
- **VNet Integration:** Seamlessly connect agents to your Azure Virtual Networks, enabling secure access to private resources like databases and key vaults.
- **Flexible Scaling:** Configure standby agents to drastically reduce pipeline startup times (bypassing the typical 3-15 minute provisioning wait). You can also leverage powerful VM sizes for faster builds and configure maximum concurrency.
- **Managed by Microsoft:** Microsoft handles the underlying VM maintenance, agent installation, updates, and scaling, freeing up your team.
- **Easy Configuration:** Manage pools effortlessly via the Azure portal or CLI.
- **Future-Proof:** Upcoming features include support for cheaper Spot VMs and the ability to use custom container images as agents.

## Conclusion

Azure Managed DevOps Pools represent a significant leap forward in Azure Pipeline agent hosting. They address many of the limitations of both Microsoft-hosted and traditional self-hosted options, offering a highly efficient, secure, and cost-effective solution for your CI/CD needs. For organizations looking to optimize their Azure DevOps pipelines and embrace modern cloud practices, Managed DevOps Pools are quickly becoming the go-to choice.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Welsh%20Azure%20User%20Group%20-%20From%20Vms%20to%20Managed%20DevOps%20Pools" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Welsh Azure User Group - From Vms to Managed DevOps Pools" and reviewed by me.

## Video - Welsh Azure User Group - From Vms to Managed DevOps Pools

<iframe width="560" height="315" src="https://www.youtube.com/embed/v762t686X9E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>