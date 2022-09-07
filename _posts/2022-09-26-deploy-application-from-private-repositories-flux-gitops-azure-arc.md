---
title: Deploy Applications from private Repositories using Flux GitOps and Azure Arc
date: 2022-09-26
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Kubernetes, k3s, Rancher, On-premises, Azure Arc, Git, Azure DevOps, GitHub, Helm, Kustomize]
description: Using the Flux GitOps operator with private Git repositories works the same way as it does with public ones. The only difference is that you have to give the operator access to the private repo. 
---

[In my last post](/XXX), I showed you how to install a GitOps operator and deploy an application using Helm charts. For this demo, I used an application from a public repository. Almost all companies host their applications in private repositories though.

Today, I want to show how you can configure the Flux GitOps operator to gain access to a private Git repository on GitHub.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).

## Deploy an Application from a private GitHub Repository

To deploy an application from a private GitHub (or any Git) repository, use the same command as in the last post:

<script src="https://gist.github.com/WolfgangOfner/85b6ba3a64d54a1b77c418e0c453cee8.js"></script>

The only difference is that I am using a private repository with the --url parameter. The application in this repository is the same as I used in my last post, except that I copied the demo from Microsoft into this private repo.

Wait a minute and then open your Azure Arc in the Azure Portal. Navigate to the GitOps pane and there you should see the previously created GitOps operator. The deployment succeeded but you will see that the operator is "Non-compliant" and shows a warning.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/The-GitOps-operator-is-not-compliant.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/The-GitOps-operator-is-not-compliant.jpg" alt="The GitOps operator is not compliant" /></a>
  
  <p>
   The GitOps operator is not compliant
  </p>
</div>

For more information, click on the GitOps operator and then select the Configuration objects pane. There you can see 3 configuration objects that are all non-compliant and displaying an error message. These configuration objects are the GitOps operator itself and the 2 configuration files you provided with the --kustomization parameter during the installation process.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/The-configuraiton-objects-display-an-error.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/The-configuraiton-objects-display-an-error.jpg" alt="The configuraiton objects display an error" /></a>
  
  <p>
   The configuraiton objects display an error
  </p>
</div>

The message of the gitopsoperator object displays the error message that tells you what went wrong: "failed to checkout and determine revision; unable to clone repository". The GitOps operator couldn't clone the repository because it is private and the operator has no permission to access it.

## Create an Access Token to access private Git Repositories on GitHub

You can grant the GitOps operator access to a private Git repository using SSH keys or a Personal Access Token (PAT). For this demo, I will show you how to create and use a PAT. Open GitHub, click on your profile in the top-right corner, and select Settings.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Open-the-settings-on-GitHub.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Open-the-settings-on-GitHub.jpg" alt="Open the settings on GitHub" /></a>
  
  <p>
   Open the settings on GitHub
  </p>
</div>

On the settings page, select Developer settings.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Open-the-developer-settings.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Open-the-developer-settings.jpg" alt="Open the developer settings" /></a>
  
  <p>
   Open the developer settings
  </p>
</div>

In the Developer settings, select Personal access tokens and then click on Generate new token.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Open-the-personal-access-token-page.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Open-the-personal-access-token-page.jpg" alt="Open the personal access token page" /></a>
  
  <p>
   Open the personal access token page
  </p>
</div>

This page allows you to configure the access token. Give it a name, set the expiration time, and select the desired scopes. For this demo, I give the access token full control of my private repositories. There is a long list of permissions though. This enables you to configure exactly what you need. It is best practice to give the token as few permissions as possible.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Configure-the-personal-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Configure-the-personal-access-token.jpg" alt="Configure the personal access token" /></a>
  
  <p>
   Configure the personal access token
  </p>
</div>

Scroll all the way down and click on Generate token to create the access token. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Open-the-personal-access-token-page.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Open-the-personal-access-token-page.jpg" alt="Open the personal access token page" /></a>
  
  <p>
   Open the personal access token page
  </p>
</div>

The token will be displayed after it is created. It is important to save the token in a save location because this is the only time that you can see the token. If you close the window, you have no access to it anymore. In case you lose the token, you have to regenerate it or create a new one.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/The-PAT-is-displayed-after-it-is-created.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/The-PAT-is-displayed-after-it-is-created.jpg" alt="The PAT is displayed after it is created" /></a>
  
  <p>
   The PAT is displayed after it is created
  </p>
</div>

## Create an Access Token to access private Git Repositories on Azure DevOps

Azure DevOps works very similarly when it comes to creating a personal access token. Click on the Settings icon on the top-right corner and then select Personal access tokens

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Select-Personal-access-tokens-in-Azure-DevOps.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Select-Personal-access-tokens-in-Azure-DevOps.jpg" alt="Select Personal access tokens in Azure DevOps" /></a>
  
  <p>
   Select Personal access tokens in Azure DevOps
  </p>
</div>

On the user settings page, click on + New Token and then configure your PAT with a name, expiration time, and the scope. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Select-Personal-access-tokens-in-Azure-DevOps.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Select-Personal-access-tokens-in-Azure-DevOps.jpg" alt="Select Personal access tokens in Azure DevOps" /></a>
  
  <p>
   Select Personal access tokens in Azure DevOps
  </p>
</div>

Click on create and the PAT gets created. As in GitHub, you also only have here the only chance to copy the token. After you copied it, close the window.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Copy-the-created-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Copy-the-created-access-token.jpg" alt="Copy the created access token" /></a>
  
  <p>
   Copy the created access token
  </p>
</div>

## Configure the Flux GitOps Operator with the Personal Access Token

With the access token in hand, go back to the GitOps operator in the Azure Portal. Inside the GitOps operator, open the Source pane and there you can see the configuration of the operator such as the URL or the branch.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Configure-the-Source-of-the-GitOps-operator.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Configure-the-Source-of-the-GitOps-operator.jpg" alt="Configure the Source of the GitOps operator" /></a>
  
  <p>
   Configure the Source of the GitOps operator
  </p>
</div>

In the Authentication section, select Provide authentication information here, enter the user name under which you create the personal access token, and then past the token. Click on Apply and in a couple of minutes, you should see that several objects have been created and all are running.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/The-deployment-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/The-deployment-succeeded.jpg" alt="The deployment succeeded" /></a>
  
  <p>
   The deployment succeeded
  </p>
</div>

Additionally, you could use the CLI kubectl to check the new resources, such as the newly created namespaces.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/09/Several-namespaces-were-created.jpg"><img loading="lazy" src="/assets/img/posts/2022/09/Several-namespaces-were-created.jpg" alt="Several namespaces were created" /></a>
  
  <p>
   Several namespaces were created
  </p>
</div>

## Conclusion

Using the Flux GitOps operator with private Git repositories works the same way as it does with public ones. The only difference is that you have to give the operator access to the private repo. This can be done with SSH keys, or as shown in this post, with a personal access token. Creating this token has almost the same steps in GitHub and Azure DevOps.

This post is part of ["Azure Arc Series - Manage an on-premises Kubernetes Cluster with Azure Arc"](/manage-on-premises-kubernetes-with-azure-arc).