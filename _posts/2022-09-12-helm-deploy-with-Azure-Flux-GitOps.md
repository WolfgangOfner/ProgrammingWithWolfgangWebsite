---
title: Deploy Helm charts with the Azure Arc Flux GitOps Extension
date: 2022-09-12
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Flux, GitOps, Helm, Azure Arc, Azure]
description: Combining Azure Arc with the Flux GitOps extension is a great way to deploy your infrastructure and applications with Helm charts to Kubernetes.
---

Combining Azure Arc with the Flux GitOps extension is a great way to deploy your infrastructure and applications to Kubernetes. [In my last post](//securely-deploy-application-azure-arc-with-flux-gitops), I showed you how to install the Flux extension and how to configure the deployment using Kustomize and YAML files.

Today, I want to show you how to deploy Helm charts using Azure Arc and the Flux GitOps extension.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## What is Helm?

Deploying microservices to Kubernetes, especially if they have dependencies, can be quite complex. This is where Helm comes in. Helm is a package manager for Kubernetes that allows you to create packages and helm takes care of installing and updating these packages. Helm packages are called charts. These charts describe everything your application needs and helm takes care to create or update your application, depending on the provided chart. Helm also serves as a template engine which makes it very easy to configure your charts either locally or during your CI/CD pipeline.

For more information see my previous post, [Helm - Getting Started](/helm-getting-started).

## The Flux Helm Controller

The Flux Helm controller is a part of the Flux installation and is also installed when you install the Flux GitOps extension (to be precise, the microsoft.flux extension) in Azure Arc. Therefore, you don't have to install any additional tools to deploy your Helm charts.

The Helm controller watches for HelmRelease objects and generates HelmChart objects. These HelmChart objects can be produced from HelmRepository and GitRepository sources. I will show examples for both further down. The Helm controller executes install and upgrade commands and reports the Helm release status. You can see the architecture on the following screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Flux-Helm-Controller-Architecture.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Flux-Helm-Controller-Architecture.jpg" alt="Flux Helm Controller Architecture" /></a>
  
  <p>
   Flux Helm Controller Architecture (<a href="https://fluxcd.io/flux/components/helm" target="_blank" rel="noopener noreferrer">Source</a>)
  </p>
</div>

Let's have a look at some of the options you have to deploy your Helm charts.

## Deploy Helm Charts from a Git Repository

Deploying a Helm chart from your Git repository is the easiest and most common approach. To get started, create a new YAML file in which you define the URL of your Helm chart in your Git repository, the branch, polling interval, and a name.

<script src="https://gist.github.com/WolfgangOfner/c38f5fb56e201126b56ceae94ce9e069.js"></script>

This file is also called chart source sometimes. The second file you have to create is a HelmRelease which will reference the previously created chart source file to deploy the Helm chart.

<script src="https://gist.github.com/WolfgangOfner/7a20ec68184195f6d1d333a21a5cc8c9.js"></script>

The source-controller of Flux will look up the Helm chart the referenced chart source and then build it. If the kind of the source is HelmRepository, then the source controller will fetch the Helm chart. I will show you this behavior in the next section.

The chart parameter can be the name of a Helm chart (if you use the type HelmRepository), or the path to your Helm chart, for example, ./charts/kubernetesdeploymentdemo.

XXX about values

### Testing the Helm Chart Deployment from a Git Repository

Create kustomization file

SCREENSHOT

## Deploy Helm charts from a Helm Repository

Another common approach is to use already existing public Helm charts such as Redis or Nginx. To deploy one of those, create a HelmRepository file where you configure the URL to the Helm chart and the polling interval.

<script src="https://gist.github.com/WolfgangOfner/dd303d43a929cfa1d244f2aacb6db3b9.js"></script>

Next, create another HelmRelease file. There you have to configure a chart name and set the kind of the SourceRef to HelmRepository. Additionally, set the version of the Helm chart you want to use. Everything else can stay the same as in the example above.

<script src="https://gist.github.com/WolfgangOfner/1776acb99873d85a0a2de2c3ad4c3a1f.js"></script>

Let's test the deployment

### Testing the Helm Chart Deployment from a Helm Repository

Create kustomization file

SCREENSHOT

## Conclusion

The Flux GitOps extension of Azure Arc can be used to install Helm charts from a Git repository as well as from a Helm repository. This post only scratched the surface of all the possibilities you have with the Flux Helm controller but it should have shown you enough to get started.

This demo only used public repositories. Companies usually use private repositories and therefore I will show you how to configure the Flux extension to use private repositories in my next post.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).