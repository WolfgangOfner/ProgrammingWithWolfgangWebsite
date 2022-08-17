---
title: Securely deploy Applications in Azure Arc with the Flux GitOps Extension
date: 2022-08-29
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [GitOps, Azure Arc, Flux, Kubernetes]
description: Azure Arc allows developers and administrators to implement a simple but secure GitOps process with the Flux extension.
---

Azure Arc allows developers and administrators to implement a simple but secure GitOps process with the Flux extension.

[My last post](/XXX) explained how you can use Kustomize to create configuration files for your Kubernetes cluster and applications and today I will use Flux to deploy these configurations to an on-premises k3s cluster. 

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## What is Flux?

<a href="https://fluxcd.io/" target="_blank" rel="noopener noreferrer">Flux</a> is a popular open-source GitOps provider and is used by Azure as the GitOps operator for Azure Arc enabled Kubernetes cluster. The Flux GitOps operator will be installed as an extension and will run inside your cluster. Once the Flux agent runs, it can send information to Azure and also connect to a Git repository. All this is done with an outbound connection, no inbound connection is needed. Therefore, your cluster will be safe, and additionally, you can use a modern approach to manage your deployments.

The Flux extension uses <a href="https://kustomize.io/" target="_blank" rel="noopener noreferrer">Kustomize</a> for the configuration of your deployments. For more information on Kustomize, see [my last post](/XXX).

## Introducing the Demo Application

You can find the code of the finished demo application on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

The application is very simple and consists only of a YAML file in the root folder of the repository that contains a Deployment and a Service.

<script src="https://gist.github.com/WolfgangOfner/416aa054b1e93e0ff6a1042dfb6af628.js"></script>

Additionally, I have added a kustomization file in [my last post](/XXX). This kustomization file will tell the Flux agent files it should apply.

<script src="https://gist.github.com/WolfgangOfner/8b0004b02535f8386b8b4df8238e5cfc.js"></script>

## Install the Flux Extension

The Flux operator can be installed as an extension with Azure Arc. Connect to the Master node of your on-premises Kubernetes cluster and use the following command to install the extension:

<script src="https://gist.github.com/WolfgangOfner/8e512913a04e7c0f5da10cb5572190e7.js"></script>

This command configures the Flux extension to be installed in the namespace cluster-config, allows access to the whole cluster with the scope parameter, and configures a Git repository and branch. The last line configures the kustomization configuration. This line sets a name, the path, and enables prune. If prune is enabled, Kustomize will delete all associated resources of the kustomization file when the file gets deleted. This should help to keep your cluster clean.

The configured namespace "cluster-config" will contain a config map and several secrets which will be used for the communication to Azure. Additionally, these secrets allow you to connect to a private Git repository. I will show you [in my next post](/XXX), how to configure a private Git repository as your source.

The installation should take a couple of minutes. After it is finished, go to your Azure Arc resource, open the Extensions pane and you should see your Flux extension there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-Flux-extension-has-been-installed.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-Flux-extension-has-been-installed.jpg" alt="The Flux extension has been installed" /></a>
  
  <p>
   The Flux extension has been installed
  </p>
</div>

If you scroll up to the output of the installation, you will see that something went wrong. The error message says: "namespace not specified, error: namespaces gitopsdemo not found.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-namespace-was-not-found.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-namespace-was-not-found.jpg" alt="The namespace was not found" /></a>
  
  <p>
   The namespace was not found
  </p>
</div>

The application in the YAML file has the gitopsdemo namespace specified but you have not created the namespace yet. Therefore, the installation of the application fails.

To display the configuration of the previously installed GitOps operator, use the following command:

<script src="https://gist.github.com/WolfgangOfner/3becc88c809cbc70ae181c625c881b5b.js"></script>

Alternatively, open the GitOps pane in your Azure Arc resource in the Azure portal and click on the configuration. If you used the same name as I did, you should see the name "gitopsoperator". Click on it and you should see the same error message as in the CLI above.

Let's delete this GitOps configuration and fix it. Use the following command to delete the GitOps operator.

<script src="https://gist.github.com/WolfgangOfner/33e3a691e751b0e1f03d0e1c6416751a.js"></script>

## Fix the failed Deployment

To fix the problem above, you have to create the namespace before the application is deployed. The first approach that comes to mind is to add the namespace to the already existing YAML file. Adding more and more resources to one file might work for this demo application but is impractical in the real world. The file would explode and you wouldn't be able to find anything.

Another approach would be to create another YAML file for the namespace and then add this new file to the kustomization file. The problem with this approach is that you can not guarantee that the namespace will be created before the application is deployed. The solution to the problem is to have the namespace created first and only then start the deployment of the application.

XXX
CREATE THE KUSTOMIZATION FILES

Make sure that you have the <a href="https://kustomize.io" target="_blank" rel="noopener noreferrer">Kustomize CLI</a> installed.
XXX

To tell Kustomize about this dependency, use the "dependsOn" attribute of the kustomization flag. The following code shows how to add two kustomization files to the deployment and have a dependency of the application deployment to the namespace one. 

<script src="https://gist.github.com/WolfgangOfner/a5d56b4eedd47ece4a873f0392613c45.js"></script>

Additionally, it is a good practice to have different folders for the type of deployment you want to do. The example above uses an App and Infrastructure folder to separate these two concerns. Each folder contains its own kustomization file which also helps to keep the file small and also allows you to apply individual configurations for each folder.

Wait a bit and the deployment should succeed this time. You can open the GitOps pane in the Azure Arc resource in the Azure portal and should see the state as succeeded.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-deployment-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-deployment-succeeded.jpg" alt="The deployment succeeded" /></a>
  
  <p>
   The deployment succeeded
  </p>
</div>

If you make any changes to your Git repository, for example, changing the tag of the image, the Flux operator will fetch and deploy these changes.

Check the pods of the gitops namespace to see that one pod of the application runs there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-application-runs-in-the-cluster.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-application-runs-in-the-cluster.jpg" alt="The application runs in the cluster" /></a>
  
  <p>
   The application runs in the cluster
  </p>
</div>

## Delete the GitOps Configuration

When you delete the GitOps operator, the Azure CLI asks you if you really want to delete it and also tells you that prune has been enabled for this deployment. Acknowledging both messages will delete the GitOps operator and due to the prune flag also all resources associated with it. This means that the namespace, application, and service of this demo will be deleted. You will see that nothing exists anymore after the delete command has finished.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/All-resources-got-deleted.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/All-resources-got-deleted.jpg" alt="All resources got deleted" /></a>
  
  <p>
   All resources got deleted
  </p>
</div>

I have noticed that the prune does not always work but so far I could not find out a reason for that behavior nor am I able to gather any logs or error messages to analyze the problem.

## Using Private Repositories for GitOps

Today's demo used a public Git repository to host the files for the deployment. Almost all enterprise applications are hosted on a private Git repository though. Therefore, I will show you in my next post how to securely connect to a private repository in Azure DevOps or GitHub using SSH keys and the Flux GitOps operator.

## Conclusion

The Flux GitOps extension for Azure Arc allows you to implement an easy and secure GitOps process. The installed Flux agent polls a configured Git repository and automatically installs any changes in the repository. Since the agent pulls the changes, no inbound connection to your cluster or network is necessary. Additionally, the Flux GitOps extension uses the popular open-source tool Kustomize to manage the configuration for applications and deployment.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).