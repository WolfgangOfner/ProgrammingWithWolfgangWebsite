---
title: Create NuGet Packages in Azure DevOps Pipelines
date: 2020-12-28
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, NuGet, CI]
description: In this post, I will show how to share code using NuGet packages and how to automatically create them in an Azure DevOps pipeline.
---

I think the most important rule of a microservice is that it has to be deployed independently. When your project or company grows, it is very likely that you want to share code between projects or microservices. This leads to the question of how to share the code? Should you copy it into your microservice, reference dlls, or should every team develop its own code independently?

In this post, I will show how to share code using NuGet packages and how to automatically create them in an Azure DevOps pipeline.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## How to share Code between Microservices

There are several methods of sharing code between microservices but I think most of them are bad. Let's have a look at the available options.

### Don't share Code

Not sharing code between microservices helps to keep them independent but this means that each microservice must develop all features by itself. This can lead to a lot of unnecessary development time and therefore costs a lot of money. Therefore, not sharing code is not an option.

### Referencing Dlls

I prefer having all microservices in a big repository. This allows you to reference code from a different project. You could create a "Shared" folder and create in there projects which are shared between several microservices. The problem with this approach is that when one team changes the code, it changes the code for all microservices that reference the code. This will certainly lead to unintended and unexpected behavior. Since we want bug-free code, this option is not good to share code.

### Create Code and then copy it to Microservices

Another option would be to create a new project with the code and use this code as the base for further developments. If a microservice wants to use this code, then copy it into their own project and then can edit it without interfering with other microservices. This solution sounds better than the previous one but this leads to a lot of overhead. All these versions will go in different directions, therefore it will take a lot of time to do simple changes, for example, updating the .NET version of the project. This has to be done in each implementation instead of in one central one. Therefore this solution is also not good.

### Share Code with NuGet Packages

If you want to get external code and have control over it, NuGet packages are perfect. You can install the version you need and also can update whenever you have to. If the NuGet package gets updated but you don't want to update yours, it's no problem at all. The source code of the NuGet package exists only once, therefore it can be updated or modified quickly. Once a new version is released, every microservice can update it whenever they want.

## Create the Source for the NuGet Package

You can find the code of the whole demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

For this Demo, I will create a simple NuGet package that offers one method which takes an integer and then calculates a prime number, depending on the input. Prime numbers are, for example, 2, 3, 5, 7, 11, and so on. The input parameter indicates the number you want, for example, if you input 2, the second prime number, 3, is returned. If you input 4, the fourth prime number, 7 is returned. I know this is not going to be the most useful NuGet package but calculating prime numbers is quite CPU intensive and I will use this method in a later example to demonstrate autoscaling if the CPU limit is reached.

I created a new folder in the root of my repository and called it NuGet. Inside this folder, I created a new folder called Prime Number which contains a new .NET 5 class library project. The class library consists only of one class with one method to calculate the prime number.

<script src="https://gist.github.com/WolfgangOfner/4b7439c21446bd7be3a89b616eb04d5f.js"></script>

To make sure that the code does what I expect it to do, I created a test project to test it.

<script src="https://gist.github.com/WolfgangOfner/28c4a68faa20855da75388d11753402a.js"></script>

That's already all the code you need for the NuGet package. You could create the NuGet package manually by executing nuget pack in the root folder of the project but in the next section, I will show you how to create it automatically in an Azure DevOps pipeline.

## Create NuGet Package in Azure DevOps Pipeline

I created a new pipeline in Azure DevOps to create the NuGet package. For more information about the basics of build pipelines read my post [Build .NET Core in a CI Pipeline in Azure DevOps](/build-net-core-in-ci-pipeline-in-azure-devops).

The pipeline is going to be very simple but let's have a look step-by-step. 

The first part is configuring when the pipeline should run, what agent it uses, and two variables. I run the pipeline every time something is changed inside the NuGet folder, except if it's inside a Test folder. 

<script src="https://gist.github.com/WolfgangOfner/555f20a07c66f5281dcfa1a37611a7c3.js"></script>

The next section defines a stage called build and creates a version number. If you want to learn more about the build versioning see [Automatically Version Docker Containers in Azure DevOps CI](/automatically-version-docker-container).

<script src="https://gist.github.com/WolfgangOfner/2fe799c64526b949eb886b34e798f8e2.js"></script>

After the version number is calculated, I execute dotnet restore and then dotnet build on all csproj files inside the NuGet folder.

<script src="https://gist.github.com/WolfgangOfner/45604237453fc3dc02a738dda71b6827.js"></script>

The next step is to run the unit tests and publish the code coverage results. If a test fails, I will stop the pipeline and don't create the NuGet package.

<script src="https://gist.github.com/WolfgangOfner/968d8bbadc48e72f7cfa2e080c3223fa.js"></script>

The last two tasks create the NuGet package using dotnet pack and then publish the generated artifacts. Dotnet pack is executed on all project files inside the NuGet folder which don't end with Test.csproj. This means that the test project doesn't get packed into a NuGet package. The publish of the artifacts will be used in the next stage to publish the artifact to a private NuGet feed and in another stage to publish it to nuget.org. You can read about publishing in my next post. 

<script src="https://gist.github.com/WolfgangOfner/27a9d993f2ada81e84863cbc42a0f354.js"></script>

You can find the finished pipeline on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/Nuget/pipelines/Nuget-CI-CD.yml" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Test the NuGet from the Pipeline

Run the pipeline and after it is finished successfully, you can find the NuGet package as an attachment of the build. In your build click on 2 published.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/Find-the-Nuget-package-in-the-build.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/Find-the-Nuget-package-in-the-build.jpg" alt="Find the NuGet package in the build" /></a>
  
  <p>
   Find the NuGet package in the build
  </p>
</div>

Open the packages-nuget folder and there you can find the created NuGet package.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/12/The-created-Nuget-package.jpg"><img loading="lazy" src="/assets/img/posts/2020/12/The-created-Nuget-package.jpg" alt="The created NuGet package" /></a>
  
  <p>
   The created NuGet package
  </p>
</div>

Download it and install it in your microservice. [In my next post](/publish-internal-nuget-feed), I will show you how to automatically upload it to a NuGet feed in the Azure DevOps pipeline and how to install it from there.

## Conclusion

Sharing code between microservices can be tricky but with NuGet packages, it is very simple and organized. In this post, I showed you how to automatically create a NuGet package using Azure DevOps pipelines. [In my next post](/publish-internal-nuget-feed), I will show how to upload the NuGet package to a NuGet feed with the same Azure DevOps pipeline and how to use it in your microservices.

You can find the code of the whole demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).