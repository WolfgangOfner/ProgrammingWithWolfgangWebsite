---
title: Infrastructure to App - Production Ready Gateway API Pipeline - Part 19
date: 2026-02-23
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [Azure, AKS, Kubernetes, Gateway API, Azure DevOps, CI-CD, Cert-Manager, Pull Request, Envoy Gateway API]
description: Automate your Kubernetes Gateway API stack. Learn to build a production-ready Azure DevOps pipeline for AKS, Envoy, Cert-Manager, and PR deployments.
---

After 18 parts of exploring the individual components of the Kubernetes Gateway API, it is time to tie everything together. While manual configuration is great for learning, real-world projects require a repeatable, automated approach. In this installment, I share the blueprint for an Azure DevOps pipeline that handles everything from the initial infrastructure to application-specific routing.

## The Goal: One-Button Environments
The primary motivation behind this setup is the ability to spin up an entire environment—Kubernetes cluster, ingress controllers, certificate management, and DNS—with a single click. This is particularly useful for training, demos, or short-lived testing environments where you want to start clean and delete everything once the work is done.

## Part 1: Automating the Infrastructure
The core of the solution is the infrastructure pipeline. It revisits the key milestones of this series and automates them using the Azure CLI for clarity and simplicity. This pipeline manages:

* **AKS Cluster Provisioning:** Setting up the cluster with Workload Identity and Entra ID authentication enabled.
* **Security & Access:** Automatically assigning RBAC roles so that both the pipeline and the developers have the correct permissions without manual intervention.
* **Cert-Manager & DNS:** Integrating Cert-Manager with Azure DNS to handle TLS challenges automatically.
* **Envoy Gateway:** Deploying Envoy as the entry point and configuring the Gateway classes.

## Part 2: The Application CI/CD Flow
Once the foundation is laid, we look at the application layer. The application pipeline is split into two distinct phases: Continuous Integration (CI) and Continuous Deployment (CD).

In the CI phase, we focus on quality. We build the application and run unit tests directly inside a container to ensure consistency across different build agents. We also collect and publish code coverage and test results so that the health of the application is visible directly within Azure DevOps.

In the CD phase, the pipeline takes the validated container image and deploys it using Helm. The logic is designed to be environment-aware, handling different configurations for test and production environments while ensuring that traffic is always securely redirected from HTTP to HTTPS.

## The Power of Pull Request Deployments
One of the most valuable features of this setup is the implementation of Pull Request (PR) deployments. When a developer creates a PR, the pipeline automatically:

1. Provisions a new, isolated namespace in the cluster.
2. Generates a unique URL for that specific feature branch.
3. Deploys the application and requests a temporary TLS certificate.

This allows stakeholders to verify changes in a live environment before the code is ever merged into the main branch. Once the review is complete, a cleanup stage ensures that the temporary namespace is deleted, keeping the cluster tidy and resource-efficient.

## Conclusion
Building a production-ready pipeline isn't just about moving code; it’s about creating a reliable system where security, networking, and application logic work in harmony. While this setup is optimized for training and demos, it provides a solid foundation for any team looking to modernize their deployment strategy with the Gateway API.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Infrastructure%20to%20App%20-%20Production-Ready%20Gateway%20API%20Pipeline%20-%20Part%2019">GitHub</a>.

This post was AI-generated based on the transcript of the video "Infrastructure to App - Production Ready Gateway API Pipeline - Part 19".

## Video - Infrastructure to App - Production Ready Gateway API Pipeline - Part 19

<iframe width="560" height="315" src="https://www.youtube.com/embed/8UOj0aJDzXc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>