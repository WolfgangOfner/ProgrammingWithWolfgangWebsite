---
title: Override Appsettings in Kubernetes
date: 2020-12-11
author: Wolfgang Ofner
categories: [Kubernetes, Docker]
tags: [Helm, AKS, Microservice, Kubernetes]
---

Changing configs was difficult in the past. In .NET we had to do a web.config transformation and we also had to have a web.config file for each environment. It was ok since there were usually only a couple of environments. This got improved a lot with .NET Core and its appsettings.json file which could override files depending on the environment. 

Nowadays, especially with microservices, we have many different environments and often create them dynamically though. It is quite common to create a new Kubernetes namespace and deploy a pull request there, including its own database. We can't have unlimited config files though. Especially when everything is so dynamic. This is where another neat .Net Core (now .NET 5) feature comes in. It is possible to override.

[In my last posts](/deploy-kubernetes-using-helm), I talked about Helm and showed how it can be used to easily deploy applications to Kubernetes. Today, I will show you you can dynamically configure your application using environment variables in Helm.

## Deploy a Microservice using Helm
You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>. If you don't know what Helm is or if you haven't installed it yet, see [Helm - Getting Started](/helm-getting-started) for more information.

Open the demo application and navigate to the Helm chart of the OrderApi. You can find it under OrderApi/OrderApi/charts. The chart is a folder called orderapi. Deploy this chart with Helm:

```powershell
helm install order orderapi
```

The package gets deployed within seconds. After it is finished, connect to the dashboard of your cluster. If you don't know how to do that, see my post ["Azure Kubernetes Service - Getting Started"](/azure-kubernetes-service-getting-started). There I explain how I use Octant and how to access your Kubernetes cluster with it.

In the dashboard, open the orderapi pod and you will see that there is an error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/RabbitMq-causes-an-Exception.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/RabbitMq-causes-an-Exception.jpg" alt="RabbitMq causes an Exception" /></a>
  
  <p>
   RabbitMq causes an Exception
  </p>
</div>

The application wants to open a connection to RabbitMq. Currently, there is no RabbitMq running in my Kubernetes cluster. Therefore, the exception occurs. 

## Override Appsettings with Environment Variables
The settings for RabbitMq are in the appsettings.json file. There is also a flag to enable and disable the connection. By default, this flag is enabled.

```yaml
{
  "RabbitMq": {
    "Hostname": "rabbitmq",
    "QueueName": "CustomerQueue",
    "UserName": "user",
    "Password": "password",
    "Enabled": true
  }
}
```
Currently, I don't want to use RabbitMq, therefore I want to disable it. Microsoft introduced the DefaultBuilder method which automatically reads environment variables, command-line arguments, and all variations of the appsettings.json files. This allows developers to use environment variables to override settings without changing the code.

I am reading the RabbitMq configs in the Startup.cs class and then register the service depending on the value of the enabled flag:

```csharp
var serviceClientSettingsConfig = Configuration.GetSection("RabbitMq");
var serviceClientSettings = serviceClientSettingsConfig.Get<RabbitMqConfiguration>();
services.Configure<RabbitMqConfiguration>(serviceClientSettingsConfig);

if (serviceClientSettings.Enabled)
{
    services.AddHostedService<CustomerFullNameUpdateReceiver>();
}
```
The enabled flag is in the RabbitMq section of the appsettings.json file. To override it with an environment variable, I have to pass one with the same structure. Instead of braces, I use double underscores (__). This means that the name of the environment variable is rabbitmq__enabled and its value is false.

### Pass the Environment Variable using Helm
Helm allows us to add environment variables easily. Add in the values.yaml file the following code:

```yaml
envvariables:
  rabbitmq__enabled: false
```
This passes the value as an environment variable into the deployment.ymal file. 

{% raw %}
```yaml
env:
  {{- $root := . }}
  {{- range $key, $value := .Values.envvariables }}
  - name: {{ $key }}
    value: {{ $value | quote }}
  {{- end }}
  {{- $root := . }}
  {{- range $ref, $values := .Values.secrets }}
  {{- range $key, $value := $values }}
  - name: {{ $key }}
    valueFrom:
      secretKeyRef:
        name: {{ template "orderapi.fullname" $root }}-{{ $ref | lower }}
        key: {{ $key }}
  {{- end }}
  {{- end }}
```
{% endraw %}

This code iterates over the envvariables and secrets section and sets the values as environment variables. This section looks different by default but I find this way of passing variables better.

### Update the Microservice
Use Helm upgrade to update the deployment with the changes in your Helm package:

```powershell
helm upgrade order orderapi
```

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
.Net Core and .NET 5 are great to override setting values with environment variables. This allows you to dynamically change the configuration during the deployment of your application. Today, I showed how to use Helm to add an environment variable to override a value of the appsettings.json file.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).