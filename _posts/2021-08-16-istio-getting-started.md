---
title: Istio in Kubernetes - Getting Started
date: 2021-08-16
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Kiali]
description: Istio is an easy to install service mesh that comes with many useful applications like Grafana, Prometheus, and Jaeger. 
---

[My last post](/service-mesh-kubernetes-getting-started) introduced the concept of a service mesh and how it can help to manage your Kubernetes cluster, especially with hundreds or thousands of pods running. The post was only theoretical and was probably a bit abstract if you have never worked with a service mesh.

Therefore, I want to show you how to install Istio and a sample application on your Kubernetes cluster in this post.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Installing Istio in Kubernetes

This demo assumes that you already have a Kubernetes cluster set up. If you don't see [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started) to set up a new cluster and also configure the connection to Kubernetes. Usually, I work with Windows but for this demo, I will use the Windows Subsystem for Linux. You can use all commands on Linux or Max as well.

To get started, download the newest version of Istio.

```bash
curl -L https://istio.io/downloadIstio | sh -
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Download-the-newest-Version-of-Istio.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Download-the-newest-Version-of-Istio.jpg" alt="Download the newest Version of Istio" /></a>
  
  <p>
   Download the newest Version of Istio
  </p>
</div>

Alternatively, go to <a href="https://github.com/istio/istio/releases" target="_blank" rel="noopener noreferrer">Github</a> and download the desired version.

After the download is finished, navigate into the downloaded Istio folder and set the path to the /bin folder as the Path variable.

```bash
cd istio-1.10.3
export PATH=$PWD/bin:$PATH
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Set-the-Istio-Path.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Set-the-Istio-Path.jpg" alt="Set the Istio Path" /></a>
  
  <p>
   Set the Istio Path
  </p>
</div>

Next, install Istio with the demo profile in your Kubernetes cluster. Istio comes with several profiles which have different configurations for the core components. The demo profile installs all components. You can find more information about the profiles in the <a href="https://istio.io/latest/docs/setup/additional-setup/config-profiles/" target="_blank" rel="noopener noreferrer">Istio docs</a>.

```bash
istioctl install --set profile=demo -y
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-Istio-in-Kubernetes.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-Istio-in-Kubernetes.jpg" alt="Install Istio in Kubernetes" /></a>
  
  <p>
   Install Istio in Kubernetes
  </p>
</div>

The installation should only take a couple of seconds. 

## Install an Istio Demo Application

Istio offers a nice demo application which I will use in this demo. Before you install it, I would recommend creating a new namespace in your K8s cluster. Additionally, set the istio-injection=enabled label on the namespace. This label configures the automatic injection of the Envoy sidecar.

```bash
kubectl create namespace istio-demo
kubectl label namespace istio-demo istio-injection=enabled
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Create-and-tag-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Create-and-tag-the-Namespace.jpg" alt="Create and tag the Namespace" /></a>
  
  <p>
   Create and tag the Namespace
  </p>
</div>

Next, install the sample app in the previously created namespace.

```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml -n istio-demo
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-the-Sample-Application.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-the-Sample-Application.jpg" alt="Install the Sample Application" /></a>
  
  <p>
   Install the Sample Application
  </p>
</div>

After the sample application is installed, make sure that all services are up and running.

```bash
kubectl get services -n istio-demo
```


<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-the-installed-Services.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-the-installed-Services.jpg" alt="Check the installed Services" /></a>
  
  <p>
   Check the installed Services
  </p>
</div>

Also, check that all pods are started and running correctly.

```bash
kubectl get pods -n istio-demo
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-the-installed-Pods.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-the-installed-Pods.jpg" alt="Check the installed Pods" /></a>
  
  <p>
   Check the installed Pods
  </p>
</div>

The demo application is only accessible through the internal network. To make it accessible from the outside, install the Istio in the same namespace.

```bash
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml -n istio-demo
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-the-Gateway.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-the-Gateway.jpg" alt="Install the Gateway" /></a>
  
  <p>
   Install the Gateway
  </p>
</div>

The gateway acts as a load balancer and only provides an external URL. Use the following command to get the application's URL and its ports.


```bash
kubectl get svc istio-ingressgateway -n istio-system
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Get-the-IP-Adresse-of-the-Sample-Application.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Get-the-IP-Adresse-of-the-Sample-Application.jpg" alt="Get the IP Adresse of the Sample Application" /></a>
  
  <p>
   Get the IP Adresse of the Sample Application
  </p>
</div>

Alternatively, use the following commands to read the URL and port and combine them in the GATEWAY_URL variable.

```bash
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
```

#### Test the Sample Application

Enter URL:Port/productpage in your browser and you should see the sample application.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Test-the-Sample-Application.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Test-the-Sample-Application.jpg" alt="Test the Sample Application" /></a>
  
  <p>
   Test the Sample Application
  </p>
</div>

## Install Istio Addons

Istio comes with a wide range of additional software which can be easily installed with the following command.

```bash
kubectl apply -f samples/addons
```

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-Istio-Addons.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-Istio-Addons.jpg" alt="Install Istio Addons" /></a>
  
  <p>
   Install Istio Addons
  </p>
</div>

This installs every available addon. If you only want to install certain products, use their specific YAML files. For example, install only [Prometheus](/monitor-net-microservices-with-prometheus) with the following command.

```bash
kubectl apply -f samples/addons/prometheus.yaml
```

The above code installed many useful tools like Grafana, Jaeger, or Zipkin. I will talk more about these tools in my next post. For now, let's take a look at Kiali which is a pretty cool tool to visualize the flow and useful information of requests in distributed applications. Kiali is already installed. All you have to do is to activate the port forwarding with the following command.

```bash
istioctl dashboard kiali
```

Open your browser, enter localhost:20001 and you should see the Kiali dashboard. On the left side select Graph, then select the istio-demo namespace from the drop-down and you should see the services of the demo application. Execute the following command to produce 100 requests which then will be visualized in the graph.

```bash
for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done
```

Play a bit around with the settings. You can, for example, enable the traffic animation and the response time of the requests. The graph also shows that most of the traffic is routed from the productpage to the details microservice. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Traffic-Flow-with-Kiali.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Traffic-Flow-with-Kiali.jpg" alt="Traffic Flow with Kiali" /></a>
  
  <p>
   Traffic Flow with Kiali
  </p>
</div>

## Analyzing Istio Errors

Istio is very robust but sometimes things go wrong. You can analyze a namespace with the following command.

```bash
istioctl analyze -n istio-demo
```

If you followed this demo and don't add a namespace (-n istio-demo), the analysis process will run in your current namespace (usually the default namespace) and will return an error that Istio is not enabled.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-for-Errors.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-for-Errors.jpg" alt="Check for Errors" /></a>
  
  <p>
   Check for Errors
  </p>
</div>

## Conclusion

Istio is an easy to install service mesh that comes with many useful applications like Grafana, Prometheus, and Jaeger. This demo used the Istio demo application and showed how to visualize your microservice dependencies and the request flow using Kiali.

In my next post, I will show you more features of Istio like fault injection, request routing and traffic shifting between microservices. 

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).