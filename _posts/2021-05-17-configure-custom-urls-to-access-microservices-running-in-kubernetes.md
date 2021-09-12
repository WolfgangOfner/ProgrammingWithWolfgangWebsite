---
title: Configure custom URLs to access Microservices running in Kubernetes
date: 2021-05-17
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes]
description: Setting up custom URLs is fast and gives your users or testers a better experience than using an IP address.
---

[In my last post](/setup-nginx-ingress-controller-kubernetes), I created an Nginx Ingress controller and added rules to route to my two microservices. This solution worked but it was far from optimal. First, I had to add routing rules for my microservices, and even worse using an IP address is very ugly in intuitive for the users.

Today, I will add URLs to my microservices to make them easily accessible for my users.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Add a DNS Entry for your Domain

Before you can use your own URL, you have to create an Azure DNS zone. In the Azure portal, search for DNS zone and click create. Provide a subscription, resource group, and the name of your domain.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/Add-a-new-DNS-zone.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/Add-a-new-DNS-zone.jpg" alt="Add a new DNS zone" /></a>
  
  <p>
   Add a new DNS zone
  </p>
</div>

After the DNS zone is created, click on + Record set and add a new A record pointing to the URL of your Nginx controller. If you don't have a public IP yet, see [Set up Nginx as Ingress Controller in Kubernetes](/setup-nginx-ingress-controller-kubernetes) to configure one. Since I have two microservices, I added two subdomains, customer.programmingwithwolfgang and order.programmingwithwolfgang.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/Add-A-records-for-your-subdomains-pointing-to-your-Kubernetes-cluster.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/Add-A-records-for-your-subdomains-pointing-to-your-Kubernetes-cluster.jpg" alt="Add A records for your subdomains pointing to your Kubernetes cluster" /></a>
  
  <p>
   Add A records for your subdomains pointing to your Kubernetes cluster
  </p>
</div>

Note: I had a different public IP address in my post [Set up Nginx as Ingress Controller in Kubernetes](/setup-nginx-ingress-controller-kubernetes). If you are following the series, make sure to add the IP address of your Nginx controller.

If you are hosting your domain outside of Azure, add the Azure DNS zone namespaces to your domain provider. In my provider, I have the following GUI to configure the nameservers:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/Add-the-Azure-DNS-server.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/Add-the-Azure-DNS-server.jpg" alt="Add the Azure DNS server" /></a>
  
  <p>
   Add the Azure DNS server
  </p>
</div>

It might take a bit until the DNS servers are updated. You can check the DNS entries with nslookup:

<script src="https://gist.github.com/WolfgangOfner/77f7f3e2ab19aa97cf26924a37a6a5e3.js"></script>

Once the DNS entries are updated, open your URL in your browser and you should see the Nginx 404 page.

## Route Traffic according to the URL

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

The DNS settings are configured and now you want to tell Nginx to route customer.programmingwithwolfgang to the customer microservices and order.programmingwithwolfgang to the order microservice. This can be done easily with a change in the ingress configuration. The ingress controller is defined using Helm. If you don't know Helm, see [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm). 

All you have to do is to add the - host: parameter above the http section and provide your URL:

<script src="https://gist.github.com/WolfgangOfner/aa6ea19ec86b0aa738329c3373cfff35.js"></script>

After adding the host line in the ingress.yaml file, add your URL to the values.yaml or values.release.yaml file. Additionally, change the path from /customerapi-test/?(.*) to /. Since the microservices are using different URLs, you don't need different paths anymore. The values.release.yaml file should now look as follows:

<script src="https://gist.github.com/WolfgangOfner/f0f67999b590a327d3e615505cb53794.js"></script>

The URL is defined as a variable in the CI/CD pipeline and will be added by the tokenizer. For more information about the tokenizer, see [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

```yaml
URL: customer.programmingwithwolfgang.com # replace with your service URL
IngressEnabled: true
```

[In my last post](/setup-nginx-ingress-controller-kubernetes), I had a small workaround in the Startup.cs class to get Swagger working. This workaround is not needed anymore due to the usage of the URL and therefore can be removed:

<script src="https://gist.github.com/WolfgangOfner/68f71a6bd286cdff9c4ac1e2cb9e82c1.js"></script>

That's it. Deploy both microservices and let's test them.

## Testing Microservices using custom URLs

After the deployment is finished, navigate to customer.programmingwithwolfgang (obviously you have to use your own URL) and you should see the Swagger UI. The UI wasn't working when using the IP instead of the URL but this problem is now fixed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-Swagger-UI-of-the-Customer-Microservice-with-the-custom-URL.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-Swagger-UI-of-the-Customer-Microservice-with-the-custom-URL.jpg" alt="The Swagger UI of the Customer Microservice with the custom URL" /></a>
  
  <p>
   The Swagger UI of the Customer Microservice with the custom URL
  </p>
</div>

The order microservice is working as well with its custom URL.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-Swagger-UI-of-the-Order-Microservice-with-the-custom-URL.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-Swagger-UI-of-the-Order-Microservice-with-the-custom-URL.jpg" alt="The Swagger UI of the Order Microservice with the custom URL" /></a>
  
  <p>
   The Swagger UI of the Order Microservice with the custom URL
  </p>
</div>

## Conclusion

Using custom URLs or subdomains is surprisingly easy with Nginx and Kubernetes. Setting up the URLs is fast and gives your users or testers a better experience than the IP address I used before. Additionally, the Swagger UI problems were also fixed. Using a custom URL is a better solution than using an IP address but it is still not optimal. [In my next post](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes), I will automatically create certificates enabling the use of HTTPS and also will implement SSL termination in the Nginx ingress controller.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).