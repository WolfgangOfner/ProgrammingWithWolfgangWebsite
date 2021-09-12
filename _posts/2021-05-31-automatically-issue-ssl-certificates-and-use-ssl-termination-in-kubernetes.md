---
title: Automatically issue SSL Certificates and use SSL Termination in Kubernetes 
date: 2021-05-31
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, TLS, SSL]
description: Users expect HTTPS connection. Cert-manager can be used to automatically issue SSL certificates to your applications running in Kubernetes.
---

[In my last post](/configure-custom-urls-to-access-microservices-running-in-kubernetes), I created an Nginx ingress controller and assigned different URLs to its public URL. The Nginx controller analyses the URL and routes the traffic automatically to the right application. The solution presented worked but only used HTTP. Nowadays, browsers show a warning when not using HTTPS and users also expect to have secure connections.

This post will show you how to configure a cert-manager and automatically issue certificates for your applications.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Install Cert-Manager

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

Cert-Manager is a Kubernetes add-on that issues automatically TLS certificates for your applications. You can find it on <a href="https://github.com/jetstack/cert-manager" target="_blank" rel="noopener noreferrer">Github</a>. To install the cert-manager using Helm charts, execute the following commands:

<script src="https://gist.github.com/WolfgangOfner/a4c2a59165adf2ffc1cfe2766a9f4009.js"></script>

I use the ingress-basic namespace also for Nginx. If you want, use a different one for the cert-manager.

## Install a Let's Encrypt Certificate Issuer

After installing the cert-manager, install a certificate issuer to generate the tls certificates for your applications.

<script src="https://gist.github.com/WolfgangOfner/c552cc5d37f16daaa24be03541553259.js"></script>

Save the code in a file and then apply the file to your Kubernetes cluster, 

<script src="https://gist.github.com/WolfgangOfner/f9d9011582570bca27f1329d79d71852.js"></script>

This example uses Let's Encrypt as issuer but you can use any CA issuer you want. Before you deploy the code, add your email so you can get emails about the certificates. At the beginning of the code, you can see the kind of object is ClusterIssuer. A ClusterIssuer can create certificates for all applications, no matter in what namespace they are. The second option is Issuer which works only in a single namespace. An issuer might be useful if you want to use a different CA issuer.

## Update the Microservices to use the TLS Certificate

There is not much to update in the configuration of the microservice to use the TLS secret. All you have to do is add the TLS secret and the host before the rules section in the ingress.yaml file of each microservice. The ingress.yaml file is part of the Helm chart. If you don't know Helm, see my posts [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm).

The ingress.yaml file looks as follows:

<script src="https://gist.github.com/WolfgangOfner/f194f24e623fdd639750e99118cf9ab5.js"></script>

The OrderApi ingress file looks the same, except that the name is orderapi instead of customerapi.

Next, add the TLS secret name and the host to the values.release.yaml or values.yaml file.

<script src="https://gist.github.com/WolfgangOfner/f2c08d18403841182fa68a81a1081e73.js"></script>
The variables, for example, \_\_TlsSecretName\_\_ are defined in the CI/CD pipeline and will be replaced by the tokenizer. For more information about the tokenizer, see [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

<script src="https://gist.github.com/WolfgangOfner/c9a4be612c66df20df3f16acd0100a01.js"></script>

You can use whatever name you want for the TLS secret.

The last step is to add an additional annotation to the ingress of the microservice. Add the following line to the annotations section of the values.yaml or values.release.yaml file:

<script src="https://gist.github.com/WolfgangOfner/929525c2a9b9829f1dba508f80cf935a.js"></script>
This is all you have to configure to automatically use HTTPS and also use SSL termination in the Nginx ingress controller. This means that the traffic inside the cluster uses only HTTP and therefore doesn't use any compute power to decrypt the connection.

## Using HTTPS to access the Microservice

Deploy the Microservice and then call their URL, in my case, customer.programmingwithwolfgang.com. You should see that HTTPS is used and that a valid certificate is used.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/A-valid-SSL-Certificate-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/A-valid-SSL-Certificate-got-created.jpg" alt="A valid SSL Certificate got created" /></a>
  
  <p>
   A valid SSL Certificate got created
  </p>
</div>

## Troubleshooting

If something did go wrong, you might see a warning when you try to access the microservice using HTTPS.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-SSL-Certificate-is-not-valid.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-SSL-Certificate-is-not-valid.jpg" alt="The SSL Certificate is not valid" /></a>
  
  <p>
   The SSL Certificate is not valid
  </p>
</div>

If you see this message, check if you added the letsencrypt annotation. I forget this one almost always. If this didn't fix the problem check if there is a certificate in your namespace with the following command:

<script src="https://gist.github.com/WolfgangOfner/7ae55a839d9544c5d4cba020d02553a5.js"></script>

This should display your certificate.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-SSL-Certificate-got-added-to-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-SSL-Certificate-got-added-to-the-Namespace.jpg" alt="The SSL Certificate got added to the Namespace" /></a>
  
  <p>
   The SSL Certificate got added to the Namespace
  </p>
</div>

## Conclusion

A cert-manager creates SSL certificates automatically in your Kubernetes cluster and helps you to reduce the time to fully configure your application. This is especially useful when you use multiple test environments.

[In my next post](/split-up-the-ci-cd-pipeline-into-two-pipelines), I will show you how to separate the CI/CD pipeline into two pipelines which will enable you to make changes faster and with less errors.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).