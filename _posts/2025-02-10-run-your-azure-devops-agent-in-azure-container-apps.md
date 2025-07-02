---
title: Run your Azure DevOps Agent in Azure Container Apps
date: 2025-02-10
author: Wolfgang Ofner
categories: [DevOps]
tags: [DevOps, Azure Container Apps, KEDA, Azure DevOps]
description: Learn the different possibilities to host your Azure DevOps agents and take a deep dive into running your agent inside an Azure Container App where it can be automatically scaled as needed with KEDA. 
---

This post explores how to run Azure DevOps agents within Azure Container Apps, offering a compelling, cost-optimized alternative to traditional methods like Kubernetes or virtual machines. We'll cover the setup, automatic scaling with KEDA, and crucial considerations for this approach.

## Why Azure Container Apps for DevOps Agents?

Running Azure DevOps agents in Container Apps provides several benefits, particularly for cost efficiency and simplified management. It allows you to leverage the serverless nature of Container Apps, scaling agents only when needed and paying only for active runtime.

## Key Steps and Concepts:
1. **Azure DevOps Configuration**
- **Personal Access Token (PAT) Creation:** Begin by creating a PAT in Azure DevOps with "Agent Pools" read and manage permissions. This PAT is essential for your agent to authenticate with the Azure DevOps server.
- **Agent Pool Setup:** Create a new agent pool in your Azure DevOps project settings and grant necessary permissions to your pipelines to ensure jobs can be picked up.
2. **Local Agent Testing**
Before deploying to the cloud, it's good practice to test your agent locally. The video demonstrates running the Azure DevOps agent as a Docker container, providing environment variables for your Azure DevOps server URL, PAT, agent name, and agent pool name. A simple pipeline can then be executed in Azure DevOps to confirm the local agent successfully picks up and runs the job.
3. **Deployment to Azure Container Apps**
- **Resource Group and Environment Creation:** Create a new resource group and an Azure Container App environment in Azure. The environment serves as a secure, logical boundary for your containers.
- **Container App Creation:** Deploy your agent as a container app within this environment. You'll specify the Docker image, CPU and memory resources, and secrets for your PAT and organization URL.
- **Manual Trigger and Testing:** Initially, configure the container app for manual triggering to test its basic functionality. Run a pipeline to verify the agent in Azure Container Apps successfully picks up the job.
4. **Automatic Scaling with KEDA (Kubernetes Event-driven Autoscaling)**
One of the biggest advantages of this approach is integrating with KEDA for automatic scaling, which significantly optimizes costs.
- **Addressing Azure DevOps Limitations:** Azure DevOps typically requires at least one agent in a pool to schedule pipelines. KEDA allows you to scale agents down to zero when idle, minimizing costs.
- **KEDA Configuration:** Create a new container app job with KEDA configured for event-driven scaling based on Azure DevOps pipelines. This involves setting minimum (zero) and maximum running containers, polling intervals, and resource allocation.
- **Scaling Demonstration:** The video demonstrates how KEDA automatically starts agents when a pipeline with multiple jobs is executed. A key point to note is that KEDA scales based on jobs, not necessarily available licenses, which can lead to idle agents if your parallel build licenses are fewer than the number of jobs.
5. **Attaching a Storage Volume**
For persistent data or caching, you can attach a storage volume:
- **Storage Account and File Share Creation:** Create an Azure storage account and a file share.
- **Attaching to Container App Environment:** Attach the storage account to your container app environment using its key.
- **Updating Container App with Volume Mount:** Update your container app's configuration to include the volume mount. This can be done manually via YAML or through an automated process using a pre-configured YAML file.
- **Testing File Share Access:** Run a pipeline to create a file in the mounted storage volume to confirm successful integration.

## Considerations for Using Azure Container Apps for Agents

- **Best Use Cases:** This approach is ideal for small deployments requiring agents within the same Azure Virtual Network (VNet) as your Azure resources (e.g., accessing Azure Key Vault or a private Container Registry).
- **Cost Efficiency:** You only pay when the container app is running, offering significant cost savings compared to continuously running VMs.
- **Limitations:** Docker-in-Docker scenarios are not supported due to security concerns (privileged mode is not available).
- **License Management:** It's crucial to configure KEDA to scale agents based on the number of parallel build licenses you have to avoid paying for idle agents that cannot pick up jobs.

## Conclusion

Running Azure DevOps agents in Azure Container Apps offers a highly cost-optimized and efficient solution for your CI/CD pipelines. By leveraging KEDA for intelligent autoscaling and integrating with Azure's networking and storage services, you can build a robust and secure agent infrastructure that scales precisely with your demands, ensuring you only pay for what you use.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Run%20your%20Azure%20DevOps%20Agent%20in%20Azure%20Container%20Apps" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Run your Azure DevOps Agent in Azure Container Apps" and reviewed by me.

## Video - Run your Azure DevOps Agent in Azure Container Apps

<iframe width="560" height="315" src="https://www.youtube.com/embed/nSUafuQex1Y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>