---
title: AKS Governance Made Easy with Azure Policy
date: 2025-06-02
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, AKS, Azure Policy]
description: Simplify AKS governance with Azure Policy. Enforce security, compliance, and standards across your Kubernetes clusters and resources.
---

This post provides a comprehensive guide on leveraging Azure Policy to enforce rules and maintain security within your Azure Kubernetes Service (AKS) clusters. Azure Policy can seem complex at first, but it's a powerful tool for governance across your entire Azure tenant.

## What is Azure Policy?

Azure Policy enables you to define and automatically apply rules to your Azure resources. These rules help ensure compliance with company guidelines and security best practices, preventing developers from deploying non-compliant resources. By enforcing consistent policies, it promotes unification of solutions across different teams and companies within your tenant.

## How Azure Policies Work

Policies can be custom-written or chosen from Microsoft's built-in options. They define actions, such as restricting resource creation to specific locations (e.g., West Europe for legal requirements) or allowing only certain VM SKUs for cost optimization.

### A policy definition includes:

- **Rules** (conditions): What must be met for the policy to apply.
- **Effects**: What happens if the rule is met.
  - **Deny**: Prevents the creation or update of non-compliant resources.
  - **Allow**: The opposite of deny.
  - **Audit**: Allows resource creation but provides compliance overviews, ideal for initial implementation without disrupting existing deployments.

Policies can be assigned at various scopes, including the entire tenant, management groups, subscriptions, or resource groups, with options for exclusions. Checks are performed automatically by Microsoft, typically within 24 hours, though they can be manually triggered.

## Use Cases for Azure Policy

- **Auditing Existing Resources**: Deploy a policy in audit mode to generate reports on non-compliant resources (e.g., resources not in West Europe).
- **Preventing Future Non-Compliance**: Set policies to deny non-compliant deployments, enforcing new security or compliance guidelines.
- **Automated Remediation**: For certain policies (e.g., enforcing tags on resources), remediation tasks can automatically apply missing configurations.
- **Centralized Dashboard**: Provides a clear overview of resource compliance across your tenant.
Azure Policy with AKS Clusters:

### Managing Resources Inside the Cluster:

Install the Azure Policy add-on for AKS using the Azure CLI command: az aks enable-addons. This add-on deploys Gatekeeper, an open-source tool that enforces policies within Kubernetes. Two examples of Azure Policies are:
- Prevent privileged containers from running, ensuring pods adhere to security best practices (e.g., running as non-root users).
- Ensure AKS clusters have the Image Cleaner enabled. This feature cleans up stale images on worker nodes to prevent the use of outdated, vulnerable images.

Set the policy to "audit" mode initially to report non-compliance without denying cluster creation or updates.
Recommendations for Getting Started:

Start small with one policy. Use the "audit" mode initially to understand its impact without disrupting existing deployments.
Gradually transition to "deny" or "allow" modes once confident. Progressively add more complex policies as you gain experience.

While Azure Policy can seem complicated at first, it's a powerful tool for governance and applying rules across your entire Azure tenant.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Understand%20Your%20AKS%20Spending%20with%20the%20Cost%20Analysis%20Add-on" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Governance Made Easy with Azure Policy" and reviewed by me.

## Video - AKS Governance Made Easy with Azure Policy

<iframe width="560" height="315" src="https://www.youtube.com/embed/rLjk_F2ZYLQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>