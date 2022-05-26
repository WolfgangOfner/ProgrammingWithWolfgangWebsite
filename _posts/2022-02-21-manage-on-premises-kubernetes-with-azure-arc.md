---
title: Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc
date: 2022-02-21
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Kubernetes, k3s, Rancher, On-premises, Azure Arc, Azure Monitor, CI/CD, Flux, GitOps]
description: Azure Arc is a great tool to manage your on-premises hardware, such as an k3s cluster, with Azure.
---

Azure Arc is a great tool to manage your on-premises hardware with Azure. This series will focus on managing a Kubernetes (k3s) cluster and will show how to install Azure Arc, and how to use different Azure services to manage the cluster.

## Project Requirements and Restrictions

The project for this demo has the following requirements and restrictions:

- Two on-premises Ubuntu 20.04 VMs
- Install and manage a Kubernetes distribution
- Developers must use CI/CD pipelines to deploy their applications
- A firewall blocks all inbound traffic
- Outbound traffic is allowed only on port 443
- Application logging
- Monitor Kubernetes and Vms metrics
- Alerting if something is wrong

The biggest problem with these restrictions is that the firewall blocks all inbound traffic. This makes the developers' life way hard, for example, using a CD pipeline with Azure DevOps won't work because Azure DevOps would push the changes from the internet onto the Kubernetes cluster.

All these problems can be solved with Azure Arc though. Let's see how to implement all this requirements from start to finish. 

- [Azure Arc - Getting Started](azure-arc-getting-started)

- [Install an on-premises k3s Cluster](/install-on-premises-k3s-cluster)

- [Install Azure Arc on an On-premises k3s Cluster](/install-azure-arc-on-premises-k3s-cluster)

Coming soon:

- Access k3s through Azure Arc
- GitOps with Flux
- CD with Helm Charts using Flux
- Deploying from a private Git repository
- Collecting Metrics from the k3s cluster
- Azure Monitoring
- Azure Key Vault integration
- Azure App Services running on on-premises infrastructure
- tbd
