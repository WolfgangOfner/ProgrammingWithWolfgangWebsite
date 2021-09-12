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

<script src="https://gist.github.com/WolfgangOfner/07bfab1dd2005f8974bbfb6c3229036e.js"></script>

### Installing Grafana Loki using an Infrastructure as Code Pipeline

In one of my past posts, I have created an Infrastructure as Code (IaC) Pipeline using Azure CLI. If you want to automatically deploy Loki, add the following code after the Kubernetes deployment in your pipeline:

<script src="https://gist.github.com/WolfgangOfner/2ef1d3a14d28857ace28aaee7e327215.js"></script>

The above code adds two variables, for the version of Loki and the namespace where it gets deployed and the does basically the same as the Helm deployment in the section above.

## Get the Credentials for Grafana

After installing Grafana Loki, you have to read the admin password from the secrets. You can do this in PowerShell with the following code:

<script src="https://gist.github.com/WolfgangOfner/7dea1e79d687b63e316f63e9108a9c21.js"></script>

Use the following code when you are on Linux:

<script src="https://gist.github.com/WolfgangOfner/5151b8b96532a0557f38a77ac0abec0e.js"></script>

These commands get the secret for the admin password, decode it from base 64, and then print it to the console.

## Access Grafana

Before you can access Grafana, you have to create a port forwarding to access the Grafana service. You can do this with the following code:

<script src="https://gist.github.com/WolfgangOfner/1fab1cdfaf15e436d1bdf526402aeb59.js"></script>

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

<script src="https://gist.github.com/WolfgangOfner/600e68f46638ff0190579ec53e727740.js"></script>

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

<script src="https://gist.github.com/WolfgangOfner/2d5235bfeaa93ed5af16507caa398fa2.js"></script>

This query is more useful than displaying all logs but often you also want to search for a specific log message. You can do this easily by extending the query:

<script src="https://gist.github.com/WolfgangOfner/eaa4a122729322fdccebac6a78b3825f.js"></script>

This query displays all error logs with Invalid Username or Password in the log message.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Query-only-error-logs.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Query-only-xcerror-logs.jpg" alt="Query only error logs" /></a>
  
  <p>
   Query only error logs
  </p>
</div>

## LogQL Query Language

All the queries above use LogQL. The examples above are just scratching the surface of what you can do with LogQL but it should be enough to get you started. For more details about LogQL, check out <a href="https://grafana.com/docs/loki/latest/logql" target="_blank" rel="noopener noreferrer">the documentation</a>.

## Conclusion

Analyzing logs is essential for every project running in a production environment. Grafana Loki offers a lot of functionality out of the box like automatically collecting logs from each object in Kubernetes and sending it to Loki where you can query and filter these logs. The examples in this post are very simple but should be enough to get you started. 

[In my next post](/monitor-net-microservices-with-prometheus), I will show you how to use Prometheus, which was also installed by Loki, to scrap metrics from the microservices.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).