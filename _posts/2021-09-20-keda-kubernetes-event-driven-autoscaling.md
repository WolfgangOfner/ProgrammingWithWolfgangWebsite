---
title: KEDA - Kubernetes Event-driven Autoscaling
date: 2021-09-20
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Kiali, KEDA]
description: Creating unit tests for a .NET 5 console application that uses dependency injection only takes a couple of lines of code to configure the service provider.
---

Autoscaling is one of my favorite features of Kubernetes. So far we have discussed the Horizontal Pod Autoscaler (HPA) which can scale pods based on CPU or RAM usage. This is a nice start but especially in distributed applications, you often have several components outside of your pods. This can be an Azure Blob Storage, Azure Service Bus, MongoDB, or Redis Stream. The HPA can not scale your pods based on metrics from these components. That's where KEDA comes into play.

KEDA, Kubernetes event-driven autoscaling allows you to easily integrate a scaler into your Kubernetes cluster to monitor an external source and scale your pods accordingly. 

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## What is KEDA

KEDA is a Kubernetes event-driven autoscaler that allows you to scale your applications according to events that occur inside or outside of your Kubernetes cluster. It is very easy to install KEDA using a Helm chart and it also runs on any platform no matter what vendor or cloud provider you use. The community and the KEDA maintainers have created more than 45 built-in scalers that allow scaling on events from sources like Azure Service Bus, Azure Storage Account, Redis Streams, Apache Kafka, or PostgreSQL. Additionally, it provides out-of-the-box integration with environment variables, K8s secrets, and pod identity.

Another neat feature is that KEDA can scale deployments or jobs to 0. Scaling to zero allows you to only spin up containers when certain events occur, for example, when messages are placed in a queue. This is the same behavior as serverless solutions like Azure Functions but this feature allows you to run Azure Functions outside of Azure.

KEDA is a CNCF Sandbox project and you can find more information about the project on <a href="https://github.com/kedacore/keda" target="_blank" rel="noopener noreferrer">GitHub</a> or <a href="https://keda.sh/" target="_blank" rel="noopener noreferrer">Keda.sh</a>.

## Deploy KEDA to your Kubernetes Cluster

KEDA can be easily installed using Helm charts. If you want to learn more about Helm see [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm).

First, add the KEDA Helm repo and update it.

<script src="https://gist.github.com/WolfgangOfner/e249da1e0193e030b31085cf258618c9.js"></script>

Next, create a new namespace called keda and install Keda there. You must install the Helm chart in the keda namespace, otherwise, KEDA will not work.

<script src="https://gist.github.com/WolfgangOfner/4f0329f240a15e854421e8d3d8a8eb36.js"></script>

That's already it. You have successfully installed KEDA in your Kubernetes cluster.

## Configure KEDA to scale based on an Azure Service Bus Queue

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

After KEDA is installed, it is time to create your first scaler. The scaler is a custom resource in Kubernetes and is of the kind ScaledObject. This scaled object references a deployment or job that should be scaled, a trigger, in our example an Azure Service Bus, a reference to a Kubernetes secret that contains the connection string to the queue, and some configuration properties about the scaling itself.

<script src="https://gist.github.com/WolfgangOfner/58156b7f48abe1de02bb2cd0100955c8.js"></script>

This scaled object defines that it should run a minimum of 0 replicas and a maximum of 10 of the kedademoapi. The cooldown period between scale events is 30 seconds and the queue it monitors has the name KedaDemo. When the queue has more than 5 messages, the scale-up event is triggered. I find this parameter a bit unintuitive but it is what it is.

The second custom resource you have to define is a TriggerAuthentication. This object contains a reference to a Kubernetes secret that contains the connection string to the Azure Service Bus Queue. The SAS (Shared Access Signature) of the connection string has to be of type Manage. You can learn more about Azure Service Bus and SAS in [Replace RabbitMQ with Azure Service Bus Queues](/replace-rabbitmq-azure-service-bus-queue).

<script src="https://gist.github.com/WolfgangOfner/9c04ab3314b553fe4567048ed3689aa9.js"></script>

You can display the secrets of the namespace kedademoapi-test with the following command:

<script src="https://gist.github.com/WolfgangOfner/c8c6bd1f9ffa0b59ec7f80807916e162.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Get-Secrets-of-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Get-Secrets-of-the-Namespace.jpg" alt="Get Secrets of the Namespace" /></a>
  
  <p>
   Get Secrets of the Namespace
  </p>
</div>

You can also find the secret in the dashboard. See [Azure Kubernetes Service - Getting Started](/azure-kubernetes-service-getting-started/#access-the-aks-cluster) for more information about Octant and how to access your Kubernetes cluster.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Secret-in-the-Dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Secret-in-the-Dashboard.jpg" alt="The Secret in the Dashboard" /></a>
  
  <p>
   The Secret in the Dashboard
  </p>
</div>

If you take a look at the screenshot above, you will see that the name and key of the TriggerAuthentication object correspond with the values in the dashboard. 

Place the ScaledObject and the TriggerAuthentication in a .yaml file and deploy it to the namespace where the application you want to deploy is running. Deploy it with the following command:

<script src="https://gist.github.com/WolfgangOfner/d7986e6b485b2316d9d0c41d77a464c5.js"></script>

You could also place both objects in separate files and execute the command for each file.

## Testing the Keda Service Bus Scaler

If you are using my KedaDemoApi, you can execute the Post method to write random messages into the queue. If you want to learn more about how to deploy applications into Kubernetes and how to set the connection string, see my ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Write-Messages-into-the-Qeueue.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Write-Messages-into-the-Qeueue.jpg" alt="Write Messages into the Qeueue" /></a>
  
  <p>
   Write Messages into the Queue
  </p>
</div>

Open the Azure Service Bus Queue and you will see the messages there. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Messages-in-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Messages-in-the-Queue.jpg" alt="The Messages in the Queue" /></a>
  
  <p>
   The Messages in the Queue
  </p>
</div>

This should automatically trigger the scale-out event and start more pods with your application. You can check the running pods with the following command:

<script src="https://gist.github.com/WolfgangOfner/4235da879fa1736d07aa2092b6a0f801.js"></script>

As you can see, five pods are now running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Application-was-scaled-out.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Application-was-scaled-out.jpg" alt="The Application was scaled out" /></a>
  
  <p>
   The Application was scaled out
  </p>
</div>

### Testing Scale to 0

You can use the Get method of the KedaDemoApi to receive all messages on the queue. The method will return the number of received messages.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Receive-all-Messages-from-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Receive-all-Messages-from-the-Queue.jpg" alt="Receive all Messages from the Queue" /></a>
  
  <p>
   Receive all Messages from the Queue
  </p>
</div>

When you check the Azure Service Bus Queue, you will see that there are no messages left.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/No-Messages-are-left-in-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/No-Messages-are-left-in-the-Queue.jpg" alt="No Messages are left in the Queue" /></a>
  
  <p>
   No Messages are left in the Queue
  </p>
</div>

Since there are no messages left in the Queue, the KEDA scaler should scale the application to 0. Execute the get pods command again and you should see that no pods are running anymore.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Application-was-scaled-to-0.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Application-was-scaled-to-0.jpg" alt="The Application was scaled to 0" /></a>
  
  <p>
   The Application was scaled to 0
  </p>
</div>

## Conclusion

KEDA is a great tool to scale your workloads in Kubernetes. It allows you to choose from a wide variety of scalers and even lets you connect to external resources like Azure Monitor or a database like PostgreSQL. Especially the scale to 0 feature allows you to remove the allocated resources to a minimum and helps you to save money operating your Kubernetes cluster.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).