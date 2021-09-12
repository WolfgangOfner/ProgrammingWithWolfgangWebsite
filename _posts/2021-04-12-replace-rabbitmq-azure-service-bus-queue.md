---
title: Replace RabbitMQ with Azure Service Bus Queues
date: 2021-04-12
author: Wolfgang Ofner
categories: [Cloud, DevOps]
tags: [DevOps, CI-CD, Azure DevOps, Azure, Kubernetes, AKS, Helm, Azure Service Bus, RabbitMq]
description: Replace RabbitMQ with Azure Service Bus Queues to take advantage of the managed and scalable queue on Azure.
---

RabbitMQ is a great tool to connect microservices asynchronously but it also comes with a couple of downsides. The biggest downside is that you have to take care of running, monitoring, and updating it. Running a RabbitMQ Docker image in Kubernetes is quite easy but still requires some management. One of the best features of cloud provides are the platform as a service (PaaS) offerings. This means that the cloud provider, for example, Azure runs the platform for you and you don't have to take care of updating or patching the software.

In this post, I will add a new class to my microservice so I can switch between RabbitMQ and Azure Service Bus.

## What is Azure Service Bus

Azure Service Bus is an enterprise messaging PaaS solution with many useful features. Some of these features are:
- Queues
- Topics (one sender, multiple subscribers)
- Transaction
- Duplication filter
- Dead message queues
- Geo-disaster recovery

Since it is a PaaS offering, Azure is managing the infrastructure which means that you as a developer can focus on implementing it and don't have to think about maintenance, upgrading, or monitoring of it. For this demo, I am using the Basic tier which has very limited features but only costs 0.043€ per million operations. In your production environment, you most likely will use the Standard tier.

### Difference between Azure Service Bus and Azure Queue

Both queue solutions are very similar but Azure Service Bus comes with a First-In-First-Out guarantee. Additionally, it has more enterprise features in the Standard and Premium tier. For a more detailed comparison between Azure Service Bus and Azure Queue, see the <a href="https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted" target="_blank" rel="noopener noreferrer">documentation</a>.

## Create a new Azure Service Bus Queue

First, you have to create an Azure Service Bus Namespace. In the Azure Portal, search for Service Bus and click on Create.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-new-Service-Bus-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-new-Service-Bus-Namespace.jpg" alt="Create a new Service Bus Namespace" /></a>
  
  <p>
   Create a new Service Bus Namespace
  </p>
</div>

Select your subscription, resource group, location, and pricing tier, and then provide a unique name. Click on Create and the Service Bus Namespace gets created.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Configure-the-new-Azure-Service-Bus-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Configure-the-new-Azure-Service-Bus-Namespace.jpg" alt="Configure the new Azure Service Bus Namespace" /></a>
  
  <p>
   Configure the new Azure Service Bus Namespace
  </p>
</div>

After the deployment, click on Queue and then add a new Queue. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-new-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-new-Queue.jpg" alt="Create a new Queue" /></a>
  
  <p>
   Create a new Queue
  </p>
</div>

Give the queue a name and leave all settings as they are.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Configure-the-new-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Configure-the-new-Queue.jpg" alt="Configure the new Queue" /></a>
  
  <p>
   Configure the new Queue
  </p>
</div>

### Configure the Access to the Queue using Shared Access Policies (SAS)

After the queue is created, click on it and then select the Shared access policies tab. There click on Add, select the Send checkbox and click on Save.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Create-a-SAS-for-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Create-a-SAS-for-the-Queue.jpg" alt="Create a SAS for the Queue" /></a>
  
  <p>
   Create a SAS for the Queue
  </p>
</div>

We will use this SAS to allow the microservice to send messages to the queue. You can also give the manage permission if you want your microservice to be allowed to create queues but I prefer as few permissions as possible. Additionally, I will show in a future post how to create the infrastructure using an Azure DevOps CI/CD pipeline.

## Send Messages to the Azure Service Bus Queue from a Microservice

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

The Azure Service Bus Queue is created and configured and now we can configure the microservice to send messages to the new queue. First, we add the following settings to the appsettings.json file:

<script src="https://gist.github.com/WolfgangOfner/92945838d4751c6c601c0fd15b2954cf.js"></script>

These settings container the Azure Service Bus queue name, the connection string, and also a switch to use RabbitMQ or Azure Service Bus Queue. I used the in-memory switch already in a previous post, [Use a Database with a Microservice running in Kubernetes](/microservice-with-database-kubernetes). The queue switch will work the same way and either register the RabbitMQ service or the Azure Service Bus Queue service. In the appsettings.Development.json file, add the UserabbitMq attribute and set it to true.

Next, create a new class that will contain the Azure Service Bus options:

<script src="https://gist.github.com/WolfgangOfner/f34227e6753663e041590fcdb8ec497c.js"></script>

In the ConfigureServices method of the Startup.cs class, read the AzureServiceBus section into the previously created AzureServiceBusConfiguration classs:

<script src="https://gist.github.com/WolfgangOfner/7006891626f0dcc9dbcdc82475be87e5.js"></script>

Additionally, read the UserabbitMq variable and either register the already existing RabbitMQ service or th Azure Service Bus service:

<script src="https://gist.github.com/WolfgangOfner/78a0e1fd77f112a88f4b1c7d949aaed7.js"></script>

That is all the configuration needed. Lastly, go to the CustomerApi.Messaging.Send project and install the Azure.Messaging.ServiceBus NuGet package and then create a new class called CustomerUpdateSenderServiceBus. This class inherits from the ICustomerUpdateSender interface and takes a customer and sends it to the Azure Service Bus Queue. The full class looks as follows:

<script src="https://gist.github.com/WolfgangOfner/a1c2f579bd1c4663d5f130cc3f17d52a.js"></script>

This code is very simple but will throw an exception if the queue does not exist. 

## Test the Azure Service Bus integration in the Microservice

Start the microservice and update a Customer using the Swagger UI.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Update-an-existing-customer.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Update-an-existing-customer.jpg" alt="Update an existing customer" /></a>
  
  <p>
   Update an existing customer
  </p>
</div>

After updating the customer, open the Service Bus Queue in the Azure Portal and select the Service Bus Explorer tab. There, you should see one message in the queue.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/One-message-got-sent-to-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/One-message-got-sent-to-the-Queue.jpg" alt="One message got sent to the Queue" /></a>
  
  <p>
   One message got sent to the Queue
  </p>
</div>

Select the Peek option (look at the first message without deleting it) and you should see your previously edited customer.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/The-updated-customer-got-sent-to-the-Queue.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/The-updated-customer-got-sent-to-the-Queue.jpg" alt="The updated customer got sent to the Queue" /></a>
  
  <p>
   The updated customer got sent to the Queue
  </p>
</div>

## Deploy the Microservice to Kubernetes and use the Azure Service Bus 

To use the Azure Service Bus Queue in Kubernetes, you have to tell your microservice the connection string. This works the same way as providing a database connection string which I described in [Use a Database with a Microservice running in Kubernetes](/microservice-with-database-kubernetes).

First, click on Variables and add a new variable inside your Azure DevOps pipeline. Name the variable AzureServiceBusConnectionString and past the connection string from the previously created SAS as the value.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/04/Add-the-Service-Bus-Queue-Connection-String.jpg"><img loading="lazy" src="/assets/img/posts/2021/04/Add-the-Service-Bus-Queue-Connection-String.jpg" alt="Add the Service Bus Queue Connection String" /></a>
  
  <p>
   Add the Service Bus Queue Connection String
  </p>
</div>

After adding the variable, add the following code to the values.release.yaml file.

<script src="https://gist.github.com/WolfgangOfner/e3e9c3c43c06a2480d9a6cd8897cebb5.js"></script>

This code creates a secret in Kubernetes with the value of the previously created variable. This secret will overwrite the appsettings of the microservice and therefore allow it to access the Azure Service Bus Queue and no sensitive information was exposed in the pipeline.

This code is using Helm to create the secret and Tokenizer to replace \_\_AzureServiceBusConnectionString\_\_ with the value of the variable AzureServiceBusConnectionString. For more information on these topics see [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm), [Override Appsettings in Kubernetes](/override-appsettings-in-kubernetes) and [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer)

## Conclusion

Cloud providers, especially Azure, offer a wide range of services. This allows developers to use different PaaS solutions which help them to focus on their implementation, rather than running and maintaining the infrastructure. Azure Service Bus is an enterprise queueing solution and can replace RabbitMQ if you want to take advantage of the PaaS offering instead of running RabbitMQ yourself. I added a switch to the microservice, so you can easily switch between RabbitMQ and Azure Service Bus Queue.

In my next post, I will show you how to replace the background service in the OrderApi with Azure Functions to use a serverless solution to process the messages on the queue.


You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).