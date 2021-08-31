---
title: Use Istio to manage your Microservices
date: 2021-08-23
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure, YAML, Docker, Helm, AKS, Kubernetes, Monitoring, Prometheus, Grafana, Istio, Kiali]
description: Istio is a Service Mesh that provides many useful features like Request Routing or Fault Injection which help developers to build more robust applications.
---

[In my last post](/istio-getting-started), I talked about Istio and how it can be installed. I also mentioned some of the features of the service mesh but only in theory. 

This post will show you some features of Istio, how to implement them and how they can help you build better applications

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Installing Istio

If you haven't installed Istio or want more information about it, see my post [Istio in Kubernetes - Getting Started](/istio-getting-started).

## Request Routing

By default, all requests are routed evenly between pods. If you have two different versions of a service running, for example, version 1 and version 2, the request will be routed once to v1 and once to v2. You can observe the request routing using Kiali. For more information about Kiali, see my last post [Istio in Kubernetes - Getting Started](/istio-getting-started).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/The-Traffic-is-routed-evenly.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/The-Traffic-is-routed-evenly.jpg" alt="The Traffic is routed evenly" /></a>
  
  <p>
   The Traffic is routed evenly
  </p>
</div>

As you can see, the requests are routed evenly between the details and the reviews service (red box) and also routed evenly within the reviews service to v1, v2, and v3 (blue box).

Following DevOps principles, we want to deploy often. To deploy as often as possible, developers have to deploy features that are not fully ready yet or need more testing before all users can access the new feature. This is where request routing comes into play. You can configure Istio to route no requests to a specific service, a small percentage, for example, 1% of all requests, or only route the requests of a specific user to the new service.

Especially routing a small percentage of the requests can be very useful. This is called canary deployment. Often companies only allow employees to use a new feature. After they confirmed that everything is working as expected, a small percentage of actual users get to use the feature. If everything is still ok, the percentage gets increased until it reaches 100%. If an error occurs that was not found during testing, only a small percentage of the users is affected, and not all.

### Configure Request Routing

The demo application of Istio is great and you should use it as starting point in your Istio journey. Create virtual services with the following command 

<script src="https://gist.github.com/WolfgangOfner/f7407ccfa0b17430ab3bd38161686d0e.js"></script>

Also, make sure that you created the default traffic rules while installing Istio.

<script src="https://gist.github.com/WolfgangOfner/9d8e1a6b1300e22a9c9b206649bad253.js"></script>

Let's have a look at the defined routes which you just created. 

<script src="https://gist.github.com/WolfgangOfner/9e5fb935538008b11ccb9d6af1321236.js"></script>

These services route traffic always to v1 of the service. For example, if the user calls the reviews service, the request is always routed to v1 of the reviews service. 

Once the routes are created, you can check that everything was applied correctly with the following command

<script src="https://gist.github.com/WolfgangOfner/30de46a9bf096d3816a634f3a4fb4b9a.js"></script>

Create a couple of requests using your browser or the following loop "for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done" and then go back to the Kiali graph dashboard. There you can see that the requests are only routed to v1 of the reviews service.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/The-Traffic-is-routed-evenly.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/The-Traffic-is-routed-evenly.jpg" alt="The Traffic is routed evenly" /></a>
  
  <p>
   The Traffic is routed evenly
  </p>
</div>

Routing is also possible based on the user identity. This can be useful if a tester wants to access the new service. 

You can delete the created routing rules with the following command:

<script src="https://gist.github.com/WolfgangOfner/a15fa9a8e64b1e9994b704306834e75b.js"></script>

## Fault Injection

Fault injection is another cool feature of Istio which helps you to build more robust applications. Probably every developer has seen applications that work fine in testing but once under production load, problems start to surface. These problems can be hard to analyze or reproduce, especially in a microservice architecture. 

Istio's fault injection allows you to intercept requests and return an HTTP error or delay requests to provoke a timeout. 

### Inject HTTP 500 Errors

In the following example, I want to test how the application works when the review service is not available. The user should see a good error message and nothing cryptic. Additionally, I want to test this in my production environment and no user should be affected by it. Therefore, I configure the injection of the HTTP 500 error to only affect a user called Jason.

<script src="https://gist.github.com/WolfgangOfner/aef775613ecbc7397554900206aebc1f.js"></script>

Let's have a look at the created virtual service.

<script src="https://gist.github.com/WolfgangOfner/af582f971748d3a442bb847df255178e.js"></script>

This virtual service applies the rule when the ratings service is called and the user matches jason. Then it injects a fault with a probability of 100% (always) and returns the HTTP code 500. You could change the 100 to 10 and test how the application behaves with "random" interrupts.

Open the demo application and log in as jason without a password. You will see that the rating service is not available and the user gets a clear error message which does not interrupt the user experience.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/The-Rating-Service-is-not-available-as-Jason.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/The-Rating-Service-is-not-available-as-Jason.jpg" alt="The Rating Service is not available as Jason" /></a>
  
  <p>
   The Rating Service is not available as Jason
  </p>
</div>

Log out and you will see that the rating service works as expected.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/08/The-Rating-Service-works-if-the-user-is-not-Jason.jpg"><img loading="lazy" src="/assets/img/posts/2021/08/The-Rating-Service-works-if-the-user-is-not-Jason.jpg" alt="The Rating Service works if the user is not Jason" /></a>
  
  <p>
   The Rating Service works if the user is not Jason
  </p>
</div>

When you are done with your testing, delete the virtual service with the following command:

<script src="https://gist.github.com/WolfgangOfner/43df89b8b3168cac8ddb08e4df468f4b.js"></script>

## Conclusion

Istio brings some cool features like fault injection and request routing which help developers to build more robust and resilient applications which will lead to a better user experience. The sample code provides a great starting point with many examples and will help you to get started.

[In my next post](/add-Istio-to-existing-microservice-in-kubernetes), I will show you how easy it is to add Istio to an existing application.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).