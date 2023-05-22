---
title: Deploy Helm charts with the Azure Arc Flux GitOps Extension
date: 2023-06-15
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Flux, GitOps, Helm, Azure Arc, Azure]
description: Combining Azure Arc with the Flux GitOps extension is a great way to deploy your infrastructure and applications with Helm charts to Kubernetes.
---

Combining Azure Arc with the Flux GitOps extension is a great way to deploy your infrastructure and applications to Kubernetes. [In my last post](/securely-deploy-application-azure-arc-with-flux-gitops), I showed you how to install the Flux extension and how to configure the deployment using Kustomize and YAML files.

Today, I want to show you how to deploy Helm charts using Azure Arc and the Flux GitOps extension.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## What is Helm?

Deploying microservices to Kubernetes, especially if they have dependencies, can be quite complex. This is where Helm comes in. Helm is a package manager for Kubernetes that allows you to create packages and helm takes care of installing and updating these packages. Helm packages are called charts. These charts describe everything your application needs and helm takes care to create or update your application, depending on the provided chart. Helm also serves as a template engine which makes it very easy to configure your charts either locally or during your CI/CD pipeline.

For more information see my previous post, [Helm - Getting Started](/helm-getting-started).

## The Flux Helm Controller

The Flux Helm Controller is a part of the Flux installation and is also installed when you install the Flux GitOps extension (to be precise, the microsoft.flux extension) in Azure Arc. Therefore, you don't have to install any additional tools to deploy your Helm charts.

The Flux Helm Controller is used to manage Kubernetes applications and cluster resources. It integrates with the Helm package manager to provide a GitOps workflow for deploying, updating, and rolling back Helm charts (Kubernetes application packages) in a cluster.

With the Flux Helm Controller, developers can define the desired state of their applications in Git and then use the controller to ensure that the actual state of the cluster matches the desired state. The controller automatically tracks changes in Git and updates the cluster as necessary to ensure that it stays in the desired state.

Helm charts can be deployed from a git repository aswell as from a Helm repository. The demo below will show you both approaches. You can see the architecture of the Flux Helm Controller on the following screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/02/Flux-Helm-Controller-Architecture.jpg"><img loading="lazy" src="/assets/img/posts/2023/02/Flux-Helm-Controller-Architecture.jpg" alt="Flux Helm Controller Architecture" /></a>
  
  <p>
   Flux Helm Controller Architecture (<a href="https://fluxcd.io/flux/components/helm" target="_blank" rel="noopener noreferrer">Source</a>)
  </p>
</div>

Let's have a look at some of the options you have to deploy your Helm charts.


az k8s-configuration flux create \
--cluster-name k3sArc \
--resource-group ArcDemo \
--name gitopsoperator \
--namespace gitopsdemo \
--cluster-type connectedClusters \
--scope cluster \
--url https://github.com/WolfgangOfner/AzureArc \
--branch main  \
--kustomization name=infra path=./HelmGitRepository/Infrastructure prune=true \
--kustomization name=app path=./HelmGitRepository prune=true dependsOn=["infra"]

also installs flux extension on cluster the first time this command is executed

az extension add -n k8s-configuration
az extension add -n k8s-extension


az k8s-configuration flux delete -g ArcDemo -c k3sArc -n gitopsoperator -t connectedClusters --yes

Change headlines

Link to docu, errors but created pr

## Deploy Helm Charts from a Git Repository

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

Deploying a Helm chart from your Git repository is the easiest and most common approach. To get started, create a new YAML file in which you define the path to your Helm chart in your Git repository, the branch, polling interval, and a name.

<script src="https://gist.github.com/WolfgangOfner/c38f5fb56e201126b56ceae94ce9e069.js"></script>

The second file you have to create is the kustomize file which tells the GitOps operator which files it should execute. Add in the kustomize file the name of the previously created YAML file.

<script src="https://gist.github.com/WolfgangOfner/7a20ec68184195f6d1d333a21a5cc8c9.js"></script>

Make sure that both files are in the same folder in your git repository. If you look at my GitHub repo, you will find the files in the ArcHelmGitOps folder.

### Testing the Helm Chart Deployment from a Git Repository

Before you can deploy your application using the Azure Arc GitOps extension, make sure that you have Azure Arc installed on your Kubernetes cluster. If you haven't installed it yet, see [Install Azure Arc on an On-premises k3s Cluster](/install-azure-arc-on-premises-k3s-cluster) for more information.

Once you hve Azure Arc installed, install a GitOps operator with the following code:

<script src="https://gist.github.com/WolfgangOfner/1e4254cb3019dce0cb025b960708a6c2.js"></script>

If you haven't installed the GitOps extension yet, this command will install the extension first and then the operator. The parameter should be quite self-explanatory. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/02/Install-the-Azure-Arc-GitOps-Agent-and-Flux-Operator.jpg"><img loading="lazy" src="/assets/img/posts/2023/02/Install-the-Azure-Arc-GitOps-Agent-and-Flux-Operator.jpg" alt="Install the Azure Arc GitOps Agent and Flux Operator" /></a>
  
  <p>
   Install the Azure Arc GitOps Agent and Flux Operator
  </p>
</div>

check for namespace gitopsdemo

### Override Values in the values.yaml file

It is quite common to override values, such as the tag of the image, in the values.yaml file in a CD pipeline. Since we don't have a deployment pipeline using GitOps, we have to find a different way to override these values. Fortunately, it is possible to add your desired values to the HelmRelease file. The following code shows how to override the value for the replicaCount and set it to 2:

<script src="https://gist.github.com/WolfgangOfner/d0f3eb51ea65ff223147abc956165315.js"></script>

### Configure Dependencies during the Deployment

A common usecase during the deployment is that you have to configure dependencies. An often used dependency is to create a new namespace first and then deploy your application inside this namespace. V1 of the GitOps agent did not support this usecase but V2 (the version of this demo) does support it. All you have to do is to create multiple kustomize files and then add the dependsOn paramter to the kustomization flag when creating the GitOps operator. The following code shows how the app kustomization file depends on the infrastructure kustomization file:

<script src="https://gist.github.com/WolfgangOfner/be16e7720f2e358d75efa81f82f90d14.js"></script>

This code executes the infrastructure kustomization file first and once it is finished executes the app kustomize file.

The kustomization file references the namespace file which defines a new namespace:

<script src="https://gist.github.com/WolfgangOfner/e7f10990f6a74122fa5dcbe3aa426d73.js"></script>

## Deploy Helm charts from a Helm Repository

Another common approach is to use already existing public Helm charts such as Redis or Nginx. To deploy one of those, create a HelmRepository file where you configure the URL to the Helm chart and the polling interval.

<script src="https://gist.github.com/WolfgangOfner/dd303d43a929cfa1d244f2aacb6db3b9.js"></script>

Next, create another HelmRelease file. There you have to configure a chart name and set the kind of the SourceRef to HelmRepository. Additionally, set the version of the Helm chart you want to use. Everything else can stay the same as in the example above.

<script src="https://gist.github.com/WolfgangOfner/1776acb99873d85a0a2de2c3ad4c3a1f.js"></script>

Let's test the deployment.

### Testing the Helm Chart Deployment from a Helm Repository

Create kustomization file

SCREENSHOT

## Conclusion

The Flux GitOps extension of Azure Arc can be used to install Helm charts from a Git repository as well as from a Helm repository. This post only scratched the surface of all the possibilities you have with the Flux Helm controller but it should have shown you enough to get started.

This demo only used public repositories. Companies usually use private repositories and therefore I will show you how to configure the Flux extension to use private repositories in my next post.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).