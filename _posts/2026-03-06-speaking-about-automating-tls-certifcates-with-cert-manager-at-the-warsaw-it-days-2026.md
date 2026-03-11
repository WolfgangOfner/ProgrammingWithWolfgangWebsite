---
title: Speaking about automating TLS Certificates with Cert-Manager at the Warsaw IT Days 2026
date: 2026-03-06
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Kubernetes, AKS, Gateway API, Ingress, Cert-Manager, TLS Certificate]
description: Master automated certificate management on AKS at Warsaw IT Days 2026. Learn about Cert-Manager, DNS-01 challenges, and Azure Workload Identity.
---

I am happy to share the details for my third and final session at [Warsaw IT Days 2026](https://warszawskiedniinformatyki.pl/en/). This presentation, titled **"Set It and Forget It: Secure & Automated Certificate Management on AKS,"** will be available as a Video on Demand starting **March 19, 2026**.

In an era of shrinking certificate lifespans and increasing cluster complexity, manual rotation has transitioned from a simple task to a significant operational liability. Automation is no longer a luxury; it is a fundamental security requirement for any modern cloud-native environment.

## What We Will Cover

This session provides a deep dive into establishing a "Gold Standard" for certificate management on Azure Kubernetes Service (AKS). We will break down the mechanics of automation and how to remove the human element from the certificate lifecycle.

* **Validation Mechanics:** A technical comparison of HTTP-01 and DNS-01 validation challenges, including why DNS-01 is the essential choice for issuing wildcard certificates.
* **Zero-Secret Identity:** How to leverage **Azure Workload Identity** to grant Cert-Manager access to Azure DNS. This model eliminates the need for managing long-lived credentials or Service Principal secrets.
* **Dynamic Workflows:** We will discuss how to configure on-demand provisioning for advanced scenarios, such as creating dynamic certificates for ephemeral environments during pull request deployments.
* **Ecosystem Integration:** Guidance on integrating these automated systems with both Kubernetes Ingress and the Gateway API.

## Why Join This Session?

The goal is to move beyond temporary fixes and build a fully automated, hands-off certificate lifecycle. By the end of this session, you will have the technical knowledge required to ensure your production environments remain secure and uptime is maintained without manual intervention.

Catch the VOD on **March 19, 2026**, through the [Warsaw IT Days 2026 website](https://warszawskiedniinformatyki.pl/en/).

Check out the session on **March 19, 2026**, via the
<href="https://warszawskiedniinformatyki.pl/en/" target="_blank" rel="noopener noreferrer">Warsaw IT Days portal</a>.

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Warsaw%20IT%20Days/Set%20It%20and%20Forget%20It%20-%20Secure%20%26%20Automated%20Certificate%20Management%20on%20AKS" target="_blank" rel="noopener noreferrer">GitHub</a>.

<!-- ## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Set It and Forget It: Secure & Automated Certificate Management on AKS

Manual certificate rotation has become a significant operational liability. In an era of shrinking certificate lifespans and increasing cluster complexity, traditional manual methods are no longer a viable way to maintain production uptime. Automation has transitioned from a luxury to a fundamental security requirement for modern cloud-native environments. 

This session breaks down the implementation of a modern "Gold Standard" for certificate management on Azure Kubernetes Service, explaining the mechanics of both HTTP-01 and DNS-01 validation challenges while detailing the practical differences between specific and wildcard certificates.

The presentation demonstrates a secure, zero-secret identity model using Azure Workload Identity to grant Cert-Manager access to Azure DNS without managing long-lived credentials. 

Attendees will gain a technical understanding of the mechanics behind the DNS-01 challenge and why it is the essential method for issuing wildcard certificates. The discussion also covers how to configure automated renewals and on-demand provisioning, enabling advanced workflows such as dynamic certificate creation for ephemeral environments during pull request deployments.

By the end of the session, participants will have the specific technical knowledge required to integrate these automated systems with both Ingress and the Gateway API, allowing them to build and maintain a fully automated, hands-off certificate lifecycle.