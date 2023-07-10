---
title: Introducing GitOps
date: 2022-08-08
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [GitOps, IaC, Flux, ArgoCD, Git, DevOps]
description: GitOps is a way to manage infrastructure as code (IaC) which gains more and more traction lately. 
---

GitOps, a trending approach for managing infrastructure as code (IaC), has gained significant popularity in recent times. In this article, we will provide you with a comprehensive introduction to GitOps, highlighting its advantages and disadvantages. Additionally, we will explore a selection of GitOps tools that can assist you in initiating your GitOps journey. 

Let's dive into this topic and discover how GitOps can revolutionize your infrastructure management practices.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## What is GitOps?


GitOps is an approach that leverages the concept of infrastructure as code (IaC) to streamline the management of complex configurations. While traditional IaC tools like Terraform and Ansible focus on deploying infrastructure, GitOps takes it a step further by utilizing a separate Git repository to store all configuration files.

By centralizing configurations in a Git repository, developers can establish a single source of truth for their infrastructure. This enables version control and facilitates the implementation of robust deployment pipelines. With GitOps, you can ensure that you always have visibility into which version of the configuration is running in a specific environment.

One of the key advantages of GitOps is its ability to promote repeatable and scalable deployments. By treating infrastructure changes as code, you can achieve fast and reliable deployments through automation. This not only enhances efficiency but also fosters collaboration among teams by providing a standardized and easily understandable representation of the infrastructure.

Another benefit of GitOps is improved security. With GitOps, developers no longer require direct access to the underlying infrastructure. Instead, changes are implemented through controlled pipelines, reducing the risk of unauthorized modifications and enhancing overall security posture.

As Kubernetes and cloud environments continue to gain prominence, GitOps becomes even more relevant. It extends the concept of IaC to cover additional aspects such as network configurations, security policies, and application configurations. This comprehensive approach allows developers to manage all aspects of their infrastructure and configurations as code, simplifying complex deployments and ensuring consistency across environments.

In the following sections, we will explore both the advantages and potential challenges of adopting GitOps. We will also introduce you to some popular GitOps tools that can help you kickstart your GitOps journey.

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