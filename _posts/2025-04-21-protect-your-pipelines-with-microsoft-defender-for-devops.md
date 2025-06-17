---
title: Protect your Pipelines with Microsoft Defender for DevOps
date: 2025-04-21
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, Defender for DevOps]
description: Secure your Azure DevOps repositories, projects and service connections with the Microsoft Defender for DevOps.
---

This post provides a comprehensive guide on installing and configuring Microsoft Defender for DevOps, based on a recent video exploring the presenter's learning experience and findings.

## What is Microsoft Defender for DevOps?

Microsoft Defender for DevOps is a tool within the Azure portal that helps you secure your DevOps environments. It scans your repositories and projects for security vulnerabilities in both code and infrastructure as code (IaC).

## Getting Started with Defender for DevOps

1. Accessing Defender for Cloud: Navigate to Microsoft Defender for Cloud in the Azure portal.
2. DevOps Security Section: Find the "DevOps security" section.
3. Adding a Connector:
  - Connect your Azure tenant to your Azure DevOps organization (or other supported platforms like AWS, Google, GitHub, or GitLab).
  - Provide a name, subscription, resource group, and location for the connector.
  - Choose the "agentless scanning" plan (currently in preview and free).
  - Authorize access with your user account, selecting which organizations and projects to scan.
  - Be aware that initial scanning can take several hours.

## Reviewing Security Findings

- The dashboard displays findings categorized as code findings (e.g., C#) and infrastructure as code (IaC) findings (e.g., Kubernetes configurations, YAML files).
- Code findings might include recommendations to prevent requesters from approving their own pull requests or requiring a minimum number of reviewers.
- IaC findings can highlight high-severity issues like containers not being privileged or medium-severity issues like minimizing root container admissions.
- Low-severity recommendations often relate to operational excellence, such as setting CPU and memory limits for containers.
- Each finding includes details about the affected branch, file, and the tool that identified the issue (e.g., Checkov).

## Enabling Pull Request Scanning (Annotations)

- Enable scanning during pull requests in the DevOps security overview.
- This feature requires the Defender for CSPM plan to be active.
- Note that this feature is in preview and may have some issues.

## Inventory Overview

- The "Inventory" section provides an overview of resources, including repositories, service connections, and builds.
- It shows recommendations for service connections, such as limiting access to specific pipelines.
- Container image findings are also displayed, showing vulnerabilities and providing explanations on how to fix them. (Exercise caution with AI-generated fix suggestions).

## Azure DevOps Integration and Extensions

- Defender for DevOps installs two extensions in Azure DevOps: "Microsoft Defender for DevOps container mapping" and "Microsoft Security for DevOps."
- The "Microsoft Security for DevOps" extension installs a task that can be used in pipelines to scan for vulnerabilities.
- The "Sarif SAST Scans Tab" extension (available in the marketplace) adds a "Scans" tab to build pipelines, displaying findings directly.

## Pull Request Demo

- The video demonstrates a pull request that triggers a CI pipeline, running a .NET build and the "Microsoft Security DevOps" task.
- This task uses tools like Checkov, Slint, Template Analyzer, and 3V to scan for vulnerabilities.
- Findings are presented as comments in the pull request, allowing developers to address issues before merging code.

## Conclusion

Microsoft Defender for DevOps, while still in preview, is a free and potentially valuable tool for identifying security findings and integrating these checks into your pull request workflow for early issue resolution. It's particularly useful for detecting secrets and connection strings in your code.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Protect%20your%20Pipelines%20with%20Microsoft%20Defender%20for%20DevOps" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Protect your Pipelines with Microsoft Defender for DevOps" and reviewed by me.

## Video - Protect your Pipelines with Microsoft Defender for DevOps

<iframe width="560" height="315" src="https://www.youtube.com/embed/SD01dp4AKmg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>