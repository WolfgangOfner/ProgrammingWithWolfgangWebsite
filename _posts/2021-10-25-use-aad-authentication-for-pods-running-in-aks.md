---
title: Use AAD Authentication for Pods running in AKS
date: 2021-10-25
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, AKS, Kubernetes, AAD, Helm]
description: AAD Pod Identity allows you to authenticate your applications inside an AKS cluster without a password against Azure Active Directory.
---

Since the dawn of time, authentication has been a problem for developers and security engineers. Weak passwords make it easy for attackers to get access to areas where they don't belong. Even if you have a very long and complex password, you might be at risk. Passwords get leaked almost every day nowadays. The current recommendation for authentication is passwordless. This means that no password exists anymore and you authenticate with an authenticator app or a security key.

This approach is safe but not possible for applications. This is where Azure Active Directory authentication comes into play. Resources in Azure can authenticate using their identity and then get an access token from AAD. Using these identities is quite easy with standard resources like App Service or Key Vault but not as easy when using Kubernetes.

Today, I would like to show you how you can configure your Azure Kubernetes Service cluster to use AAD Pod Identity to authenticate against the AAD.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What are Managed Identities

Every application faces the same challenges when it comes to securing its credentials. Managed identities eliminate the need for credentials and help to make applications more secure at the same time. Since there are no passwords with managed identities, no password can be compromised which could give unauthorized people access to resources.

Managed identities can be used to access a database or an Azure Key Vault where the application can load all required credentials for resources that do not support managed identities yet. Additionally, managed identities can be used without any additional costs. There are two types of managed identities, system-assigned and user-assigned.

### System-Assigned Managed Identity

Some resources in Azure like App Service or Azure Container Registry allow you to enable a managed identity directly on that service. This identity is created in the Azure AD and shares the same lifecycle as the service instance. When you delete the service, the system-assigned managed identity will be also deleted.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/System-assigned-managed-identity-in-ACR.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/System-assigned-managed-identity-in-ACR.jpg" alt="System assigned managed identity in ACR" /></a>
  
  <p>
    System assigned managed identity in ACR
  </p>
</div>

### User-Assigned Managed Identity

A user-assigned managed identity is a standalone resource in Azure. It can be assigned the resource and can be used in the same way as the system-assigned managed identity to authenticate that resource. The user-assigned managed identity has an independent lifecycle. This means that you can delete the Azure resource where the identity is assigned to and the identity does not get deleted.

## Enable Managed Identities for Applications running in Azure Kubernetes Service (AKS)

Enabling managed identities for applications in AKS, so-called pod identities, is unfortunately not straightforward. There are different documentation but neither of them works reliably. You can find a demo integration on <a href="https://azure.github.io/aad-pod-identity/docs/demo/standard_walkthrough/" target="_blank" rel="noopener noreferrer">Github</a> but the documentation is missing some steps and the scripts did not work for me (mostly due to wrong file paths).

Follow this guide to install pod identity on your AKS cluster and then test it with a demo application. Afterwards, I will go into the details of what is happening.

### Set up your AKS Cluster for Pod Identities

For this tutorial, I will assume that you have no AKS cluster created yet. This demo uses the Azure CLI and bash. Before you begin, create a couple of variables, which you can use throughout this demo. Note to replace the value of SubscriptionId with the Id of your Azure Subscription.

<script src="https://gist.github.com/WolfgangOfner/6d8c0345231d7214627bda6f9ca7a47d.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Set-some-variables.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Set-some-variables.jpg" alt="Set some variables" /></a>
  
  <p>
  Set some variables
  </p>
</div>

Next, create an AKS cluster with a managed identity and the azure network plugin.

<script src="https://gist.github.com/WolfgangOfner/343c7136a87781e143047553c51f096d.js"></script>

After the AKS cluster is created, retrieve the client Id of the managed identity of the cluster. Then use this client Id to assign the Managed Identity Operator and Virtual Machine Contributor role to the managed identity.

<script src="https://gist.github.com/WolfgangOfner/23bff74abc3a525743af89dbade2a6cf.js"></script>

This finishes the setup of the AKS cluster. Connect to your newly created cluster and let's continue to configure the pod identity.

<script src="https://gist.github.com/WolfgangOfner/e66a01e046a431e84b69d88eb1583eab.js"></script>

### Configure Pod Identity in Azure Kubernetes Service

Install the AAD Pod Identity Helm chart using Helm. If you do not know Helm, see [Helm - Getting Started](/helm-getting-started) for more information. Add and install the Helm chart with the following command:

<script src="https://gist.github.com/WolfgangOfner/49ece58a8d86c5d3192eee38140435fa.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/The-AAD-Pod-Identity-Helm-Chart-was-installed-successfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/The-AAD-Pod-Identity-Helm-Chart-was-installed-successfully.jpg" alt="The AAD Pod Identity Helm Chart was installed successfully" /></a>
  
  <p>
  The AAD Pod Identity Helm Chart was installed successfully
  </p>
</div>

After the installation is finished, you will see a message to verify that all associated pods have been started. Use the following command to check that:

<script src="https://gist.github.com/WolfgangOfner/670add38913779a79ed98e8f7da0ef2b.js"></script>

This should show that all pods are running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/All-AAD-Pod-Identity-Pods-are-running.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/All-AAD-Pod-Identity-Pods-are-running.jpg" alt="All AAD Pod Identity Pods are running" /></a>
  
  <p>
  All AAD Pod Identity Pods are running
  </p>
</div>

Next, create a new identity and export its client Id and Id:

<script src="https://gist.github.com/WolfgangOfner/1485648644bc1b14dc16c5d1334fdca0.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Create-a-new-Identity.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Create-a-new-Identity.jpg" alt="Create a new Identity" /></a>
  
  <p>
  Create a new Identity
  </p>
</div>

With this identity, create a new Kubernetes object of the type AzureIdentity and add the identity Id and client Id to it.

<script src="https://gist.github.com/WolfgangOfner/4324e4b5f79ebfb43397e764c773ee36.js"></script>

Optionally, you could save the AzureIdentity in a file and then apply this file. If you are using this approach, you have to replace the variables with their actual values though. 

The last step of the configuration of pod identities is to create an AzureIdentityBinding using the following command:

<script src="https://gist.github.com/WolfgangOfner/f39c35333e027ea1ffcead10923f8b41.js"></script>

### Test the usage of the Pod Identity

Microsoft has a test application that will retrieve a token and give you a success message when the operation is completed. If something went wrong, you will see an error message. Deploy the test application with the following command:

<script src="https://gist.github.com/WolfgangOfner/1cfc2a01a3c862228c572ff18b9a72f3.js"></script>

Wait for around a minute and then check the logs of the pod. You can do this either using kubectl or a dashboard. Kubectl gives you a wall of text that might be hard to read. 

<script src="https://gist.github.com/WolfgangOfner/0d7e50b0757f5f1b61387efa3ce8e8d2.js"></script>

I prefer Octant as my dashboard. You can find more information about the usage and installation in [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started/#access-the-aks-cluster).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/The-token-was-retrieved-successfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/The-token-was-retrieved-successfully.jpg" alt="The token was retrieved successfully" /></a>
  
  <p>
    The token was retrieved successfully
  </p>
</div>

## What happens inside Kubernetes when adding Pod Identity

There was a lot going on during the demo which might be hard to understand at first. Let's go through it step by step.

### Azure Kubernetes Service Cluster installation

The AKS cluster is created with the flags --network-plugin azure and --enable-managed-identity. AKS supports two network modes, kubenet and azure, whereas kubenet is the default mode. 

AAD Pod Identity is disabled by default on clusters using the Kubnet network mode. This is due to security concerns because Kubenet is susceptible to APR spoofing. This makes it possible for pods to impersonate other pods and gain access to resources which they are not allowed to access. The Azure network plugin prevents ARP Spoofing.

The second flag --enable-managed-identity creates a service principal. This service principal is used to authenticate against the AAD and retrieve tokens for the pods. Adding the Managed Identity Operator and Virtual Machine Contributor roles to the service principal is necessary so it can assign and un-assign identities from the worker nodes that run on the VM scale set.

### Managed Identity Controller (MIC) and Node Managed Identity (NMI)

The Managed Identity Controller (MIC) monitors pods through the Kubernetes API Server. When the MIC detects any changes, it adds or deletes AzureAssignedIdentity if needed. Keep in mind that the identity is applied when a pod is scheduled. This means if you change your configuration, you have to re-schedule your pods for the changes to be applied.

The Node Managed Identity (NMI) intercepts traffic on all nodes and makes an Azure Active Directory Authentication Library (ADAL) request to get a token on behalf of the pods. The request to get a token is sent to the Azure Instance Metadata Service (IMDS) at 169.254.169.254. The answer is redirected to the NMI pod due to changes to the iptable rules of the nodes. 

### AzureIdentity and AzureIdendityBinding

AzureIdentity can be a user-assigned identity, service principal, or service principal with a certificate and is used to authenticate the requests from the NMI to get a token from the AAD.

The AzureIdendityBinding connects the AzureIdentity to a pod. The AzureIdentity is assigned to a pod if the selectors are matching.

The following screenshot shows the workflow of the token acquisition.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Token-acquisation-workflow.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Token-acquisation-workflow.jpg" alt="Token acquisation workflow" /></a>
  
  <p>
  Token acquisation workflow (<a href="https://azure.github.io/aad-pod-identity/docs/concepts/block-diagram-and-design/" target="_blank" rel="noopener noreferrer">Github</a>)
  </p>
</div>

### Uninstalling AAD Pod Identity

You can use the following code to uninstall pod identity.

<script src="https://gist.github.com/WolfgangOfner/c83ed13c4ded845afd89b96450994e02.js"></script>

The iptables that got modified by the NMI pods should be cleaned up automatically when the pod identity pods are uninstalled. If the pods get terminated unexpectedly, the entries in the iptables are not removed. You can do that with the following commands:

<script src="https://gist.github.com/WolfgangOfner/785981aa2a0b865c36e0451b354ecfd0.js"></script>

## Conclusion

Using AAD authentication in Azure Kubernetes Service is unfortunately not straightforward, especially since the documentation is missing some crucial information. Nevertheless, going passwordless is definitely worth the hassle and will make it easier to manage your applications in the future.

In my next post, I will show you how to use this AAD authentication to access your database without a password.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).