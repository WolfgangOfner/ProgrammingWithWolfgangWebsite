---
title: ListenerSet + cert manager - The Perfect Gateway API Combo
date: 2026-10-05
author: Wolfgang Ofner
categories: [Cloud, Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Envoy, Envoy Gateway API, ListenerSet, Platform Engineering, Cert-Manager, TLS Certificate]
description: Automate HTTPS certificates in Kubernetes by pairing Gateway API ListenerSet with cert-manager and Azure DNS workload identity for secure self-service ingress.
---

Managing TLS certificates across multi-tenant Kubernetes clusters can quickly become a friction point between platform engineering teams and developer teams. With the evolution of the Kubernetes Gateway API, the ListenerSet custom resource enables individual application teams to attach independent listeners to a shared Gateway.

By pairing Gateway API ListenerSets with cert-manager (v1.20+) and passwordless Entra Workload ID, teams can dynamically auto-provision production-ready Let's Encrypt HTTPS certificates without administrative friction or hardcoded credentials.

## Key Benefits of the ListenerSet + cert-manager Pattern

* **Decoupled Responsibilities:** Platform operators manage the core Gateway and ClusterIssuer, while development teams attach custom domains and TLS requirements via ListenerSets.
* **Zero-Trust & Passwordless Security:** Uses Azure Entra Workload ID (OIDC federation) so cert-manager can update Azure DNS TXT records without static API keys or stored credentials.
* **Automated Renewal Loops:** Let’s Encrypt certificates auto-renew every 60 days, ensuring zero-downtime HTTPS across all services.
* **Reduced Blast Radius:** Misconfigurations in one team's ListenerSet do not affect the central Gateway or other tenant workloads.

## Architecture Flow

1. **Developer Team:** Applies a ListenerSet resource specifying port 443, their custom hostname, and a target secret reference.
2. **Gateway API:** Notifies cert-manager of the missing TLS secret based on annotations pointing to the ClusterIssuer.
3. **cert-manager:** Initiates the ACME DNS-01 challenge against Azure DNS using passwordless Entra Workload Identity.
4. **Azure DNS & Let's Encrypt:** Let's Encrypt verifies the TXT record in Azure DNS and issues a signed certificate.
5. **TLS Secret & Envoy Gateway:** The certificate populates into the Kubernetes Secret, allowing Envoy Gateway to transition the listener status to Programmed and terminate HTTPS traffic.

## Step-by-Step Implementation Guide

### 1. Enable Workload Identity on Your Kubernetes Cluster
When creating or updating your AKS cluster, ensure both the OIDC Issuer and Workload Identity flags are enabled. This provides the identity foundation required for cert-manager to communicate securely with Azure services.

### 2. Install cert-manager with ListenerSet Feature Gates
Deploy cert-manager via Helm (version 1.20.3 or newer) into the cert-manager namespace with Custom Resource Definitions enabled. Crucially, set the Gateway API flag to true and pass the feature gate parameter enabling Gateway API ListenerSets.

### 3. Configure Azure Managed Identity for DNS-01 Validation
To allow cert-manager to solve DNS-01 challenges, set up identity permissions in Azure:
* Create a User-Assigned Managed Identity in your resource group.
* Assign the DNS Zone Contributor role to this Managed Identity scoped to your Azure DNS zone.
* Establish a Federated Identity Credential linking the AKS OIDC issuer URL and the cert-manager Kubernetes service account to the Azure Managed Identity.

### 4. Deploy the Let's Encrypt ClusterIssuer
Create a cluster-wide ClusterIssuer resource specifying the Let's Encrypt production endpoint, your admin email address, and an ACME DNS-01 solver. In the solver configuration, reference your Azure DNS zone name, subscription ID, resource group, and the Client ID of the Azure Managed Identity.

### 5. Create the Team-Level ListenerSet Resource
Application teams can now attach HTTPS endpoints to the shared Envoy Gateway. In their namespace, they deploy a ListenerSet resource that includes:
* An annotation referencing the ClusterIssuer name (`cert-manager.io/cluster-issuer`).
* A parent reference pointing to the shared cluster Gateway.
* A listener entry on port 443 (HTTPS protocol) with their application hostname and a target secret name for storing the certificate.

Once applied, cert-manager automatically creates the DNS TXT record, completes the Let's Encrypt challenge, populates the secret, and Envoy Gateway begins serving HTTPS traffic.

## Summary

Combining Gateway API ListenerSets with cert-manager establishes a clean boundary between central platform control and developer autonomy. Application teams gain self-service HTTPS provisioning without managing credentials, while platform architects maintain cluster-wide governance and security standards.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/ListenerSet%20%2B%20cert-manager%20-%20The%20Perfect%20Gateway%20API%20Combo">GitHub</a>.

This post was AI-generated based on the transcript of the video "ListenerSet + cert manager - The Perfect Gateway API Combo".

## Video - ListenerSet + cert manager - The Perfect Gateway API Combo

<iframe width="560" height="315" src="https://www.youtube.com/embed/nhcpQN33IJI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>