---
title: URL Rewrite & URL Redirect with Application Gateway for Containers - Part 9
date: 2025-12-15
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Routing]
description: Master URL Rewriting and Redirection on AKS using the Kubernetes Gateway API. Learn how to manage legacy URLs and optimize cluster performance.
---

As application architectures evolve, the way we manage traffic needs to stay flexible. You might need to reorganize your backend services, move content to new paths, or rename legacy endpoints without breaking existing links for your users. This is where **URL Rewriting** and **URL Redirection** become essential tools in your DevOps toolkit.

Implementing these two features using the **Kubernetes Gateway API** on **Azure Kubernetes Service (AKS)** allows you to handle these changes at the infrastructure level rather than within your application code.

## Rewrite vs. Redirect: Choosing the Right Tool

While they might sound similar, rewriting and redirecting serve very different purposes and behave differently for the end user.

### URL Rewrite (Internal)
A rewrite is entirely transparent to the user. When a request comes in, the gateway changes the URL path internally before forwarding it to the backend service. The user’s browser address bar remains unchanged. This is ideal for internal service organization where you want to keep public URLs clean and simple, even if the backend requires a more complex path.

### URL Redirect (External)
A redirect is a visible instruction to the client’s browser. The gateway receives a request and immediately sends back an HTTP status code (like 301 or 302) telling the browser to look elsewhere. The browser then makes a second, new request to the updated location. 

One major benefit of redirection with tools like **Application Gateway for Containers (AGFC)** is efficiency. Since the redirect happens at the gateway level outside your cluster, the original request never consumes resources on your Kubernetes nodes.

## Implementing URL Rewriting

The Gateway API simplifies the rewrite process using filters within an `HTTPRoute` definition. There are two primary ways to modify paths internally:

* **Replace Prefix Match:** This is the most common method. You define a specific prefix to watch for (e.g., `/api`) and replace only that portion with a new string (e.g., `/v2`). If a user requests `/api/users`, the backend service receives the request as `/v2/users`.
* **Replace Full Path:** This provides absolute control by discarding the original path entirely and replacing it with a specific destination. No matter what parameters follow the matched prefix, the backend will always receive the exact path you’ve defined.

## Configuring URL Redirection

Redirection is handled through the `requestRedirect` filter. This is the go-to solution for permanent site migrations, temporary marketing promotions, or forcing HTTPS.

* **HTTP Status Codes:** You can specify exactly how the browser should treat the move. **301 (Moved Permanently)** is best for SEO and long-term changes, while **302 (Found/Moved Temporarily)** is perfect for short-term redirects or A/B testing scenarios.
* **Path Precision:** Just like with rewrites, you can choose to replace just the prefix or the entire path during the redirection process, giving you total control over where your users end up.

## Conclusion

URL Rewriting and Redirection are foundational for managing professional-grade traffic. They provide the agility needed to update your infrastructure without ever disrupting the user experience. By offloading these tasks to the Kubernetes Gateway API, you can maintain legacy support, keep your internal architecture clean, and optimize cluster performance by handling redirects at the edge. Mastering these path-based modifications is a key step toward building resilient, user-friendly cloud-native applications.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/URL%20Rewrite%20%26%20URL%20Redirect%20with%20Application%20Gateway%20for%20Containers%20-%20Part%209">GitHub</a>.

This post was AI-generated based on the transcript of the video "URL Rewrite & URL Redirect with Application Gateway for Containers - Part 9" and reviewed by me.

## Video - URL Rewrite & URL Redirect with Application Gateway for Containers - Part 9

<iframe width="560" height="315" src="https://www.youtube.com/embed/y714oJ2rnwc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>