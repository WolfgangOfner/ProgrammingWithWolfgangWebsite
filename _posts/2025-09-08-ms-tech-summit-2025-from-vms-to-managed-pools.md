---
title: MS Tech Summit 2025 - From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting
date: 2025-09-08
author: Wolfgang Ofner
categories: [Youtube, Speaking, DevOps]
tags: [Azure, Azure DevOps, Managed DevOps Pools]
description: Recording of my session at the MS Tech Summit 2025 where I talk about the different options in Azure DevOps to host agents.
---

The World of Azure DevOps Agents: A Technical Breakdown
In the world of automated software delivery, Azure DevOps agents are the engines that build, test, and deploy your code. Choosing the right type of agent is a critical decision that impacts cost, performance, and security. This post provides a technical breakdown of the different agent options, highlighting the pros and cons of each to help you make an informed choice for your projects.

## Microsoft-Hosted Agents: The Quick Start

These agents are fully managed by Microsoft, making them the easiest way to get started with Azure DevOps.

**Pros:**

- **Simplicity:** You don't have to configure or maintain any infrastructure; you simply specify the desired VM image (e.g., Ubuntu, Windows) in your pipeline.
- **Cost-Effective:** A free tier is available for both private and public projects.
- **Pre-installed Software:** They come with a wide range of common developer tools, with Microsoft handling all updates and maintenance.

**Cons:**

- **No Caching:** A new, clean agent is provisioned for every job, which can lead to slow build times, especially for tasks like building Docker images.
- **Limited Resources:** You are restricted to a fixed amount of CPU (2 cores) and RAM (7 GB).
- **Security Limitations:** They operate on the public internet and cannot integrate with private networks, requiring your services to be publicly accessible for deployment.

## Self-Hosted Agents: The Fully Customizable Option

Self-hosted agents give you complete control over your build environment. You provision and manage the agent yourself, whether it's on a VM or in a container.

**Pros:**

- **Full Control:** You can install any software, use any hardware, and customize the environment to your exact needs.
- **Enhanced Security:** You can integrate these agents into your private network, allowing for secure access to internal resources without exposing them to the internet.
- **No Time Limits:** You can run long-running jobs without time constraints.
- **Caching:** When hosted on a VM, you can cache artifacts and images to significantly speed up subsequent builds.

**Cons:**

- **High Maintenance:** You are responsible for all maintenance, including OS updates and security patches.
- **Manual Management:** You must manually handle scaling, monitoring, and resource management to ensure there are enough agents for your team.

## Managed DevOps Pools: A Managed and Scalable Solution

Managed DevOps Pools offer a powerful compromise, combining the management simplicity of Microsoft-hosted agents with the control and network integration of self-hosted agents.

**Pros:**

- **Automated Management:** Microsoft handles the underlying VM management and agent configuration, freeing you from maintenance tasks.
- **Network Integration:** They can be seamlessly integrated into your Azure VNet, enabling secure, private deployments to sensitive services.
- **Cost-Effective:** You only pay for the VM when the agent is actively running a pipeline, making them a cost-effective solution for powerful machines.
- **Scalability:** Azure automatically scales the number of agents based on your needs, up to a maximum you define.

## Conclusion

For quick starts and simple projects, Microsoft-hosted agents are an ideal choice. For organizations that require ultimate control and security, self-hosted agents provide the necessary flexibility. However, for a modern, scalable, and secure approach, Managed DevOps Pools represent the next evolution in pipeline agents, offering the benefits of both worlds to significantly improve your team's efficiency and workflow.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/MS%20Tech%20Summit%202025%20-%20From%20VMs%20to%20Managed%20DevOps%20Pools%20-%20Navigating%20Azure%20DevOps%20Agent%20Hosting" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "MS Tech Summit 2025 - From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting" and reviewed by me.

## Video - MS Tech Summit 2025 - From VMs to Managed Pools - Navigating Azure DevOps Agent Hosting

<iframe width="560" height="315" src="https://www.youtube.com/embed/uwNQ8Ua1ybI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>