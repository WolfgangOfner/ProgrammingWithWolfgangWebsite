---
title: Speaking about automating TLS Certificates with Cert-Manager at The Hack Summit 2026
date: 2026-09-09
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress, Cert-Manager, TLS Certificate]
description: Automated certificate management on Azure Kubernetes Service using cert-manager and Azure Workload Identity. Watch my VOD at The Hack Summit 2026.
---

I am presenting a second session at **[The Hack Summit 2026](https://thehacksummit.com/en)**! My session, **"Set It and Forget It: Secure & Automated Certificate Management on AKS,"** releases on **November 5th, 2026** as an on-demand VOD presentation.

With certificate lifespans continuously shrinking, manual certificate rotation is no longer just an inconvenience—it is a major operational liability that leads to unexpected production downtime. In cloud-native environments, automated TLS certificate lifecycle management is a fundamental security requirement.

In this deep dive, I walk through building a "Gold Standard" automated certificate pipeline on Azure Kubernetes Service (AKS) using cert-manager and a zero-secret security model.

## Key Topics Covered

* **Validation Mechanics:** A detailed breakdown of HTTP-01 versus DNS-01 validation challenges, including why DNS-01 is essential for issuing wildcard certificates.
* **Zero-Secret Identity Model:** Leveraging Azure Workload Identity to grant cert-manager access to Azure DNS without managing long-lived secrets or credentials.
* **Dynamic Ephemeral Environments:** How to configure automated renewals and on-demand provisioning for short-lived pull request deployments.
* **Ingress & Gateway API Integration:** Practical technical steps to connect automated certificate issuance with both traditional Ingress controllers and the modern Kubernetes Gateway API.

Say goodbye to expired production certificates and late-night emergency renewals by building a completely hands-off certificate lifecycle.

Stream the session on-demand starting November 5th at **[The Hack Summit 2026](https://thehacksummit.com/en)**.

<!-- ## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Warsaw%20IT%20Days/Set%20It%20and%20Forget%20It%20-%20Secure%20%26%20Automated%20Certificate%20Management%20on%20AKS" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/6HgGOrjttTM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Set It and Forget It: Secure & Automated Certificate Management on AKS

Manual certificate rotation has become a significant operational liability. In an era of shrinking certificate lifespans and increasing cluster complexity, traditional manual methods are no longer a viable way to maintain production uptime. Automation has transitioned from a luxury to a fundamental security requirement for modern cloud-native environments. 

This session breaks down the implementation of a modern "Gold Standard" for certificate management on Azure Kubernetes Service, explaining the mechanics of both HTTP-01 and DNS-01 validation challenges while detailing the practical differences between specific and wildcard certificates.

The presentation demonstrates a secure, zero-secret identity model using Azure Workload Identity to grant Cert-Manager access to Azure DNS without managing long-lived credentials. 

Attendees will gain a technical understanding of the mechanics behind the DNS-01 challenge and why it is the essential method for issuing wildcard certificates. The discussion also covers how to configure automated renewals and on-demand provisioning, enabling advanced workflows such as dynamic certificate creation for ephemeral environments during pull request deployments.

By the end of the session, participants will have the specific technical knowledge required to integrate these automated systems with both Ingress and the Gateway API, allowing them to build and maintain a fully automated, hands-off certificate lifecycle.