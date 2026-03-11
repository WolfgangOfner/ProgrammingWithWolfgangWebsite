---
title: Speaking about Managed DevOps Pools at the Warsaw IT Days 2026
date: 2026-03-04
author: Wolfgang Ofner
categories: [Speaking]
tags: [Speaking, Public Speaking, Conference, Azure, Security, Azure DevOps, Managed DevOps Pools, Private Endpoint]
description: Learn how to secure Azure DevOps pipelines using Managed DevOps Pools. This session covers VNet injection, Managed Identities, and cost-effective scaling.
---

I’m excited to share that I’ll be speaking at [Warsaw IT Days 2026](https://warszawskiedniinformatyki.pl/en/)! My session will be available as a VOD starting **March 19, 2026**.

Securing enterprise cloud environments by moving critical resources like **AKS, Azure SQL, and Key Vault** behind Private Endpoints is a standard security posture. However, it often creates a connectivity gap where standard cloud build agents lack native visibility into these private environments.

In my session, **"Private, Secure, and Cost-Effective: The Trifecta of Managed DevOps Pools,"** we will explore how to resolve this conflict.

## What We Will Cover

Traditionally, teams have been forced to choose between the high maintenance of virtual machines or complex, insecure networking workarounds. Managed DevOps Pools offer a better way by providing the seamless experience of hosted agents with the security of native Virtual Network integration.

* **Technical Implementation:** Learn how to use VNet injection to grant build agents direct access to private resources without firewall modifications or public IP addresses.
* **Identity Management:** See how to leverage Managed Identities for authentication, eliminating the risks of Service Principal secrets and the operational burden of password rotation.
* **Total Cost of Ownership:** I’ll provide a framework for optimizing costs by transitioning from static, idle infrastructure to ephemeral, on-demand agents that scale dynamically.

### Join the Session

By the end of this presentation, you will have the technical knowledge required to build a secure, cost-effective pipeline foundation that serves the requirements of platform, security, and development teams alike.

Check out the session on **March 19, 2026**, via the
<href="https://warszawskiedniinformatyki.pl/en/" target="_blank" rel="noopener noreferrer">Warsaw IT Days portal</a>.

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/tree/main/2026%20-%20Warsaw%20IT%20Days/Private%2C%20Secure%2C%20and%20Cost-Effective%20-%20The%20Trifecta%20of%20Managed%20DevOps%20Pools" target="_blank" rel="noopener noreferrer">GitHub</a>.

<!-- ## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->

The abstract for my session is as follows:

## Private, Secure, and Cost-Effective: The Trifecta of Managed DevOps Pools

Traditionally, securing the enterprise cloud has meant moving critical resources like AKS, Azure SQL, and Key Vault behind Private Endpoints. While this posture significantly reduces the attack surface, it often creates a connectivity gap where standard cloud build agents lack native visibility into these private environments. 
Historically, teams have been forced to choose between the high maintenance of virtual machines or complex, insecure networking workarounds. Managed DevOps Pools resolve this conflict by providing the seamless experience of hosted agents with the security of native Virtual Network integration.

This session demonstrates the technical implementation of VNet injection to grant build agents direct access to private resources without the need for firewall modifications or public IP addresses. The presentation demonstrates how to leverage Managed Identities for authentication,, eliminating the risks of Service Principal secrets and the operational burden of password rotation. Furthermore, the session provides a framework for optimizing the total cost of ownership by transitioning from static, idle infrastructure to ephemeral, on-demand agents that scale dynamically with development needs. 

By the end of the session, participants will have the technical knowledge required to build a secure, cost-effective pipeline foundation that serves the requirements of platform, security, and development teams alike.