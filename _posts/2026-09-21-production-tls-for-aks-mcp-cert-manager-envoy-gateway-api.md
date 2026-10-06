---
title: Production TLS for AKS MCP - Cert-Manager & Envoy Gateway API
date: 2026-09-21
author: Wolfgang Ofner
categories: [Cloud, Kubernetes]
tags: [AKS, AKS-MCP, Cert-Manager, Gateway API, Envoy Gateway API, TLS Certificate, ListenerSet]
description: Master Azure Kubernetes Service with this guide to configuring an AKS MCP server. Enhance your cloud infrastructure and AI integrations today.
---

Exposing a Model Context Protocol (MCP) server running on Azure Kubernetes Service (AKS) for team-wide or external use requires a robust production setup. While local port-forwarding works during early development, a production-grade infrastructure demands public domain routing, automated TLS certificate lifecycles, and identity-based access control.

By combining the Kubernetes Gateway API, `cert-manager`, Azure Workload Identity, and Microsoft Entra ID, you can deploy an internet-facing MCP server that remains completely secure without managing long-lived secrets or manual port forwards.

## Gateway API & ListenerSet Routing

Connecting to an MCP server directly over HTTPS requires defining an ingress point using the Kubernetes Gateway API. Utilizing a `ListenerSet` resource allows you to attach dedicated listener configurations—specifically for HTTPS on port 443—directly to an existing Gateway infrastructure.

An accompanying `HTTPRoute` maps external incoming requests on your domain to the target MCP service running inside the cluster on port 8000. This decoupled architecture separates infrastructure management from application routing, ensuring clean traffic handling.

## Automated TLS via Cert-Manager and Azure Workload Identity

To serve traffic over HTTPS without managing static SSL/TLS certificates, `cert-manager` automates issuance and renewal through Let's Encrypt. 

### Zero-Secret DNS-01 Validation

To validate domain ownership for certificate requests, `cert-manager` uses the ACME DNS-01 challenge against Azure DNS. Rather than storing sensitive Azure credentials in Kubernetes secrets, the authentication relies on Azure Workload Identity:

1. **User-Assigned Managed Identity:** Created in Azure and assigned the `DNS Zone Contributor` role scoped directly to your Azure DNS zone.
2. **Federated Credentials:** Linked between the Azure Managed Identity and the `cert-manager` Kubernetes service account using your cluster's OIDC issuer URL.
3. **ClusterIssuer Configuration:** A `ClusterIssuer` resource points to Let's Encrypt and uses the managed identity's Client ID to interact with Azure DNS seamlessly.

When a new certificate is required, `cert-manager` dynamically creates the necessary `TXT` records in Azure DNS to satisfy the ACME challenge, receives the signed TLS certificate, and populates the secret referenced by your Gateway API `ListenerSet`. Automatic renewals trigger 30 days prior to expiration.

## Entra ID Authentication & Remote Helm Configuration

Because the endpoint is publicly accessible, access must be restricted to authenticated users.

To support authentication over a custom HTTPS domain:

* **App Registration Update:** Add the external OAuth callback URL (`https://<your-domain>/oauth/callback`) to your Entra ID App Registration redirect URIs.
* **Helm Values Update:** Upgrade the MCP Helm release to accept the new external domain name in its allowed hosts configuration, alongside the local Visual Studio Code callback port.

## Verifying Remote Access in Visual Studio Code

With HTTPS and Entra ID configured, Visual Studio Code connects directly to the remote domain endpoint. When initiating a connection:

1. VS Code triggers an OAuth login prompt directing you to your custom domain.
2. Entra ID enforces user authentication and Multi-Factor Authentication (MFA).
3. Upon successful login, VS Code receives an authorization token and establishes a secure channel to the MCP server.

## Wrapping Up

Transitioning from local port-forwarding to a public-facing infrastructure powered by the Gateway API, `cert-manager`, Azure Workload Identity, and Entra ID turns a developer experiment into an enterprise-ready platform utility. This architecture gives your engineering team friction-free remote access directly from Visual Studio Code while maintaining strict zero-trust access control and zero secret-management overhead.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Production%20TLS%20for%20AKS%20MCP-%20cert-manager%20%26%20Envoy%20Gateway%20API">GitHub</a>.

This post was AI-generated based on the transcript of the video "Production TLS for AKS MCP - Cert-Manager & Envoy Gateway API".

## Video - Production TLS for AKS MCP - Cert-Manager & Envoy Gateway API

<iframe width="560" height="315" src="https://www.youtube.com/embed/wWoyeWky1R4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>