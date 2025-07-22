---
title: How to Use ArgoCD with Private GitHub and Azure DevOps Repos
date: 2025-07-21
author: Wolfgang Ofner
categories: [DevOps]
tags: [AKS, GitOps, ArgoCD, DevOps, GitHub, Azure DevOps]
description: Learn how to securely integrate ArgoCD with your private GitHub and Azure DevOps repositories.
---

In the rapidly evolving landscape of cloud-native development, GitOps has emerged as a powerful paradigm for managing Kubernetes deployments. At its heart, ArgoCD champions this approach, allowing you to declare your desired application state in Git and automate its synchronization to your clusters. While demonstrating ArgoCD with public repositories is straightforward, real-world enterprise environments demand the robust security of private Git repositories. This article will guide you through the practical steps of securely integrating ArgoCD with your private GitHub and Azure DevOps repositories using Personal Access Tokens (PATs).

## The Imperative of Private Repositories in GitOps

For any production-grade application, exposing source code and sensitive configurations publicly is a non-starter. Private repositories offer the essential security layer needed for proprietary code, internal tools, and confidential deployment manifests. Integrating these secure repositories with ArgoCD is a foundational step towards building a compliant and robust continuous delivery pipeline.

## Setting the Stage: Your ArgoCD Environment

Before diving into private repository connections, ensure you have a basic Kubernetes and ArgoCD setup:

- **Azure Kubernetes Service (AKS) Cluster:** Your operational environment where applications will be deployed.
- **ArgoCD Installation:** A running instance of ArgoCD within your AKS cluster, typically deployed via its official Helm chart for simplified management.
- **ArgoCD UI Access:** Ensure you can access the ArgoCD user interface, often through port forwarding or a configured ingress controller.

### Bridging to Private Azure DevOps Repositories with PATs

Personal Access Tokens (PATs) provide a direct and effective way for ArgoCD to authenticate with your private Azure DevOps repositories.

### Step-by-Step Configuration:

1. **Generate an Azure DevOps PAT:**

- Navigate to your Azure DevOps organization settings.
- Locate "Personal access tokens" and create a new token.
- Crucially, define its scope to grant "Code: Read" permissions. This allows ArgoCD to fetch repository content without granting unnecessary elevated access.

2. **Add the Repository in ArgoCD:**

- Access your ArgoCD UI.
- Go to the "Settings" menu, then select "Repositories."
- Click "Connect Repo" to add a new repository connection.
- Provide the full HTTPS URL of your private Azure DevOps repository.
- For authentication, use the Azure DevOps username associated with the PAT creator (often your email address or display name) and paste the generated PAT into the password field.

3. **Deploy Your Application:**

- Once the repository is successfully added, proceed to create a new ArgoCD application.
- Specify the path to your application's manifests within this newly connected private Azure DevOps repository.
- ArgoCD will now be able to synchronize and deploy your applications directly from this secure source.

## Integrating with Private GitHub Repositories using PATs
Connecting to private GitHub repositories follows a very similar pattern, leveraging GitHub Personal Access Tokens.

### Step-by-Step Configuration:

1. **Generate a GitHub PAT:**

- Access your GitHub account settings (usually found under your profile picture).
- Navigate to "Developer settings" > "Personal access tokens." It's recommended to use "Tokens (classic)" for broader compatibility, or "Fine-grained tokens" if you need highly specific permissions.
- Generate a new token.
- Ensure the token has "repo" scope access (or specific "Contents: read" permissions if using fine-grained tokens) to allow ArgoCD to clone the repository.

2. **Add the Repository in ArgoCD:**

- In the ArgoCD UI, add a new repository connection.
- Enter the full HTTPS URL of your private GitHub repository.
- For credentials, use your GitHub username and the newly generated PAT as the password.

3. **Verify Connection and Deploy:**

- After adding the repository, verify the connection by attempting to create an application that sources its manifests from this private GitHub repository.
- A successful connection indicates ArgoCD can now manage deployments from your private GitHub source.

## The Trade-offs of Personal Access Tokens

While PATs offer a straightforward and effective way to establish connections, it's crucial to acknowledge their inherent limitations:

- **User-Tied Dependency:** PATs are directly associated with a specific user account. If that user's account is deactivated or they leave the organization, the PAT becomes invalid, leading to broken deployments.
- **Expiry and Rotation:** PATs often have expiry dates (though some can be set to never expire, which is generally discouraged for security). This necessitates a manual rotation and management process, which can be cumbersome and a source of unexpected CI/CD outages if not handled diligently.
- **Secret Management Overhead:** Storing PATs as secrets within ArgoCD still requires careful secret management practices, including rotation and secure storage.

## Beyond PATs: The Path to Enhanced Security

The limitations of PATs underscore the importance of exploring more robust and automated authentication methods for critical infrastructure components like ArgoCD. Solutions leveraging cloud-native identity services, such as Azure Managed Identities or Workload Identities, represent the next evolutionary step. These approaches can eliminate the need for manually managing and rotating tokens, providing a more secure, compliant, and operationally efficient way for ArgoCD to access private repositories.

## Conclusion
Integrating ArgoCD with private Git repositories via Personal Access Tokens is a foundational skill for secure GitOps. It empowers you to maintain strict control over your code and configurations while still benefiting from ArgoCD's powerful automation capabilities. As your GitOps journey matures, however, transitioning to more advanced, token-less authentication methods like Managed Identities will further enhance your security posture and streamline your operations, paving the way for truly robust and scalable continuous delivery.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/How%20to%20Use%20ArgoCD%20with%20Private%20GitHub%20and%20Azure%20DevOps%20Repos" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "How to Use ArgoCD with Private GitHub and Azure DevOps Repos" and reviewed by me.

## How to Use ArgoCD with Private GitHub and Azure DevOps Repos

<iframe width="560" height="315" src="https://www.youtube.com/embed/HUQXdpfpz2k" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>