---
title: Manage your Kubernetes Resources with Kustomize
date: 2022-08-22
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, Kustomize, Flux, Azure Arc, Helm]
description: Kustomize allows you to easily create configuration files of your Kubernetes resources and is also used by Azure Arc to deploy your resources to Kubernetes.
---

Azure Arc offers the Flux extensions to enable a GitOps workflow. You should know about Kustomize before you can use the Flux extension though.

Today, I want to show you what Kustomize is and how it helps you to create a configuration file for your application and how to deploy your application using the Kustomize CLI.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Kustomize - Kubernetes Native Configuration Management

<a href="https://kustomize.io/" target="_blank" rel="noopener noreferrer">Kustomize</a> is an open-source tool to customize your Kubernetes configuration. In contrast to Helm, Kustomize does not rely on templates to manage your configuration files. Additionally, Kustomize ist part of kubectl since version 1.14. This means that you don't have to install anything and can use it in combination with kubectl.

Kustomize scans your folders and creates a kustomization file that contains information and references about all YAML files it found. This kustomization file can be applied to your Kubernetes cluster. 

Let's create a demo application and see Kustomize in action.

## Deploy an Application to Kubernetes with Kustomize

You can find the code of the finished demo application on <a href="https://github.com/WolfgangOfner/AzureArc" target="_blank" rel="noopener noreferrer">GitHub</a>.

Before you get started, install <a href="https://kubectl.docs.kubernetes.io/installation/kustomize/" target="_blank" rel="noopener noreferrer">Kustomize</a>.

First, create a YAML file that contains a namespace definition:

<script src="https://gist.github.com/WolfgangOfner/ba40dd8f5d7b838dcfd8f3a670dd1508.js"></script>

Next, open your command line and navigate to the folder containing the previously created namespace YAML file. Use Kustomize to scan your folder for YAML files and create a kustomization file according to its findings.

<script src="https://gist.github.com/WolfgangOfner/f3ad4fa81b46704160dad9f741100b51.js"></script>

The --autodetect flag tells Kustomize to search for Kubernetes resources and the --recursive flag also searches all sub-folders.

The created kustomization file should look as follows:

<script src="https://gist.github.com/WolfgangOfner/431226a4308db7006e64da51aaf2c057.js"></script>

This is the simplest kustomization file possible and it only has one reference to the previously created namespace file. That's enough for a first deployment though. You can combine the build of the kustomization file and its deployment with the following command:

<script src="https://gist.github.com/WolfgangOfner/7c04fe4e4b1363c2df01b11c8e79ceb3.js"></script>

You should see your new namespace after the kustomization file is applied.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-namespace-was-created.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-namespace-was-created.jpg" alt="The namespace was created" /></a>
  
  <p>
   The namespace was created
  </p>
</div>

## Flux with Kustomize

Azure Arc uses Flux as its GitOps operator and Flux uses Kustomize for the configuration of your deployment. Since I want to focus on Azure Arc, let's take a look at Flux in combination with Kustomize.

Kustomize offers a wide range of configuration parameters. Flux allows to adding these parameters during the creation of the Flux operator or as part of the kustomization file. Let's take a look at an example kustomization file.

<script src="https://gist.github.com/WolfgangOfner/441e0ab69f97cf6767e7e4fd245d329e.js"></script>

Most of the config flags should be self-explanatory  but to prevent any confusion, here is what they do:

- interval: checks for configuration drifts and deletes changes made outside of Kustomize, e.g. changes made with kubectl
- wait: wait until all resources are ready
- timeout: the time when Kustomize gives up
- retryInterval: time between retry tries
- prune: remove stale resources from your cluster
- force: recreate resources
- targetNamespace: the namespace where your resources are deployed into
- url: configures a git repository
- secretRef: reference to a user PAT (personal access token) to access this git repository
- branch: the branch Kustomize will check for resources

You could also configure the use of a local file instead of an URL. To do this, use the path parameter and set the folder of your kustomize file as its value.

## Conclusion

Kustomize allows you to easily create configuration files of your Kubernetes resources. This post gave a short introduction to Kustomize because Azure Arc uses Flux as its GitOps operator which uses Kustomize to configure your deployments.

[In my next](/securely-deploy-application-azure-arc-with-flux-gitops), I will show you how to use Flux on Azure Arc to deploy your resources to Kubernetes with the help of Kustomize.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).