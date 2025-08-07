---
title: ArgoCD SSO with Entra ID Made Easy
date: 2025-08-04
author: Wolfgang Ofner
categories: [DevOps]
tags: [AKS, GitOps, ArgoCD, DevOps, SSO, Entra ID, Entra Workload ID]
description: Simplify your ArgoCD access and enhance security by implementing Single Sign-On (SSO) with Microsoft Entra ID.
---

This blog post, based on a recent video, provides a detailed walkthrough on how to set up Single Sign-On (SSO) for ArgoCD using Entra ID. This method allows users to authenticate to both the ArgoCD UI and CLI with their existing Azure accounts, simplifying access management and enhancing security.

## The Importance of SSO for ArgoCD

Enabling SSO for ArgoCD is a critical step for any organization, as it:

- **Simplifies User Experience:** Users can access ArgoCD with their corporate credentials, eliminating the need to remember a separate username and password.
- **Centralizes User Management:** Access is managed through a central identity provider (Entra ID), making it easier to onboard, offboard, and manage user permissions.
- **Enhances Security:** It allows you to leverage robust security features like Multi-Factor Authentication (MFA) and conditional access policies directly from Entra ID.

## Step-by-Step Guide: Configuring Entra ID SSO

The process is divided into three main parts: setting up your AKS cluster, configuring an application in Entra ID, and configuring ArgoCD itself.

**1. Cluster Setup and ArgoCD Installation**
- **Create Your AKS Cluster:** Start by creating a new AKS cluster. It's essential to enable workload identity and the OIDC issuer during this step, as these features are fundamental for enabling your Kubernetes service account to verify credentials against Entra ID.
- **Install ArgoCD:** The video demonstrates using the ArgoCD AKS extension to simplify the installation. If you are not using the extension, the process can be done manually by modifying Kubernetes manifests later.
- **Expose ArgoCD:** To enable the redirect URIs needed for SSO, you must make the ArgoCD server service publicly accessible. Change the service type to `LoadBalancer` to obtain a public IP address.

**2. Configuring the Entra ID Application**

This step creates the trust relationship between your ArgoCD instance and Entra ID.

- **Create an App Registration:** In the Azure portal, create a new App Registration. Give it a descriptive name, such as "ArgoCD."
- **Add Redirect URIs:** Add the redirect URIs for both the ArgoCD UI and the ArgoCD CLI. This allows users to log in from either interface. The UI redirect URI will use the public IP address of your ArgoCD server, while the CLI redirect URI will be `http://localhost:8085/auth/callback`.
- **Configure Federated Credentials:** Create federated credentials to establish a trust relationship between your ArgoCD service account and the Entra ID application. You'll need to provide the OIDC issuer URL from your AKS cluster, the namespace where ArgoCD is deployed, and the name of the ArgoCD service account.
- **Token Configuration:** To enable role-based access control (RBAC), add a groups claim to the token configuration. This allows ArgoCD to read a user's group assignments from Entra ID.
- **API Permissions and Admin Consent:** Grant API permissions to allow the application to read user profiles and provide admin consent to finalize the configuration.

**3. Configuring ArgoCD for OIDC**

Once Entra ID is configured, you'll update ArgoCD to use it as an identity provider.

- **Update Configuration:** If you're using the AKS extension, you can update its Bicep file with the Entra app client ID, your tenant ID, and the public IP address.
- **Manual Configuration:** For manual installations, you'll need to update the `argocd-cm` and argocd-rbac-cm ConfigMaps.
    - In argocd-cm, add the OIDC connector configuration, including the `tenant ID`, `client ID`, and `URL`.
    - In `argocd-rbac-cm`, define roles and group-to-role mappings. For example, you can create a policy that grants the `org-admin` role to a specific Entra ID group or user.
- **Enable Workload Identity:** To complete the connection, you'll need to add a label to the ArgoCD server pods (`azure.workload.identity/use: "true"`) and an annotation to the service account (`azure.workload.identity/client-id`) if you're not using the AKS extension.

## Verifying RBAC and SSO Functionality

The final step is to test the SSO setup to ensure that RBAC is working correctly. You can test with:

- **Standard User:** A user who is not assigned to an admin group should be able to log in but will be unable to perform privileged actions, such as creating a new application.
- **Admin User:** A user assigned to the admin group should be able to log in and successfully perform all administrative tasks, including creating and managing applications.

This demonstrates that the integration is working as intended, providing both a streamlined login experience and secure, role-based access to your ArgoCD deployments.

## Conclusion
Enabling SSO for ArgoCD with Entra ID is a strategic move that significantly improves both the user experience and the security of your GitOps environment. By centralizing user authentication and management, you eliminate the overhead of maintaining separate credentials while gaining the security benefits of a robust identity provider. This integration is a crucial step towards building a streamlined, compliant, and resilient continuous delivery system. By following these steps, you can confidently secure your ArgoCD deployments and focus on what matters most: delivering value through code.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/ArgoCD%20SSO%20with%20Entra%20ID%20Made%20Easy" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "ArgoCD SSO with Entra ID Made Easy" and reviewed by me.

## Video - ArgoCD SSO with Entra ID Made Easy

<iframe width="560" height="315" src="https://www.youtube.com/embed/cI3G8hBrKXg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>