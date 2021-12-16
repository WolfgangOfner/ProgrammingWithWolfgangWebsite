---
title: Upgrade a Microservice from .NET Core 3.1 to .NET 5.0
date: 2020-11-11
author: Wolfgang Ofner
categories: [ASP.NET, Docker]
tags: [Azure DevOps, CI, Docker, xUnit, .NET 5]
description: Upgrading from .NET Core 3.1 to .NET 5.0 is very fast and when using microservices can be easily done within a single day.
---

Microsoft released the next major release, called .NET 5.0 which succeeds .NET Core 3.1. .NET 5.0 comes with a lot of improvements and also with C# 9. It also is the first step of a unified .NET platform and is the first version of Microsofts new release cycle. From now on, Microsoft will release a new version of .NET every November. .NET 6.0 will be released in November 2021, .NET 7.0 in November 2022, and so on.

Today, I want to show how to upgrade a microservice and its build pipeline from .NET Core 3.1 to .NET 5.0. You can find the code of this demo on [GitHub](https://github.com/WolfgangOfner/MicroserviceDemo).

## System Requirements for .NET 5.0
To use .NET 5.0 you have to install the .NET 5.0 SDK from the [dotnet download page](https://dotnet.microsoft.com/download/dotnet/5.0) and [Visual Studio 16.8 or later](https://visualstudio.microsoft.com/downloads).

## Uprgrade from .NET Core 3.1 to .NET 5.0
To upgrade your solution to .NET 5.0, you have to update the TargetFramework in every .csproj file of your solution. Replace 

<script src="https://gist.github.com/WolfgangOfner/cdfd7fdc3d33834b5ab9e94fb86bcd07.js"></script>

with

<script src="https://gist.github.com/WolfgangOfner/fe7e83a1e8ef8151406b4fbf002516cc.js"></script>

Instead of updating all project files and next year updating them again, I created a new file called common.props in the root folder of the solution. This file contains the following code:

<script src="https://gist.github.com/WolfgangOfner/4eefad732a9e54713340e5364896f507.js"></script>

This file defines the C# version I am using and sets DefaultTargetFramework to net5.0. Additionally, I have a Directory.Build.props file with the following content:

<script src="https://gist.github.com/WolfgangOfner/23995e5a73196b0b92cec8cbeb22df9a.js"></script>

This file links the common.props file to the .csproj files. After setting this up, I can use this variable in my project files and can update with it all my projects with one change in a single file. Update the TargetFramework of all your .csproj files with the following code:

<script src="https://gist.github.com/WolfgangOfner/e69b3da0ae0a8496f2a056e2a97ba7a8.js"></script>

After updating all project files, update all NuGet packages of your solution. You can do this by right-clicking your solution --> Manage NuGet Packages for Solution...

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Update-Nuget-packages.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Update-Nuget-packages.jpg" alt="Update NuGet packages" /></a>
  
  <p>
    Update your NuGet packages
  </p>
</div>

That's it. Your solution is updated to .NET 5.0. Build the solution to check that you have no errors.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Build-the-solution.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Build-the-solution.jpg" alt="Build the solution" /></a>
  
  <p>
    Build the solution
  </p>
</div>

Additionally, run all your tests to make sure your code still works.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Run-all-unit-tests.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Run-all-unit-tests.jpg" alt="Run all unit tests" /></a>
  
  <p>
    Run all unit tests
  </p>
</div>

Lastly, I update the path to the XML comments in the CustomerApi.csproj file with the following code:

<script src="https://gist.github.com/WolfgangOfner/90b782649bee40a0fe2861c50526e824.js"></script>

## Update CI pipeline

There are no changes required in the CI pipeline because the solution is built-in Docker. Therefore, I have to update the Dockerfile. Replace the following two lines:

<script src="https://gist.github.com/WolfgangOfner/3d8fe7ec7dd8b6c1c82c4e99418c200b.js"></script>

with 

<script src="https://gist.github.com/WolfgangOfner/ddc336ebc6a693235ab2510e1b7fa726.js"></script>

This tells Docker to use the new .NET 5.0 images to build and run the application. Additionally, I have to copy the .props files into my Docker image with the following code inside the Dockerfile:

<script src="https://gist.github.com/WolfgangOfner/87de6c2717ea4c1c1d6c24a9fb1551fe.js"></script>

Check in your changes and the build pipeline in Azure DevOps will run successfully.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/The-Net-5-build-was-successful.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/The-Net-5-build-was-successful.jpg" alt="The .NET 5.0 build was successful" /></a>
  
  <p>
    The .NET 5.0 build was successful
  </p>
</div>

## Conclusion
Today, I showed how easy it can be to upgrade .NET Core 3.1 to .NET 5.0. To upgrade was so easy because I kept my solution up to date and because microservices are small solutions that are way easier to upgrade than big monolithic applications. The whole upgrade for both my microservices took around 10 minutes. I know that a real-world microservice will have more code than mine but nevertheless, it is quite easy to update it. If you are coming from .NET Core 2.x or even .NET 4.x, the upgrade might be harder.

You can find the code of this demo on [GitHub](https://github.com/WolfgangOfner/MicroserviceDemo).

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).