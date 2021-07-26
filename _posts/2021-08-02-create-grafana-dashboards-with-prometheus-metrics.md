---
title: Create Grafana Dashboards with Prometheus Metrics
date: 2021-08-02
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana]
description: Grafana combined with Prometheus is a powerful tool to visualize your metrics from each component of your Kubernetes cluster and even from single deployments or pods.
---

[In my last post](/monitor-net-microservices-with-prometheus), I added the Prometheus client library to my .NET microservices. This was the first step to implement monitoring of the microservices which are running in a Kubernetes cluster.

In this post, I will show you how to create your first dashboard with Grafana using the Prometheus data.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Add the Microservices to the Prometheus Configuration for Scrapping

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

You have to add the microservices as targets in Prometheus before you can visualize their Prometheus data. I installed Grafana Loki in a previous post which also installs Prometheus. You can find the details in [Collect and Query your Kubernetes Cluster Logs with Grafana Loki](/collect-and-query-kubernetes-logs-with-grafana-loki).

After you have installed Prometheus, open the configuration of the Prometheus server. You can use a dashboard and edit the yaml file in your browser. In [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started/#access-the-aks-cluster) I explain how to use Octant as a dashboard to access your Kubernetes cluster.

Open the dashboard and then select the namespace where you have installed Prometheus. If you followed this series, the namespace is loki-grafana. Navigate to the Config Maps and there you can find the configuration for the Prometheus server named loki-prometheus-server.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Edit-the-Prometheus-Configuration.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Edit-the-Prometheus-Configuration.jpg" alt="Edit the Prometheus Configuration" /></a>
  
  <p>
   Edit the Prometheus Configuration
  </p>
</div>

Select the YAML tab and add the following code under scrape_configs:

```yaml
scrape_configs:
- job_name: prometheus
  static_configs:
  - targets:
    - localhost:9090
- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  job_name: 'customerapi-test'
  scrape_interval: 10s
  metrics_path: '/metrics'
  kubernetes_sd_configs:
  - role: pod
    namespaces:
      names:
      - customerapi-test
    selectors:
    - role: "pod"
      label: "app=customerapi"
```
This tells Prometheus to scrape data from a pod in the customer-api namespace. The pod has the label app=customerapi and the Prometheus data is available under /metrics. Save the config and then let's check if customerapi is available in Prometheus.

### Inspect the Prometheus Scrap Targets

In the Kubernetes dashboard, navigate to the loki-grafana namespace and select the loki-prometheus-server pod. There you can activate the port forwarding to access the pod from your computer. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Open-the-Prometheus-Server-Pod-in-the-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Open-the-Prometheus-Server-Pod-in-the-Dashboard.jpg" alt="Open the Prometheus Server Pod in the Dashboard" /></a>
  
  <p>
   Open the Prometheus Server Pod in the Dashboard
  </p>
</div>

Click the button Start Forwarding and you will get a localhost URL that forwards your request to the Prometheus server instance. The URL in my case is http://localhost:53625.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Activate-the-Port-Forwarding.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Activate-the-Port-Forwarding.jpg" alt="Activate the Port Forwarding" /></a>
  
  <p>
   Activate the Port Forwarding
  </p>
</div>

Open the URL and navigate to /targets. There you should see the customerapi-test target as healthy. You can also see when a scrape happened the last time, how long it took, and if there were any errors.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Inspect-the-Prometheus-Scrap-Targets.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Inspect-the-Prometheus-Scrap-Targets.jpg" alt="Inspect the Prometheus Scrap Targets" /></a>
  
  <p>
   Inspect the Prometheus Scrap Targets
  </p>
</div>

## Query Prometheus Data in Grafana

If you don't know how to access Grafana, see [Collect and Query your Kubernetes Cluster Logs with Grafana Loki](/collect-and-query-kubernetes-logs-with-grafana-loki/#access-grafana) for information on how to configure the redirect and how to read the admin password from the Kubernetes secret.

In Grafana, click on the round (compass?) symbol on the left and select Explore to open the query editor.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Open-the-Grafana-Query-Editor.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Open-the-Grafana-Query-Editor.jpg" alt="Open the Grafana Query Editor" /></a>
  
  <p>
   Open the Grafana Query Editor
  </p>
</div>

Make sure that you select Prometheus as the data source on top of the page and then you can create your first queries. Click on metrics to get an overview of a lot of the built-in commands and get familiar with the functionality of the queries. A useful metric is the histogram where you can display a certain quantile, for example, the 95% quantile. You can see a query of the 95% quantile of the request duration. You can see that the requests were fast but at around 18:30 the request duration spiked to up to 100 seconds. This clearly indicates that there was a problem.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Create-a-Histogram.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Create-a-Histogram.jpg" alt="Create a Histogram" /></a>
  
  <p>
   Create a Histogram
  </p>
</div>

The functionality of PromQL is way too vast for this post today but you can find example in the <a href="https://prometheus.io/docs/prometheus/latest/querying/basics/" target="_blank" rel="noopener noreferrer">Prometheus documentation</a>.

## Import Grafana Dashboards

Grafana allows you to import dashboards from the community which is a great starting point. You can find a list of all the dashboards on <a href="https://grafana.com/grafana/dashboards/" target="_blank" rel="noopener noreferrer">https://grafana.com/grafana/dashboards</a>.

Once you found a dashboard you like, for example the <a href="https://grafana.com/grafana/dashboards/6417" target="_blank" rel="noopener noreferrer">Kuberets Cluster (Prometheus)</a> dashboard, copy its id. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Copy-the-id-of-the-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Copy-the-id-of-the-Dashboard.jpg" alt="Copy the id of the Dashboard" /></a>
  
  <p>
   Copy the id of the Dashboard
  </p>
</div>

Next, click on the + button on the left of your Grafana GUI and select Import.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Import-a-Grafana-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Import-a-Grafana-Dashboard.jpg" alt="Import a Grafana Dashboard" /></a>
  
  <p>
   Import a Grafana Dashboard
  </p>
</div>

On the import page of the dashboard, provide a name (or leave the default one) and select your Prometheus instance from the dropdown. Then click on Import and the dashboard gets imported. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Configure-the-Dashboard-Import.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Configure-the-Dashboard-Import.jpg" alt="Configure the Dashboard Import" /></a>
  
  <p>
   Configure the Dashboard Import
  </p>
</div>

After the dashboard is imported, it gets immediately displayed and gives you an overview of your cluster health, the cluster's pods, and containers, and much more. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/The-Dashboard-gives-an-Overview-of-the-Kubernetes-Cluster.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/The-Dashboard-gives-an-Overview-of-the-Kubernetes-Cluster.jpg" alt="The Dashboard gives an Overview of the Kubernetes Cluster" /></a>
  
  <p>
   The Dashboard gives an Overview of the Kubernetes Cluster
  </p>
</div>

The dashboard already gives you useful information but you can easily edit or remove its components and also can take a look at the definition of each component. This can help you when you try to create your own dashboards.

Community dashboards are a good way to get started but you will always have to create your own dashboards to fulfill your requirements. 

## Create your own Grafana Dashboard with Data from Prometheus

To create your own Grafana dashboard, click on the + button on the left side of the Grafana GUI and then select Add Query.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Start-creating-a-new-Grafana-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Start-creating-a-new-Grafana-Dashboard.jpg" alt="Start creating a new Grafana Dashboard" /></a>
  
  <p>
   Start creating a new Grafana Dashboard
  </p>
</div>

Select Prometheus as your data source on the next screen and enter a query. My query creates a histogram for the 99% quantile for the request duration in seconds over the last 10 minutes.

```bash
histogram_quantile(0.99, sum by (le) ( rate(http_request_duration_seconds_bucket[10m])))
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Create-a-Histogram-Query.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Create-a-Histogram-Query.jpg" alt="Create a Histogram Query" /></a>
  
  <p>
   Create a Histogram Query
  </p>
</div>

The Visualization tab allows you to configure the looks of your dashboard. I added points to the graph and added a label and unit for the left y-axis. Additionally, I added the min, max, and average values of the query to the legend on the bottom left of the graph.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Configure-the-Visualization-of-the-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Configure-the-Visualization-of-the-Dashboard.jpg" alt="Configure the Visualization of the Dashboard" /></a>
  
  <p>
   Configure the Visualization of the Dashboard
  </p>
</div>

There is a wide variety of options to customize your dashboard. Some are more and some are less useful like the following one.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Use-a-Gauge-to-display-your-data.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Use-a-Gauge-to-display-your-data.jpg" alt="Use a Gauge to display your data" /></a>
  
  <p>
   Use a Gauge to display your data
  </p>
</div>

On the next page, provide a title for the dashboard. You should always name all the axis and dashboards so everyone can easily see what this dashboard displays.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Add-a-Title.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Add-a-Title.jpg" alt="Add a Title" /></a>
  
  <p>
   Add a Title
  </p>
</div>

Lastly, click on the Save button and give your dashboard a name.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Save-your-first-Grafana-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Save-your-first-Grafana-Dashboard.jpg" alt="Save your first Grafana Dashboard" /></a>
  
  <p>
   Save your first Grafana Dashboard
  </p>
</div>

Congratulation, you created your first dashboard. You can add as many components as you want to this dashboard in the future. If you take a look at the one we have, you can immediately see that there is something not right with the service.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Something-is-wrong-with-the-monitored-Service.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Something-is-wrong-with-the-monitored-Service.jpg" alt="Something is wrong with the monitored Service" /></a>
  
  <p>
   Something is wrong with the monitored Service
  </p>
</div>

Between 21:55 and 22:01 the request time was around 5 - 7 seconds which does not look good compared to the very low request time the service usually has. At 22:07 the request duration spikes to around 35 seconds which is definitely not good and shows that something is massively wrong.

## Conclusion

Grafana combined with Prometheus is a powerful tool to visualize your metrics from each component of your Kubernetes cluster and even from single deployments or pods. This post showed how to add new targets to the Prometheus scrap configuration and how to import and create your own dashboards to display the request duration.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).