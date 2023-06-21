---
title: Deploy Helm Charts from Git Repositories with Azure Arc Flux
date: 2023-06-19
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure Arc, Flux GitOps, Helm charts, Kubernetes deployments, Git repositories, k3s]
description: Learn streamlined Kubernetes deployments with Azure Arc and Flux GitOps. Deploy Helm charts from Git repositories, simplifying app management and collaboration. Optimize efficiency with this comprehensive guide.
---
Integrating Azure Arc with the Flux GitOps extension presents a highly effective approach for deploying infrastructure and applications to Kubernetes. In a previous article, I provided a comprehensive guide on installing the Flux extension and configuring deployments using Kustomize and YAML files, which can be found [here](/securely-deploy-application-azure-arc-with-flux-gitops).

Today, I want to demonstrate the process of deploying Helm charts using Azure Arc in conjunction with the Flux GitOps extension.

The following content forms a segment of the wider series titled ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Understanding Helm

When it comes to deploying microservices on Kubernetes, especially those with dependencies, the process can often be complex. This is where Helm, a powerful package manager for Kubernetes, proves invaluable. Helm simplifies the deployment process by enabling the creation of packages, with Helm taking charge of installation and updates. These packages, known as charts, encompass all the necessary components and configurations required by your application. Leveraging Helm's capabilities, you can effortlessly create or update your application based on the provided chart. Furthermore, Helm also functions as a versatile template engine, facilitating easy configuration of charts, be it locally or within your CI/CD pipeline.

For further insights and details, I recommend referring to my earlier post, [Helm - Getting Started](/helm-getting-started).

## Understanding the Flux Helm Controller

The Flux Helm Controller, an integral component of the Flux installation, is automatically installed alongside the Flux GitOps extension (specifically, the microsoft.flux extension) in Azure Arc. As a result, there's no need to install any additional tools to facilitate the deployment of Helm charts.

The Flux Helm Controller serves as a management tool for Kubernetes applications and cluster resources. It seamlessly integrates with the Helm package manager, enabling a GitOps workflow for deploying, updating, and rolling back Helm charts (which encapsulate Kubernetes application packages) within a cluster.

By leveraging the Flux Helm Controller, developers can define the desired state of their applications within a Git repository. The controller then ensures that the actual state of the cluster aligns with this desired state. It automatically monitors Git for any changes and promptly updates the cluster to maintain the desired state.

It's worth noting that Helm charts can be deployed from both Git repositories and Helm repositories. For the purpose of the upcoming demonstration, a Git repository will be utilized. However, in an upcoming post, I will elaborate on deploying charts from Helm repositories. To gain further insight, refer to the architectural depiction of the Flux Helm Controller presented in the accompanying screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Flux-Helm-Controller-Architecture.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Flux-Helm-Controller-Architecture.jpg" alt="Flux Helm Controller Architecture" /></a>
  
  <p>
   Flux Helm Controller Architecture (<a href="https://fluxcd.io/flux/components/helm" target="_blank" rel="noopener noreferrer">Source</a>)
  </p>
</div>

## Deploy Helm Charts from a Git Repository

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

Deploying a Helm chart directly from your Git repository offers a straightforward approach. To begin, create a new YAML file where you'll define essential details such as the path to your Helm chart within the Git repository, the branch to track, polling interval, and a name for the deployment.

<script src="https://gist.github.com/WolfgangOfner/c38f5fb56e201126b56ceae94ce9e069.js"></script>


Take note of the line "clusterconfig.azure.com/use-managed-source: "true", which informs Flux that the Helm chart is stored within a Git repository.

The next file to create is the kustomize file, which instructs the GitOps operator regarding the files it should execute. In the kustomize file, include the name of the previously generated YAML file.

<script src="https://gist.github.com/WolfgangOfner/7a20ec68184195f6d1d333a21a5cc8c9.js"></script>

Ensure that both files reside within the same folder in your Git repository. If you navigate to my GitHub repository, you will find these files within the ArcHelmGitOps folder. If you look at my GitHub repo, you will find the files in the ArcHelmGitOps folder.

### Testing the Helm Chart Deployment from a Git Repository

Before proceeding with deploying your application using the Azure Arc GitOps extension, ensure that you have Azure Arc installed on your Kubernetes cluster.

<script src="https://gist.github.com/WolfgangOfner/ae380c941cadbf525751baf148fef436.js"></script>

Once Azure Arc is successfully installed, proceed to install a GitOps operator with the following command:

<script src="https://gist.github.com/WolfgangOfner/1e4254cb3019dce0cb025b960708a6c2.js"></script>

This command will install the GitOps extension and subsequently the operator. The provided parameters should be self-explanatory.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-Flux-Extension-was-installed-and-the-configuration-created.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-Flux-Extension-was-installed-and-the-configuration-created.jpg" alt="The Flux Extension was installed and the configuration created" /></a>
  
  <p>
   The Flux Extension was installed and the configuration created
  </p>
</div>

After a few minutes, your application should be up and running within your k3s cluster.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-application-was-deployed.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-application-was-deployed.jpg" alt="The application was deployed" /></a>
  
  <p>
   The application was deployed
  </p>
</div>

Additionally, you can verify the compliance and state of the GitOps operator in the Azure portal. Access your Azure Arc instance, navigate to the GitOps pane, and observe the Compliance status as "Compliant" and the State as "Succeeded".

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-GitOps-operator-is-compliant.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-GitOps-operator-is-compliant.jpg" alt="The GitOps operator is compliant" /></a>
  
  <p>
   The GitOps operator is compliant
  </p>
</div>

### Overriding Values in the values.yaml File

In typical Continuous Deployment (CD) pipelines, it is common to override values, such as the image tag, in the values.yaml file. However, in the absence of a deployment pipeline utilizing GitOps, alternative methods are required for value overrides. Fortunately, it is possible to achieve this by adding the desired values directly to the HelmRelease file. The following code snippet demonstrates how to override the value for replicaCount and set it to 2:

<script src="https://gist.github.com/WolfgangOfner/d0f3eb51ea65ff223147abc956165315.js"></script>

By specifying the desired values directly within the HelmRelease file, you can conveniently override specific values without relying on a traditional CD pipeline (I will update this file with a CD pipeline in a future post). Customize the replicaCount and add any other necessary value overrides as need.

## Updating or Deleting the Flux Configuration

Thus far, we have focused on creating a new flux configuration. However, there are various other operations that can be performed, including updating or deleting an existing configuration. For a comprehensive overview of all available commands, please refer to the <a href="https://learn.microsoft.com/en-us/cli/azure/k8s-configuration/flux?view=azure-cli-latest" target="_blank" rel="noopener noreferrer">documentation</a>.

If you have completed the demo and wish to remove the flux configuration, execute the following command:

<script src="https://gist.github.com/WolfgangOfner/1c624b1e026e698ab991f1d52c25f9fb.js"></script>

To uninstall the Flux extension, utilize the subsequent command:

<script src="https://gist.github.com/WolfgangOfner/d18908706100e400b603241e3587f490.js"></script>

## Conclusion

In conclusion, Azure Arc combined with the Flux GitOps extension provides a powerful solution for deploying applications to Kubernetes clusters. Leveraging Helm and the Flux Helm Controller, developers can simplify the deployment process and maintain the desired state of their applications. With the ability to deploy Helm charts from Git repositories and easily manage configurations, Azure Arc and Flux enable efficient management of Kubernetes deployments, promoting collaboration and operational efficiency. Embracing these tools empowers developers to streamline their deployment workflows and maximize the potential of their Kubernetes infrastructure. 

In my next post, I will explore the installation of Helm charts from a Helm repository, aiming for a smoother experience compared to the demo discussed today. Stay tuned as we dive into this process and uncover its potential benefits.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).