---
title: Deploy Applications from private Repositories using Flux GitOps and Azure Arc
date: 2023-06-19
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [GitOps, Flux, Azure Arc, PAT, GitHub, Azure DevOps, Kubernetes]
description: Effortlessly deploy applications from private repositories with Flux GitOps and Azure Arc. Streamline and optimize your deployment process for enhanced control and efficiency.
---

[In my previous post](/secure-application-deployments-azure-arc-flux-gitops), I provided a comprehensive guide on installing a GitOps operator and seamlessly deploying an application with the Azure Arc Flux extension. The demonstration involved utilizing an application sourced from a public repository, an approach commonly observed in various scenarios. However, it is essential to acknowledge that the majority of organizations prefer hosting their applications in private repositories.

In today's post, I aim to delve into the process of configuring the Flux GitOps operator to establish privileged access to a private Git repository situated on the widely adopted GitHub platform. By unraveling the necessary steps and techniques, I hope to equip you with the knowledge and expertise required to navigate the intricacies of private repository integration effectively.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Deploy an Application from a private GitHub Repository

To facilitate the deployment of an application residing within a private GitHub (or any Git) repository, the command employed remains unchanged from [the previous post](/secure-application-deployments-azure-arc-flux-gitops). Utilize the same command, as follows:

<script src="https://gist.github.com/WolfgangOfner/85b6ba3a64d54a1b77c418e0c453cee8.js"></script>

The sole distinction lies in the utilization of the --url parameter, where you specify the private repository. Notably, the application in this repository is the same as I used in the previous post. Additionally, I have included a demo from Microsoft, which can be found on their <a href="https://github.com/Azure/gitops-flux2-kustomize-helm-mt" target="_blank" rel="noopener noreferrer">GitHub</a>.

Open the Azure portal and navigate to the GitOps pane of your Azure Arc instance. There, you will discover the pre-established GitOps operator. Although the deployment process has succeeded, it is noteworthy that the operator is presently labeled as "Non-compliant".

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-GitOps-operator-is-not-compliant.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-GitOps-operator-is-not-compliant.jpg" alt="The GitOps operator is not compliant" /></a>
  
  <p>
   The GitOps operator is not compliant
  </p>
</div>

You can find more detailed information of the GitOps operator by clicking on it, followed by selecting the Configuration objects pane. Within this section, you will encounter three configuration objects, all of which are flagged as non-compliant and exhibit an error message. These configuration objects encompass the GitOps operator itself and the two configuration files that were provided during the installation process via the --kustomization parameter.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-configuraiton-objects-display-an-error.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-configuraiton-objects-display-an-error.jpg" alt="The configuraiton objects display an error" /></a>
  
  <p>
   The configuraiton objects display an error
  </p>
</div>

Within the message of the gitopsoperator object, you will encounter a specific error message that sheds light on the encountered issue: "failed to checkout and determine revision; unable to clone repository." The underlying cause of this error can be attributed to the GitOps operator's inability to clone the repository, primarily due to its private nature, consequently depriving the operator of the necessary access permissions.

## Create an Access Token to access private Git Repositories on GitHub

To provide the GitOps operator with access to a private Git repository on GitHub, you have the option of utilizing SSH keys or a Personal Access Token (PAT). In this demo, I will generate and use a PAT.

First, open GitHub and click on your profile located in the top-right corner, then select "Settings."

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Open-the-settings-on-GitHub.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Open-the-settings-on-GitHub.jpg" alt="Open the settings on GitHub" /></a>
  
  <p>
   Open the settings on GitHub
  </p>
</div>

Within the settings page, navigate to "Developer settings." 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Open-the-developer-settings.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Open-the-developer-settings.jpg" alt="Open the developer settings" /></a>
  
  <p>
   Open the developer settings
  </p>
</div>

In the Developer settings section, select "Personal access tokens" and click on "Generate new token."

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Open-the-personal-access-token-page.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Open-the-personal-access-token-page.jpg" alt="Open the personal access token page" /></a>
  
  <p>
   Open the personal access token page
  </p>
</div>

On the personal access token page, you can configure the access token settings. Provide it with a meaningful name, set the expiration time, and select the desired scopes. For this demo, I will grant the access token full control over private repositories. However, it is advisable to assign the token the minimum required permissions based on your specific needs.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Configure-the-personal-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Configure-the-personal-access-token.jpg" alt="Configure the personal access token" /></a>
  
  <p>
   Configure the personal access token
  </p>
</div>

Scroll to the bottom of the page and click on "Generate token" to create the access token.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Generate-the-Token.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Generate-the-Token.jpg" alt="Generate the Token" /></a>
  
  <p>
   Generate the Token
  </p>
</div>

Once the token is generated, it will be displayed on the screen. It is crucial to save the token in a secure location as this is the only instance you will be able to view it. If you close the window without saving the token, you will lose access to it. In the event that the token is lost, you will need to regenerate it or create a new one.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-PAT-is-displayed-after-it-is-created.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-PAT-is-displayed-after-it-is-created.jpg" alt="The PAT is displayed after it is created" /></a>
  
  <p>
   The PAT is displayed after it is created
  </p>
</div>

Please note that the displayed access token should be handled with care and stored securely to maintain the integrity and security of your GitHub repositories.

## Create an Access Token to access private Git Repositories on Azure DevOps

Creating a personal access token (PAT) to access private Git repositories on Azure DevOps follows a similar process to GitHub. Please follow the steps below:

Click on the Settings icon located in the top-right corner of Azure DevOps, then select "Personal access tokens."

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Select-Personal-access-tokens-in-Azure-DevOps.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Select-Personal-access-tokens-in-Azure-DevOps.jpg" alt="Select Personal access tokens in Azure DevOps" /></a>
  
  <p>
   Select Personal access tokens in Azure DevOps
  </p>
</div>

Configure the PAT by providing it with a name, expiration time, and selecting the desired scope based on your requirements.

Click on "Create" to generate the PAT.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Create-the-Azure-DevOps-PAT.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Create-the-Azure-DevOps-PAT.jpg" alt="Create the Azure DevOps PAT" /></a>
  
  <p>
   Create the Azure DevOps PAT
  </p>
</div>

Similar to GitHub, this is your only opportunity to copy the token. Once copied, ensure that you securely store it.

After copying the token, you can close the window.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Copy-the-created-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Copy-the-created-access-token.jpg" alt="Copy the created access token" /></a>
  
  <p>
   Copy the created access token
  </p>
</div>

Remember, it is crucial to handle the access token securely and store it in a safe location to maintain the confidentiality and security of your Azure DevOps repositories.

## Configure the Flux GitOps Operator with the Personal Access Token

Once you have obtained the personal access token (PAT), go to the GitOps operator in the Azure Portal. Inside the GitOps operator, navigate to the Source pane, where you can view the current configuration of the operator, including the URL and branch.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Configure-the-Source-of-the-GitOps-operator.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Configure-the-Source-of-the-GitOps-operator.jpg" alt="Configure the Source of the GitOps operator" /></a>
  
  <p>
   Configure the Source of the GitOps operator
  </p>
</div>

In the Authentication section, select "Provide authentication information here." Enter the username associated with the personal access token you created and paste the token in the provided field.

Click on "Apply." After a few minutes, you should observe the creation of several objects, and all of them should be in a running state, indicating a successful deployment. Additionally, the GitOps operator should be in a "Complient" state now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/The-deployment-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/The-deployment-succeeded.jpg" alt="The deployment succeeded" /></a>
  
  <p>
   The deployment succeeded
  </p>
</div>

To verify the new resources, you can use the CLI tool kubectl. Execute the necessary commands, such as kubectl get namespaces, to check the newly created namespaces.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/06/Several-namespaces-were-created.jpg"><img loading="lazy" src="/assets/img/posts/2023/06/Several-namespaces-were-created.jpg" alt="Several namespaces were created" /></a>
  
  <p>
   Several namespaces were created
  </p>
</div>

## Conclusion

In conclusion, integrating the Flux GitOps operator with private Git repositories follows a similar process to working with public repositories. The key difference lies in granting the operator access to the private repository. Access can be provided through SSH keys or by utilizing a personal access token (PAT).

Creating a PAT involves a straightforward process, which is almost identical in both GitHub and Azure DevOps. By generating and configuring a PAT, you empower the GitOps operator to securely access and deploy resources from the private repository.

Whether using SSH keys or a PAT, incorporating private Git repositories into your GitOps workflow with the Flux GitOps operator enables efficient and controlled application deployments, regardless of the repository's visibility.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).