---
title: Envoy Gateway + Cert Manager - Zero Touch TLS Without Certificate Objects - Part 16
date: 2026-02-02
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Envoy, Envoy Gateway API, Cert-Manager]
description: Discover how to automate HTTPS for Kubernetes with Envoy Gateway and Cert-Manager. Learn to provision TLS certificates without manual certificate objects.
hidden: true
---

As the Kubernetes ecosystem shifts toward the **Gateway API**, many engineers are looking for ways to streamline security and traffic management. In Part 16 of our series, we address a common question: can we automate TLS certificates even further? 

The answer is a resounding yes. By integrating **Envoy Gateway** with **Cert-Manager**, you can achieve a "set and forget" security model where certificates are provisioned automatically based on your gateway configuration.

## Standardizing with Envoy Gateway

One of the major strengths of the Gateway API is its consistency. Whether you are using a managed service like the Azure Application Gateway for Containers (AGFC) or an in-cluster solution like Envoy, the core resources remain the same. 

While in-cluster solutions lack some specific cloud integrations (like native Azure WAF links), they offer identical behavior for Gateways, GatewayClasses, and HTTPRoutes. This makes Envoy a powerful, portable choice for teams who want to maintain the same networking logic across any environment.

## The Secret to Zero-Touch TLS

Traditionally, using Cert-Manager required creating a specific Certificate object for every domain you wanted to secure. While effective, this adds another layer of YAML to manage. 

You can eliminate this extra step by using **Annotations**. By adding the specific cluster issuer annotation directly to your **Gateway** resource, you signal to Cert-Manager that it should take over the certificate lifecycle for that gateway.

### How the Automation Works
1. **Gateway Annotation:** You tag your Gateway with the name of your Cluster Issuer.
2. **Listener Configuration:** Within the Gateway manifest, you define an HTTPS listener and reference a TLS secret name.
3. **Automatic Provisioning:** Cert-Manager detects these settings, automatically reaches out to a Certificate Authority (like Let's Encrypt), solves the necessary challenges, and populates the secret with a valid TLS certificate.

This process removes the need for manual intervention, ensuring that as soon as a new domain is added to your gateway, it is secured with HTTPS by default.

## Verification and Readiness

Once the configuration is applied, the Gateway status provides immediate feedback. A "Programmed" state of true indicates that the Envoy proxy has successfully accepted the configuration. Simultaneously, the Gateway events will show the successful creation of the certificate.

In a production-ready environment, this setup allows for immediate access via HTTPS. Testing with simple tools like curl or a standard web browser will confirm that the connection is secure and that the certificate—issued by a trusted authority—is valid and ready for traffic.

## Conclusion

Automating TLS with Envoy Gateway and Cert-Manager represents the next step in reducing Kubernetes operational overhead. By removing the need for manual certificate objects, teams can deploy secure applications faster and with fewer configuration errors. This approach provides a robust, portable, and free security model that is fully production-ready.

**Would you like me to create the LinkedIn post for this part as well?**
You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Envoy%20Gateway%20%2B%20Cert-Manager%20-%20Zero-Touch%20TLS%20Without%20Certificate%20Objects%20-%20Part%2016">GitHub</a>.

This post was AI-generated based on the transcript of the video "Envoy Gateway + Cert Manager - Zero Touch TLS Without Certificate Objects - Part 16" and reviewed by me.

## Video - Envoy Gateway + Cert Manager - Zero Touch TLS Without Certificate Objects - Part 16

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZLUCt4yhe0Q" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>