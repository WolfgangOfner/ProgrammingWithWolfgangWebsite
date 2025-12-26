---
title: AKS Gateway Routing Path, Query, and Headers - Part 8
date: 2025-12-08
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers, Routing]
description: Master advanced Kubernetes Gateway API routing on AKS. Learn to implement rules based on Path, Query Strings, and Headers.
---

Setting up basic hostname routing is the first step, but modern applications demand more surgical precision when directing traffic. **Part 8** of our Kubernetes Gateway API series dives deep into the advanced routing options that allow you to control traffic flow based on specific components of an incoming request: **Path, Query Parameters, and Headers.**

This guide provides a complete tutorial on how to implement these routing mechanisms on an **Azure Kubernetes Service (AKS)** cluster using the Gateway API.

## Understanding Advanced Routing Options

The Kubernetes Gateway API offers several ways to match and forward traffic beyond simple hostnames:

1.  **Path Matching:** The most common form of advanced routing, allowing traffic to be split based on the URL path.
2.  **Query Parameter Matching:** Directing traffic based on specific parameters present in the query string (e.g., `?version=beta`).
3.  **Header Matching:** Routing decisions based on specific HTTP headers (e.g., matching a `User-Agent` to differentiate between mobile and desktop users).
4.  **Hostname Matching:** The foundational routing based on the domain name, which the custom rules extend.
5.  **Default/Fallback Route:** A crucial "catch-all" route that ensures no request results in a generic 404 error if none of the explicit rules match.

## Implementing Path-Based Routing

Path routing can be configured with three main matching types:

* **Prefix:** Matches any path that *begins* with the configured value (e.g., `/routing` matches `/routing` and `/routing/abc`).
* **Exact:** Matches only if the path is *exactly* the configured value (e.g., `/exact` matches only `/exact`).
* **Regular Expression (Regex):** Offers the most powerful and flexible matching, allowing for complex pattern recognition in the path.

In the demonstration, setting a rule with a path prefix like `/routing` directs traffic to a specific backend application, while an exact path match only works when the URL is precisely defined.

## Extending Routing with Headers and Query Strings

To implement sophisticated deployment strategies like A/B testing or internal feature access, you can combine path matching with checks against HTTP headers and query strings:

* **Header Matching:** A rule can be configured to send traffic to a second application (e.g., App #2) only if the path is matched *and* a specific header (e.g., `Header: routing`) is present. If the header is absent or has a different value, traffic falls to the next matching rule.
* **Query String Matching:** Similar to header matching, a rule can be set to direct traffic to a third application (e.g., App #3) if a specific query string (e.g., `?query=routing`) is included in the request.

By chaining these rules in an `HTTPRoute` definition, you can establish complex logic to direct traffic to the correct service.

## Using Custom Hostnames and Fallback Routes

The guide also covers two critical aspects of production readiness:

1.  **Custom Domain Integration:** By simply adding a custom URL (like `routing.programmingwithwolfgang.com`) to the `hostnames` list on the `HTTPRoute`, you enable access via a custom domain. This relies on the Azure DNS zone being configured with a `CNAME` record pointing the custom URL to the AGFC's public hostname.
2.  **Implementing a Default Route:** To enhance user experience, a final, less-indented `backendRef` is added to the `HTTPRoute` that acts as a catch-all. If none of the specific path, header, or query rules are satisfied, the request is forwarded to a designated **default application** (e.g., App #4), preventing a generic 404 error. This ensures a consistent user experience with a helpful landing page or error message.

## Conclusion

The **Kubernetes Gateway API** provides a powerful and flexible way to manage traffic, moving far beyond simple hostname resolution. By utilizing path, query, and header matching, you gain the ability to implement advanced DevOps strategies on **AKS**, such as precise A/B testing and seamless canary rollouts.

The key takeaways are:
* Keep routing rules as **simple** as possible to maintain clarity.
* Always include a **default/fallback route** to handle unmatched requests gracefully.
* Leverage external DNS records to easily use **custom hostnames** with your `HTTPRoute` definitions.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20Gateway%20Routing%20Path%2C%20Query%2C%20and%20Headers%20-%20Part%208">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS Gateway Routing Path, Query, and Headers - Part 8" and reviewed by me.

## Video - AKS Gateway Routing Path, Query, and Headers - Part 8

<iframe width="560" height="315" src="https://www.youtube.com/embed/iT9WhRoukyY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>