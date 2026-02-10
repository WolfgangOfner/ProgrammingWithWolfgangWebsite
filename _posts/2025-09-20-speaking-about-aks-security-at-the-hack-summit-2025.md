---
title: Speaking about AKS Security at The Hack Summit 2025
date: 2025-09-20
author: Wolfgang Ofner
categories: [Speaking]
tags: [Azure Kubernetes Service, AKS, Speaking, Public Speaking, Conference,Kubernetes, Azure, Security]
description: Join me at The Hack Summit 2025 and learn everything Auzure developers need to know to keep their AKS cluster secure.
---

I am excited to announce that I will be sharing my expertise on cloud security at The Hack Summit 2025! While the conference is running, my session, "AKS Security Simplified for Developers," will be available on-demand (VOD) for you to watch at your convenience.

This session is designed specifically for developers and teams who need to secure their Kubernetes environments without getting bogged down in complex infrastructure management.

## Why You Should Watch

If you have ever worried that securing your AKS environment is too complicated, this session is for you. We cut through the noise to focus on the essential Azure-native tools that simplify complex security challenges like:

- **Eliminating Secrets:** Using Entra Workload ID to secure application-to-resource communication.
- **Controlling Network Traffic:** Securing your image supply chain with private ACR connections.
- **Managing Access:** Configuring secure access for both developers and CI/CD pipelines to private clusters.
- **Enforcing Governance:** Leveraging Azure Policy to automatically maintain security standards.

I look forward to you watching the session! Be sure to check out the rest of the fantastic content available at The Hack Summit 2025.

Join me online on Monday, October 13, 2025.

You can register for the event and get more details on the <a href="https://thehacksummit.com/en" target="_blank" rel="noopener noreferrer">conference website</a>.

Looking forward to seeing you there!

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/blob/main/2025%20-%20The%20Hack%20Summit%202025/AKS%20Security%20Simplified%20for%20Developers.pdf" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://youtu.be/kymejuB0CZI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

The abstract for my session is as follows:

## AKS Security Simplified for Developers

Kubernetes is widely adopted for managing containerized applications, therefore, ensuring its security is crucial. This talk will demonstrate that securing your Azure Kubernetes Service (AKS) clusters, while it may seem challenging, is quite manageable with the right practices. 

This session explores setting up private connections to Azure Container Registry, enabling secure image storage and retrieval. It also covers integrating Azure Policy to enforce security standards across your clusters, and how Entra Workload ID provides secure access to resources without the need for managing secrets. 

Private clusters enhance the security by restricting access to the cluster's API server endpoint. Various authentication options, such as using Entra ID, ensure that only authorized users can access your resources. However, accessing private clusters from CI/CD pipelines presents unique challenges. This talk addresses these by explaining how to configure service connections and use managed identities effectively. 

Attend this session for a comprehensive overview of these security features, complete with practical demos and expert tips. Whether you are new to AKS or looking to enhance your existing security measures, this session will provide valuable insights to help you secure your Kubernetes environment effectively.