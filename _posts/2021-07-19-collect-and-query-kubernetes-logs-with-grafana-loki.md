---
title: Collect and Query your Kubernetes Cluster Logs with Grafana Loki
date: 2021-07-19
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, Logging, Monitoring]
description: Collecting and querying logs in Kubernetes is crucial for important applications. Grafana Loki offers a great toolset to help you out.
---

So far I have talked about the development, deployment, and configuration of microservices and Kubernetes in this series. Over the next couple of posts, I want to talk about an essential topic when it comes to running your services in production: logging and monitoring.

In this post, I will show you how to install the Grafana Loki stack and how you can query the logs of everything inside a Kubernetes cluster.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## The Components of Grafana Loki 

Grafana Loki installs various components which are used for different tasks. Let's have a look at them:

### Grafana

Grafana is a tool to query, visualize and alert metrics. These metrics can be stored in a wide variety of data sources and can be brought into Grafana via plugins. Grafana is mostly known for its beautiful graphs to display everything you want to know about your infrastructure and applications. 

You can find more details on the <a href="https://grafana.com" target="_blank" rel="noopener noreferrer">Grafana website</a>. In a future post, I will show you how to create your own dashboards.

### Prometheus

Prometheus is an open-source project for monitoring and alerting and is also one of the oldest projects of the Cloud Native Computing Foundation (CNCF). Some of the main features of Prometheus are:

- PromQL, its own flexible query language
- a multi-dimensional data model for time series data
- collecting logs via a pull model

You can find more details on the <a href="https://prometheus.io" target="_blank" rel="noopener noreferrer">Prometheus website</a>. In a future post, I will show you how to use Prometheus to collect and display metrics from your microservices and Kubernetes cluster. 

### Promtail

Promtail is an agent for Loki. It discovers services, for example, applications inside a Kubernetes cluster or nodes of the cluster, and sends the logs to Loki. You can find more details in the <a href="https://grafana.com/docs/loki/latest/clients/promtail" target="_blank" rel="noopener noreferrer">Promtail documentation</a>. 

### Loki

Loki is a highly available logging solution. It gets described by its developers as "Like Prometheus but for Logs". It indexes the labels of the logs and allows querying of these logs using LogQL. You can find more details in the <a href="https://grafana.com/docs/loki/latest" target="_blank" rel="noopener noreferrer">Promtail documentation</a>. 

## Installing Grafana Loki using Helm

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

The Grafana Loki stack can be easily installed with Helm charts. If you are new to Helm, check out my previous posts [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm) for more details.

Use the following code to add the Grafana Helm charts, update it and then install Loki:

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki --namespace=grafana-loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=true,prometheus.server.persistentVolume.enabled=true
```

### Installing Grafana Loki using an Infrastructure as Code Pipeline

In one of my past posts, I have created an Infrastructure as Code (IaC) Pipeline using Azure CLI. If you want to automatically deploy Loki, add the following code after the Kubernetes deployment in your pipeline:

```yaml
variables:  
  LokiVersion: '2.5.2'
  LokiNamespace: loki-grafana

- task: HelmDeploy@0
  displayName: "Install Loki Grafana (Helm repo add)"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'add loki https://grafana.github.io/loki/charts'

- task: HelmDeploy@0
  displayName: "Install Loki Grafana (Helm repo update)"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    command: 'repo'
    arguments: 'update'

- task: HelmDeploy@0
  displayName: "Install Loki Grafana"
  inputs:
    connectionType: '$(AzureConnectionType)'
    azureSubscription: '$(AzureSubscription)'
    azureResourceGroup: '$(ResourceGroupName)'
    kubernetesCluster: '$(AksClusterName)'
    useClusterAdmin: true
    namespace: '$(LokiNamespace)'
    command: 'upgrade'
    chartType: 'Name'
    chartName: 'loki/loki-stack'
    chartVersion: '$(LokiVersion)'
    releaseName: 'loki'
    overrideValues: 'grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=true,prometheus.server.persistentVolume.enabled=true,loki.persistence.enabled=true,loki.persistence.size=10Gi'
    arguments: '--create-namespace'
```

The above code adds two variables, for the version of Loki and the namespace where it gets deployed and the does basically the same as the Helm deployment in the section above.

## Get the Credentials for Grafana

After installing Grafana Loki, you have to read the admin password from the secrets. You can do this in PowerShell with the following code:

```PowerShell
$encodedPassword = kubectl get secret -n loki-grafana loki-grafana -o jsonpath="{.data.admin-password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedPassword))
```

Use the following code when you are on Linux:

```bash
kubectl get secret -n loki-grafana loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

These commands get the secret for the admin password, decode it from base 64, and then print it to the console.

## Access Grafana

Before you can access Grafana, you have to create a port forwarding to access the Grafana service. You can do this with the following code:

```bash
kubectl get pod -n loki-grafana

kubectl port-forward -n loki-grafana <loki-grafana pod name> 3000
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Configure-the-port-forwarding-to-access-Grafana.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Configure-the-port-forwarding-to-access-Grafana.jpg" alt="Configure the port forwarding to access Grafana" /></a>
  
  <p>
   Configure the port forwarding to access Grafana
  </p>
</div>

This configuration enables you to access the Grafana dashboard using http://localhost:3000. Enter the URL into your browser and you will see the Grafana login screen.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/The-Grafana-login-screen.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/The-Grafana-login-screen.jpg" alt="The Grafana login screen" /></a>
  
  <p>
   The Grafana login screen
  </p>
</div>

The user name is admin and the password is what you decoded in the previous step.

## create your first Query in Loki

After the successful login, click on the round icon on the left and select Explore to open the query editor.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Open-the-Loki-query-editor.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Open-the-Loki-query-editor.jpg" alt="Open the Loki query editor" /></a>
  
  <p>
   Open the Loki query editor
  </p>
</div>

On the top of the page, select Loki as your data source and then you can create a simple query by clicking on Log labels. For example, select pod and then select the loki-grafana pod to query all logs from this specific pod. The query looks as follows:

```bash
{pod="loki-grafana-7d4d587544-npc6n"} 
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Create-your-first-Loki-query.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Create-your-first-Loki-query.jpg" alt="Create your first Loki query" /></a>
  
  <p>
   Create your first Loki query
  </p>
</div>

The query will display all logs from the grafana-loki pod. For more details about a log entry, click on it. You can see a successful login on the following screenshot.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/A-successful-login-got-logged.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/A-successful-login-got-logged.jpg" alt="A successful login got logged" /></a>
  
  <p>
   A successful login got logged
  </p>
</div>

## Filter your Logs

Displaying all the logs is nice but not really useful. Usually, you want to filter your logs and only display problematic entries like errors. You can use the following query to display only log entries with the error level:

```bash
{pod="loki-grafana-7d4d587544-npc6n"} |= "error"
```

This query is more useful than displaying all logs but often you also want to search for a specific log message. You can do this easily by extending the query:

```bash
{pod="loki-grafana-7d4d587544-npc6n"} |= "error" != "Invalid Username or Password"
```

This query displays all error logs with Invalid Username or Password in the log message.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Query-only-error-logs.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Query-only-error-logs.jpg" alt="Query only error logs" /></a>
  
  <p>
   Query only error logs
  </p>
</div>

## LogQL Query Language

All the queries above use LogQL. The examples above are just scratching the surface of what you can do with LogQL but it should be enough to get you started. For more details about LogQL, check out <a href="https://grafana.com/docs/loki/latest/logql" target="_blank" rel="noopener noreferrer">the documentation</a>.

## Conclusion

Analyzing logs is essential for every project running in a production environment. Grafana Loki offers a lot of functionality out of the box like automatically collecting logs from each object in Kubernetes and sending it to Loki where you can query and filter these logs. The examples in this post are very simple but should be enough to get you started. 

In my next post, I will show you how to extend the existing microservices of my demo to send their logs also to Loki.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).