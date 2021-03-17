---
title: Helm - Getting Started
date: 2020-12-07
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Helm, AKS, Microservice, Kubernetes]
---

Helm is a package manager for Kubernetes which helps developers to quickly deploy their application. In my last post, [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started), I showed how to deploy an application to AKS using the dashboard.
In this post, I will talk about the basics of Helm and show how to add it to your application.

## What is Helm?
Deploying microservices to Kubernetes, especially if they have dependencies, can be quite complex. This is where Helm comes in. Helm is a package manager for Kubernetes that allows you to create packages and helm takes care of installing and updating these packages. 
Helm packages are called charts. These charts describe everything your application needs and helm takes care to create or update your application, depending on the provided chart. Helm also serves as a template engine which makes it very easy to configure your charts either locally or during your CI/CD pipeline. 

Let's add a Helm chart to our microservice and I will explain every component of the chart. You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

## Add Helm Charts to a Microservice
Visual Studio comes with great Helm support. Right-click on your API project and select Add --> Container Orchestrator Support.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Add-Container-Orchestration-Support.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Add-Container-Orchestration-Support.jpg" alt="Add Container Orchestration Support" /></a>
  
  <p>
    Add Container Orchestration Support
  </p>
</div>

This opens a new window where you can select Helm or Docker-compose. Select Kubernetes/Helm and click OK.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Add-Helm.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Add-Helm.jpg" alt="Add Helm" /></a>
  
  <p>
    Add Helm
  </p>
</div>

If you don't have Kubernetes/Helm as an option, make sure that you have the Visual Studio Tools for Kubernetes installed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Add-the-Visual-Studio-Tools-for-Kubernetes.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Add-the-Visual-Studio-Tools-for-Kubernetes.jpg" alt="Add the Visual Studio Tools for Kubernetes" /></a>
  
  <p>
    Add the Visual Studio Tools for Kubernetes
  </p>
</div>

Visual Studio creates a new folder called charts and places a folder inside this charts folder with the name of your project. It's important to only use lowercase because Kubernetes can process only lowercase names.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-Helm-charts-got-added.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-Helm-charts-got-added.jpg" alt="The Helm charts got added" /></a>
  
  <p>
    The Helm charts got added
  </p>
</div>

### Helm Chart Templates
Helm created another subfolder, called templates, and places a couple of files into it. If you ignore the _helpers and Notes files, the remaining file names should sound familiar if you think about Kubernetes objects. The charts folder contains templates for the Service, Deployment, Ingress, and Secrets. These four objects are needed to run your application in Kubernetes. At a first glance, these files look super complicated and confusing but they are quite simple. You have to know the yaml definition of the Kubernetes objects though. The templates are basically the same, except that the values are added dynamically. 

Let's have a look at the service.yaml file:

{% raw %}
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ template "customerapi.fullname" . }}
  labels:
    app: {{ template "customerapi.name" . }}
    chart: {{ template "customerapi.chart" . }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: {{ template "customerapi.name" . }}
    release: {{ .Release.Name }}
```
{% endraw %}

This file defines a service, adds labels, and then configures its ports and protocol. Helm replaces all values inside the two braces. What's important to notice is that some start with .Values.*. These values come from the values.yaml file which is outside of the templates folder.

### Override Values

In the previous section, I showed the service.yaml file. This file reads two values from the values.yaml file: .Values.service.type and .Values.service.port. You can find the respective files in the values.yaml file in the service section:

```yaml
fullnameOverride: customerapi
replicaCount: 1
image:
  repository: customerapi
  tag: stable
  pullPolicy: IfNotPresent
imagePullSecrets: []
service:
  type: ClusterIP
  port: 80
```

Take a look at the values.yaml file and you will see that the type of the service is ClusterIP and its port is 80. This approach enables you to configure your application with changes in only one file. The same principle applies to all files inside the templates folder. 

The fullnameOverride parameter is used to replace the variable customerapi.fullname which serves, for example, as name of the deployment and service.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Usage-of-the-fullnameOverride-variable.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Usage-of-the-fullnameOverride-variable.jpg" alt="Usage of the fullnameOverride variable" /></a>
  
  <p>
    Usage of the fullnameOverride variable
  </p>
</div>

## Conclusion
In this post, I gave a very short introduction to Helm. Helm is a package manager for Kubernetes and helps you to deploy your application including all its dependencies to Kubernetes. Helm also serves as a template engine which makes it very easy to change values.
 
In my next post, I will show who to deploy our microservice to Kubernetes using Helm. You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).