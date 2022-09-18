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

This demo assumes that you already have a Kubernetes cluster set up. If not see [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started) to set up a new cluster and also configure the connection to Kubernetes. Usually, I work with Windows but for this demo, I will use the Windows Subsystem for Linux. You can use all commands on Linux or Mac as well.

To get started, download the newest version of Istio.

<script src="https://gist.github.com/WolfgangOfner/0f38e918e4925b9735a5145866cdb280.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Download-the-newest-Version-of-Istio.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Download-the-newest-Version-of-Istio.jpg" alt="Download the newest Version of Istio" /></a>
  
  <p>
   Download the newest Version of Istio
  </p>
</div>

Alternatively, go to <a href="https://github.com/istio/istio/releases" target="_blank" rel="noopener noreferrer">GitHub</a> and download the desired version.

After the download is finished, navigate into the downloaded Istio folder and set the path to the /bin folder as the Path variable.

<script src="https://gist.github.com/WolfgangOfner/833549730e61eaf1bd23de7ee49bae71.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Set-the-Istio-Path.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Set-the-Istio-Path.jpg" alt="Set the Istio Path" /></a>
  
  <p>
   Set the Istio Path
  </p>
</div>

Next, install Istio with the demo profile in your Kubernetes cluster. Istio comes with several profiles which have different configurations for the core components. The demo profile installs all components. You can find more information about the profiles in the <a href="https://istio.io/latest/docs/setup/additional-setup/config-profiles/" target="_blank" rel="noopener noreferrer">Istio docs</a>.

<script src="https://gist.github.com/WolfgangOfner/bc77adb038c4142edafc08845c5a9226.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-Istio-in-Kubernetes.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-Istio-in-Kubernetes.jpg" alt="Install Istio in Kubernetes" /></a>
  
  <p>
   Install Istio in Kubernetes
  </p>
</div>

The installation should only take a couple of seconds. 

## Install an Istio Demo Application

Istio offers a nice demo application which I will use in this demo. Before you install it, I would recommend creating a new namespace in your K8s cluster. Additionally, set the istio-injection=enabled label on the namespace. This label configures the automatic injection of the Envoy sidecar.

<script src="https://gist.github.com/WolfgangOfner/76501b96d6290048638c60f8f176dc14.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Create-and-tag-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Create-and-tag-the-Namespace.jpg" alt="Create and tag the Namespace" /></a>
  
  <p>
   Create and tag the Namespace
  </p>
</div>

Next, install the sample app in the previously created namespace.

<script src="https://gist.github.com/WolfgangOfner/f659e5daee35a1653cc0451f57d749cc.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-the-Sample-Application.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-the-Sample-Application.jpg" alt="Install the Sample Application" /></a>
  
  <p>
   Install the Sample Application
  </p>
</div>

After the sample application is installed, make sure that all services are up and running.

<script src="https://gist.github.com/WolfgangOfner/97e3052c540dc6243a3b77b22fb0ea28.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-the-installed-Services.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-the-installed-Services.jpg" alt="Check the installed Services" /></a>
  
  <p>
   Check the installed Services
  </p>
</div>

Also, check that all pods are started and running correctly.

<script src="https://gist.github.com/WolfgangOfner/38027298f5697f593c1ad158383822bf.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-the-installed-Pods.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-the-installed-Pods.jpg" alt="Check the installed Pods" /></a>
  
  <p>
   Check the installed Pods
  </p>
</div>

The demo application is only accessible through the internal network. To make it accessible from the outside, install the Istio in the same namespace.

<script src="https://gist.github.com/WolfgangOfner/187ae759bb4cf86c09406b8f4001140f.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-the-Gateway.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-the-Gateway.jpg" alt="Install the Gateway" /></a>
  
  <p>
   Install the Gateway
  </p>
</div>

The gateway acts as a load balancer and only provides an external URL. Use the following command to get the application's URL and its ports.


<script src="https://gist.github.com/WolfgangOfner/494821b162503978062afc0a8c7f9a81.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Get-the-IP-Adresse-of-the-Sample-Application.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Get-the-IP-Adresse-of-the-Sample-Application.jpg" alt="Get the IP Adresse of the Sample Application" /></a>
  
  <p>
   Get the IP Adress of the Sample Application
  </p>
</div>

Alternatively, use the following commands to read the URL and port and combine them in the GATEWAY_URL variable.

<script src="https://gist.github.com/WolfgangOfner/800d6a15cecd3fcd2a20e82d2bd4dd10.js"></script>

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

<script src="https://gist.github.com/WolfgangOfner/6587a4e53cfa71983ed1332e1cc615bb.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Install-Istio-Addons.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Install-Istio-Addons.jpg" alt="Install Istio Addons" /></a>
  
  <p>
   Install Istio Addons
  </p>
</div>

This installs every available addon. If you only want to install certain products, use their specific YAML files. For example, install only [Prometheus](/monitor-net-microservices-with-prometheus) with the following command.

<script src="https://gist.github.com/WolfgangOfner/1991090b17843e7c4ce3cacff4f57685.js"></script>

The above code installed many useful tools like Grafana, Jaeger, and Zipkin. [I will talk more about these tools in my next post](/use-istio-to-manage-your-microservices/). For now, let's take a look at Kiali which is a pretty cool tool to visualize the flow and useful information of requests in distributed applications. Kiali is already installed. All you have to do is to activate the port forwarding with the following command.

<script src="https://gist.github.com/WolfgangOfner/82425747b15f00b92565466b2c572a23.js"></script>

Open your browser, enter localhost:20001 and you should see the Kiali dashboard. On the left side select Graph, then select the istio-demo namespace from the drop-down and you should see the services of the demo application. Execute the following command to produce 100 requests which then will be visualized in the graph.

<script src="https://gist.github.com/WolfgangOfner/b06c09dfde69e74d9c999365faf7287b.js"></script>

Play a bit around with the settings. You can, for example, enable the traffic animation and the response time of the requests. The graph also shows that most of the traffic is routed from the productpage to the details microservice. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Traffic-Flow-with-Kiali.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Traffic-Flow-with-Kiali.jpg" alt="Traffic Flow with Kiali" /></a>
  
  <p>
   Traffic Flow with Kiali
  </p>
</div>

## Analyzing Istio Errors

Istio is very robust but sometimes things go wrong. You can analyze a namespace with the following command.

<script src="https://gist.github.com/WolfgangOfner/a08e0f19747d109151c26b82cfa64c30.js"></script>

If you followed this demo and don't add a namespace (-n istio-demo), the analysis process will run in your current namespace (usually the default namespace) and will return an error that Istio is not enabled.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/Check-for-Errors.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/Check-for-Errors.jpg" alt="Check for Errors" /></a>
  
  <p>
   Check for Errors
  </p>
</div>

## Conclusion

Istio is an easy to install service mesh that comes with many useful applications like Grafana, Prometheus, and Jaeger. This demo used the Istio demo application and showed how to visualize your microservice dependencies and the request flow using Kiali.

[In my next post](/use-istio-to-manage-your-microservices), I will show you more features of Istio like fault injection, request routing, and traffic shifting between microservices. 

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).