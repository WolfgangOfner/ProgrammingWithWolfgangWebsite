---
title: Introducing GitOps
date: 2022-08-08
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [GitOps, Iac, Flux, ArgoCD, ]
description: GitOps is a way to manage infrastructure as code (IaC) which gains more and more traction lately. 
---

GitOps is a way to manage infrastructure as code (IaC) which gains more and more traction lately. 

Today, I want to give you an introduction to GitOps, talk about the good and bad, and also introduce some GitOps tools you can use to get started.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## What is GitOps?

Infrastructure as code is nothing new and there are many popular tools such as Terraform, Pulumi, Ansible, and many more. IaC means that you have the configuration of your infrastructure in a file, mostly a YAML file. The advantage is that you can take this file and deploy it as often as you want. This enables you to have fast and repeatable deployments. 

With the rise of Kubernetes and cloud environments, we see more and more topics as code, such as network as code, configuration as code, or security as code. This allows developers to have everything as code. All these configuration files also come with more complexity. This is where GitOps comes into play.

GitOps usually uses a separate Git repository that contains all your configuration files. This already allows developers to have a single source of truth and also allows them to create pipelines that deploy these configuration files. Therefore, you should always know what version of your configuration is running in a given environment. Additionally, since the changes are deployed via a pipeline, the developers don't need access to the infrastructure anymore which will lead to increased security.

## Deployment Modes

GitOps knows two different deployment modes:

- pull-based deployments
- push-based deployments

As the name suggests, the push-based deployment mode pushes your changes into the configured environment. This is the default way of deploying changes for most developers since this is exactly what a CD pipeline does.

On the other hand, a pull-based deployment has an agent or operator running in your environment. This agent monitors a configured Git repo and branch for changes and if there are changes, pulls these changes and executes them. The advantage of this approach is that your environment can block all incoming traffic and only has to allow outgoing traffic on port 443. 

Azure Arc uses the pull-based approach and I will talk about this approach in more detail in a later post of this series.

## Benefits of GitOps

Applying GitOps to your deployment process has many advantages, such as:

- IaC files are checked into your version control.
- Run automated tests on the configuration files, for example, check if the YAML files are valid.
- Enforce pull requests for changes to increase the quality of your configuration files and share knowledge at the same time.
- Use CD pipelines for your deployment. Therefore, you will know what version of the configuration is installed in your environment and also allows for easy rollbacks in case of a problem.
- The Git repository is your single source of truth.
- You will have higher security since only the CD pipeline needs access to your environment.

## Disadvantages of GitOps

As with every tool or feature, there are some downsides to consider: 

- You will have to manage more Git repositories.
- The code might be less flexible, especially when using the pull approach. For example, you will need configuration files for each environment instead of changing variables during the deployment as you would do in a CD pipeline.
- There is no solution for the secret management and you will have to rely on an outside tool such as Azure Key Vault for your secrets and passwords.

## GitOps Tools

There is a wide variety of tools available if you want to use the push deployment model for your configuration:

- <a href="https://www.terraform.io/" target="_blank" rel="noopener noreferrer">Terraform</a> 
- <a href="https://www.pulumi.com/" target="_blank" rel="noopener noreferrer">Pulumi</a> 
- <a href="https://www.ansible.com/" target="_blank" rel="noopener noreferrer">Ansible</a> 
- <a href="https://www.chef.io/" target="_blank" rel="noopener noreferrer">Chef</a> 
- <a href="https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" target="_blank" rel="noopener noreferrer">Azure CLI</a> 

Since the pull model is a newer way of deploying your configurations (and applications), there are fewer tools available currently. The most used ones are:

- <a href="https://fluxcd.io" target="_blank" rel="noopener noreferrer">Flux</a>  (Flux is used in Azure Arc and will be used to deploy applications in a later post)
- <a href="https://argo-cd.readthedocs.io/en/stable" target="_blank" rel="noopener noreferrer">ArgoCD</a>  

## Conclusion

GitOps takes the DevOps approach and extends it to your configuration files. This will allow developers to have everything configuration related in code files such as YAML files and will also increase the security since the developers don't need to access the infrastructure directly anymore. 

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).