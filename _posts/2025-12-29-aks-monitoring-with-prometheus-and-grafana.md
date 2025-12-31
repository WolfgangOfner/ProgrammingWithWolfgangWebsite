---
title: AKS Monitoring with Prometheus and Grafana - Part 11
date: 2025-12-29
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Grafana, Prometheus, Azure Monitor]
description: Implement AKS Monitoring using Managed Prometheus and Grafana. Learn to track Application Gateway for Containers metrics and cluster health.
---

In modern cloud environments, visibility is everything. Once you have your **Kubernetes Gateway API** and **Azure Kubernetes Service (AKS)** running, the next critical step is ensuring you can see what is happening inside your cluster. **Part 11** of our series dives into implementing a robust monitoring stack using **Managed Prometheus** and **Managed Grafana** in Azure.

This guide explores how to collect metrics, logs, and health data from both your AKS cluster and the **Application Gateway for Containers (AGFC)** to build a unified monitoring dashboard.

## The Monitoring Architecture

A complete monitoring solution for AKS involves gathering data from multiple sources:

1.  **Application Gateway for Containers:** We collect metrics (like total requests and HTTP status codes) and diagnostic logs.
2.  **AKS Cluster:** We use Prometheus to scrape performance data directly from the Kubernetes nodes and pods.
3.  **Log Analytics Workspace:** This acts as the central repository for all logs and diagnostic information.
4.  **Grafana:** The visualization layer that connects to both Prometheus and Log Analytics to display data in intuitive dashboards.

## Configuring Diagnostic Logs for AGFC

To start monitoring the Application Gateway for Containers, you must first enable diagnostic settings. By creating a **Log Analytics Workspace** and configuring the AGFC to send its logs and metrics there, you gain the ability to:

* **Track Request Volume:** See exactly how many requests your gateway is handling over time.
* **Monitor Health:** Identify spikes in 400 or 500-level error codes that might indicate an issue with your backend services.
* **Set Alerts:** Use Azure’s built-in alerting to notify administrators automatically if specific thresholds are met.

## Deploying Managed Prometheus and Grafana

Azure provides managed versions of these popular open-source tools, allowing for a "button-click" setup that avoids the overhead of managing the monitoring infrastructure yourself.

### Setting Up Prometheus
Once enabled, Azure installs a monitoring agent on your AKS cluster. A crucial step in this process is applying a **ConfigMap** that tells the agent how to scrape data. For this series, you must ensure the configuration points to the specific namespace where your **Application Load Balancer (ALB)** is deployed (e.g., `ALB-info`). This allows Prometheus to gather data specifically related to your Gateway API implementation.

### Setting Up Grafana
The **Managed Grafana** instance handles the visualization. After deployment, a critical but often overlooked step is configuring permissions. By default, Grafana may not have access to your Log Analytics data. You must assign the **Monitoring Reader** role to the Grafana Managed Identity at the subscription or resource group level to allow it to fetch data from your workspace.

## Building Useful Dashboards

With your data sources connected, you can create various visualizations in Grafana:

* **Endpoint Monitoring:** Visualize the total number of active endpoints managed by your ALB controller.
* **Pod Inventory:** Use Kusto Query Language (KQL) to query Log Analytics and display the number of pods running in each namespace, helping you keep track of cluster density.
* **HTTP Performance:** Create graphs that split HTTP traffic by response code (e.g., 200 vs 404 vs 500), allowing you to quickly spot trends in application errors.

## Conclusion

Implementing Prometheus and Grafana provides the deep insights necessary to operate a production-ready Kubernetes environment. While Azure's built-in metrics provide a great baseline, the flexibility of Grafana allows you to build custom, cross-resource dashboards that combine gateway performance with cluster-level health. By offloading the management of these tools to Azure's managed services, you can focus on analyzing your data rather than maintaining the monitoring platform itself.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Monitoring%20with%20Prometheus%20and%20Grafana%20-%20Part%2011">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Monitoring with Prometheus and Grafana - Part 11" and reviewed by me.

## Video - AKS Monitoring with Prometheus and Grafana - Part 11

<iframe width="560" height="315" src="https://www.youtube.com/embed/_81ypGr5X9w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>