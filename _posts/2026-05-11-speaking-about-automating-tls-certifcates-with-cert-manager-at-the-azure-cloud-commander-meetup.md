---
title: Speaking about automating TLS Certificates with Cert-Manager at the Azure Cloud Commanders Meetup
date: 2026-05-11
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress]
description: Master automated certificate management on AKS at Azure Cloud Commanders Meetup. Learn about Cert-Manager, DNS-01 challenges, and Azure Workload Identity.
---

Manual certificate management is an operational liability waiting to happen. Tracking expiration dates, manually rotating keys, and managing long-lived secrets across numerous DNS zones is a recipe for a sudden, unexpected production outage. 

Join me on **June 1st, 2026 at 3 PM ET** for a deep dive into building a completely hands-off, zero-trust certificate infrastructure. 

[Register and Join the Session Here](https://techcommunity.microsoft.com/event/905f6364-959b-4f0a-bb85-10c14d665ed6/set-it-and-forget-it-secure--automated-certificate-management-on-aks/4518589)

## What We are Building

This session focuses on moving away from manual interventions and long-lived credentials entirely. We will walk through the exact architectural patterns and technical steps required to achieve a true "set it and forget it" certificate lifecycle on Kubernetes.

Here is the breakdown of what we will cover:

* **Identity over Secrets:** How to leverage Azure Workload Identity and cert-manager to eliminate the need for storing high-privilege credentials inside your cluster.
* **Wildcards & Validation at Scale:** Using DNS-01 challenges to safely automate wildcard certificates, including how to handle CNAME delegation to securely manage verification across multiple DNS zones via a centralized validation domain.
* **End-to-End Encryption:** How to correctly combine cloud-edge protection—like Azure Front Door managed certificates—with automated regional backend certificates to ensure traffic remains fully encrypted from the edge down to the individual pod.

If you want to remove manual overhead from your platform team and guarantee your cluster security never lapses due to an expired certificate, this talk is for you.

See you there on June 1st! 

[Secure Your Spot for the Event](https://techcommunity.microsoft.com/event/905f6364-959b-4f0a-bb85-10c14d665ed6/set-it-and-forget-it-secure--automated-certificate-management-on-aks/4518589)

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Azure%20Cloud%20Commanders/Set%20It%20and%20Forget%20It%20-%20Secure%20%26%20Automated%20Certificate%20Management%20on%20AKS" target="_blank" rel="noopener noreferrer">GitHub</a>.

<!-- ## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/cpzYH_Xk_xw?si=f85WjKS_qI9zHTxx" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Set It and Forget It: Secure & Automated Certificate Management on AKS

Manual certificate rotation has become a significant operational liability. In an era of shrinking certificate lifespans and increasing cluster complexity, traditional manual methods are no longer a viable way to maintain production uptime. Automation has transitioned from a luxury to a fundamental security requirement for modern cloud-native environments. 

This session breaks down the implementation of a modern "Gold Standard" for certificate management on Azure Kubernetes Service, explaining the mechanics of both HTTP-01 and DNS-01 validation challenges while detailing the practical differences between specific and wildcard certificates.

The presentation demonstrates a secure, zero-secret identity model using Azure Workload Identity to grant Cert-Manager access to Azure DNS without managing long-lived credentials. 

Attendees will gain a technical understanding of the mechanics behind the DNS-01 challenge and why it is the essential method for issuing wildcard certificates. The discussion also covers how to configure automated renewals and on-demand provisioning, enabling advanced workflows such as dynamic certificate creation for ephemeral environments during pull request deployments.

By the end of the session, participants will have the specific technical knowledge required to integrate these automated systems with both Ingress and the Gateway API, allowing them to build and maintain a fully automated, hands-off certificate lifecycle.