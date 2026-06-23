---
title: Talk to Your ADO - Wikis, Work Items, and Pipelines Using AI
date: 2026-06-22
author: Wolfgang Ofner
categories: [Youtube, DevOps]
tags: [Azure, Azure DevOps, MCP]
description: Learn how to configure the native Azure DevOps Remote Model Context Protocol (MCP) server to query pipelines, repositories, wikis, and work items directly inside VS Code via GitHub Copilot using Entra ID authentication.
---

Navigating large enterprise environments in Azure DevOps (ADO) often introduces significant operational friction. Between searching through dozens of disconnected project wikis, auditing multi-hundred-line infrastructure pipelines, and tracking sprint work items across disparate boards, platform engineers spend an excessive amount of time context-switching. 

The introduction of the Remote Model Context Protocol (MCP) server for Azure DevOps shifts this dynamic. By establishing a native bridge between GitHub Copilot and the Azure DevOps API, engineers can interrogate their entire ADO organization using natural language directly from their local integrated development environment (IDE).

## Remote MCP vs. Local MCP: Shifting to a Native Control Plane

Prior implementations of the Model Context Protocol required running a local MCP server. This legacy architecture introduced several maintenance and security overheads, such as requiring a local Node.js runtime environment and execution via local execution packages. Furthermore, access typically relied on generating and managing static Azure DevOps Personal Access Tokens (PATs), which introduces token lifecycle management challenges and security compliance risks.

The Remote MCP server runs directly on top of Azure DevOps as a native platform capability. This optimization alters the integration plane significantly:

* **Zero-Touch Local Installation:** There are no local runtimes, packages, or background daemons to install and maintain on the engineer's workstation.
* **Native Entra ID Authentication:** The authentication handshake leverages the active Entra ID identity tied directly to the user's GitHub Copilot session. This completely eliminates the need for passwords or access tokens.
* **Identity-Scoped Security Boundaries:** The remote server enforces strict permission parity. The AI interface cannot discover or interact with any projects, repositories, or pipelines that the authenticated Entra ID user cannot already access through the standard ADO portal interface.

## Setting Up the Remote MCP Server in VS Code

Configuring the Remote MCP server takes less than a minute and requires only basic directory configuration. In your local workspace, you simply need to create a dedicated configuration file that maps your IDE to your target Azure DevOps organization endpoint.

To do this, ensure a standard VS Code configuration directory exists in your project root, and add a standard MCP configuration file inside it. Within this configuration, you define the remote connection string pointing to your specific Azure DevOps organization URL and list the explicit platform capabilities you want to expose, such as repositories, work items, pipelines, and wikis.

During the public preview phase, leaving capabilities fully open can occasionally cause the model to inadvertently attempt to create new assets rather than query existing ones—such as creating an empty wiki page when searching for documentation. Setting explicit capability parameters or enforcing a read-only flag within your structural configurations stabilizes tool interactions and prevents accidental modifications.

## Practical Engineering Use Cases

Once the configuration file is saved and the Entra ID authentication loop is completed inside the terminal interface, GitHub Copilot gains a contextual understanding of your cloud infrastructure ecosystem.

### 1. Interrogating Technical Wikis and Architecture Docs
Onboarding new team members or searching for internal platform standards usually requires clicking through nested documentation structures. With the wiki capability enabled, you can execute natural language lookups to surface architectural guardrails instantly. When asked about a specific project onboarding flow, the MCP server calls the wiki search APIs, parses the relevant documents, and synthesizes an immediate textual summary of the setup steps directly into your active chat window.

### 2. Accelerating Infrastructure Pipeline Audits
Modern infrastructure deployment pipelines frequently span hundreds of lines of complex configurations. Locating specific resource definitions across dozens of repositories is highly inefficient. 

By exposing pipeline and repository capabilities to the remote server, you can pinpoint specific definitions quickly. For example, asking the AI to locate the pipeline responsible for provisioning an AKS cluster allows it to search your active projects, identify the exact target manifest file, read the underlying logic, and output a concise structural breakdown of the tasks, triggers, and parameters without requiring you to manually browse the source tree.

### 3. Automated Work Item and Sprint Tracking
For platform team leads or product owners, maintaining a clear view of delivery metrics across multiple tracks is critical. Instead of executing complex database queries or scrolling through massive Azure Boards, you can track development velocity natively. Asking the interface to list work items completed in the last sprint yields a clean, chronological text list of closed features, bugs, or documentation tasks, complete with assignment metadata and completion states.

## Conclusion

The Azure DevOps Remote MCP server represents a major step forward in operational efficiency for cloud platform engineering teams. By transforming the workspace context from a collection of fragmented browser tabs into a single, unified natural language interface, it minimizes cognitive load and dramatically accelerates information retrieval. 

While the feature remains in public preview with occasional edge-case quirks, its architectural implementation—relying entirely on native Entra ID security scopes without local token overhead—makes it an immediate win for teams looking to optimize their development and platform governance workflows. Start by mapping your primary organization in your local workspace settings, lock down your read/write capabilities according to your workflow security requirements, and begin offloading routine documentation and pipeline audits to the data plane.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Talk%20to%20Your%20ADO%20Wikis%2C%20Work%20Items%2C%20and%20Pipelines%20Using%20AI">GitHub</a>.

This post was AI-generated based on the transcript of the video "Talk to Your ADO - Wikis, Work Items, and Pipelines Using AI".

## Video - Talk to Your ADO - Wikis, Work Items, and Pipelines Using AI

<iframe width="560" height="315" src="https://www.youtube.com/embed/ygG-kaHMHLo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>