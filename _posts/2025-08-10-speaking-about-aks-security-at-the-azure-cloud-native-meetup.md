---
title: Speaking about AKS Security at the Azure Cloud Native Meetup
date: 2025-08-10
author: Wolfgang Ofner
categories: [Speaking]
tags: [Azure Kubernetes Service, AKS, Speaking, Public Speaking, Kubernetes, Azure, Security]
description: Join me at the Azure Cloud Native Meetup and learn everything developers need to know to keep their AKS cluster secure.
---

I am excited to announce that I will be speaking at the Azure Cloud Native Meetup on Thursday, August 21, 2025, at 1:00 PM ET!

My session, "AKS Security Simplified for Developers," will dive into practical strategies for securing your Azure Kubernetes Service (AKS) clusters. We will break down common security concerns and demonstrate how manageable it can be to implement robust protection for your containerized applications.

Here is a sneak peek at what we will cover:

- **Secure Image Storage and Retrieval:** Setting up private connections to Azure Container Registry.
- **Enforcing Security Standards:** Integrating Azure Policy for consistent security across your clusters.
- **Secretless Access:** Leveraging Entra Workload ID for secure resource access.
- **Enhancing Cluster Security:** Understanding the benefits of private AKS clusters.
- **Authentication Options:** Utilizing Entra ID for secure user access.
- **Securing Azure DevOps Pipelines with Private Clusters:** Addressing the challenges and solutions for effective integration using service connections and managed identities.

This session is designed for developers and anyone working with AKS who wants to gain a clearer understanding of how to implement effective security measures. We will go beyond theory with practical demos and expert tips you can apply immediately. Whether you're just starting with AKS or looking to level up your security game, this session will provide valuable insights.

Don't miss out on this opportunity to learn how to secure your Kubernetes environment effectively!

Join me online on Thursday, August 21, 2025, at 1:00 PM ET.

You can register for the event and get more details <a href="https://www.meetup.com/azure-cloud-native/events/308204875/" target="_blank" rel="noopener noreferrer">on Meetup</a>.

Looking forward to seeing you there!

## Slides of the Talk

You can find the slides of the talk on <a href="https://github.com/WolfgangOfner/Presentation/blob/main/2025%20-%20Azure%20Cloud%20Native/AKS%20Security%20Simplified%20for%20Developers%20.pdf" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Watch on Youtube

You can find the recording of the talk on Youtube.

<iframe width="560" height="315" src="https://youtu.be/GsazJl_HeFY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

The abstract for my session is as follows:

## AKS Security Simplified for Developers

Kubernetes is widely adopted for managing containerized applications, therefore, ensuring its security is crucial. This talk will demonstrate that securing your Azure Kubernetes Service (AKS) clusters, while it may seem challenging, is quite manageable with the right practices.

This session explores setting up private connections to Azure Container Registry, enabling secure image storage and retrieval. It also covers integrating Azure Policy to enforce security standards across your clusters, and how Entra Workload ID provides secure access to resources without the need for managing secrets.

Private clusters enhance the security by restricting access to the cluster's API server endpoint. Various authentication options, such as using Entra ID, ensure that only authorized users can access your resources. However, accessing private clusters from Azure DevOps pipelines presents unique challenges. This talk addresses these by explaining how to configure service connections and use managed identities effectively.

Attend this session for a comprehensive overview of these security features, complete with practical demos and expert tips. Whether you are new to AKS or looking to enhance your existing security measures, this session will provide valuable insights to help you secure your Kubernetes environment effectively