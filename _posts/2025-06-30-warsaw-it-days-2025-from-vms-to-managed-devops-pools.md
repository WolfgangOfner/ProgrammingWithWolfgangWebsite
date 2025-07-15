---
title: From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting - Warsaw IT Days 2025
date: 2025-06-30
author: Wolfgang Ofner
categories: [Speaking, DevOps]
tags: [Azure DevOps, Managed DevOps Pools, Speaking, Public Speaking, Conference]
description: Recording of my session at the Warsaw IT Days 2025 where I talk about the different options in Azure DevOps to host agents.
---

This post, inspired by "From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting" by Programming with Wolfgang, provides an insightful look into the various hosting options for Azure Pipeline agents, crucial for automating your build and deployment processes.

## Why Azure Pipeline Agents Are Essential

Azure Pipeline agents are the workhorses of your CI/CD pipelines. They are needed to:

- Run code independently and execute tasks.
- Install necessary software (like Docker CLI or .NET SDK).
- Automate build and deployment processes.
- Scale compute power for large teams.
- Maintain an audit log of deployments.

## Microsoft-Hosted Agents

- **Advantages:** Managed by Microsoft, offering Ubuntu, Windows, and macOS options with pre-installed common software. They are easy to use and cost-effective for basic needs.
- **Limitations:** A new agent is provisioned for each job, leading to slower execution due to lack of caching. They have limited resources (2 CPU cores, 7GB RAM, 14GB SSD) and cannot be integrated into private networks. Free tier execution is limited to 60 minutes.
- **Costs:** One free agent with 1,800 minutes/month per organization. Public projects get 10 agents with unlimited minutes. Additional parallel jobs cost $40 each per month with unlimited minutes.

## Self-Hosted Agents
- **Advantages:** Full control over the operating system, software installation, and hardware. No execution time limits, easy integration with private networks, and choice of any Linux, Windows, or macOS version.
- **Limitations:** You are responsible for updates, security patches, infrastructure costs, scalability, and monitoring.
- **Costs:** One free parallel job per organization. Additional jobs can be obtained via Visual Studio Enterprise licenses or purchased for $15 per parallel job per month, plus your own infrastructure and maintenance costs.

## Self-Hosted Agent Options

- **Virtual Machines (VMs):**
    - **Pros:** Full control, caching capabilities, easy network integration. Azure's Virtual Machine Scale Sets (VMSS) can aid with scaling.
    - **Cons:** High maintenance overhead, potential underutilization, higher costs, and security risks if not properly managed.

- **Containers (Docker):**
- **Pros:** Easy software installation via Dockerfiles, local testing. Can run on Azure Kubernetes Service (AKS) or Azure Container Apps, with Container Apps offering a free tier and scaling to zero using KEDA.
- **Cons:** Requires container knowledge, limitations with Docker-in-Docker builds (unless using privileged mode), and lack of caching.

## Managed DevOps Pools (The Recommended Option)

- **Description:** These are serverless virtual machines fully managed by Microsoft, combining the power of VMs with Microsoft's operational expertise. They handle agent installation, updates, and configuration.
- **Benefits:** Pay only for runtime, allowing for powerful VMs and faster builds. They support custom images for specific software needs and integrate seamlessly with private networks for secure deployments.
- **Drawbacks:** No caching and a startup time of 3-15 minutes.
- **Scaling:** Support standby agents for immediate execution, automatic scaling, or a mix based on business hours.
- **Upcoming Features:** Expected support for cheaper spot VMs and custom container images as agents.

## Conclusion

The video concludes with a strong recommendation for Managed DevOps Pools as the best option for hosting Azure DevOps agents. They offer a compelling balance of ease of setup, powerful capabilities, and cost-effectiveness by allowing you to pay only for runtime. While Microsoft-hosted agents are great for basic needs and self-hosted VMs or containers offer full control, Managed DevOps Pools present a modern, efficient, and secure solution for most Azure DevOps pipeline requirements.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Warsaw%20IT%20Days%202025%20-%20From%20VMs%20to%20Managed%20Pools%20-%20Navigating%20Azure%20DevOps%20Agent%20Hosting" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Warsaw IT Days 2025 - From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting" and reviewed by me.

## Video - Warsaw IT Days 2025 - From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting

<iframe width="560" height="315" src="https://www.youtube.com/embed/OEBvWVlAuw0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>