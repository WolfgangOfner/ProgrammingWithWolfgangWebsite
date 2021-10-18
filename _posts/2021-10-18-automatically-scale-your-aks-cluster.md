---
title: Automatically scale your AKS Cluster
date: 2021-10-18
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, AKS, Kubernetes, Monitoring, Prometheus, Grafana, KEDA, Azure DevOps]
description: Kubernetes can easily scale out your pods but your cluster might run out of resources. The cluster autoscaler helps you to automatically add more worker nodes to your cluster.
---

If you followed this series, you have learned how to scale your applications using the [Horizontal Pod Autoscaler (HPA)](/auto-scale-kubernetes-hpa) or [KEDA, Kubernetes Event-driven Autoscaling](/deploy-keda-and-autoscaler-using-azure-devops-pipelines). Both approaches can automatically scale out and scale in your application but also suffer from the same shortcoming. When the existing nodes have no resources left, no new pods can be scheduled.

Today, I would like to tell you how to automatically scale your Azure Kubernetes Cluster to add or remove nodes using the cluster autoscaler.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Working without automatic Cluster scaling

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/Infrastructure/AzureResources/Azure-resource-install-pipeline.yml" target="_blank" rel="noopener noreferrer">Github</a>.

In [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started), I have created a new Azure Kubernetes Cluster with one node. This cluster works fine if you ignore the fact that one node does not provide high availability, but since the creation of the cluster, I have added more and more applications to it. When I have to scale one of my applications to several pods, the node runs out of resources and Kubernetes can't schedule the new pods.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/New-Pods-can-not-be-scheduled.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/New-Pods-can-not-be-scheduled.jpg" alt="New Pods can not be scheduled" /></a>
  
  <p>
   New Pods can not be scheduled
  </p>
</div>

To get the error message why the pod can't be started, use the following command:

<script src="https://gist.github.com/WolfgangOfner/d2936a2b0dc0bd934859b42d154694a1.js"></script>

Replace kedademoapi-68b66664cb-jjhvg with the name of one of your pods that can not be started and enter the namespace where your pods are running. You will see the error message at the bottom of the output.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/The-Pod-cant-be-started-due-to-insufficient-CPU.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/The-Pod-cant-be-started-due-to-insufficient-CPU.jpg" alt="The Pod cant be started due to insufficient CPU" /></a>
  
  <p>
   The Pod cant be started due to insufficient CPU
  </p>
</div>

## Verify your Worker Nodes

If you are using Azure Kubernetes Service, you have two options to verify how many worker nodes are running. First, open your AKS cluster in the Azure portal and navigate to the Node pools pane to see how many nodes are running at the moment. As you can see, my cluster has only one node:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Node-count-in-the-Azure-Portal.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Node-count-in-the-Azure-Portal.jpg" alt="Node count in the Azure Portal" /></a>
  
  <p>
   Node count in the Azure Portal
  </p>
</div>

The second option to verify the number of nodes is using the command line. Use the following command to display all your nodes:

<script src="https://gist.github.com/WolfgangOfner/0290fdc0f94e759bd9323e76723e4443.js"></script>

This command will display one worker node.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/One-worker-node-exists.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/One-worker-node-exists.jpg" alt="One worker node exists" /></a>
  
  <p>
   One worker node exists
  </p>
</div>

## Configure AKS Cluster Autoscaler

[In an earlier post](/use-infrastructure-as-code-to-deploy-infrastructure/#create-an-azure-kubernetes-cluster), I have created a YAML pipeline in Azure DevOps to create my AKS cluster using Azure CLI. The code looks as follows:

<script src="https://gist.github.com/WolfgangOfner/3dc43bd5eaac8478f43e75e8d42df278.js"></script>

The cluster autoscaler can be easily enabled and configured using the enable-cluster-autoscaler flag and setting the minimum and maximum node count.

<script src="https://gist.github.com/WolfgangOfner/85d33d24e9789cec071faff5588f544a.js"></script>

The cluster autoscaler has a wide range of settings that can be configued using the cluster-autoscaler-profile flag. For a full list of all attributes and their default values, see <a href="https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler#using-the-autoscaler-profile" target="_blank" rel="noopener noreferrer">the official documentation</a>.
The default values are usually good, except that I would like to scale down faster. Therefore, I change two settings of the cluster autoscaler profile:

<script src="https://gist.github.com/WolfgangOfner/b9e129c469cf63c919fc51347f0dce08.js"></script>

## Test the Cluster Autoscaler

The cluster autoscaler sees pods that can not be scheduled and adds a new node to the cluster. Open the Node pools pane of your AKS cluster in the Azure portal and you will see that your cluster is running two nodes now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Two-Nodes-in-the-Azure-Portal.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Two-Nodes-in-the-Azure-Portal.jpg" alt="Two Nodes in the Azure Portal" /></a>
  
  <p>
   Two Nodes in the Azure Portal
  </p>
</div>

Using the CLI also shows that your cluster has two nodes now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Two-Nodes-in-the-CLI.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Two-Nodes-in-the-CLI.jpg" alt="Two Nodes in the CLI" /></a>
  
  <p>
   Two Nodes in the CLI
  </p>
</div>

Use the following command to see that all pods got scheduled on one of the two nodes (replace kedademoapi-test with your K8s namespace):

<script src="https://gist.github.com/WolfgangOfner/f545d570b1fbe86dd0e900c66fdc573d.js"></script>

This command displays all your pods in the given namespace and shows on which node they are running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/All-Pods-got-scheduled.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/All-Pods-got-scheduled.jpg" alt="All Pods got scheduled" /></a>
  
  <p>
   All Pods got scheduled
  </p>
</div>

## Conclusion

Modern applications must react quickly to traffic spikes and scale out accordingly. This can be easily achieved using the Kubernetes Horizontal Pod Autoscaler or KEDA. These approaches only schedule more pods and your cluster can easily run out of space on its worker nodes. The cluster autoscaler in Azure Kubernetes Services helps you running out of resources and can automatically add new worked nodes to your cluster. Additionally, the cluster autoscaler also removes underutilized nodes and therefore can help you to keep costs to a minimum.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/Infrastructure/AzureResources/Azure-resource-install-pipeline.yml" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).