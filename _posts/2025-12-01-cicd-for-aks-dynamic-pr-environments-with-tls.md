---
title: CI/CD for AKS Dynamic PR Environments with TLS - Part 7
date: 2025-12-01
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Azure DNS Zone, TLS Certifcate, Cert-Manager, HTTPS]
description: Build ephemeral environments for AKS pull requests. Automate Kubernetes Gateway API deployments, Azure DNS CNAMEs, and Cert-Manager TLS certificates.
---

Modern DevOps practices emphasize fast feedback loops and isolated testing. **Ephemeral environments**—temporary, full-stack deployments created for specific feature branches or pull requests (PRs)—are a game-changer for achieving this.

This article, based on Part 7 of our Kubernetes Gateway API series, brings together all the concepts from previous parts to demonstrate a complete, automated workflow for deploying and tearing down these environments on Azure Kubernetes Service (AKS) using Azure Application Gateway for Containers (AGFC), Cert-Manager, and **Azure DevOps Pipelines**.

## The Power of Ephemeral Environments

Imagine a scenario where every single pull request automatically spins up a dedicated, full-stack environment. Developers, QA, and even product owners can access the changes in isolation, ensuring that features are thoroughly tested without impacting staging or production. Once the PR is merged or closed, the environment (and all its associated cloud costs) is automatically dismantled.

This process provides:
* **Faster Feedback:** Changes are tested in a production-like environment instantly.
* **Isolated Testing:** No more "it works on my machine" or conflicts with other features.
* **Cost Efficiency:** Environments only exist when needed.
* **Reduced Risk:** Catch issues early before they reach shared environments.

## Architecture and Azure DevOps Workflow

The automated deployment process leverages **Azure DevOps Pipelines** for CI/CD and orchestrates a series of powerful tools:

**1. Azure DevOps Pipeline Trigger:**
* **Trigger on PR Opened:** When a new PR is opened, the deployment pipeline is triggered.
* **Trigger on PR Closed:** When a PR is merged or closed, a cleanup pipeline is automatically triggered.

**2. Deployment Steps (on PR Opened):**

* **AKS Authentication:** The Azure DevOps pipeline securely authenticates with the AKS cluster.
* **Dynamic Namespace Creation:** A new Kubernetes namespace is created, dynamically named after the pull request (e.g., `pr-123`).
* **Application Deployment:** The application (in this demo, a simple Nginx app) is deployed into this new namespace. Each deployment is unique to the PR.
* **HTTPRoute Creation:** An `HTTPRoute` Kubernetes resource is created. This routes traffic for a dynamically generated hostname (e.g., `pr-123.yourdomain.com`) to the application's service within the new namespace.
* **Cert-Manager Certificate Request:** A `Certificate` Kubernetes resource is created, requesting a TLS certificate for the dynamically generated hostname. This leverages our existing Cert-Manager and Wildcard ClusterIssuer setup (from Part 6).
* **Azure DNS CNAME Automation:** Using an Azure CLI script (from Part 4), a CNAME record is automatically created in Azure DNS, pointing `pr-123.yourdomain.com` to the AGFC's public hostname.

**3. Cleanup Steps (on PR Closed):**

* **Resource Deletion:** The Azure DevOps pipeline deletes the dynamically created Kubernetes namespace (`pr-123`).
* **Azure DNS CNAME Cleanup:** The associated CNAME record in Azure DNS for `pr-123.yourdomain.com` is also automatically removed.

## Bringing It All Together

This workflow combines all the core components configured in previous parts of the series:

* **Azure Application Gateway for Containers (AGFC):** The centralized entry point and traffic manager.
* **Kubernetes Gateway API:** Defining the routing rules for each ephemeral environment.
* **Cert-Manager with Wildcard Certificates:** Automated, secure HTTPS for every new domain.
* **Azure DNS Automation:** Dynamically managing domain records.
* **Microsoft Entra Workload Identity:** Secure authentication between AKS and Azure resources.

The result is a fully automated, end-to-end system that provides isolated, production-like testing environments on demand, significantly accelerating development and increasing confidence in deployments.

## Conclusion

Automating ephemeral environments for pull requests is a cornerstone of modern, high-velocity development teams. This article demonstrates how the **Kubernetes Gateway API**, combined with **Azure Application Gateway for Containers**, **Cert-Manager**, and **Azure DevOps**, creates a powerful, cost-effective, and secure solution on **AKS**. By eliminating manual environment setup and teardown, teams can focus on innovation, deliver faster, and ensure higher quality code.

## What's Next?

With the foundations of robust traffic management and automated environments in place, the series continues to explore advanced configurations:

* **Part 8:** Diving deeper into advanced routing capabilities using path, query string, and header matching with the Gateway API.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/CICD%20for%20AKS%20Dynamic%20PR%20Environments%20with%20TLS%20-%20Part%207" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "CI/CD for AKS Dynamic PR Environments with TLS - Part 7" and reviewed by me.

## Video - CI/CD for AKS Dynamic PR Environments with TLS - Part 7

<iframe width="560" height="315" src="https://www.youtube.com/embed/6p-W7DE7Yd0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>