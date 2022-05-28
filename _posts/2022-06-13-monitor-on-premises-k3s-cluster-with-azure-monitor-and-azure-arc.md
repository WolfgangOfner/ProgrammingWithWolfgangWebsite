---
title: Monitor an on-premises k3s Cluster with Azure Monitor and Azure Arc
date: 2022-06-13
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, k3s, Rancher, On-premises, Azure Arc, Monitoring, Azure Monitor]
description: The Azure Monitor extension collects various metrics and sends them to Azure. There, you can create dashboards or alerts with Azure Arc.
---

Azure Arc allows you to project your on-premises Kubernetes cluster into Azure. Doing so enables you to manage the cluster from Azure with tools such as Azure Monitor or Cloud Defender.

Today, I want to show you how to install the Container Insights Extension which enables you to monitor your pods and nodes from the on-premise cluster in Azure.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Install the Azure Monitor Extension

Using Azure Monitor with your on-premises Kubernetes cluster is surprisingly easy. All you have to do is to execute the following Azure CLI command on the Master node of your cluster:

<script src="https://gist.github.com/WolfgangOfner/df783364ca52544364f1636531a59efe.js"></script>

The parameter of the command should be self-explanatory. The most interesting one is probably the --name parameter. This Azure CLI command installs the Azure Monitor extension in the cluster in the namespace you defined with the --name parameter. 

XXX INSERT SCREENSHOT OF K8s MONITOR EXTENSIONS NAMESPACE XXX

Additionally, the --name parameter defines the name of the extension which you can find in the Azure Portal in the Extensions pane.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/The-Azure-Monitor-Extension-in-the-Azure-Portal.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/The-Azure-Monitor-Extension-in-the-Azure-Portal.jpg" alt="The Azure Monitor Extension in the Azure Portal" /></a>
  
  <p>
   The Azure Monitor Extension in the Azure Portal
  </p>
</div>

The Azure CLI command automatically creates a new Log Analytics Workspace for the metrics and logs of the extensions. You can also use an existing Work Analytics Workspace. Use the following command to assign the Log Analytics Workspace Id to a variable and then use this variable for the Azure Monitor extension:

<script src="https://gist.github.com/WolfgangOfner/b7840583d94cde23630bab8c2c550e63.js"></script>

You can also display the installed extensions using the Azure CLI with the following command:

<script src="https://gist.github.com/WolfgangOfner/30c06c9670b898fcd518672d97a18ebf.js"></script>

## Create Dashboards in the Azure Portal

After you have installed the extension, it collects metric information and sends them to Azure. This allows you to use Azure Monitor the same way as you would use it with Azure VMs. Open Azure Arc in the Azure Portal and navigate to the Insights pane. There you can see various dashboards already. You can change what you want to display and also switch the scope, for example, from the Cluster scope to the Container scope. Additionally, you can set various filters such as a time range.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Display-various-dashboards-in-the-Azure-Portal.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Display-various-dashboards-in-the-Azure-Portal.jpg" alt="Display various dashboards in the Azure Portal" /></a>
  
  <p>
   Display various dashboards in the Azure Portal
  </p>
</div>

For even more insight into your cluster or pods, open the Metrics pane in Azure Arc. There you can create charts and display useful information. The following screenshot shows a chart that displays the pod count and the used CPU percentage of all nodes.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/06/Create-custom-charts-to-display-information.jpg"><img loading="lazy" src="/assets/img/posts/2022/06/Create-custom-charts-to-display-information.jpg" alt="Create custom charts to display information" /></a>
  
  <p>
   Create custom charts to display information
  </p>
</div>

Another neat feature of Azure Monitor is Alerting. Go to the Alerting pane and there you can create alerts based on custom rules. For example, you could send an email to an administrator if the CPU usage of the cluster is greater than 80% over 5 minutes.

## Conclusion

Monitoring your on-premise Cluster is as easy as it could be with Azure Arc. All you need is a single Azure CLI command to install the Azure Monitor extension. This extension collects various metrics and sends them to Azure. There, you can create dashboards or alerts. All this works the same way as when using Azure Monitor with Azure VMs.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).