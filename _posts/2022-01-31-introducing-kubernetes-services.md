---
title: Introducing Kubernetes Services
date: 2022-01-31
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Kubernetes]
description: Kubernetes Services provide a permanent endpoint for applications by routing requests to the associated pods of the application.
---

Pods can be deleted and recreated at any time, making them a so-called nonpermanent resource in Kubernetes. Therefore, the IP address of a pod will likely change regularly. This behavior will cause problems when you have a resource, for example, a DNS record, pointing to your application. It will be impossible to route to the application since the IP address of the pods will always change.

This is why Kubernetes introduced the Service resource.

## Kubernetes Service Resource

A Service provides a permanent endpoint for your application. This means that its IP address never changes. Therefore, you can point a DNS record or another application to the Service. The Service then redirects the traffic to a pod of the associated application. The Service can access the pods because it uses selectors and not an IP address. 

Let's have a look at a simple Service definition:

<script src="https://gist.github.com/WolfgangOfner/7dc774a6040d54a7fa2d0ed3b8685617.js"></script>

This service publishes port 80 and redirects the request to port 8080 of a pod with the label "app=my-application" The targetPort property is optional. The Service redirects the request to the same value as port if targetPort is not set.

Services can expose multiple ports, for example, one for HTTP and one for HTTPS. When using more than one port, you have to provide a name for each port, as shown in the following example:

<script src="https://gist.github.com/WolfgangOfner/41548a571c50edef9123ee290f9501f1.js"></script>

## Service Types

Currently, there are four service types in Kubernetes:

- ClusterIP
- LoadBalancer
- NodePort
- ExternalName

### ClusterIP

ClusterIP is the default type of a Kubernetes service. This type exposes the service on a Kubernetes internal IP Address and port. This means that only applications inside the Kubernetes cluster can access this service.

### LoadBalancer

This type exposes the service externally using a cloud provider's load balancer. For example, if you use the LoadBalancer Service in an Azure Kubernetes Service cluster, Azure will create a load balancer in Azure and route the requests to a NodePort and ClusterIP Service. These services are created automatically.

### NodePort

NodePort is a service type that I have only used in on-premises clusters. This service type exposes the service to the outside and also creates a ClusterIP Service for internal requests. The default range of available ports for NodePort is 30000-32767. This property can be configured by using the --service-node-port-range flag.

### ExternalName

This type maps the service to external fields like (foo.bar.com) and returns a CNAME record. I have never used this service, therefore I can't talk much about it. All I know is that you need at least kube-dns version 1.7 or CoreDNS 0.0.8 or higher to use the type ExternalName.

## Conclusion

This post gave a very simple introduction to Kubernetes Services and the four available types. For more details about Services, see the <a href="https://kubernetes.io/docs/concepts/services-networking/service" target="_blank" rel="noopener noreferrer">official Kubernetes documentation</a>.

If you want to get started with Kubernetes, I would recommend you to use a managed service like <a href="https://azure.microsoft.com/en-us/services/kubernetes-service/#overview" target="_blank" rel="noopener noreferrer">Azure Kubernetes Service (AKS)</a>.