---
title: Restore NuGet Packages from a Private Feed when building Docker Containers
date: 2021-01-11
author: Wolfgang Ofner
categories: [Docker, DevOps]
tags: [Azure DevOps, Docker, NuGet, CI]
description: This post will show you how to create an access token for your private Azure DevOps NuGet feed and how to pass it to your Dockerfile to build Docker images.
---

[In my last posts](/publish-internal-nuget-feed), I created a private NuGet feed and automatically uploaded a NuGet package with my Azure DevOps pipeline. Using Visual Studio to restore the NuGet package from the private feed works fine because my user has access to the feed. When I try to restore the package when building a Docker image, it will crash with a 401 Unauthorized error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/The-Docker-build-failed.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/The-Docker-build-failed.jpg" alt="The Docker build failed" /></a>
  
  <p>
   The Docker build failed
  </p>
</div>

Today, I will show you how to create an access token for your private Azure DevOps NuGet feed and how to pass it to your Dockerfile to build Docker images.

## Create a Personal Access Token (PAT) in Azure DevOps

To create a personal access token in Azure DevOps, click on user settings, and select Personal access tokens.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Create-a-Personal-access-tokens.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Create-a-Personal-access-tokens.jpg" alt="Create a Personal access tokens" /></a>
  
  <p>
   Create a Personal access tokens
  </p>
</div>

This opens a new flyout window. There you can enter a name, your organization, and the expiration date. If you select Custom defined as the expiration date, you can create a PAT which is valid for one year. Select custom defined scope and then select Read in the Packaging section. This allows the PAT to read the NuGet packages from the feed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Configure-the-PAT.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Configure-the-PAT.jpg" alt="Configure the PAT" /></a>
  
  <p>
   Configure the PAT
  </p>
</div>

After you click Create, the new PAT is displayed. Make sure to copy it because you won't be able to see it again after you closed the window.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/The-PAT-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/The-PAT-got-created.jpg" alt="The PAT got created" /></a>
  
  <p>
   The PAT got created
  </p>
</div>

## Pass the PAT to build the Dockerfile locally

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

### Add a nuget.config file

The first step to restoring the NuGet package from the private feed is to add a nuget.config file to the root folder of the CustomerApi project. This file contains the URLs for the nuget.org and private feed. Since this file gets committed to source control, I don't add the PAT there because I want to keep it private. The file looks as follows:

<script src="https://gist.github.com/WolfgangOfner/28375d0e75ca00efe8032e4da0a6a334.js"></script>

### Use the PAT in the Dockerfile

Docker supports build arguments which I will use to pass the PAT inside the Dockerfile in the CI pipeline. Locally, I don't pass a PAT but I can set a default value. Additionally, I have to add the PAT and a username to the nuget.config to be able to access the private NuGet feed. the code looks as follows:

<script src="https://gist.github.com/WolfgangOfner/90904cd7210a118375ec568ca9c14219.js"></script>

Instead of localhost, use the previously created PAT. Make sure to not commit it to your source control though. Additionally, you have to copy the previously nuget.config file inside the Docker image. You can do this with the following code:

<script src="https://gist.github.com/WolfgangOfner/2f10984ed3a70d27a523d5e13aa05d43.js"></script>

To use the nuget.config file during the restore, use the --configfile flag and provide the path to the nuget.config file.

<script src="https://gist.github.com/WolfgangOfner/878b19f724adb6c12843393ce4ac4cdb.js"></script>

You can find the finished Dockerfile on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/CustomerApi/Dockerfile" target="_blank" rel="noopener noreferrer">GitHub</a>.

Run the docker build again and it will finish successfully this time.

## Pass the PAT in the Azure DevOps Pipeline

In the Azure DevOps pipeline, create a new secret variable for the PAT. To do that, open the pipeline and then click on Variables on the right top. Click on the + symbol and then provide a name for the variable and the value of the PAT. Make sure to enable Keep this value secret to hide the actual value from users.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Create-a-secret-variable-for-the-PAT.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Create-a-secret-variable-for-the-PAT.jpg" alt="Create a secret variable for the PAT" /></a>
  
  <p>
   Create a secret variable for the PAT
  </p>
</div>

Next, add the build-arg parameter to the docker build task and provide the previously created variable as PAT. The whole task looks as follows:

<script src="https://gist.github.com/WolfgangOfner/dc83eb924ad195c33e4d8283b6f18b87.js"></script>

That's already all to restore the NuGet package from a private feed. Run the pipeline it will finish successfully.

## Conclusion

You can create a private access token (PAT) to access NuGet packages of a private NuGet feed in Azure DevOps. This token can be passed to the Dockerfile as a build argument and then inside the Dockerfile be added to the nuget.config file. This allows you to restore private NuGet packages locally and in your Azure DevOps pipeline without committing your secret PAT to source control.

Note: If you run this demo, it will work without my private feed because I uploaded the NuGet package to nuget.org.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).