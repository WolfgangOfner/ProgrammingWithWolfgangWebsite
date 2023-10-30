---
title: How to Build Docker Images with Podman using an Azure DevOps Agent in Kubernetes
date: 2023-10-02
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, Azure DevOps, Kubernetes, KEDA, Podman, CI-CD, AKS, Docker, DevOps]
description: Learn how to build Docker images using Podman with an Azure DevOps agent running in Kubernetes. A step-by-step guide for DevOps enthusiasts.
---

In the previous article, ["Mastering Azure DevOps Agents in Kubernetes - A Comprehensive Guide"](/mastering-azure-devops-agents-in-kubernetes-guide), we explored the utilization of Azure DevOps agents operating within a Kubernetes cluster, which are dynamically scaled using KEDA. By building the agent from a Dockerfile, you can incorporate all the necessary software for your application's build process. However, due to the agent's location within a Kubernetes cluster and the discontinuation of Dockershim by Kubernetes, building a Docker image is not feasible.

In this post, we will delve into the use of Podman as a solution to build your Docker images, despite the Azure DevOps agent running within a Kubernetes cluster.

## Building Docker Images without Podman

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/Ado-Agent-Keda" target="_blank" rel="noopener noreferrer">GitHub</a>.

If your Azure DevOps agent isn't running locally on your device or within Kubernetes, refer to ["Mastering Azure DevOps Agents in Kubernetes - A Comprehensive Guide"](/mastering-azure-devops-agents-in-kubernetes-guide) for comprehensive instructions to get started. This guide also provides information on configuring the Azure DevOps pipeline to utilize your self-hosted Azure DevOps agent.

To test the process of building a Dockerfile with your DevOps agent operating within a Kubernetes cluster, create the following pipeline in your Azure DevOps project:

<script src="https://gist.github.com/WolfgangOfner/db8fb8cb4aff6c5feb4117f3291ea447.js"></script>

Ensure to use the pool in which your DevOps is running. Additionally, add a Dockerfile to your repository. For more information on Docker and Dockerfiles, see ["Dockerize an ASP .NET Core Microservice and RabbitMQ"](/dockerize-an-asp-net-core-microservice-and-rabbitmq).

Upon running the pipeline, you’ll encounter an error message akin to the one displayed in the following screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/10/Docker-not-found-on-DevOps-Agent.jpg"><img loading="lazy" src="/assets/img/posts/2023/10/Docker-not-found-on-DevOps-Agent.jpg" alt="Docker not found on DevOps Agent" /></a>
  
  <p>
   Docker not found on DevOps Agent
  </p>
</div>

## Install Podman in your Azure DevOps Agent

You can find the Dockerfile of the Azure DevOps agent on <a href="https://github.com/WolfgangOfner/Ado-Agent-Keda/blob/main/Dockerfile" target="_blank" rel="noopener noreferrer">GitHub</a>.

The installation of Podman might seem daunting if you're unfamiliar with the process, but it is actually quite straightforward. Initially, you will need to manually add the Kubic repository, as it is not included in the default Ubuntu repository.

<script src="https://gist.github.com/WolfgangOfner/2509ad379c86213900a7675d46e16400.js"></script>

Following this, install Podman along with the fuse-overlayfs:

<script src="https://gist.github.com/WolfgangOfner/4a2245acc670ae16d4497dbc71336f1b.js"></script>

Lastly, it is necessary to add a volume. Without this step, you will encounter an error message when running the agent, as Podman will be unable to mount the required volume.

<script src="https://gist.github.com/WolfgangOfner/13273b03e3987e8f3c5ae90c55755e65.js"></script>

These are the only modifications needed for the Dockerfile. The complete Dockerfile looks as follows:

<script src="https://gist.github.com/WolfgangOfner/708446c954a56110f64dd8e90fa2a756.js"></script>

You can now execute the DevOps agent locally using the command outlined in the [last post](/mastering-azure-devops-agents-in-kubernetes-guide). Remember to include the --privilege flag to operate the container in privileged mode. Failure to do so will result in an error message when attempting to build a Dockerfile with your agent.

<script src="https://gist.github.com/WolfgangOfner/9c77304bfcf808d8a309696c380a5f9e.js"></script>

## Build Dockerfiles with your Azure DevOps Agent running in Kubernetes

Before proceeding with building your Dockerfile using the newly configured agent, it is necessary to update the pipeline. As we have transitioned to using Podman, the Dockerfile must be built using Podman. Replace the Docker task in the pipeline with the following code:

<script src="https://gist.github.com/WolfgangOfner/43e2cd8887a763ea8073ecb565e519eb.js"></script>

Ensure to update the path to your Dockerfile accordingly. If you haven't deployed your agent to Kubernetes, see ["Mastering Azure DevOps Agents in Kubernetes - A Comprehensive Guide"](/mastering-azure-devops-agents-in-kubernetes-guide).

Upon running the pipeline, you will likely encounter the following error message:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/10/Podman-Build-Error.jpg"><img loading="lazy" src="/assets/img/posts/2023/10/Podman-Build-Error.jpg" alt="Podman Build Error" /></a>
  
  <p>
   Podman Build Error
  </p>
</div>

This error arises due to Podman not operating in privileged mode.

## Run your Azure DevOps Agent in Privileged Mode within your Kubernetes Cluster

To fix the previous error, it is necessary to operate your Kubernetes agent in privileged mode. This can be achieved by incorporating the following code into the specification section of your container:

<script src="https://gist.github.com/WolfgangOfner/176365a8bb6a06978aafe3c3be51628c.js"></script>

The complete keda-scaled-jobs.yaml file should appear as follows:

<script src="https://gist.github.com/WolfgangOfner/71b38d508a258b8b208ba21d8f08ae87.js"></script>

To apply the file, use the following command. From this point forward, your Azure DevOps agent will operate in privileged mode:

<script src="https://gist.github.com/WolfgangOfner/fd446ac27483be1c9ce851b3f4442359.js"></script>

Upon running your pipeline again, the Dockerfile should be successfully built.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/10/Building-Docker-Image-with-the-Agent-running-in-Kubernetes.jpg"><img loading="lazy" src="/assets/img/posts/2023/10/Building-Docker-Image-with-the-Agent-running-in-Kubernetes.jpg" alt="Building Docker Image with the Agent running in Kubernetes" /></a>
  
  <p>
   Building Docker Image with the Agent running in Kubernetes
  </p>
</div>

## Considerations when Building Docker in Docker with Podman

It is important to note that, typically, the aim is to operate your pods and containers with the minimum privileges necessary. Running the Azure DevOps agent in privileged mode could potentially pose a security risk. However, I was unable to operate it in a non-privileged mode.

If anyone has insights on how to operate the container in a non-privileged mode, your contributions in the comments below would be greatly appreciated.

## Conclusion

In conclusion, this blog post has provided a comprehensive guide on how to use Podman to build Docker images with an Azure DevOps agent running inside a Kubernetes cluster. 

We have explored the process of installing Podman, running the Azure DevOps agent in privileged mode, and updating the pipeline for Dockerfile construction. 

However, it is important to note that running containers in privileged mode can pose potential security risks, and it is generally recommended to operate with the least privileges possible. If you have insights on operating the container in a non-privileged mode, your contributions would be greatly appreciated.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/Ado-Agent-Keda" target="_blank" rel="noopener noreferrer">GitHub</a>.