---
title: WAF Security for AKS with Application Gateway for Containers - Part 12
date: 2026-01-05
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, WAF, Web Application Firewall]
description: Secure your AKS cluster by applying WAF policies to the Kubernetes Gateway API. Learn to configure geographic blocking and granular security scopes.
---

Security is a top priority when exposing applications to the internet. While the **Kubernetes Gateway API** and **Application Gateway for Containers (AGFC)** provide robust traffic management, adding a **Web Application Firewall (WAF)** adds an essential layer of protection against common web vulnerabilities.

In this guide, we explore how to implement WAF policies to keep your applications secure, while also addressing some common configuration hurdles.

## What is a Web Application Firewall (WAF)?

An Azure WAF is a centralized security service that protects your web applications from common exploits and vulnerabilities. It primarily uses two sets of rules:

* **Managed Rules:** Pre-configured rules maintained by Microsoft that protect against common attack vectors like SQL injection, cross-site scripting (XSS), and bot detection.
* **Custom Rules:** User-defined rules tailored to specific needs. For example, you can block or allow traffic based on IP addresses, header values, or geographic locations.

## Granular Control: WAF Scopes

One of the most powerful features of using WAF with the Gateway API is the ability to apply policies at different levels of granularity:

1.  **Gateway Scope:** Applying a policy here protects every application in your entire cluster. This is ideal for broad security requirements, such as restricting access to a company's internal network.
2.  **Listener Scope:** Target specific listeners (e.g., HTTPS on a specific port) to apply specialized security rules only to certain entry points.
3.  **HTTP Route Scope:** Apply policies to specific routes, giving you control over security for individual services.
4.  **Path Scope:** The most specific level, allowing you to secure individual paths (like `/admin`) while leaving the rest of the application open to the public.

## Essential Configuration Steps

Setting up a WAF with AGFC requires a few critical steps that are sometimes overlooked. To ensure a successful deployment, follow this workflow:

### 1. Identity and Role Assignment
Before the gateway can link to a WAF policy, the **ALB Managed Identity** must have the correct permissions. You must assign the **Network Contributor** role to this identity at the scope of the resource group where your WAF policy resides. Without this, the link between Kubernetes and Azure will fail.

### 2. Creating and Enabling the Policy
The WAF policy must be created in Azure before it can be referenced in your Kubernetes manifests. Once created, ensure the policy state is set to **Enabled**. You should also choose between two modes:
* **Detection:** Logs the traffic but does not block it (useful for testing).
* **Prevention:** Actively blocks traffic that matches your security rules.

### 3. Implementing Geographic Blocking
A common security use case is restricting traffic by country. By creating a custom rule with a **Geo-location** condition, you can easily deny access to any country outside of your approved list. This is particularly useful for localized services or reducing the attack surface from regions where you don't expect legitimate users.

## Verifying the Deployment

Once you have applied your `WebApplicationFirewallPolicy` custom resource in Kubernetes, it is important to verify its status. You can use the `kubectl get` command to check if the policy deployment is successful. 

If the status shows as `False`, use `kubectl describe` to find the specific error. Common issues usually relate to missing role assignments or trying to reference a WAF policy that hasn't been created yet in the Azure portal.

## Conclusion

Integrating a WAF with your Kubernetes Gateway API setup provides a critical defense-in-depth strategy. While there is a cost increase associated with the WAF service, the peace of mind and protection it offers against automated attacks and regional threats are often worth the investment. By leveraging granular scopes and custom rules, you can create a security posture that is both highly secure and tailored to your application's unique needs.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/WAF%20Security%20for%20AKS%20with%20Application%20Gateway%20for%20Containers%20-%20Part%2012">GitHub</a>.

This post was AI-generated based on the transcript of the video "WAF Security for AKS with Application Gateway for Containers - Part 12" and reviewed by me.

## Video - WAF Security for AKS with Application Gateway for Containers - Part 12

<iframe width="560" height="315" src="https://www.youtube.com/embed/CW3S2AFe4UE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>