---
title: Use the TokenRequest API to create Tokens in Kubernetes 1.24
date: 2022-08-01
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, k3s, Rancher, On-premises, Azure Arc]
description: Kubernetes 1.24 removed the automated creation of secrets when creating new service accounts. Use the TokenRequest API instead.
---

In one of my former posts, [Securely connect to an on-premises Kubernetes Cluster with Azure Arc](/securely-connect-to-on-premises-kubernetes-with-azure-arc), I showed you how to securely connect to an on-premise Kubernetes cluster using Azure Arc. To achieve that, I have create a user and then retrieved the token of the user. 

This method has changed a bit from Kubernetes version 1.24 on and in this post, I will show you how to get this token if you are using the new K8s version.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Breaking Change with Tokens in Kubernetes 1.24

When I described how you can connect to your Kubernetes cluster, I showed you how to create a new service account and bind a role to this account. See the following code as a reminder.

<script src="https://gist.github.com/WolfgangOfner/3351fe1c4967a5833b8e74e86c9b9f03.js"></script>

Back then I said that this cluster binding also creates the secret which we will retrieve and then use to connect to the cluster. The code to do that was as following:

<script src="https://gist.github.com/WolfgangOfner/a5285efb1f3c9a263443ea074df8c96d.js"></script>

From Kubernetes 1.24 on, this token is not automatically created anymore. Therefore if you execute the code above, the $SECRET_NAME variable will be empty and as a result you won't be able to retrieve the token (obviously since it was not created in the first place).

## What is new in Kubernetes 1.24

As with every new Kubernetes version, there are many changes and new features associated with the release. You can find all the changes and also upgrade notes in the <a href="https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.24.md#urgent-upgrade-notes" target="_blank" rel="noopener noreferrer">Kubernetes changelog on GitHub</a>.

> The LegacyServiceAccountTokenNoAutoGeneration feature gate is beta, and enabled by default. When enabled, Secret API objects containing service account tokens are no longer auto-generated for every ServiceAccount. Use the TokenRequest API to acquire service account tokens, or if a non-expiring token is required, create a Secret API object for the token controller to populate with a service account token by following this guide.

This means that you have to create the token yourself which I will show you in the next section.

## Use the TokenRequest API to create the Token

Kubernetes 1.22 introduced the TokenRequest API which is now the recommended way to create tokens because they are more secure than the previously used Secret object. To use the API, first create a new service account and bind a role to it. Then use "kubectl create token \<Service Account Name\> to create the token.

<script src="https://gist.github.com/WolfgangOfner/ca5efc785f453876bb8cc6e4c5bd0dda.js"></script>

The create token command automatically creates the token and prints it to the console.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Use-the-TokenRequest-API.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Use-the-TokenRequest-API.jpg" alt="Use the TokenRequest API" /></a>
  
  <p>
   Use the TokenRequest API
  </p>
</div>

## Use a Service Account Secret Objects to access the K8s Cluster

If you can't use the TokenRequest API, then you can create the secret yourself. To create the access token in Kubernetes 1.24 manually, you have to create a service account and bind a role to this account first. This is the same code as in my last post:

<script src="https://gist.github.com/WolfgangOfner/3351fe1c4967a5833b8e74e86c9b9f03.js"></script>

Next, add a new secret to your cluster with the following code:

<script src="https://gist.github.com/WolfgangOfner/7472da6468bd76c5e119527455c2f5df.js"></script>

Make sure that the annotation "kubernetes.io/service-account.name:" has the name of the previously created service account as value. After the secret is created, Kubernetes automatically fills in the information for the token. 

Assign the value of the name in the previously created secret to the SECRET_NAME variable and then use following code to read the automatically created value of the token and then print it to the console:

<script src="https://gist.github.com/WolfgangOfner/7d0231698c2e90df5f844c071f5536d5.js"></script>

The following screenshot shows the whole process and the printed token.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Create-a-new-service-account-and-print-its-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Create-a-new-service-account-and-print-its-token.jpg" alt="Create a new service account and print its token" /></a>
  
  <p>
   Create a new service account and print its token
  </p>
</div>

When you delete the service account, the associated secret will be automatically deleted too. 

## Conclusion

Kubernetes 1.24 removed the automated creation of secrets when creating new service accounts. Use the TokenRequest API instead to create tokens which is easier and also more secure than creating tokens manually.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).