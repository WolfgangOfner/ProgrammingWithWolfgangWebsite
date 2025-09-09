---
title: Azure Back to School - From VMs to Managed DevOps Pools - Navigating Azure DevOps Agent Hosting
date: 2025-09-04
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure, Azure DevOps, Managed DevOps Pools]
description: My contribution to the Azure Back to School 2025 event.
---

In the world of automated software delivery, Azure Pipeline agents are the workhorses that build, test, and deploy your code. Choosing the right type of agent is crucial for balancing cost, performance, and security. This post provides a technical breakdown of the different agent options in Azure DevOps, from the basic Microsoft-hosted agents to the powerful new Managed DevOps Pools.

## Microsoft-Hosted Agents: The Quick and Easy Start
These agents are fully managed by Microsoft. They're a great choice for small projects or for getting started quickly without any setup.

**Pros:**

- **Ease of Use:** You simply specify the VM image (e.g., Ubuntu, Windows) in your pipeline, and the agent is provisioned for you.
- **Pre-Installed Software:** They come with a wide range of common developer tools, and Microsoft handles all the maintenance and security patches.
- **Cost-Effective:** They can be used for free for a small number of minutes per month.

**Cons:**

- **No Caching:** A new, clean agent is created for every job, which can lead to longer pipeline execution times.
- **Limited Resources:** You are restricted to a fixed amount of CPU and RAM.
- **Security Limitations:** They operate on the public internet, making it impossible to integrate them directly into your private network.

## Self-Hosted Agents: The Fully Customizable Option
Self-hosted agents are virtual machines or containers that you provision and manage yourself. They offer complete control over your build environment.

**Pros:**

- **Full Control:** You can install any software, use any hardware, and customize the environment to your exact needs.
- **Enhanced Security:** They can be deployed within your private network, allowing for secure access to internal resources.
- **No Time Limits:** You can run long-running jobs without time constraints.

**Cons:**

- **High Maintenance:** You are responsible for all maintenance, including OS updates and security patches.
- **Scalability Challenges:** You must manually ensure that you have enough agents to handle your team's workload.

## Managed DevOps Pools: The Best of Both Worlds
This is a newer Azure service that combines the convenience of Microsoft-hosted agents with the power and control of self-hosted agents.

Pros:

- **Automated Management:** Microsoft handles the provisioning and underlying VM maintenance, so you don't have to.
- **Customization:** You can select a VM image from a library or create your own custom image with all your required software pre-installed.
- **Network Integration:** You can seamlessly integrate these agents into your virtual network, enabling them to securely access private resources.
- **Cost-Effective:** You only pay for the time the VM is running, even when using powerful machines.
- **Improved Performance with Caching:** A key feature is the "grace period." After a job is finished, the agent can be kept alive for a short time (e.g., 5 minutes) to wait for a new job. This allows for caching and dramatically speeds up subsequent pipeline runs.

The first pipeline run on a new managed agent may take a few minutes to provision the VM, but subsequent runs on the same agent within the grace period can be significantly faster due to the cached environment.

## Conclusion
For small teams and quick starts, Microsoft-hosted agents are a great choice. For organizations with specific, long-running, or secure network needs, self-hosted agents provide the necessary control. However, Managed DevOps Pools represent the next evolution in pipeline agents, offering a compelling blend of automated management, customization, and security that can significantly improve your team's efficiency and workflow.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Azure%20Back%20to%20School%20-%20From%20VMs%20to%20Managed%20Pools" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Azure Back to School - From VMs to Managed DevOps Pools - Navigating Azure DevOps Agent Hosting" and reviewed by me.

## Video - Azure Back to School - From VMs to Managed DevOps Pools - Navigating Azure DevOps Agent Hosting

<iframe width="560" height="315" src="https://youtu.be/YjFb5xarITg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>