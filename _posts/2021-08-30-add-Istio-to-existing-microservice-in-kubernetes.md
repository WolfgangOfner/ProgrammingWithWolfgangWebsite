---
title: Add Istio to an existing Microservice in Kubernetes
date: 2021-08-30
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Kiali]
description: 
---

[My last post](/use-istio-to-manage-your-microservices) highlighted some of Istio's features and showed how to apply them to your microservices. 

In this short post, I will show you how to add Istio to an existing application.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Add Istio to an existing Application running Kubernetes

If you already have an application or microservices running in your Kubernetes and want to add Istio support, all you have to do is to add the following label to the namespace.

<script src="https://gist.github.com/WolfgangOfner/508ae5af388bf26a772f6347e7b8a002.js"></script>

The next time a pod is created, the new label will be applied and the sidecar will be injected automatically. You can verify the flow of your application in Kiali, once the label is applied. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Visualize-the-request-flow.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Visualize-the-request-flow.jpg" alt="Visualize the request flow" /></a>
  
  <p>
   Visualize the request flow
  </p>
</div>

Note, of course you have to have Istio installed in your cluster For more information about Kiali and Istio, see my post [Istio in Kubernetes - Getting Started](/istio-getting-started).

## Conclusion

If you already have an application running in Kubernetes, all you have to do is add a label to the namespace to enable Istio. The label will be applied to pods when they are created the next time.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).