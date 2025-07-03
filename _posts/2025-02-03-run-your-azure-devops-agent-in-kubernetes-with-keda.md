---
title: Run your Azure DevOps Agent in Kubernetes with KEDA
date: 2025-02-03
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [DevOps, AKS, KEDA, Azure DevOps]
description: Learn the different possibilities to host your Azure DevOps agents and take a deep dive into running your agent inside a Docker container and then deploy it to a Kubernetes cluster where it can be automatically scaled with KEDA. 
---

This post, based on "Azure DevOps Agents in Azure Kubernetes Service (AKS) - The Cost Optimized Way," provides a comprehensive guide to hosting Azure DevOps agents within an Azure Kubernetes Service (AKS) cluster. This modern approach leverages KEDA for automatic scaling, offering a flexible and cost-effective alternative to traditional VM-based agents.

## Why Host Agents in AKS?

While Microsoft-hosted agents are convenient, they come with limitations like no VNet integration, restricted access to private resources, and execution time limits. Self-hosted agents become necessary for accessing private resources, longer execution times, or caching. Running these agents within an existing AKS cluster allows you to utilize your existing Kubernetes infrastructure efficiently and scale dynamically.

## Key Steps and Concepts

1. **Building a Docker Container for the Agent**
The process begins by creating a Dockerfile for your Azure DevOps agent. This typically involves:

- Using a base image like Ubuntu.
- Installing necessary tools (e.g., curl, git).
- Configuring a non-root user for enhanced security.

2. **Local Testing**
Before deploying to AKS, it's crucial to test your agent locally. This involves:

- Building and running the Docker container.
- Connecting it to Azure DevOps using a Personal Access Token (PAT) with appropriate permissions and specifying an agent pool.
- Running a simple pipeline to ensure the local agent picks up and executes the job successfully.

3. **Deployment to AKS**
Once tested, the agent Docker image is pushed to a container registry (e.g., Docker Hub, Azure Container Registry). It's then deployed to your AKS cluster using a Kubernetes YAML file that defines:
- A Kubernetes secret for securely storing the PAT.
- The container deployment itself, referencing your agent image.

4. **Integrating KEDA for Scaling**
KEDA (Kubernetes Event-driven Architecture) is a game-changer for cost optimization.

- **Installation:** KEDA is typically installed via Helm.
- **Configuration:** A ScaledJob YAML file is configured to define when agents should scale. KEDA monitors Azure Pipelines events (e.g., a new job starting) and automatically scales the number of agent pods up or down based on demand. This allows agents to scale to zero when no jobs are running, significantly reducing costs.

5. **Enhancing Agent Capabilities**
The video also demonstrates how to extend your agent's capabilities:

- **Installing SDKs:** Modifying the Dockerfile to include necessary SDKs (e.g., .NET SDK) for building specific application types.
- **Building Docker Files with Podman:** Addressing the "Docker in Docker" challenge within Kubernetes by demonstrating how to install and use Podman to build Docker images. A workaround for running the container in privileged mode might be discussed for rootless container scenarios.

## Considerations for Using AKS for Agents

- **Existing Kubernetes Cluster:** This approach is most beneficial if you already have an AKS cluster with available resources.
- **Private Resource Deployment:** Ideal for pipelines that need to deploy to or interact with private resources within the same VNet as your Kubernetes cluster.
- **Building Docker Files:** While possible, "Docker in Docker" has security implications and might not always be the most efficient method.
- **Azure DevOps Licensing:** Be mindful of your parallel build licenses, as they can limit the actual number of concurrent jobs, potentially impacting KEDA's scaling effectiveness.
- **Local Testing:** Using a Docker container for local agent testing remains a convenient way to iterate and troubleshoot.

## Conclusion

Hosting Azure DevOps agents in AKS with KEDA offers a powerful, flexible, and cost-optimized solution for your CI/CD pipelines. By leveraging Kubernetes' orchestration capabilities and KEDA's event-driven scaling, you can build a highly efficient agent infrastructure that scales precisely with your workload, ensuring optimal resource utilization and reduced operational costs.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Run%20Azure%20DevOps%20Agent%20in%20Kubernetes%20with%20Keda" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Run your Azure DevOps Agent in Kubernetes with KEDA" and reviewed by me.

## Video - Run your Azure DevOps Agent in Kubernetes with KEDA

<iframe width="560" height="315" src="https://www.youtube.com/embed/42EzF7lQXf0?si=zha4Uig2mH3Z_Az6" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>