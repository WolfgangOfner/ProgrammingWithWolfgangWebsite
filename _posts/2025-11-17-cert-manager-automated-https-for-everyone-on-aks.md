---
title: Cert-Manager Automated HTTPS for everyone on AKS - Part 5
date: 2025-11-17
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Azure DNS Zone]
description: Automate HTTPS and TLS for your AKS apps using Cert-Manager and Let's Encrypt. Learn to set up the ClusterIssuer with AGFC and Gateway API.
---

Building on our foundation of AKS, Application Gateway for Containers (AGFC), and Azure DNS, this article tackles the critical step of enabling secure, automated HTTPS for applications. This process uses Cert-Manager and Let's Encrypt to provide valid, free TLS certificates, eliminating the "insecure connection" warning and securing all traffic.

## Introducing Cert-Manager and ClusterIssuer

Achieving automated HTTPS requires two key Kubernetes resources:

* **Cert-Manager:** This controller watches the cluster for resources that request certificates and communicates with external Certificate Authorities (CAs) like Let's Encrypt to fulfill those requests.
* **ClusterIssuer:** A cluster-scoped resource that defines the CA configuration, including the ACME server endpoint (e.g., Let's Encrypt's production server) and the contact email for notifications.

This setup ensures that certificates are automatically renewed before their 90-day expiration, providing a hands-off, secure solution.

## Installation and Deployment

The deployment process involves three main steps:

1.  **Install Cert-Manager:** The controller is installed into the cluster, typically via Helm. It is crucial to enable the Gateway API feature during installation so Cert-Manager is aware of and can interact with the Gateway resources.
2.  **Deploy ClusterIssuer:** A `ClusterIssuer` resource is created, configured to use the production endpoint for Let's Encrypt. The configuration specifies the `HTTP01` solver, which defines how Cert-Manager proves domain ownership.
3.  **The HTTP01 Challenge:** When a certificate is requested, Cert-Manager uses the `HTTP01` challenge. It temporarily provisions a specific HTTP route that exposes a unique validation file. Let's Encrypt validates this file via the public domain name, proving ownership before issuing the certificate.

## Enabling HTTPS on the Gateway

With Cert-Manager ready, the Kubernetes `Gateway` resource must be updated to expose a secure listener:

* A new listener is added to the `Gateway` resource, explicitly configured for **Port 443** and the **HTTPS** protocol.
* This listener configuration must reference the hostnames (e.g., `traffic.example.com`) and point to the Kubernetes `Secret` where the certificate and key will be stored by Cert-Manager.

## Requesting and Routing Certificates

The final step is to request the certificates and ensure traffic is correctly routed:

1.  **Create Certificate Resources:** A `Certificate` resource is deployed for each domain (e.g., for Nginx and Traefik). This resource links the domain name to the deployed `ClusterIssuer` and specifies the name of the `Secret` that will hold the final certificate.
2.  **Automatic Provisioning:** Cert-Manager immediately takes over, executes the HTTP01 challenge via the Gateway, and populates the secret with the valid TLS certificate.
3.  **HTTPRoute Utilization:** Since the routing rules are already defined in the `HTTPRoute` resources (created in Part 3), no further modification is needed for the application side. Traffic arriving on the new 443 listener is seamlessly routed to the correct backend service.

## Conclusion

Part 5 successfully brings robust security to the AKS environment. By integrating Cert-Manager and Let's Encrypt with the Azure Application Gateway for Containers via the Kubernetes Gateway API, we achieve fully automated, end-to-end HTTPS encryption. The ability to automatically obtain and renew valid TLS certificates is a cornerstone of maintaining a secure and professional cloud-native application landscape.

## What's Next?

While the current setup supports specific domain names, the next part of the series will address advanced scenarios:

* **Part 6:** Extending the ClusterIssuer to support **Wildcard Certificates**, requiring integration with **Azure DNS** for the necessary DNS-01 challenge.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Cert-Manager%20Automated%20HTTPS%20for%20everyone%20on%20AKS%20-%20Part%205" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Cert-Manager Automated HTTPS for everyone on AKS - Part 5" and reviewed by me.

## Video - Cert-Manager Automated HTTPS for everyone on AKS - Part 5

<iframe width="560" height="315" src="https://www.youtube.com/embed/BfynzCAcvTc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>