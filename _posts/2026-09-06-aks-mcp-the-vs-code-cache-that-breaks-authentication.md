---
title: AKS MCP - The VS Code Cache That Breaks Authentication
date: 2026-09-06
author: Wolfgang Ofner
categories: [Youtube, Kubernetes]
tags: [AKS, AKS-MCP, Visual Studio Code]
description: Resolve Visual Studio Code Entra ID authentication failures caused by SQLite state caching when switching AKS MCP servers using an automated PowerShell cleanup script.
---

When securing a Model Context Protocol (MCP) server running on Azure Kubernetes Service (AKS) using Microsoft Entra ID (formerly Azure AD) App Registrations, authentication provides a crucial layer of access control. However, developers connecting to these MCP servers via Visual Studio Code will likely run into a frustrating edge case: VS Code silently caches authentication details against the endpoint URL, causing subsequent connections to fail if the underlying App Registration changes.

In Part 4 of our five-part AKS MCP series, we analyze why this authentication caching bug occurs in VS Code, examine how the underlying SQLite state database behaves, and walk through a PowerShell automation script that clears stale state entries so you can switch environments seamlessly.

## The Root Cause: Localhost Endpoint Caching in VS Code

When you connect Visual Studio Code to an MCP server exposed on a URL like `http://localhost:8000`, the editor initiates an Entra ID OAuth/OIDC login flow bound to a specific App Registration `Client ID`. 

Once authenticated, VS Code stores key-value pairs representing this connection inside its global state SQLite database (`state.vscdb`) along with a corresponding backup file. The primary issue is that VS Code associates the endpoint URL (e.g., `localhost:8000`) directly with the initial App Registration's `Client ID`.

If you subsequently:
* Delete and recreate the App Registration during cluster teardowns/re-deployments,
* Switch between different environments (e.g., Dev, Staging, or Prod AKS clusters) running on the same local port, or
* Rotate your Entra ID credentials,

VS Code does not prompt for a fresh App Registration configuration. Instead, it re-uses the cached `Client ID` from its internal database. Entra ID then rejects the request with an error stating that the application identifier was not found in the tenant (`AADSTS700016`), rendering the MCP server connection unusable.

## Simulating the Broken Authentication Flow

To observe the bug in action:

1. **Initial Connection:** Deploy the AKS MCP server, configure an Entra ID App Registration, and establish a port-forwarding session to `localhost:8000`. Authenticate through VS Code using your Entra ID credentials. The connection succeeds.
2. **Re-creating the App Registration:** Delete the old App Registration in Azure Entra ID and provision a new App Registration with identical permissions, generating a new `Client ID`.
3. **Updating the MCP Helm Release:** Update the Helm release running in your AKS cluster with the new `Client ID` and restart the MCP pod.
4. **Attempting Re-authentication:** Launch VS Code and trigger the MCP connection. Despite the server presenting the new `Client ID`, VS Code pulls the cached initial `Client ID` from its global state database and sends it to Entra ID, throwing an application identifier mismatch error.

Because VS Code maintains both a primary `state.vscdb` database and an automated backup database, manually altering or deleting individual keys without closing VS Code often causes the editor to restore the stale data from backup upon restart.

## The Workaround: Clearing the VS Code SQLite State Database

To resolve this issue without remapping your MCP server to arbitrary local ports for every build, you must clear the cached key-value entries from VS Code's internal database while all instances of VS Code are closed.

### PowerShell Cleanup Automation

The following process automates the cleanup:

1. **Process Enforcement:** Verifies that all instances of Visual Studio Code (`Code.exe`) are completely closed to prevent file locks or automatic backup restoration.
2. **SQLite Tooling:** Detects whether `sqlite3` is available on the path; if missing, it automatically installs it via WinGet.
3. **Database Backup:** Creates a timestamped backup copy of VS Code's global state files before modifying any records.
4. **Targeted Entry Deletion:** Executes targeted SQL `DELETE` queries against `state.vscdb` and its backup files to remove state records matching your local endpoint (e.g., `localhost:8000`).

Once the script completes, launch VS Code and reconnect to your MCP server. VS Code will execute a clean OIDC handshake against the updated Entra ID App Registration, successfully establishing the session.

## Conclusion & Next Steps

While caching connection state improves user experience for static endpoints, VS Code's hard binding of endpoint URLs to OAuth Client IDs creates significant friction when developing or testing custom MCP servers across multiple AKS clusters. Until upstream fixes are applied to VS Code's extension state handler, running an automated SQLite state cleanup script serves as the most reliable workaround.

In the fifth and final part of this series, we will bring together all components—Envoy Gateway API, cert-manager TLS, Microsoft Entra ID authentication, and NAT Gateway v2—to deliver a fully hardened, production-ready AKS MCP infrastructure.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20MCP%20-%20The%20VS%20Code%20Cache%20That%20Breaks%20Authentication">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS MCP - The VS Code Cache That Breaks Authentication".

## Video - AKS MCP - The VS Code Cache That Breaks Authentication

<iframe width="560" height="315" src="https://www.youtube.com/embed/7EORfQgouv0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>