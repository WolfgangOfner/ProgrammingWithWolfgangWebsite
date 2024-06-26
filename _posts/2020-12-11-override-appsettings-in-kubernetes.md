---
title: Override Appsettings in Kubernetes
date: 2020-12-11
author: Wolfgang Ofner
categories: [Kubernetes, Docker]
tags: [Helm, AKS, Microservice, Kubernetes]
description: Nowadays, especially with microservices, we have many different environments and often create them dynamically though. Today, I will show you you can dynamically override appsettings using Helm.
---

Changing configs was difficult in the past. In the .NET framework, we had to do a web.config transformation and we also had to have a web.config file for each environment. It was ok since there were usually only a couple of environments. This got improved a lot with .NET Core and its appsettings.json file which could override files depending on the environment. 

Nowadays, especially with microservices, we have many different environments and often create them dynamically. It is quite common to create a new Kubernetes namespace and deploy a pull request there, including its own database. We can't have unlimited config files though. Especially when everything is so dynamic. This is where another neat .NET Core (now just .NET) feature comes in. It is possible to override values in the appsettings.json file using environment variables or even to replace these values using Tokenizer.

[In my last posts](/deploy-kubernetes-using-helm), I talked about Helm and showed how it can be used to easily deploy applications to Kubernetes. Today, I will show you you can dynamically configure your application using environment variables in Helm.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Deploy a Microservice using Helm
You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>. If you don't know what Helm is or if you haven't installed it yet, see [Helm - Getting Started](/helm-getting-started) for more information.

Open the demo application and navigate to the Helm chart of the OrderApi. You can find it under OrderApi/OrderApi/charts. The chart is in a folder called orderapi. Deploy this chart with Helm:

<script src="https://gist.github.com/WolfgangOfner/70f9102d45721e96b59298e38f9ba860.js"></script>

The package gets deployed within seconds. After it is finished, connect to the dashboard of your cluster. If you don't know how to do that, see my post ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started). There I explain how I use Octant and how to access your Kubernetes cluster with it.

In the dashboard, open the orderapi pod and you will see that there is an error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/RabbitMq-causes-an-Exception.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/RabbitMq-causes-an-Exception.jpg" alt="RabbitMQ causes an Exception" /></a>
  
  <p>
   RabbitMQ causes an Exception
  </p>
</div>

The application wants to open a connection to RabbitMQ. Currently, there is no RabbitMQ running in my Kubernetes cluster. Therefore, the exception occurs. 

## Override Appsettings with Environment Variables
The settings for RabbitMQ are in the appsettings.json file. There is also a flag to enable and disable the connection. By default, this flag is enabled.

<script src="https://gist.github.com/WolfgangOfner/4eb27dfc961f6f495e231cc73672d6ef.js"></script>

Currently, I don't want to use RabbitMQ, therefore I want to disable it. Microsoft introduced the DefaultBuilder method which automatically reads environment variables, command-line arguments, and all variations of the appsettings.json files. This allows developers to use environment variables to override settings without changing the code.

I am reading the RabbitMQ configs in the Startup.cs class and then register the service depending on the value of the enabled flag:

<script src="https://gist.github.com/WolfgangOfner/57c8634c35d3c44969c601b7dbff6edf.js"></script>

The enabled flag is in the RabbitMQ section of the appsettings.json file. To override it with an environment variable, I have to pass one with the same structure. Instead of braces, I use double underscores (__). This means that the name of the environment variable is rabbitmq__enabled and its value is false.

### Pass the Environment Variable using Helm
Helm allows us to add environment variables easily. Add in the values.yaml file the following code:

<script src="https://gist.github.com/WolfgangOfner/ea099ab9a29e58dbc6c8e96673a3d610.js"></script>

This passes the value as an environment variable into the deployment.yaml file. 

<script src="https://gist.github.com/WolfgangOfner/ae024adfa8325edd239ea0dd5f49d042.js"></script>

This code iterates over the envvariables and secrets section and sets the values as environment variables. This section looks different by default but I find this way of passing variables better.

### Update the Microservice
Use Helm upgrade to update the deployment with the changes in your Helm package:

<script src="https://gist.github.com/WolfgangOfner/4c879caa731f4165a9bd41e30859333e.js"></script>

After the changes are applied, open the dashboard and navigate to the orderapi pod.

## Testing the overridden Values
You will see that the pod is running now. The environment variable is also displayed in the dashboard. If your application is not working as expected, check there first if all environment variables are present. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-pod-starts-and-the-environment-variable-is-shown.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-pod-starts-and-the-environment-variable-is-shown.jpg" alt="The pod starts and the environment variable is shown" /></a>
  
  <p>
   The pod starts and the environment variable is shown
  </p>
</div>

To test the application, click either on "Start Port Forwarding" which will give you a localhost URL or you can open the Service and see the external IP of your service there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Check-the-external-IP-of-your-service.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Check-the-external-IP-of-your-service.jpg" alt="Check the external IP of your service" /></a>
  
  <p>
   Check the external IP of your service
  </p>
</div>

Open your browser and navigate either to the shown localhost URL or to the external URL of your Service. There you will see the Swagger UI of the OrderApi microservice.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-Swagger-UI-of-the-microservice.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-Swagger-UI-of-the-microservice.jpg" alt="The Swagger UI of the microservice" /></a>
  
  <p>
   The Swagger UI of the microservice
  </p>
</div>

## Conclusion

.NET Core and .NET are great frameworks to override setting values with environment variables. This allows you to dynamically change the configuration during the deployment of your application. Today, I showed how to use Helm to add an environment variable to override a value of the appsettings.json file.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).