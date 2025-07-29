---
title: Eliminate PATs - ArgoCD Private Repo Access with Managed Identity
date: 2025-07-28
author: Wolfgang Ofner
categories: [DevOps]
tags: [AKS, GitOps, ArgoCD, DevOps, Azure DevOps, Entra Workload ID]
description: Ready to ditch Personal Access Tokens for good? This video demonstrates how to use Azure Managed Identities for secure, PAT-free access to your private Git repositories with ArgoCD.
---

Managing secrets and Personal Access Tokens (PATs) for your CI/CD pipelines can be a significant operational burden and a security risk. If a token expires or a user leaves, your deployments can grind to a halt. This article, based on a recent video demonstration, explores a more robust and secure approach: leveraging Azure's Entra Workload ID with Managed Identities to grant ArgoCD access to private Azure DevOps repositories, completely eliminating the need for PATs.

## The Challenge with PATs
While Personal Access Tokens (PATs) offer a quick way to authenticate, they come with inherent drawbacks:

- **Manual Management:** PATs require manual creation, rotation, and storage.
- **User Dependency:** They are tied to a specific user, creating a single point of failure if that user's account is deactivated.
- **Expiration Headaches:** Expiring tokens can lead to unexpected deployment failures and urgent troubleshooting.

Azure's Managed Identities, combined with Entra Workload ID, provide a solution that addresses these challenges by offering a more secure and automated authentication mechanism.

## Understanding Entra Workload ID and Managed Identities
**Managed Identities** in Azure provide an automatically managed identity for your Azure services. This identity can authenticate to any service that supports Azure AD authentication, without you having to manage any credentials in your code.

**Entra Workload ID** (formerly Azure AD Workload Identity) builds on this by allowing your Kubernetes service accounts to act as managed identities. This means your ArgoCD instance, running as a pod in AKS, can directly authenticate to Azure DevOps using an identity managed by Azure, rather than a user-tied PAT.

## Step-by-Step Guide: Implementing Token-Free Access
Here’s a detailed breakdown of how to set up ArgoCD to access private Azure DevOps repositories using Managed Identity:

1. **Prepare Your AKS Cluster**
The foundation for this setup is an AKS cluster configured for Workload Identity.
- **Deploy AKS Cluster:** When creating your AKS cluster, ensure that both OIDC issuer and workload identity features are explicitly enabled. These are critical for the Kubernetes service account to obtain access tokens from Azure AD.

<script src="https://gist.github.com/WolfgangOfner/225242620c8ddb67770d24e3cc45ad94.js"></script>

- **Retrieve OIDC Issuer URL:** After cluster creation, get the OIDC issuer URL. This URL allows your AKS cluster to obtain access tokens for authentication with Azure AD.

<script src="https://gist.github.com/WolfgangOfner/07e0eb02a2396c053ad4d8f56d6588ff.js"></script>

2. **Configure Your Azure Managed Identity**
Next, you'll create and configure the managed identity that ArgoCD will use.

- **Create Managed Identity:** Create a new user-assigned managed identity in Azure.

<script src="https://gist.github.com/WolfgangOfner/772bf4cdadd09e913c7002f84c558c3c.js"></script>

- **Get Client ID:** Note down the `clientId` of this newly created managed identity. You'll need it for subsequent steps.

3. **Grant Permissions in Azure DevOps**
The managed identity needs explicit permissions to access your Azure DevOps project.

- **Invite Managed Identity to Azure DevOps:**
    - In your Azure DevOps organization settings, go to "Users."
    - Invite the managed identity as a new user. You'll typically use its `clientId` or its principal name (e.g., `myArgoCDManagedIdentity@yourtenant.onmicrosoft.com`).
    - Assign it a "Basic" access level.

- **Grant Project-Level Permissions:**
    - Navigate to your specific Azure DevOps project settings.
    - Go to "Permissions."
    - Add the managed identity to the "Readers" group for that project. This ensures it has read-only access to your code repositories.

4. **Install and Configure ArgoCD AKS Extension (or Manual Setup)**
This step integrates ArgoCD with your AKS cluster and links it to the managed identity.

- **Using AKS Argo CD Extension:**
    - If you're using the AKS Argo CD extension (which, at the time of the video, provided a workaround for a known bug in Argo CD's direct Workload ID support), deploy it using a Bicep file or ARM template.
    - Crucially, update the extension configuration to set `workloadIdentityEnabled` to true and provide the `workloadIdentityClientId` (the client ID of your managed identity).

- **Manual Setup (for newer Argo CD versions):**
    - If you're on a newer Argo CD version where direct Workload ID support is stable, you'll manually configure your Argo CD `repo-server` pod and service account.
    - Label the Argo CD Repo Server Pod: Add the label `azure.workload.identity/use: "true"` to your Argo CD `repo-server` pod specification.
    - Annotate the Argo CD Repo Server Service Account: Add the annotation `azure.workload.identity/client-id: "<your-managed-identity-client-id>"` to the `argocd-repo-server` service account.

5. **Create Federated Identity Credential**
This is the core step that links your Kubernetes service account to the Azure Managed Identity.

- **Create Federated Credential:** Use the Azure CLI to create a - federated identity credential. This establishes a trust relationship, allowing the Argo CD `repo-server` service account to exchange its Kubernetes service account token for an Azure AD token using your managed identity.

<script src="https://gist.github.com/WolfgangOfner/cad29fac5307d52f0d69524dda16b614.js"></script>

- Replace `<OIDC_ISSUER_URL_FROM_STEP_1>` with the URL you retrieved earlier.
- `argocd:argocd-repo-server` refers to the namespace and name of the Argo CD repository server's service account.

6. **Test Access in ArgoCD UI**
Finally, verify that ArgoCD can now access your private repository without PATs.

- **Access ArgoCD UI:** Port-forward the Argo CD service to access its UI.
- **Connect New Repository:** In ArgoCD settings, go to "Repositories" and connect a new repository.
Configure for Managed Identity:
    - Enter the URL of your private Azure DevOps repository.
    - Leave the username and password fields completely empty.
    - Crucially, enable the "Use Azure workload identity" setting.
- **Verify and Deploy:** Observe the connection status. It should be successful. You can then create a new application, pointing it to this private repository. ArgoCD will seamlessly fetch your manifests and deploy your application, all without any PATs or stored credentials.

## Key Benefits of This Approach
By implementing this token-free access, you gain significant advantages:
- **Eliminated Credential Management:** No more creating, rotating, or storing PATs or passwords for repository access.
- **Enhanced Security Posture:** Access is tied to a managed identity with granular permissions, reducing the attack surface compared to user-tied tokens.
- **Improved Operational Efficiency:** Deployments are more resilient to personnel changes or token expirations, leading to fewer unexpected outages.
- **Automated Lifecycle:** The identity lifecycle is managed by Azure, simplifying your GitOps operations.

## Conclusion

Transitioning from PATs to Azure's Entra Workload ID and Managed Identities for ArgoCD's private repository access is a crucial step towards building a more secure, automated, and resilient GitOps environment. This method not only simplifies credential management but also significantly enhances the overall security and reliability of your continuous delivery pipelines. Embrace this modern approach to streamline your deployments and focus on delivering value, not managing secrets.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Eliminate%20PATs%20-%20ArgoCD%20Private%20Repo%20Access%20with%20Managed%20Identity" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Eliminate PATs - ArgoCD Private Repo Access with Managed Identity" and reviewed by me.

## Video - Eliminate PATs - ArgoCD Private Repo Access with Managed Identity

<iframe width="560" height="315" src="https://www.youtube.com/embed/hAB1N-GIrE8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>