---
title: Secretless Microsoft Authentication in Azure App Service
date: 2026-07-06
author: Wolfgang Ofner
categories: [Cloud]
tags: [Azure, App Service, Entra, Managed Identity]
description: Learn how to configure secure, secretless Microsoft Entra ID authentication for Azure App Service using Bicep and Federated Credentials, eliminating expiring client secrets.
---

Configuring Microsoft authentication for an Azure App Service is a standard security requirement for enterprise cloud applications. However, relying purely on the Azure Portal to set this up introduces hidden operational risks and brittle configuration patterns. By understanding how to decouple identity creation from infrastructure deployment, platform engineers can implement a completely secretless, passwordless authentication flow using Infrastructure as Code and Microsoft Entra ID Federated Credentials.

## The Pitfalls of Portal-Driven Authentication

When administrators use the Azure Portal to enable Microsoft authentication on an App Service, the portal automatically handles the creation of the underlying Microsoft Entra ID App Registration behind the scenes. While convenient, this wizard-driven approach generates a client secret that is automatically configured with a default expiration window, typically 180 days. 

When this secret expires, authentication breaks instantly, taking down application access. This requires teams to manually rotate keys, store credentials inside Azure Key Vault, and constantly update configuration references. Furthermore, in enterprise environments, application developers rarely possess the high-level Entra ID tenant permissions required to create App Registrations directly. This leads to broken deployment pipelines and manual IT ticketing bottlenecks where developers are left waiting for security teams to generate secrets and pass them back securely.

## Decoupling Identity and Infrastructure

To achieve a clean separation of concerns, the Entra ID App Registration can be provisioned ahead of time by an identity administrator, allowing the developer to consume the resulting Client ID entirely through automated deployment workflows. 

When establishing the App Registration, specific architectural configurations must be enforced conceptually:

* **Redirect URI:** The registration requires a Web platform redirect URI matching the canonical format of your App Service domain, appended with the mandatory authentication callback suffix.
* **Token Issuance:** Within the authentication configuration pane, implicit grant flows must be explicitly updated to support ID tokens. This allows the App Service middleware to safely process user sign-ins.
* **API Scopes:** To establish proper audience boundaries, you must expose an API, define an Application ID URI, and generate a delegated permission scope, ensuring only authorized callers can initiate authentication handshakes.

## Declarative Infrastructure Configuration

Once the Client ID is obtained from the pre-provisioned App Registration, the entire runtime environment can be managed declaratively using tools like Bicep or Terraform. The infrastructure template handles the deployment of the User-Assigned Managed Identity, the App Service Plan, and the App Service itself.

Instead of inserting passwords or connection strings into the app configuration, the template defines the platform-level authentication settings block. This configuration tells the App Service middleware how to handle unauthenticated traffic, forcing anonymous requests to redirect directly to Microsoft Entra ID for validation. It maps the Entra Client ID and sets the allowed audience boundaries so the hosting platform natively intercepts and validates claims before the traffic ever reaches the underlying application code.

## Establishing the Passwordless Trust Boundary

To completely eliminate the need for client secrets or background token rotations, the App Service utilizes its assigned User-Assigned Managed Identity to authenticate directly against the Entra ID App Registration. This trust is established via Federated Credentials.

By configuring a Federated Credential on the App Registration that points directly to the Managed Identity of the App Service, you create an asymmetric cryptographic trust boundary between the Entra identity object and the Azure hosting infrastructure. No strings, passwords, or certificates are generated or stored. When a user logs in, the platform validates the handshake securely via this trusted relationship, completely removing credential rotation and secret leakage vulnerabilities from your operational lifecycle.

## Conclusion

Transitioning to a secretless architecture represents a major milestone in establishing a robust zero-trust security posture for cloud-native web applications. Moving away from manual, portal-driven setups to declarative infrastructure templates eliminates the brittle lifecycle of expiring client secrets and thoroughly mitigates the risk of credential exposure. By pairing Microsoft Entra ID Federated Credentials with User-Assigned Managed Identities, platform teams can bridge the operational gap between rigid enterprise identity governance and high-velocity developer workflows. Ultimately, this approach ensures your Azure App Services remain continuously secure, fully compliant, and completely free of routine password maintenance.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Secretless%20Microsoft%20Authentication%20in%20Azure%20App%20Service">GitHub</a>.

This post was AI-generated based on the transcript of the video "Secretless Microsoft Authentication in Azure App Service".

## Video - Secretless Microsoft Authentication in Azure App Service

<iframe width="560" height="315" src="https://www.youtube.com/embed/9zr6sJmpC0g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>