---
title: Manage your Kubernetes Resources with Kustomize
date: 2022-08-22
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, Kustomize, Flux, Azure Arc, GitOps, Deployment, Configuration Management]
description: Discover the power of Kubernetes deployment with Flux, Kustomize, and Azure Arc. Streamline your GitOps workflow for efficient configuration management in this comprehensive guide.
---

Azure Arc presents the Flux extensions as a powerful facilitator of the GitOps workflow. However, prior knowledge of Kustomize becomes indispensable for leveraging the full potential of the Flux extension.

Today, our objective is to shed light on the essence of Kustomize and its profound impact on creating meticulous configuration files for your applications. 

Furthermore, I will guide you through the process of deploying your application using the Kustomize CLI, equipping you with the necessary expertise in application deployment. Let's dive right in and explore the wonders of Kustomize!

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Kustomize - Kubernetes Native Configuration Management

<a href="https://kustomize.io/" target="_blank" rel="noopener noreferrer">Kustomize</a> is powerful open-source tool designed to customize your Kubernetes configuration seamlessly. Unlike Helm, Kustomize takes a different approach by eliminating the need for templates to manage your configuration files. Notably, Kustomize has become an integral part of kubectl since version 1.14, allowing you to leverage its capabilities without any additional installations.

When you unleash Kustomize on your folders, it diligently scans and compiles a comprehensive kustomization file. This file acts as a centralized hub, capturing vital information and references to all the YAML files discovered during the scanning process. Once you have your kustomization file in hand, you can effortlessly apply it to your Kubernetes cluster, bringing your configuration to life.

To witness the power of Kustomize firsthand, let's create a demo application and observe Kustomize in action.

## Deploy an Application to Kubernetes with Kustomize

You can find the code of the finished demo application on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

Before you get started, install <a href="https://kubectl.docs.kubernetes.io/installation/kustomize/" target="_blank" rel="noopener noreferrer">Kustomize</a>.

First, create a YAML file that contains a namespace definition:

<script src="https://gist.github.com/WolfgangOfner/ba40dd8f5d7b838dcfd8f3a670dd1508.js"></script>

Next, open your command line and navigate to the folder containing the namespace YAML file. Use Kustomize to scan the folder and generate a kustomization file based on the detected YAML files.

<script src="https://gist.github.com/WolfgangOfner/f3ad4fa81b46704160dad9f741100b51.js"></script>

The --autodetect flag tells Kustomize to search for Kubernetes resources, while the --recursive flag ensures that sub-folders are also included in the search.

The generated kustomization file will look like this:

<script src="https://gist.github.com/WolfgangOfner/431226a4308db7006e64da51aaf2c057.js"></script>

This is a simple kustomization file that references the previously created namespace file. It's sufficient for an initial deployment. You can combine the build of the kustomization file and its deployment using the following command:

<script src="https://gist.github.com/WolfgangOfner/7c04fe4e4b1363c2df01b11c8e79ceb3.js"></script>

After applying the kustomization file, you should see the newly created namespace.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-namespace-was-created.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-namespace-was-created.jpg" alt="The namespace was created" /></a>
  
  <p>
   The namespace was created
  </p>
</div>

## Flux with Kustomize

In the world of Azure Arc, Flux serves as the GitOps operator, seamlessly integrating with Kustomize for efficient deployment configuration. As we delve into the realm of Azure Arc, let's explore the powerful combination of Flux and Kustomize.

Kustomize offers a wide range of configuration parameters that enable fine-grained control over your deployments. Flux allows you to leverage these parameters during the creation of the Flux operator or incorporate them directly into the kustomization file. To better understand this integration, let's examine an example kustomization file:

<script src="https://gist.github.com/WolfgangOfner/441e0ab69f97cf6767e7e4fd245d329e.js"></script>

In this example, the kustomization file showcases various configuration parameters. The interval specifies the frequency at which Flux checks for configuration drifts and removes changes made outside of Kustomize. The wait parameter ensures that Flux waits until all resources are ready before proceeding. The timeout defines the duration after which Kustomize aborts the operation if it exceeds the specified time. The retryInterval determines the interval between retry attempts. The prune flag enables the removal of stale resources, while the force flag allows for the recreation of resources if necessary. The targetNamespace specifies the namespace where the resources are deployed.

Additionally, the sourceRef section defines the Git repository URL, the secretRef references a user PAT (personal access token) for accessing the repository, and the branch indicates the branch from which Kustomize fetches the resources.

It's worth noting that you can also configure Kustomize to use a local file instead of a URL by using the path parameter and specifying the folder path where your kustomization file resides.

With Flux and Kustomize working in harmony, you have the flexibility to tailor your deployments and fine-tune the configuration to meet your specific needs. The combination of GitOps principles with the versatility of Kustomize empowers you to achieve a robust and streamlined deployment workflow within the Azure Arc ecosystem.

## Conclusion

In summary, Flux and Kustomize form a powerful duo within the Azure Arc ecosystem, enabling a streamlined and automated GitOps workflow for managing Kubernetes deployments. With Flux serving as the GitOps operator and Kustomize providing flexible configuration management, you can achieve consistency, reproducibility, and efficiency in deploying and managing your applications. 

By leveraging their integration, you empower your team to automate deployments, detect configuration drifts, and maintain the desired state of your Kubernetes resources. Embrace the combined capabilities of Flux and Kustomize to enhance the reliability and scalability of your Azure Arc deployments, unlocking the full potential of GitOps within your Kubernetes environment.

[In my next post](/secure-application-deployments-azure-arc-flux-gitops), I will show you how to use Flux on Azure Arc to deploy your resources to Kubernetes with the help of Kustomize.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).