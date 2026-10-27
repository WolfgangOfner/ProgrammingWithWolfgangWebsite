---
title: Block Public Ingestion! Secure Azure App Insights with Private Endpoints
date: 2026-10-26
author: Wolfgang Ofner
categories: [Cloud]
tags: [Azure, Private Endpoint, Azure App Service, Azure Container Apps, Private DNS-Zone, Azure Application Insights]
description: Secure Azure App Insights telemetry using private endpoints, VNet integration, and managed identities to block public internet ingestion.
---

# Block Public Ingestion: Secure Azure App Insights with Private Endpoints

When building secure cloud applications, ensuring that telemetry and logging data remain protected from public exposure is just as critical as securing your application runtime. By default, Azure Application Insights and Log Analytics workspaces accept ingestion and query traffic over the public internet. 

By integrating virtual networks, private endpoints, and Azure Monitor Private Link Scopes (AMPLS), you can completely block public internet ingestion and route all monitoring traffic through secure private connections.

## Why Block Public Ingestion for Application Insights?

* Eliminate Public Exposure: Prevent telemetry data streams from traversing the public internet, satisfying strict corporate compliance and zero-trust security mandates.
* Network Isolation: Ensure that Azure App Service and Azure Container Apps emit logs exclusively over internal virtual network routes via VNet injection.
* Controlled Query Access: Restrict who can read analytics data by tying query permissions to private network boundaries or role-based access control.
* Passwordless Telemetry Alignment: Combine private link routing with managed identity authentication to remove static instrumentation keys entirely from application configurations.

## Architecture Overview

Implementing private monitoring involves three core architectural components:

1. Virtual Network (VNet) & Subnets: Dedicated subnets configured for App Service injection, Container Apps, private endpoints, and optional management VMs.
2. Azure Monitor Private Link Scope (AMPLS): A resource that links your private endpoint to your underlying Log Analytics workspace and Application Insights components, overriding public DNS resolution via private DNS zones.
3. Private DNS Zones: Custom DNS zones that resolve service hostnames to internal private IP addresses within your VNet.

## Step-by-Step Implementation Workflow

### 1. Provision the Virtual Network and Subnets
Create a virtual network with dedicated subnets separated for your hosting compute, private endpoints, and any jumpbox or administrative virtual machines needed for testing. Apply appropriate VNet service delegations to the compute subnets.

### 2. Set Up Private DNS Zones and Azure Monitor Private Link Scope
Establish private DNS zones to handle internal name resolution for Azure Monitor services. Create an AMPLS resource and link it to your Log Analytics workspace and Application Insights instance, binding them to a private endpoint deployed in your designated private subnet.

### 3. Restrict Public Ingestion and Query Modes
Update the configuration properties of your Log Analytics workspace and Application Insights components to enforce private-only access for both data ingestion and data querying, effectively blocking all public traffic entry points.

### 4. Configure VNet Injection for Compute Resources
Integrate your Azure App Service and Azure Container Apps environments into their respective VNet subnets and enable full route-all capabilities. This ensures outgoing application traffic and telemetry packets are forced through the private internal network.

### 5. Assign Managed Identity and Telemetry Permissions
Enable managed identities on your App Service and Container Apps, and assign the Monitoring Metrics Publisher role scoped directly to your Application Insights instance. Update application settings to use credential-based authentication instead of public instrumentation keys.

## Managing Secure Query Access

When public query access is disabled, querying logs from outside the virtual network requires specific network connectivity such as a VPN, ExpressRoute, or an internal Azure virtual machine acting as a secure jumpbox. Platform engineers can maintain strict role-based access control policies while evaluating telemetry data within authorized private network boundaries.

## Summary

Locking down telemetry ingestion with private endpoints and AMPLS ensures your observability data never touches the public internet. By combining VNet integration, private DNS zones, and managed identity authentication, you achieve a fully isolated, enterprise-grade monitoring architecture for Azure workloads.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Block%20Public%20Ingestion!%20Secure%20Azure%20App%20Insights%20with%20Private%20Endpoints">GitHub</a>.

This post was AI-generated based on the transcript of the video "Block Public Ingestion! Secure Azure App Insights with Private Endpoints".

## Video - Block Public Ingestion! Secure Azure App Insights with Private Endpoints

<iframe width="560" height="315" src="https://www.youtube.com/embed/cXYImfwyTGs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>