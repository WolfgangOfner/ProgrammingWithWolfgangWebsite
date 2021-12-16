---
title: Publish NuGet Packages to Nuget.org using Azure DevOps Pipelines
date: 2021-01-18
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, NuGet, CI]
description: If you want to share your NuGet packages, you should automatically upload them using an Azure DevOps pipeline.
---

[In my last posts](/publish-internal-nuget-feed), I published my NuGet package to a private NuGet feed. This is a good solution if you want to use your NuGet packages only internally. If you want to share them, you need a public NuGet feed. The by far biggest one (also the default feed) is nuget.org. 

In this post, I will extend my previously created Azure DevOps pipeline and deploy the NuGet package to nuget.org so everyone can download and use it.

## Create a Nuget.org API Key

To be able to push NuGet packages to nuget.org, you have to obtain an API key first. Go to nuget.org and signup or login and then click on your profile and select API Keys.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Create-a-nuget-api-key.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Create-a-nuget-api-key.jpg" alt="Create a NuGet api key" /></a>
  
  <p>
   Create a NuGet API key
  </p>
</div>

This opens the API keys page of your account. There click on + Create and enter a name and expiry date. Additionally, select which packages you want to associate with your key. I uploaded the NuGet package by hand before, therefore I can see it in the list. Click Create and the API key gets generated.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Generate-a-nuget-API-key.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Generate-a-nuget-API-key.jpg" alt="Generate a NuGet API key" /></a>
  
  <p>
   Generate a NuGet API key
  </p>
</div>

Make sure that you click Copy after the API key is generated. This is the only time you can access the key. If you don't copy it, you have to refresh it to get a new one.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Copy-the-API-key.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Copy-the-API-key.jpg" alt="Copy the API key" /></a>
  
  <p>
   Copy the API key
  </p>
</div>

## Create a NuGet Connection in Azure DevOps

The next step is to use the previously created API key to connect Azure DevOps with nuget.org. In your Azure DevOps project, click on Project settings and then Service connections. There click on New service connection and select NuGet. Select ApiKey as the authentication method, enter https://api.nuget.org/v3/index.json as the feed URL, and paste the previously create NuGet API key in the ApiKey textbox. Provide a name and then click Save.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Create-a-nuget-service-connection.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Create-a-nuget-service-connection.jpg" alt="Create a NuGet service connection" /></a>
  
  <p>
   Create a NuGet service connection
  </p>
</div>

## Publish to Nuget.org using an Azure DevOps Pipeline

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

The last step is to use the previously created service connection to extend the Azure DevOps pipeline and push the NuGet package to nuget.org. Publishing to nuget.org is almost the same as publishing to a private NuGet feed.

First, I create a name stage in which I download the previously created NuGet package.

<script src="https://gist.github.com/WolfgangOfner/dba1efbc1a4995115fe0ed981941dc75.js"></script>

Next, I push the NuGet package to nuget.org using the dotnet core nuget push command. The only difference to push to the internal feed is that I use as feed type external and as publishFeedCredentials the previously created service connection.

<script src="https://gist.github.com/WolfgangOfner/c836a95a5b8bc3a4fda45490447af23f.js"></script>

For more details about the steps see my post [Publish to an Internal NuGet Feed in Azure DevOps](/publish-internal-nuget-feed). 

That's all you have to do. Save the pipeline and run it. You can find the finished pipeline on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/Nuget/pipelines/Nuget-CI-CD.yml" target="_blank" rel="noopener noreferrer">GitHub</a>.

## DotNetCore currently does not support using an encrypted Api Key

When you run the pipeline, you will get an error while publishing the NuGet package to nuget.org. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Publishing-to-nuget-failed.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Publishing-to-nuget-failed.jpg" alt="Publishing to nuget.org failed" /></a>
  
  <p>
   Publishing to nuget.org failed
  </p>
</div>

Everything is set up correctly but there is a bug (or missing feature) in Dotnet Core and therefore you can't use an API key to push packages. There is an open <a href="https://github.com/microsoft/azure-pipelines-tasks/issues/7160" target="_blank" rel="noopener noreferrer">GitHub</a> issue which was created in 2018 but Microsoft has ignored the problem so far.

### Bug Workaround

Luckily there is a workaround until (if ever) Microsoft fixes the problem. You can use a dotnetcore custom command and provide the appropriate arguments to push to nuget.org.

<script src="https://gist.github.com/WolfgangOfner/d19c40fc568a6f638c26acb5b2b3694c.js"></script>

You tell the command which packages it should push, -s declares the destination, and -k provides the nuget.org API key. The best practice for secret variables is to create a new variable inside the pipeline by clicking on Variables on the top right corner and then click + on the pop-out. Provide a name and previously copied API key. Additionally, check "Keep this value secret" so no user can read the value. Click on OK and run the pipeline again.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/Publishing-the-nuget-package-worked.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/Publishing-the-nuget-package-worked.jpg" alt="Publishing the NuGet package worked" /></a>
  
  <p>
   Publishing the NuGet package worked
  </p>
</div>

This time the publish worked.

## Conclusion

Publishing a NuGet package to nuget.org works almost as the publish to a private Azure DevOps feed. Unfortunately, Microsoft has a bug in their dotnetcore task and therefore it is not working as expected. This post showed how you still can use an Azure DevOps pipeline to push a NuGet package to nuget.org using a small workaround.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).