---
title: Ditch Port Forwarding - Exposing AKS MCP via Kubernetes Gateway API
date: 2026-08-10
author: Wolfgang Ofner
categories: [Cloud, Kubernetes]
tags: [Azure, AKS, Kubernetes, Gateway API, Envoy, Envoy Gateway API, AKS-MCP]
description: Expose your AKS MCP server using the Kubernetes Gateway API. Learn how to ditch unstable port forwarding with ListenerSet, HTTPRoute, and custom DNS.
---

Connecting to an Azure Kubernetes Service (AKS) Model Context Protocol (MCP) server via local port forwarding is fine for quick sanity checks, but it falls apart fast in real usage. Connections drop, sessions timeout, and team members end up constantly re-running terminal commands just to keep their AI tools connected.

By placing your MCP server behind the Kubernetes Gateway API, you can replace temporary local tunnels with a persistent, stable HTTP URL.

## The Problem with Port Forwarding

Using local port forwarding creates several friction points when working with cluster-hosted MCP tools:

* **Session Instability**: Local proxy tunnels frequently drop when idle, forcing manual reconnects inside your IDE.
* **Non-Persistent Endpoints**: Every engineer has to maintain their own local port forwarding process pointing to localhost.
* **Brittle Integration**: Client tools like Visual Studio Code rely on a steady connection state to execute cluster operations seamlessly.

Exposing the MCP server over a dedicated domain name gives your development tools a reliable endpoint that stays connected.

## Architecture: How Traffic Reaches the MCP Server

Transitioning from local forwarding to URL-based access involves four interconnected layers:

### 1. Azure DNS Mapping
An A-record in your Azure DNS zone points your chosen subdomain directly to the public IP address of your cluster's ingress Gateway resource.

### 2. ListenerSet Configuration
A ListenerSet resource attaches to your central Gateway object. It listens on port 80 for incoming HTTP traffic matching your specific custom domain name.

### 3. HTTPRoute Mapping
An HTTPRoute links the ListenerSet to the internal ClusterIP service of the MCP server. It intercepts requests for your host domain and forwards them to port 8000 on the MCP service.

### 4. Host Header Verification
By default, the MCP server rejects requests if the incoming host header does not match its internal allowed hosts list. You must update the MCP server deployment parameters to explicitly authorize your custom domain name.

## Implementation Steps

Setting up URL access to your MCP server requires a few key configuration steps:

1. **Map the Gateway IP in DNS**: Retrieve the public IP address of your Gateway resource and create an A-record in your Azure DNS zone.
2. **Deploy the ListenerSet**: Define a ListenerSet targeting your Gateway name and namespace, set to listen on port 80 for your target host domain.
3. **Deploy the HTTPRoute**: Create an HTTPRoute attached to the ListenerSet that routes traffic directly to your MCP server's Kubernetes service on port 8000.
4. **Update Allowed Hosts via Helm**: Perform a Helm upgrade on your MCP server deployment to set the allowed hosts value to your domain name. Skipping this step will cause the server to reject incoming traffic.
5. **Update Client Settings**: In your local development environment, update your MCP client configuration file to point to your new HTTP URL instead of localhost.

## Security Warning

Exposing an MCP server directly to an HTTP URL makes the endpoint publicly reachable over the internet. Because the MCP server operates with administrative permissions on your Kubernetes cluster, anyone who discovers the URL could potentially execute commands against your cluster. 

In a production workflow, you must layer user authentication (such as Microsoft Entra ID) and automated TLS encryption over this endpoint before using it beyond isolated testing environments.

## Conclusion

Replacing port forwarding with the Kubernetes Gateway API transforms a flaky developer setup into a reliable, persistent connection for your AKS MCP server. By aligning Azure DNS records, ListenerSet rules, HTTPRoutes, and host header permissions, you provide your AI tools with a stable endpoint while laying the foundation for future authentication and TLS policies.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Ditch%20Port-Forwarding%20Exposing%20-%20AKS%20MCP%20via%20Kubernetes%20Gateway%20API">GitHub</a>.

This post was AI-generated based on the transcript of the video "Ditch Port Forwarding - Exposing AKS MCP via Kubernetes Gateway API".

## Video - Ditch Port Forwarding - Exposing AKS MCP via Kubernetes Gateway API

<iframe width="560" height="315" src="https://www.youtube.com/embed/kPu49cLK7B0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>