---
title: Passwordless Telemetry App Service & Container Apps with Entra ID
date: 2026-10-12
author: Wolfgang Ofner
categories: [Cloud]
tags: [Azure, Azure App Service, Azure Container App, Managed Identity, Azure Application Insights, KQL]
description: Secure Azure App Service and Container Apps telemetry using Entra ID managed identities. Eliminate access keys and stream logs safely to Application Insights.
---

When building secure cloud infrastructure, managing secrets and connection strings is one of the most common operational overheads. Traditional application monitoring setups rely on static instrumentation keys or connection strings to send telemetry data to Application Insights. If these keys leak or expire, logging breaks or security is compromised. 

By leveraging Azure Entra ID and Managed Identities, you can completely eliminate access keys for telemetry and establish a fully passwordless, secure pipeline for both Azure App Service and Azure Container Apps.

## Why Move to Passwordless Telemetry?

* **Eliminate Hardcoded Secrets:** Removing static instrumentation keys from application settings or environment variables prevents accidental credential exposure in source control or configuration files.
* **Automated Identity Lifecycle:** Azure automatically manages the lifecycle, rotation, and token issuance for Managed Identities assigned to your hosting resources.
* **Enhanced Compliance and Zero-Trust:** Aligning with zero-trust principles ensures that workloads only possess the exact permissions required to emit logs and metrics.
* **Simplified Operations:** No need to manually rotate expired or compromised connection strings across multiple application environments.

## Architecture and Configuration Overview

The transition to passwordless telemetry involves establishing a trusted identity relationship between your compute resource and your Application Insights instance:

1. **Enable System-Assigned or User-Assigned Managed Identity:** Provision an identity on your Azure App Service or Container Apps deployment.
2. **Assign Monitoring Roles:** Grant the managed identity the necessary RBAC permissions (such as Monitoring Metrics Publisher or Log Analytics Contributor) on the target Application Insights or Log Analytics workspace.
3. **Configure Application SDKs:** Update your application configuration to authenticate using DefaultAzureCredential or identity-based connection strings rather than static instrumentation keys.

Once configured, the application requests short-lived OAuth tokens from Entra ID on the fly, authenticating securely with Application Insights without ever storing a static password or key.

## Implementation Steps

### 1. Enable Managed Identity on Your Compute Resource
Whether you are deploying an Azure App Service plan or an Azure Container Apps environment, ensure that managed identity is enabled on the resource container. This creates a secure service principal in your Entra ID tenant tied directly to the lifecycle of your application.

### 2. Grant Permissions to Application Insights
Assign the appropriate monitoring role to the managed identity at the Application Insights or workspace scope. This ensures the app has authorization to ingest telemetry without needing a shared secret.

### 3. Update Application Settings and Code
Remove any legacy connection strings or instrumentation keys from your configuration settings. Update your .NET, Node.js, Python, or Java application code to initialize the Application Insights SDK using credential-based authentication.

## Summary

Implementing passwordless telemetry for Azure App Service and Container Apps removes the vulnerability of static access keys while streamlining secret management. By combining Entra ID managed identities with Application Insights, platform and development teams can maintain robust observability without compromising security posture.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Passwordless%20Telemetry%20App%20Service%20%26%20Container%20Apps%20with%20Entra%20ID">GitHub</a>.

This post was AI-generated based on the transcript of the video "Passwordless Telemetry App Service & Container Apps with Entra ID".

## Video - Passwordless Telemetry App Service & Container Apps with Entra ID

<iframe width="560" height="315" src="https://www.youtube.com/embed/iuY94njMrBs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>