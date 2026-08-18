---
title: Warsaw IT Days 2026 - Set It and Forget It - Secure & Automated Certificate Management on AKS
date: 2026-08-17
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, Gateway API, Envoy Gateway API, Cert-Manager, TLS Certificate]
description: Learn how to automate TLS certificate management on AKS using cert-manager, Gateway API, Let's Encrypt, and Entra Workload ID for zero-trust HTTPS.
---

Managing TLS certificates manually across enterprise Kubernetes clusters is an operational risk. Expired certificates lead to unexpected service outages, security warnings, and broken integrations. By combining **cert-manager**, **Let's Encrypt**, the **Kubernetes Gateway API**, and **Azure Entra Workload ID**, platform engineering teams can build a fully automated, secretless certificate lifecycle system on Azure Kubernetes Service (AKS).

Once properly configured, this setup automatically issues, installs, and renews single-domain and wildcard certificates before they expire, requiring zero ongoing manual intervention.

## Core Components: cert-manager and Let's Encrypt

At the heart of automated cluster security is **cert-manager**, an open-source Kubernetes operator that acts as the central controller for TLS certificates. It detects when incoming HTTP routes require HTTPS, requests certificates from a Certificate Authority (CA), and stores the resulting TLS key pairs as Kubernetes secrets.

### How CAs and Issuers Interact
cert-manager itself does not create certificates; it relies on **Issuers** or **ClusterIssuers**. 
* An **Issuer** is scoped to a single Kubernetes namespace.
* A **ClusterIssuer** operates cluster-wide, allowing workloads across multiple namespaces to share the same certificate authority configuration.

For public certificates, **Let's Encrypt** provides free, automated X.509 certificates. By default, Let's Encrypt certificates are valid for 90 days, with cert-manager automatically triggering a renewal roughly 30 days before expiration.

### Staging vs. Production Environments
When configuring cert-manager, Let's Encrypt offers two distinct environments:
* **Staging Environment**: Generates untrusted development certificates but features high rate limits. It is designed for testing cluster setups without risking IP or domain lockouts.
* **Production Environment**: Issues fully trusted, browser-recognized certificates but enforces strict rate limits (such as a cap on duplicate certificate requests per week).

The recommended workflow is to validate all DNS routes and solver configurations against the staging Issuer before switching the ClusterIssuer to production.

## Domain Ownership Validation: HTTP-01 vs. DNS-01

Before Let's Encrypt issues a TLS certificate, it must verify that the requester actually owns the targeted domain. cert-manager automates this verification using two primary challenge mechanisms:

### 1. HTTP-01 Challenge
The HTTP-01 challenge validates ownership by placing a temporary file containing an ACME token at a well-known HTTP path on your domain. Let's Encrypt makes an outbound HTTP request to this path to confirm the token matches.
* **Best Used For**: Standard individual domain names (e.g., `app.example.com`).
* **Limitations**: Cannot be used to issue wildcard certificates (`*.example.com`).

### 2. DNS-01 Challenge
The DNS-01 challenge validates domain ownership by writing a temporary `TXT` record directly into your DNS zone (such as `_acme-challenge.example.com`). Let's Encrypt queries your public DNS provider to verify the record's existence.
* **Best Used For**: Wildcard certificates covering arbitrary subdomains under a single endpoint.
* **Security Requirement**: The cluster must possess write permissions to your public DNS zone.

## Passwordless Security with Azure Entra Workload ID

Granting cert-manager access to modify public Azure DNS records can create a security vulnerability if managed using long-lived client secrets or service principal keys stored inside Kubernetes.

To eliminate credential leaks, AKS supports **Azure Entra Workload ID** (federated identity credentials):

1. **Service Account Linking**: A dedicated Kubernetes Service Account used by cert-manager is annotated to map directly to an Azure Managed Identity.
2. **Federated Credentials**: Azure Entra ID trusts the OpenID Connect (OIDC) issuer URL of the AKS cluster. It exchanges short-lived Kubernetes token credentials for Azure access tokens without relying on static passwords.
3. **Role Assignment**: The Azure Managed Identity is assigned the `DNS Zone Contributor` role scoped strictly to the Azure DNS resource group or zone.

This passwordless architecture enables cert-manager to write temporary ACME `TXT` records into Azure DNS seamlessly during DNS-01 challenges, maintaining a zero-trust security posture.

## Integrating with the Gateway API & Traffic Redirection

cert-manager natively integrates with the Kubernetes Gateway API. By annotating Gateway objects with the name of your ClusterIssuer, cert-manager continuously monitors Gateway listeners for HTTPS configurations.

When a new host name or wildcard route is added to an HTTPS listener on port 443, cert-manager automatically detects the missing secret, submits the challenge, retrieves the signed certificate, and binds it to the gateway proxy (such as Envoy).

### Enforcing Global HTTPS (301 Redirects)
To ensure unencrypted HTTP requests on port 80 never expose traffic, you can deploy a lightweight HTTPRoute on the port 80 listener. This route intercepts all incoming HTTP traffic and issues an immediate `301 Moved Permanently` redirect to port 443 (HTTPS), ensuring end-to-end transport security for all services.

## Conclusion & Summary

Automating TLS management transforms cluster security from a reactive maintenance burden into a silent, reliable platform feature. By deploying cert-manager alongside Let's Encrypt and the Kubernetes Gateway API, AKS operators achieve:

* **Zero Manual Effort**: Automatic issuance and 90-day renewal loops for single-domain and wildcard endpoints.
* **Secretless Azure Authentication**: Utilizing Azure Entra Workload ID and Managed Identities to perform DNS-01 challenges without static credentials.
* **Global Transport Protection**: Instant certificate binding and automatic HTTP-to-HTTPS traffic redirection.

Once configured, your cluster's certificate infrastructure becomes truly "set it and forget it," allowing engineering teams to focus entirely on building applications rather than managing infrastructure keys.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Warsaw%20IT%20Days%202026%20-%20Set%20It%20and%20Forget%20It%20-%20Secure%20%26%20Automated%20Certificate%20Management%20on%20AKS">GitHub</a>.

This post was AI-generated based on the transcript of the video "Warsaw IT Days 2026 - Set It and Forget It - Secure & Automated Certificate Management on AKS".

## Video - Warsaw IT Days 2026 - Set It and Forget It - Secure & Automated Certificate Management on AKS

<iframe width="560" height="315" src="https://www.youtube.com/embed/6HgGOrjttTM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>