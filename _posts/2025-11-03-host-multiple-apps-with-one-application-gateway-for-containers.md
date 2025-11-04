---
title: Host multiple Apps with one Application Gateway for Containers on AKS - Part 3
date: 2025-11-03
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Application Gateway for Containers]
description: Use a single Azure Application Gateway for Containers (AGFC) to host multiple apps on AKS. Learn to route traffic using the Gateway API's HTTPRoute.
---

Part 3 of our series shifts from infrastructure setup to practical application hosting. In this content, we demonstrate a core capability of modern traffic management: using a single **Azure Application Gateway for Containers (AGFC)** to expose and route traffic to multiple, independent applications residing within your AKS cluster.

This walkthrough builds directly upon the foundation established in Part 2, focusing on the configuration of Kubernetes Gateway API resources to achieve intelligent routing.

## 1. The Gateway API in Action: Architecture Overview

The key to hosting multiple applications is the **HTTPRoute** resource.

* **Gateway Resource (In `infrastructure` namespace):** The central entry point, provisioned by the AGFC, which listens for all incoming traffic.
* **Applications (In dedicated namespaces):** Two test applications (`Nginx` and `Traefik Whoami`) are deployed into their own namespaces with a standard `ClusterIP` Service, meaning they are not directly exposed to the internet.
* **HTTPRoute Resources (In application namespaces):** This resource links the application service to the central `Gateway`. Crucially, it allows you to define rules based on hostnames or paths, telling the Gateway exactly where to forward the request.

This setup ensures that the applications are isolated within their own namespaces while being securely and selectively exposed via the single, centralized Gateway.

## 2. Step-by-Step Multi-App Configuration

The content provides a detailed guide on deploying and configuring the applications:

* **Application Deployment:** Two simple applications (`Nginx` and `Traefik`) are deployed using standard Kubernetes `Deployment` and `ClusterIP Service` resources in their own namespaces (`nginx-ns` and `traffic-ns`).
* **Initial Path-Based Routing:** An `HTTPRoute` is first configured to route traffic based on a URI path prefix (e.g., `/nginx` or `/traefik`), demonstrating how the Gateway can differentiate between requests destined for different backends.
    * *Example:* A request to `[FQDN]/traefik` is successfully routed to the `Traefik` service.
* **Advanced Hostname Routing:** The configuration is then updated to use **hostname-based routing**. The `HTTPRoute` for each application is configured to match a custom URL (e.g., `nginx.programmingwithwolfgang.com`), allowing your applications to be accessed via clean, dedicated hostnames.

## 3. Key Takeaway: Separation of Concerns

By using the Gateway API's resource model, you achieve a clean separation of concerns:

| Component | Responsibility | Resource | Location |
| :--- | :--- | :--- | :--- |
| **Connectivity** | Public exposure & single entry point | `Gateway` | Infrastructure Namespace |
| **Routing Logic** | Hostname/Path matching & Backend selection | `HTTPRoute` | Application Namespace |
| **Application** | Core logic & port listening | `Deployment` / `Service` | Application Namespace |

This pattern allows application developers to manage their routing rules (`HTTPRoute`) without needing permissions to modify the central infrastructure (`Gateway`).

## 4. Conclusion

Part 3 validates the flexible and powerful traffic management capabilities provided by the **Kubernetes Gateway API** when combined with the **Azure Application Gateway for Containers**. By successfully routing different hostnames to separate backends using the `HTTPRoute` resource, we demonstrate how a single, powerful external gateway can efficiently serve a multi-application environment. This pattern is essential for modern, scalable AKS deployments where application teams need autonomy over their exposure while benefiting from centralized, high-performance infrastructure.

## What's Next?

With the ability to route traffic to multiple applications established, the foundation is now set for implementing advanced networking features, including:

* Configuring **Azure DNS** to point your custom domain to the Gateway's public hostname.
* Implementing automated **TLS certificates (HTTPS)** using **Cert-Manager** for secure connections.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Host%20Multiple%20Apps%20with%20One%20Application%20Gateway%20for%20Containers%20on%20AKS%20-%20Part%203" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Host multiple Apps with one Application Gateway for Containers on AKS - Part 3" and reviewed by me.

## Video - Host multiple Apps with one Application Gateway for Containers on AKS - Part 3

<iframe width="560" height="315" src="https://www.youtube.com/embed/JoRQhny4QPM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>