---
title: Securely connect to an on-premises Kubernetes Cluster with Azure Arc
date: 2022-06-06
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, k3s, Rancher, On-premises, Azure Arc, RBAC]
description: Using Azure Arc enables you to access an on-premises cluster securely from your machine or the Azure Portal using RBAC.
---

[In my last post](/install-azure-arc-on-premises-k3s-cluster), I installed Azure Arc which allowed me to project my k3s cluster into Azure. The installation was done directly on the Master node of the cluster and developers would also need to connect to the master node to execute any commands on the Kubernetes cluster.

Today, I want to show you how to give developers access using RBAC (Role-based access control) and let them connect to the Kubernetes cluster through Azure Arc.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Create a User on the Kubernetes Cluster

To authorize a user to access the Kubernetes cluster, you first have to create a user account and then give this user permissions using the kubectl cluterrolebinding command. Use the following command on the Master node to create a new admin user and give this user the cluster-admin role:

<script src="https://gist.github.com/WolfgangOfner/3351fe1c4967a5833b8e74e86c9b9f03.js"></script>

This command additionally creates a secret for the user that contains a JWT token. You can read the token with the following command and then print it to the console:

<script src="https://gist.github.com/WolfgangOfner/a5285efb1f3c9a263443ea074df8c96d.js"></script>

The following screenshot shows all the commands and also the printed token:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Create-an-user-and-print-the-token-to-the-console.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Create-an-user-and-print-the-token-to-the-console.jpg" alt="Create an user and print the token to the console" /></a>
  
  <p>
   Create an user and print the token to the console
  </p>
</div>

Copy the token as you will need it to access the Kubernetes cluster through Azure Arc.

## Access the k3s Cluster in the Azure Portal with Azure Arc

When you open the Azure Arc resource in the Azure Portal and go to any Kubernetes resources pane, you will see a message that you have to sign in to view the Kubernetes resources.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Sign-in-to-view-your-Kubernetes-resources.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Sign-in-to-view-your-Kubernetes-resources.jpg" alt="Sign in to view your Kubernetes resources" /></a>
  
  <p>
   Sign in to view your Kubernetes resources
  </p>
</div>

Paste the previously created token into the text box and click Sign in. Now you should see the resources of the Kubernetes cluster.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Display-Kubernetes-resources-in-Azure-Arc.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Display-Kubernetes-resources-in-Azure-Arc.jpg" alt="Display Kubernetes resources in Azure Arc" /></a>
  
  <p>
   Display Kubernetes resources in Azure Arc
  </p>
</div>

## Access the k3s Cluster from a Developer Computer with Azure Arc

Using the Azure Portal to access the Kubernetes cluster is nice but as a developer, I am used to using kubectl or any custom dashboards. To access the Kubernetes cluster from my Windows computer, I will use the following Azure CLI command.

<script src="https://gist.github.com/WolfgangOfner/1d73e10ab3c34847ae72e6d57400aec0.js"></script>

Replace \<TOKEN\> with the previously created token. You can use this command on any computer as long as the Azure CLI is installed. The command downloads the Kubernetes config file, sets the context, and creates a proxy connection through Azure Arc to the Kubernetes cluster.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Create-a-connect-to-the-Kubernetes-Cluster.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Create-a-connect-to-the-Kubernetes-Cluster.jpg" alt="Create a connect to the Kubernetes Cluster" /></a>
  
  <p>
   Create a connect to the Kubernetes Cluster
  </p>
</div>

After the connection is established, open a new terminal window and use kubectl as you are used to. It is also possible to use any dashboard to display the resources from the Kubernetes cluster. I like to use Octant from VMWare but you can use whatever dashboard you feel comfortable. For more information about Octant and how to install it, see ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started/#access-the-aks-cluster)

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Access-the-Kubernetes-Cluster-with-a-dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Access-the-Kubernetes-Cluster-with-a-dashboard.jpg" alt="Access the Kubernetes Cluster with a dashboard" /></a>
  
  <p>
   Access the Kubernetes Cluster with a dashboard
  </p>
</div>

## Conclusion

Using Azure Arc enables you to access an on-premises cluster securely from your machine or the Azure Portal. All you have to do is to create a user on the Kubernetes cluster and give this user the desired permissions. Then retrieve its access token and use this token to connect to the cluster.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).