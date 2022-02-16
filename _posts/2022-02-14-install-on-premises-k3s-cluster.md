---
title: Install an on-premises k3s Cluster
date: 2022-02-14
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Kubernetes, k3s, Rancher, On-premises]
description: K3s is a fully certified, lightweight Kubernetes distribution developed by Rancher. It can be easily installed and helps you get started with Kubernetes.
---

Using cloud technologies is amazing and makes a developer's life so much easier. Lately, I have to work with an on-premises Kubernetes cluster and I had to realize how much work it is to do all these things cloud providers offer. That's the reason why I got into Azure Arc. In my last post, [Azure Arc - Getting Started](/azure-arc-getting-started), I explained what Azure Arc is and how it can be used to manage on-premises resources.

Today, I would like to get more practical and show you how to install an on-premises k3s cluster and in the next post, I will install Azure Arc to manage the cluster.

## Project Requirements and Restrictions

My project has the following requirements and restrictions:

- Two on-premises Ubuntu 20.04 VMs
- Install and manage a Kubernetes distribution
- Developers must use CI/CD pipelines to deploy their applications
- A firewall blocks all inbound traffic
- Outbound traffic is allowed only on port 443
- Application logging
- Monitor Kubernetes and Vms metrics
- Alerting if something is wrong

The biggest problem with these restrictions is that the firewall blocks all inbound traffic. This makes the developers' life way hard, for example, using a CD pipeline with Azure DevOps won't work because Azure DevOps would push the changes from the internet onto the Kubernetes cluster.

All these problems can be solved with Azure Arc though. Let's start with installing a Kubernetes distribution and project it into Azure Arc.

## Installing an on-premises k3s Cluster

Since I am a software architect and not really a Linux guy, I decided to use k3s as my Kubernetes distribution. K3s is a lightweight and fully certified Kubernetes distribution that is developed by Rancher. The biggest advantage for me is that it can be installed with a single command. You can find more information about k3s on the <a href="https://rancher.com/docs/k3s/latest/en" target="_blank" rel="noopener noreferrer">Rancher website</a>.

My infrastructure consists of two Ubuntu 20.04 VMs. One is called master and will contain the Kubernetes control plane and also serve as a worker node. The second VM, called worker, will only serve as a worker node for Kubernetes.

To get started, connect to the master server via ssh and install k3s with the following command:

<script src="https://gist.github.com/WolfgangOfner/0f99459e09aa1bd1c2288e65d319f42d.js"></script>

There are several options to configure the installation. For this demo, the default is fine but if you want to take a closer look at the available options, see the <a href="https://rancher.com/docs/k3s/latest/en/installation/install-options" target="_blank" rel="noopener noreferrer">Installation Options</a>.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/02/Install-k3s.jpg"><img loading="lazy" src="/assets/img/posts/2022/02/Install-k3s.jpg" alt="Install k3s" /></a>
  
  <p>
   Install k3s
  </p>
</div>

The installation should only take a couple of seconds. After it is finished, use the Kubernetes CLI, kubectl, to check that the cluster has one node now:

<script src="https://gist.github.com/WolfgangOfner/82b89d9f37b50237c1bb9128afc3ffe4.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/02/The-master-node-got-installed.jpg"><img loading="lazy" src="/assets/img/posts/2022/02/The-master-node-got-installed.jpg" alt="The master node got installed" /></a>
  
  <p>
   The master node got installed
  </p>
</div>

If you want a very simple Kubernetes installation, you are already good to go.

### Add Worker Nodes to the k3 Cluster

To add worker nodes to the k3s cluster, you have to know the k3s cluster token and the IP address of the master node. To get the token, use the following command on the master node:

<script src="https://gist.github.com/WolfgangOfner/908e4738f904b21fcb2b84b8c2ee7344.js"></script>

The node token should look as follows:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/02/Get-the-node-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/02/Get-the-node-token.jpg" alt="Get the node token" /></a>
  
  <p>
   Get the node token
  </p>
</div>

Copy the token somewhere and then connect to the worker VM via ssh. Use the following command to install k3s on the VM and also add it to the cluster:

<script src="https://gist.github.com/WolfgangOfner/1821c22e014de87fe6b80df8658fd892.js"></script>

Replace the URL with the URL of your master node and also replace the token with your token.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/02/Add-a-new-k3s-worker-node.jpg"><img loading="lazy" src="/assets/img/posts/2022/02/Add-a-new-k3s-worker-node.jpg" alt="Add a new k3s worker node" /></a>
  
  <p>
   Add a new k3s worker node
  </p>
</div>

Go back to the master VM and you should see two nodes in your cluster now:

<script src="https://gist.github.com/WolfgangOfner/82b89d9f37b50237c1bb9128afc3ffe4.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/02/The-worker-node-got-added-to-the-cluster.jpg"><img loading="lazy" src="/assets/img/posts/2022/02/The-worker-node-got-added-to-the-cluster.jpg" alt="The worker node got added to the cluster" /></a>
  
  <p>
   The worker node got added to the cluster
  </p>
</div>

You can repeat this process for every node you want to add to the cluster.

## Conclusion

K3s is a fully certified, lightweight Kubernetes distribution developed by Rancher. It can be easily installed and is a great tool to get started with Kubernetes when you have to use on-premises infrastructure.

In my next post, I will install Azure Arc and project the cluster to Azure. This will allow managing the cluster in the Azure portal.