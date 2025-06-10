---
title: Optimize Your DevOps Pipeline with Cost Effective Stateful Agents
date: 2025-05-12
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, Managed DevOps Pools]
description: Boost DevOps efficiency! Learn how stateful agents drastically cut pipeline execution times and reduce costs compared to traditional stateless agents.
---

This post explores how to significantly improve the efficiency of your Azure DevOps pipelines by leveraging stateful agents. Stateful agents offer a compelling alternative to traditional stateless agents, leading to faster pipeline execution and reduced costs.

## The Stateless Agent Bottleneck

Traditionally, Azure DevOps pipelines rely on stateless agents. These agents are created from scratch for each job within a pipeline. While seemingly straightforward, this approach introduces substantial overhead. The creation of a new agent can take anywhere from 3 to 15 minutes, and in pipelines with multiple jobs, this wait time accumulates, dramatically increasing the overall pipeline duration.

## Stateful Agents: A Faster, More Efficient Solution

Stateful agents address this inefficiency by allowing the reuse of an agent across multiple jobs within a pipeline. Instead of constantly creating and destroying agents, a stateful agent persists and can be leveraged by subsequent jobs, eliminating the agent creation delay. This results in significantly faster pipeline execution times.

## Implementing Stateful Agents

The video demonstrates the deployment of a managed DevOps pool using Azure CLI commands, defining the necessary resources and configurations. Key configuration aspects include:

- **Fabric Profile**: This configuration defines the virtual machine that will serve as the agent. Parameters include VM size (e.g., standard T2 with 2 CPU cores and 8GB RAM), the operating system (e.g., Ubuntu 22.04), and storage specifications (e.g., standard SSD).
- **Organization Profile**: This profile specifies the Azure DevOps organization URL and determines which projects have access to the managed DevOps pool. It also handles permission settings for managing the pool.
- **Agent Profile**: This is where the crucial distinction between stateless and stateful agents is made. Initially, a stateless agent is configured to establish a performance baseline. The managed DevOps pool is then updated to utilize a stateful agent. Key parameters for stateful agents include:
  - **maximumAgentLifetime**: This parameter defines the maximum lifespan of an agent before it is recycled (e.g., 7 days).
  - **gracePeriod**: This specifies the amount of time an agent will wait without receiving any jobs before being terminated (e.g., 5 minutes). The gracePeriod is critical for balancing cost-effectiveness and efficiency.

## Performance Gains in Practice

The video highlights the dramatic performance improvements achieved with stateful agents. A pipeline with two jobs, which took 4 minutes and 22 seconds to complete using stateless agents (with only 2 seconds of actual script execution time), was reduced to under a minute (46 and 41 seconds for two runs) after switching to a stateful agent configuration. This demonstrates the significant time savings achieved by eliminating agent creation overhead.

## Conclusion

Stateful agents offer a powerful way to optimize Azure DevOps pipelines. By enabling agent reuse, they drastically reduce pipeline execution times and improve overall DevOps efficiency. While the initial setup may involve some configuration, the performance benefits and cost savings make stateful agents a worthwhile investment. Microsoft is also actively developing solutions to further accelerate new agent creation, promising even greater pipeline efficiency in the future.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Optimize%20Your%20DevOps%20Pipeline%20with%20Cost-Effective%20Stateful%20Agents" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Optimize Your DevOps Pipeline with Cost Effective Stateful Agents" and reviewed by me.

## Video - Optimize Your DevOps Pipeline with Cost Effective Stateful Agents

<iframe width="560" height="315" src="https://www.youtube.com/embed/1zIBNDZp9Uw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>