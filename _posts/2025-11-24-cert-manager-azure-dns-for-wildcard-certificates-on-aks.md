---
title: Cert Manager & Azure DNS for Wildcard Certificates on AKS - Part 6
date: 2025-11-24
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Azure DNS Zone, TLS Certifcate, Cert-Manager, HTTPS]
description: Automate Wildcard TLS for your AKS apps with Cert-Manager. Integrate the DNS-01 challenge securely with Azure DNS using Entra Workload Identity.
---

In previous guides, we explored how to automate standard HTTPS certificates for specific domains on Azure Kubernetes Service (AKS) using Cert-Manager and the HTTP-01 challenge. While effective for static sites, modern cloud-native workflows often require more flexibility.

This article expands that foundation to support **Wildcard Certificates** (e.g., `*.example.com`). Wildcard certificates are essential for dynamic environments, such as automatically provisioning unique URLs for pull request deployments without needing to issue a new certificate every time.

## The Challenge with Wildcards: Switching to DNS-01

The standard HTTP-01 validation method used for single domains involves placing a file on a specific web path. However, for security reasons, Let's Encrypt and other certificate authorities cannot validate wildcard ownership using this method. To prove ownership of an entire domain namespace like `*.example.com`, you must use the **DNS-01 challenge**.

The DNS-01 challenge requires creating a specific `TXT` record within your domain's DNS zone. When Cert-Manager requests a wildcard certificate, the CA checks for the presence of this DNS record to verify domain ownership before issuing the certificate.

## Securely Integrating Azure DNS with Entra Workload Identity

To automate the DNS-01 challenge, Cert-Manager needs permission to create and delete records in your Azure DNS zone. The least secure way to do this would be creating a service principal and storing its client secret in the cluster.

A far superior and recommended approach is using **Microsoft Entra Workload Identity** (the evolution of Pod Identity). This allows a Kubernetes Service Account to securely act as an Azure Managed Identity without ever storing hard-coded secrets or passwords in the cluster.

The setup involves:
* **Creating an Azure Managed Identity.**
* **Assigning Permissions:** Granting that Managed Identity the `DNS Zone Contributor` role on the target Azure DNS zone.
* **Establishing Federation:** Creating a federated identity credential that links the Kubernetes Service Account used by Cert-Manager directly to the Azure Managed Identity.

## Updating the ClusterIssuer for DNS-01

Once the identity infrastructure is in place, the existing `ClusterIssuer` Kubernetes resource must be updated to use the DNS solver instead of the HTTP solver.

The updated configuration tells Cert-Manager:
* To use the DNS-01 challenge mechanism.
* Which Azure DNS zone and resource group to target.
* Which Azure Managed Identity to use for authentication when performing DNS operations.

Once applied, Cert-Manager is empowered to automatically manage the required DNS verification records.

## Requesting and Using the Wildcard Certificate

With the `ClusterIssuer` configured for DNS-01, requesting a wildcard certificate is as simple as deploying a standard Kubernetes `Certificate` manifest requesting a domain like `*.yourdomain.com`.

Cert-Manager will detect the request, use the Managed Identity to create the verification TXT record in Azure DNS, wait for propagation, and then store the resulting validated wildcard certificate in a Kubernetes Secret.

Finally, the Kubernetes Gateway API resource needs an update. A new HTTPS listener is added for port 443, configured to use the wildcard hostname and referencing the newly created wildcard TLS secret. Any subsequent `HTTPRoute` created for a specific subdomain (e.g., `pr-123.yourdomain.com`) will automatically be secured by this single wildcard certificate.

## Conclusion

By transitioning from HTTP-01 to the DNS-01 challenge and leveraging Entra Workload Identity for secure Azure DNS integration, you unlock powerful, scalable SSL automation for your AKS cluster. This setup provides fully validated, free wildcard certificates, enabling secure, dynamic application deployments without the operational overhead and security risks of managing manual secrets or individual certificates for every new service.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Cert-Manager%20%26%20Azure%20DNS%20for%20Wildcard%20Certificates%20on%20AKS%20-%20Part%206" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Cert Manager & Azure DNS for Wildcard Certificates on AKS - Part 6" and reviewed by me.

## Video - Cert Manager & Azure DNS for Wildcard Certificates on AKS - Part 6

<iframe width="560" height="315" src="https://www.youtube.com/embed/io9GdZMwAYA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>