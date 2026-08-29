---
title: How to Restrict User Access to the AKS MCP Server
date: 2026-08-24
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [AKS, AKS-MCP]
description: Secure your AKS Model Context Protocol server by implementing Microsoft Entra ID authentication, user impersonation API scopes, and strict user assignment controls.
---

When deploying a Model Context Protocol (MCP) server for Azure Kubernetes Service (AKS), convenience often comes at the expense of security. By default, initial deployments operate without authentication. Because the underlying service account typically carries administrative cluster rights, anyone who can establish a connection or port-forward to the MCP server pod can execute commands as a full cluster administrator.

In this guide, we will remediate this security risk by configuring Microsoft Entra ID authentication, restricting login rights strictly to authorized users or groups.

## Key Security Concepts

* **Unauthenticated Risks:** Without authentication, any developer with read access or port-forward capabilities in the MCP namespace effectively gains cluster admin access.
* **Delegated Permissions:** We use the Azure Service Management user impersonation API scope, allowing the MCP server to act on behalf of the logged-in identity rather than running with full static admin permissions.
* **Explicit Assignment Requirement:** By enforcing the app role assignment requirement on the Enterprise Application, unassigned users are completely blocked during token issuance.

## Step 1: Environment Preparation

Before executing configuration scripts, define your standard parameters:

* Set your target Helm release name and target Kubernetes namespace.
* Define your Entra ID tenant ID and display name for the new application registration.
* Specify the user principal name or group ID that will receive initial access.

## Step 2: Create and Configure the Entra ID App Registration

We must create an App Registration configured for public client/desktop redirects and assign delegated permissions for Azure Service Management.

### 1. Create the App Registration
Create a public client application registration. Crucially, set the public client redirect URI to the localhost endpoint on port 33418. This specific redirect URI is required by Visual Studio Code's authentication handler for desktop logins.

### 2. Add API Permissions
Retrieve the application client ID and assign the delegated Azure Service Management permission. Select the user impersonation scope so the application operates strictly with the permissions of the authenticated user.

### 3. Enterprise Application & Admin Consent
Generate the enterprise application service principal bound to your application ID. Grant admin consent across your tenant so individual users are not prompted for administrative sign-off during login.

### 4. Enforce Explicit User Assignment
Update the service principal properties to set the app role assignment requirement to true. This blocks any user in your tenant from logging in unless they have been explicitly added to the application. Assign your designated user object ID or Azure security group to the application's default role.

## Step 3: Enable OAuth on the AKS MCP Server via Helm

Perform an upgrade on your existing Helm release to activate OAuth protection:

* Keep your existing values intact while setting OAuth to enabled.
* Pass your Entra tenant ID and client ID into the release configuration.
* Set the OAuth redirect URI to match the Visual Studio Code desktop callback address on port 33418.
* Re-establish port forwarding to port 8000 once the pod completes its rolling restart.

## Step 4: Verification and Live Testing

### Testing Authorized User Access
Connect to the local server port via Visual Studio Code. Complete the browser authentication prompt using your assigned user account and multi-factor authentication. Once verified, the MCP tools will successfully initialize.

### Testing Unauthorized User Access
Sign out of the active session in Visual Studio Code. Attempt to connect using an unassigned Entra ID account. Entra ID will immediately reject the sign-in request with an administrative blocking error.

## Conclusion

Enforcing Entra ID authentication closes a massive security loophole in default AKS MCP server setups. By mapping user logins directly to Entra ID app assignments and applying user impersonation, you ensure that cluster access remains governed by existing identity policies rather than open namespace permissions. 

Be aware that rotating app registrations can trigger an undocumented VS Code token caching bug, which we will resolve step-by-step in Part 4. In Part 5, we will remove local port forwarding entirely by exposing the authenticated MCP server over HTTPS using Envoy Gateway API and cert-manager.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/How%20to%20Restrict%20User%20Access%20to%20the%20AKS%20MCP%20Server">GitHub</a>.

This post was AI-generated based on the transcript of the video "How to Restrict User Access to the AKS MCP Server".

## Video - How to Restrict User Access to the AKS MCP Server

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZAgamywJNmk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>