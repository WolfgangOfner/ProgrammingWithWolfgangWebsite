---
title: Service Mesh in Kubernetes - Getting Started
date: 2021-08-09
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Consul, Linkerd]
description: A Service Mesh helps with traffic management, security, and traceability in Kubernetes and can be achieved independently of the business logic
---

If you have followed this series then you have learned what microservices are, how to program and deploy them, and how to monitor your Kubernetes cluster and applications. The last missing puzzle piece in your microservice journey is how to manage applications with hundreds or thousands of pods and microservices.

This is where a service mesh comes into play. This post will talk about the pro and cons of a service mesh and also will give an overview of existing solutions.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is a Service Mesh?

Imagine you have an application running hundreds or thousands of microservices like Netflix already had in 2015. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/04/Netflix-Architecture-in-2015.jpg"><img loading="lazy" src="/assets/img/posts/2020/04/Netflix-Architecture-in-2015.jpg" alt="Netflix Microservices Architecture in 2015" /></a>
  
  <p>
    Netflix Microservices Architecture in 2015 (<a href="https://www.youtube.com/watch?v=-mL3zT1iIKw" target="_blank" rel="noopener noreferrer">Source Youtube</a>)
  </p>
</div>

These microservices probably have doubled by now. All these microservices are communicating with each other, need monitoring, tracing, and security like encryption. Configuring each microservice would take forever and is impractical in practice. To accomplish all these tasks you have to add a layer above your applications. This is where a service mesh comes into play. 

A Service mesh separates your business logic from managing the network traffic, security and monitoring. This should help to increase the productivity of the developers whereas network and operation specialists can configure the Kubernetes cluster. The separation is often achieved by using sidecars. This means that the service mesh injects an additional container (sidecar) into your pod. The sidecar is often an Envoy container which is a popular open-source proxy. The Envoy container intercepts requests from and to the container to modify the traffic. 

Another popular feature of service meshes is fault injection and rate-limiting. This allows you to configure how many requests randomly fail (returning HTTP 500) and also to time-out services if they send too many requests. Especially the fault injection helps developers to test error handling and often helps to make the application more resilient to gracefully handling errors.

## Service Mesh Projects for Kubernetes

There are three big service mesh competitors in the Kubernetes world at the moment: Istio, Linkerd, and Consul.

### Istio

Istio was originally developed by Lyft and has been adopted by many major technology companies like Google or Microsoft. Istio is the most popular service mesh solution and has an active community. As of this writing, the project has almost 28 thousand stars and more than 5 thousand forks on GitHub. Istio can be easily installed using Helm charts and also installs many useful tools to operate your Kubernetes cluster, like [Prometheus](/monitor-net-microservices-with-prometheus), Jaeger, [Grafana](/create-grafana-dashboards-with-prometheus-metrics), and Zipkin. 

[In my next post](/istio-getting-started), I will show you how to install Istio using its Helm charts and how to configure the traffic management. For more information see <a href="https://istio.io/" target="_blank" rel="noopener noreferrer">istio.io</a>. 

### Consul

Consul is the probably second most popular open-source service mesh out there and has been developed by HashiCorp. Consul promises better performance compared to Istio because it uses an agent-based model in comparison to Istio's multiple services. The agents run on the Kubernetes nodes and therefore can locally cache settings to improve the performance. 

I have not worked with Consul yet therefore I would recommend that you check out <a href="https://consul.io/" target="_blank" rel="noopener noreferrer">consul.io</a> for more information about Consul's features and how it works.

### Linkerd

Linkerd is another popular service mesh and has been completely re-written for version 2. Both versions combined have around 12 thousand stars on GitHub and also have a very active community. Linkerd provides a good-looking dashboard to help operators understand what is happening inside the Kubernetes cluster in real-time. Additionally, it installs useful tools like Prometheus and Grafana.

Linkerd can be installed via its own CLI. For more information see <a href="https://linkerd.io/" target="_blank" rel="noopener noreferrer">linkerd.io</a>. 

## Disadvantages of a Service Mesh

As always, using a service mesh comes not only with advantages but also with some disadvantages. Probably the biggest disadvantage is that developers/operators need to learn yet another tool to run their application. Especially in the beginning, using a service mesh might add some problems due to more possibilities of misconfiguration and therefore breaking your application rather than helping.

Another disadvantage of a service mesh is that it adds some overhead and especially additional resource usage. Istio measured that the Envoy proxy sidecar uses 350 mCPUs and around 40 MB memory per 1000 requests. Additionally, it adds 2.65 ms to the 90th percentile latency. This might not sound like much but if your cluster has 1000 pods running, it adds up. 

## Conclusion

A service mesh can help operators to manage their Kubernetes cluster managing traffic, security, and monitoring. A big advantage is that these features are separate from the business logic and can be independently managed and implemented. This post gave a very short introduction to services meshes and [in my next post](/istio-getting-started), I will show you how to install Istio and how to take advantage of the features it provides.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).