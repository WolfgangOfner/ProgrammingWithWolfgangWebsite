---
title: Simplifying Dockerization without a Dockerfile using .NET 8
date: 2025-04-08
author: Wolfgang Ofner
categories: [Docker, Programming]
tags: [.NET, Docker]
description: Explore the simplicity of Dockerization without a Dockerfile using .NET 8. A game-changer for developers using console-based .NET applications.
---

This blog post delves into one of the new features in .NET 8 - the ability to create Docker images without a Dockerfile. While this might seem like a minor change, it has significant implications for developers who prefer using the console for creating and building .NET applications. Whether you are a seasoned developer or a novice exploring the .NET ecosystem, this post will guide you through the nuances of this new feature, its potential use cases, and its impact on your development workflow. 

So, let's dive in and explore what .NET 8 has in store for us when working with containers.

## Prerequisites

Before you start creating container images using `dotnet publish`, make sure you have the following tools installed:

- <a href="https://dotnet.microsoft.com/en-us/download/dotnet/8.0" target="_blank" rel="noopener noreferrer">.NET 8 SDK</a> (Although .NET 7 might work, it lacks support for certain parameters. Given its end-of-life status in November 2024, I suggest using .NET 8.)
- <a href="https://www.docker.com/products/docker-desktop/" target="_blank" rel="noopener noreferrer">Docker Desktop</a>  

## Building a Sample Application and Docker Container with .NET 8 SDK

No matter what your platform is (Windows, Linux, or Mac), you can use the dotnet CLI to create a new .NET application. Let’s begin by creating a new API application with the following command:

<script src="https://gist.github.com/WolfgangOfner/fb206fa22b436e5cd3b5d02cd5bac1d5.js"></script>

This command creates a new web API application in a folder named `DotNetContainerWithoutDocker`. Navigate into the `DotNetContainerWithoutDocker` folder and run `dotnet run` to start the app.

<script src="https://gist.github.com/WolfgangOfner/33ab12a90cc2ef50dd33a358335e5cbe.js"></script>

You will see the console output that shows the API is running and the port it’s using. Don’t forget to append `/weatherforecast` to the endpoint when calling it via localhost to avoid an HTTP 404 error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Testing-the-application-without-Docker.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Testing-the-application-without-Docker.jpg" alt="Testing the application without Docker" /></a>
  
  <p>
   Testing the application without Docker
  </p>
</div>

To create a Docker image using the .NET SDK, you first need to enable `IsPublishable` and `EnableSdkContainerSupport` in the `.csproj` file:

<script src="https://gist.github.com/WolfgangOfner/244200a44c20ed614f8041fb9e45a415.js"></script>

That's all you need to set up the .NET SDK to create a Docker image from your .NET application. Let's build the container image with the following command:

<script src="https://gist.github.com/WolfgangOfner/84ce03c5ae106734060e36dfec5cb57d.js"></script>

The parameters are the same ones you would use for a regular `dotnet publish`. 
- The `--os linux` and `--arch x64` parameters target Linux with the x64 architecture.
- `-c Releases` specifies the release configuration.
- `-p:PublishProfile=DefaultContainer` tells MSBuild to create a container image. If you’re using a non-web application, like a console app, replace this parameter with `/t:PublishContainer`.

The image will have the same name as your project file (in lowercase).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Creating-a-Docker-image-with-the-project-name.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Creating-a-Docker-image-with-the-project-name.jpg" alt="Creating a Docker image with the project name" /></a>
  
  <p>
   Creating a Docker image with the project name
  </p>
</div>

## Additional Configuration Options

When running `dotnet publish`, you may encounter an error message if your project name is not a valid Docker tag. The tag must adhere to the following rules:

- Be valid ASCII.
- Contain lowercase and uppercase letters, digits, underscores, periods, and hyphens.
- Not start with a period or hyphen.
- Not exceed 128 characters in length.

To resolve this, add the `ContainerRepository` parameter to your `.csproj` file and set your preferred image name.

<script src="https://gist.github.com/WolfgangOfner/8b9a3dd27db946151fa0267dac89d7aa.js"></script>

Save the file and rerun the `dotnet publish` command. The publishing process should now complete successfully, and the new image name will be displayed in the console.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Creating-a-Docker-image-with-a-customized-name.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Creating-a-Docker-image-with-a-customized-name.jpg" alt="Creating a Docker image with a customized name" /></a>
  
  <p>
   Creating a Docker image with a customized name
  </p>
</div>

If you have been following this demonstration, you should now have two Docker images: `dotnetcontainerwithoutdocker` and `myNewImageName`. Let's initiate one of them using the `docker run` command and test if we can access the API.

<script src="https://gist.github.com/WolfgangOfner/aeab5959cbc3da41b8dda0afe79852cd.js"></script>

After executing this command, the .NET application within the container should start. However, when you attempt to access it, you will encounter an HTTP 404 error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/The-container-listens-on-port-8080.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/The-container-listens-on-port-8080.jpg" alt="The container listens on port 8080" /></a>
  
  <p>
   The container listens on port 8080
  </p>
</div>

The HTTP 404 error is due to a change in .NET 8. The default port is now 8080, not 80. The console output also indicates `Now listening on: http://[::]:8080` when the application starts. There are two ways to address this issue. The first is to simply change the port mapping in the `docker run` command from 80 to 8080.

The second option is to set the `ASPNETCORE_HTTP_PORTS` environment variable, which .NET applications read at startup and use if set. You can provide this environment variable when using `docker run` or you can add it to the `.csproj` file to have it included in the Docker image. To add it to the `.csproj` file, add the `ContainerEnvironmentVariable` parameter.

<script src="https://gist.github.com/WolfgangOfner/1e2f7a32e3265d71fb3fda247bbe68f3.js"></script>

The above code snippet configures the .NET application to listen at port `22334`. Now let's modify the `docker run` command to point to this port and test the application again. Don’t forget to run the `dotnet publish` command first, otherwise, you will use the old image that doesn’t have the added environment variable.

<script src="https://gist.github.com/WolfgangOfner/f1fdbf9c53a15884823a60ee7a3e6b9c.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Testing-the-port-provided-from-the-environment-variable.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Testing-the-port-provided-from-the-environment-variable.jpg" alt="Testing the port provided from the environment variable" /></a>
  
  <p>
   Testing the port provided from the environment variable
  </p>
</div>

The final parameter I want to discuss is the `ContainerUser` parameter, which can be used to configure the user that should run the container. Before .NET 8, all images ran by default under the root user. This is not ideal from a security perspective, and it’s recommended to use a non-root user to run the container. Since .NET 8, all images come with a non-root user named `app`. You can configure the user in the `.csproj` file with the `ContainerUser` parameter.

Use `app` as non-root user on Linux and `ContainerUser` on Windows.

<script src="https://gist.github.com/WolfgangOfner/d039f35060836e1eafe93924497b845c.js"></script>

If you try to use a user that doesn’t exist in the container, you will get an error message. For instance, I tried to use the user `wolfgang`, which doesn’t exist, and therefore, I was unable to publish the .NET application.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/The-user-wolfgang-does-not-exist-in-the-container.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/The-user-wolfgang-does-not-exist-in-the-container.jpg" alt="The user wolfgang does not exist in the container" /></a>
  
  <p>
   The user wolfgang does not exist in the container
  </p>
</div>

## Conclusion

The ability of .NET 8 to create Docker images without a Dockerfile is indeed a remarkable technological advancement. However, I understand your perspective. If you are accustomed to using Visual Studio, which automatically generates the Dockerfile for you, and you run your tests within the Dockerfile along with everything else your application requires, this feature might not seem as appealing.

Nonetheless, it's undeniable that this is a valuable addition to the .NET SDK's capabilities. For those who use the console to create and build .NET applications and simply want to package a basic app in a container, this feature could be extremely useful. It's all about finding the right tools and features that work best for your specific needs and workflow.