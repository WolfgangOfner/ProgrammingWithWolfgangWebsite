---
title: Automate DNS Records for AKS TLS Setup - Part 4
date: 2025-11-10
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Azure DNS Zone]
description: Use a single Azure Application Gateway for Containers (AGFC) to host multiple apps on AKS. Learn to route traffic using the Gateway API's HTTPRoute.
---

Part 4 of our Kubernetes Gateway API series focuses on a crucial networking step that enables custom URLs and automated HTTPS for your applications: the automated configuration of Azure DNS records. Building upon the infrastructure deployed in previous parts, this article details how to reliably point your custom domains to the single entry point of your AKS cluster: the Azure Application Gateway for Containers (AGFC).

## The Central Role of the Gateway Hostname

The AGFC, combined with the Kubernetes Gateway resource, provides a single, high-performance entry point to your cluster. This Gateway resource is assigned a unique hostname by Azure.

In a practical deployment, you cannot ask customers or API clients to use this generated hostname (e.g., `gkg9apgzcpd3gchp.fz65.alb.azure.com`). Instead, you must point your custom domain names (e.g., `app.mycompany.com`) to this Gateway hostname. This is achieved by creating a **CNAME record** in your Azure DNS Zone.

## Why CNAMEs are Superior to IPs

A key advantage of the Gateway API and AGFC over traditional Ingress solutions is the stability of the endpoint:

* **Ingress (Traditional):** Often uses a load balancer with a publicly exposed **IP address**. If the cluster or load balancer is rebuilt, the IP can change, requiring manual DNS updates.
* **Gateway API (AGFC):** Provides a unique, stable **CNAME hostname**. Since this hostname does not change even if the underlying cloud resources are re-provisioned, your custom DNS records remain valid, minimizing maintenance overhead.

## Use Cases for Automated DNS

Automating your DNS records unlocks several key features:

* **Friendly URLs:** Use memorable, branded URLs for public applications and APIs instead of cryptic FQDNs.
* **Automated TLS/HTTPS:** Owning and controlling your domain is a prerequisite for the secure and automated creation of TLS certificates (which is the focus of the next parts).
* **Ephemeral Environments:** Quickly create and tear down temporary environments for pull requests or feature branches. By deploying a new environment and automatically creating a unique DNS record (e.g., `pr-123.mycompany.com`), QA and product teams can easily access and test the changes.

## Scripting DNS Automation with Azure CLI

The most efficient way to manage these records is through automation. This guide demonstrates a script utilizing a combination of **Azure CLI** and PowerShell:

1.  **Get AGFC Hostname:** The script first queries the AGFC's public hostname from the Kubernetes Gateway resource.
2.  **Iterate and Check:** It loops through a predefined list of required custom domains.
3.  **Create or Update:** For each domain, it checks if a DNS record already exists in the Azure DNS Zone.
    * If the record does not exist, it creates a new CNAME record set.
    * It then updates the CNAME record to point directly to the AGFC hostname, ensuring all custom domains resolve correctly to the cluster entry point.

This automated process guarantees that all domains are correctly linked to the new AKS environment with a single command, making cluster rebuilds and maintenance significantly easier.

## Conclusion

Part 4 establishes the fundamental connection between your custom domains and your AKS cluster through Azure DNS automation. By leveraging the stable CNAME provided by the Azure Application Gateway for Containers and an efficient Azure CLI script, we eliminate manual, error-prone DNS configuration. This step completes the network prerequisite necessary for the next, highly critical stage: enabling secure, automated HTTPS across all your AKS applications.

## What's Next?

With DNS records correctly pointing to the Gateway, we are ready to implement true security:

* **Part 5:** Setting up **Cert-Manager** and a **ClusterIssuer** to automatically create free and valid TLS certificates.
* **Part 6:** Extending the TLS setup to support **Wildcard Certificates** using Azure DNS for the necessary challenge verification.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Automate%20DNS%20Records%20for%20AKS%20TLS%20Setup%20-%20Part%204" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Automate DNS Records for AKS TLS Setup - Part 4" and reviewed by me.

## Video - Automate DNS Records for AKS TLS Setup - Part 4

<iframe width="560" height="315" src="https://www.youtube.com/embed/gPvXGWCqkrI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>