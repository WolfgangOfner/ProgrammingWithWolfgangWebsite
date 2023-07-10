---
title: Secure Application Deployments in Azure Arc with Flux GitOps
date: 2022-08-29
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure Arc, Flux GitOps, Application Deployment, Secure Deployments, Kubernetes, Configuration Management, k3s]
description: Securely deploy applications in Azure Arc with Flux GitOps. Simplify Kubernetes deployments and enhance configuration management for efficient operations.
---

Azure Arc offers developers and administrators a seamless and robust GitOps process by leveraging the Flux extension, enabling efficient management and security.

In my previous post ["Manage your Kubernetes Resources with Kustomize"](/manage-kubernetes-resources-with-kustomize) I delved into the utilization of Kustomize for generating configuration files tailored to your Kubernetes cluster and applications. 

Today, we will explore the utilization of Flux to deploy these meticulously crafted configurations to an on-premises k3s cluster. This integration of Azure Arc, Kustomize, and Flux empowers organizations with enhanced control and flexibility in their deployment workflows.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Understanding Flux

<a href="https://fluxcd.io/" target="_blank" rel="noopener noreferrer">Flux</a> is a widely adopted open-source GitOps provider that serves as the GitOps operator for Azure Arc-enabled Kubernetes clusters. As an extension installed within your cluster, the Flux GitOps operator operates autonomously. It establishes an outbound connection, ensuring the security of your cluster without requiring any inbound connections. This modern approach empowers you to manage your deployments effectively.

The Flux extension leverages <a href="https://kustomize.io/" target="_blank" rel="noopener noreferrer">Kustomize</a> for configuring your deployments. If you would like to delve deeper into Kustomize, I invite you to refer to [my previous post](/manage-kubernetes-resources-with-kustomize) where I explored its intricacies and benefits. By combining the capabilities of Flux and Kustomize, you can streamline your deployment processes while adhering to best practices in the field of Kubernetes management.

## Introducing the Demo Application

You can find the code of the finished demo application on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

The demo application is designed with simplicity in mind and comprises a YAML file located in the repository's root folder. This YAML file encompasses a Deployment and a Service, forming the core components of the application.

<script src="https://gist.github.com/WolfgangOfner/416aa054b1e93e0ff6a1042dfb6af628.js"></script>

In addition to the application YAML file, I have also included a kustomization file in [my last post](/manage-kubernetes-resources-with-kustomize). This kustomization file instructs the Flux agent on which files to apply.

<script src="https://gist.github.com/WolfgangOfner/8b0004b02535f8386b8b4df8238e5cfc.js"></script>

By leveraging the code and the kustomization file, you can effortlessly deploy and manage the demo application using the power of Azure Arc, Flux, and Kustomize. Feel free to explore the GitHub repository for a comprehensive understanding of the demo application's implementation.

## Installing the Flux Extension

To integrate the Flux operator as an extension with Azure Arc, you need to connect to the Master node of your on-premises Kubernetes cluster and execute the following command for installation:

<script src="https://gist.github.com/WolfgangOfner/8e512913a04e7c0f5da10cb5572190e7.js"></script>

This command configures the installation of the Flux extension within the cluster-config namespace, granting access to the entire cluster through the scope parameter. It also sets up a Git repository and branch for Flux to interact with. The last line configures the kustomization configuration, specifying a name, path, and enabling the prune feature. When enabled, Kustomize will remove associated resources if their corresponding kustomization file is deleted, ensuring cluster cleanliness.

The cluster-config namespace will contain a configuration map and several secrets used for communication with Azure. These secrets also enable connectivity to private Git repositories. In [my next post](/deploy-application-from-private-repositories-flux-gitops-azure-arc), I will guide you on configuring a private Git repository as the source.

The installation process may take a few minutes. Once completed, navigate to your Azure Arc resource, open the Extensions pane, and you should find the Flux extension listed there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-Flux-extension-has-been-installed.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-Flux-extension-has-been-installed.jpg" alt="The Flux extension has been installed" /></a>
  
  <p>
   The Flux extension has been installed
  </p>
</div>

If you review the installation output, you'll notice an error indicating that the namespace was not found. The error message states: "namespace not specified, error: namespaces gitopsdemo not found."

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-namespace-was-not-found.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-namespace-was-not-found.jpg" alt="The namespace was not found" /></a>
  
  <p>
   The namespace was not found
  </p>
</div>

This error occurs because the YAML file specifies the gitopsdemo namespace, which hasn't been created yet. Consequently, the application installation fails.

To view the configuration of the previously installed GitOps operator, you can use the following command:

<script src="https://gist.github.com/WolfgangOfner/3becc88c809cbc70ae181c625c881b5b.js"></script>

Alternatively, in the Azure portal, navigate to the GitOps pane within your Azure Arc resource, click on the configuration, and if you used the same name, you should see "gitopsoperator." Clicking on it will display the same error message as shown above in the CLI output.

Let's resolve this issue by deleting the current GitOps configuration and rectifying it. Execute the following command to delete the GitOps operator:

<script src="https://gist.github.com/WolfgangOfner/33e3a691e751b0e1f03d0e1c6416751a.js"></script>

## Fixing the Failed Deployment

To address the problem mentioned earlier, we need to create the namespace before deploying the application. Instead of adding the namespace directly to the existing YAML file, let's adopt a more scalable approach. We'll create separate folders for different deployment types, such as "App" and "Infrastructure," and include a kustomization file in each folder. This organization ensures modularity, easy maintenance, and the ability to apply individual configurations.

First, let's create a YAML file in the "Infrastructure" folder to establish the new namespace:

<script src="https://gist.github.com/WolfgangOfner/ba40dd8f5d7b838dcfd8f3a670dd1508.js"></script>

Next, open a terminal and execute the following commands to create a kustomization file in each folder:

<script src="https://gist.github.com/WolfgangOfner/f1956fa7dcdad3ed47772a019edb63f3.js"></script>

Make sure that you have the <a href="https://kustomize.io" target="_blank" rel="noopener noreferrer">Kustomize CLI</a> installed.

To establish the dependency between the application deployment and the namespace creation, utilize the "dependsOn" attribute in the kustomization file:

<script src="https://gist.github.com/WolfgangOfner/a5d56b4eedd47ece4a873f0392613c45.js"></script>

Wait a moment, and this time the deployment should succeed. In the Azure portal, open the GitOps pane within your Azure Arc resource, and you should observe the deployment status as "succeeded."

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-deployment-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-deployment-succeeded.jpg" alt="The deployment succeeded" /></a>
  
  <p>
   The deployment succeeded
  </p>
</div>

If you make any changes to your Git repository, such as modifying the image tag, the Flux operator will fetch and deploy those changes automatically.

Check the pods in the gitops namespace to ensure that one pod of the application is running there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-application-runs-in-the-cluster.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-application-runs-in-the-cluster.jpg" alt="The application runs in the cluster" /></a>
  
  <p>
   The application runs in the cluster
  </p>
</div>

The Flux operator ensures seamless updates whenever changes are made to the Git repository, providing a robust and automated deployment process.

## Deleting the GitOps Configuration

When you delete the GitOps operator, the Azure CLI will prompt you to confirm the deletion. Additionally, it informs you that the prune flag has been enabled for this deployment. By confirming these messages, the GitOps operator and all associated resources will be deleted. In the case of this demo, it means that the namespace, application, and service will also be deleted. Once the deletion command completes, you will observe that no resources exist anymore.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/All-resources-got-deleted.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/All-resources-got-deleted.jpg" alt="All resources got deleted" /></a>
  
  <p>
   All resources got deleted
  </p>
</div>

Please note that although the prune flag is enabled, there might be instances where the prune operation doesn't function as expected. At present, the cause of this behavior remains unknown, and there are no available logs or error messages for further analysis.

## Using Private Repositories for GitOps

In the demo, a public Git repository was used to host the deployment files. However, in enterprise scenarios, applications are typically hosted on private Git repositories. In [my next post](/deploy-application-from-private-repositories-flux-gitops-azure-arc), I will guide you on securely connecting to a private repository in Azure DevOps or GitHub using Personal Access Tokens and the Flux GitOps operator.

## Conclusion

In summary, this article highlights the importance of secure application deployments in Azure Arc with Flux GitOps. By integrating Flux, Azure Arc, and Kustomize, developers and administrators can streamline Kubernetes deployments and enhance configuration management. 

The article introduces a demo application and provides installation steps for the Flux extension. It emphasizes the scalability of organizing deployments and mentions future topics such as deleting the GitOps configuration and using private repositories. Overall, Azure Arc, Flux GitOps, and Kustomize offer a robust solution for secure and efficient application deployments in Kubernetes clusters.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).