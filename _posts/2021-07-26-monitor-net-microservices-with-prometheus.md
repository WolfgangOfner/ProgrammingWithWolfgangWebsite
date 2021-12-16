---
title: Monitor .NET Microservices in Kubernetes with Prometheus
date: 2021-07-26
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus]
description: Prometheus is a widely used open-source monitoring and alerting system that is the most popular solution for Kubernetes environments.
---

Knowledge is power is a famous saying which also holds true when running software. You would like to know how many errors occur, how long the response times of your services are, and also how many people are even using your application.

In my last post, I added Grafana Loki to log events but it also installed Prometheus which I will use in this post to log messages from my microservices in my Kubernetes cluster.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is Prometheus?

Prometheus is an open-source monitoring and alerting system and was the second project to join the CNCF (Cloud Native Computing Foundation) in 2016. It has more than 6000 forks and almost 40K stars on GitHub with a very active community. Prometheus collects data using a pull model over HTTP and does not rely on distributed storage solutions. This allows you to create several independent Prometheus servers to make it highly available.

The components of Prometheus are the server itself, client libraries, an alert manager, and several other supporting tools.

The client libraries allow you to publish log messages which can be scrapped by Prometheus. Further down, I will show you how to do that in .NET 5. The Alertmanager can send alerts to a wide range of systems like email, webhooks, Slack, or WeChat.

Prometheus can be used as a data source in Grafana where you can easily create beautiful dashboards. I will show you this in my next post.

## Available Metric Types

Prometheus knows the following four metric types:

- Counter: A counter whose value can only increase or bet set at zero.
- Gauge: A number that can go up or down.
- Histogram: Samples of observations that are counted in buckets.
- Summary: Like the histogram but can calculate quantiles.

## Installing the Prometheus Client Library in .NET 5

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

Installing the C# Prometheus client libraries is very simple. All you have to do is to install the prometheus-net and prometheus-net.AspNetCore NuGet packages

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Install-the-Prometheus-Nuget-Packages.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Install-the-Prometheus-Nuget-Packages.jpg" alt="Install the Prometheus NuGet Packages" /></a>
  
  <p>
   Install the Prometheus NuGet Packages
  </p>
</div>

Next, add the metric server to expose the metrics which can be scrapped by Prometheus. Use the following code and make sure you add it before app.UseEndpoints... in the Startup.cs class:

<script src="https://gist.github.com/WolfgangOfner/b51793ea1e3a2eb9df7fb3bbbd7fef58.js"></script>

Start your application, navigate to the /metrics endpoints and you will see the default metrics which are exposed from the client library.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Prometheus-default-metrics.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Prometheus-default-metrics.jpg" alt="Prometheus default metrics" /></a>
  
  <p>
   Prometheus default metrics
  </p>
</div>

The metrics might look confusing at first but they will be way more readable once you created your first dashboard.

## Add Prometheus Metrics

The Prometheus client libraries allow you to easily create your own metrics. First, you have to collect the metrics. You can use the following code to create a counter and histogram:

<script src="https://gist.github.com/WolfgangOfner/e6b1adde23faf6866a28a67dcc701e37.js"></script>

The code above will expose the response time for each HTTP code, for example, how long was the response for an HTTP 200 code. Additionally, it counts the total number of requests. To use the code above, create a new middleware that uses the MetricCollector.

<script src="https://gist.github.com/WolfgangOfner/6468df19a76b1265d323fda9e6ec34b7.js"></script>

The last step is to register the new middleware in the Startup.cs class. Add the following code to the ConfigureServices method:

<script src="https://gist.github.com/WolfgangOfner/effbfb55a0c8b3491d832a95e89d7c13.js"></script>

After registering the collector, add the middleware to the Configure method:

<script src="https://gist.github.com/WolfgangOfner/5706feae7033bde0355b77da1690633a.js"></script>

When you start your microservice and navigate to /metrics, you will see the number of different requests and the response time.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Test-the-custom-metrics.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Test-the-custom-metrics.jpg" alt="Test the custom metrics" /></a>
  
  <p>
   Test the custom metrics
  </p>
</div>

The code for the <a href="https://gist.githubusercontent.com/aevitas/3405c495632333c76624fcd517876eb7/raw/5cbadfeb45ccd32a5e5d3d1280b82604eea70a06/MetricReporter.cs" target="_blank" rel="noopener noreferrer">MetricCollector</a> and the <a href="https://gist.githubusercontent.com/aevitas/0df15474cbf2437e278739986a6b599c/raw/ce990d63e991df308a40362c63369f22b0400308/ResponseMetricMiddleware.cs" target="_blank" rel="noopener noreferrer">middleware</a> were taken from GitHub.

## Conclusion

Prometheus is the go-to solution for collecting metrics in dockerized environments like Kubernetes. This demo showed how to add the Prometheus client library to a .NET 5 microservice and how to create your own metrics. 

[In my next post](/create-grafana-dashboards-with-prometheus-metrics), I will show you how to use these metrics to create dashboards with Grafana.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).