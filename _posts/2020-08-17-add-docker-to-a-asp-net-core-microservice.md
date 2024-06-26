---
title: Add Docker to an ASP .NET Core Microservice
date: 2020-08-17T18:31:42+02:00
author: Wolfgang Ofner
categories: [Docker]
tags: [.NET Core 3.1, Docker, Microservice]
description: Microservices need to be deployed often and fast. Docker container help to achieve these tasks and run them wherever needed.
---
Microservices need to be deployed often and fast. To achieve this, they often run inside a Docker container. In this post, I will show how easy it is to add Docker support to a project using Visual Studio.

## What is Docker?

Docker is the most popular container technology. It is written in Go and open-source. A container can contain a Windows or Linux application and will run the same, no matter where you start it. This means it runs the same way during development, on the testing environment, and on the production environment. This eliminates the famous “It works on my machine”.

Another big advantage is that Docker containers share the host system kernel. This makes them way smaller than a virtual machine and enables them to start within seconds or even less. For more information about Docker, check out <a href="https://www.docker.com/resources/what-container" target="_blank" rel="noopener noreferrer">Docker.com</a>. There you can also download Docker Desktop which you will need to run Docker container on your machine.

For more information, see my post &#8220;<a href="/dockerize-an-asp-net-core-microservice-and-rabbitmq/" target="_blank" rel="noopener noreferrer">Dockerize an ASP .NET Core Microservice and RabbitMQ</a>&#8221;

## Add Docker Support to the Microservice

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/.NETCoreMicroserviceCiCdAks/tree/AddDocker" target="_blank" rel="noopener noreferrer">GitHub</a>.

Open the solution with Visual Studio 2019 and right-click on the CustomerApi project. Then click on Add and select Docker Support&#8230;

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/08/Add-Docker-Support-to-the-API-project.jpg"><img loading="lazy" src="/assets/img/posts/2020/08/Add-Docker-Support-to-the-API-project.jpg" alt="Add Docker Support to the API project" /></a>
  
  <p>
    Add Docker Support to the API project
  </p>
</div>

This opens a window where you can select the operating system for your project. If you don&#8217;t have a requirement to use Windows, I would always use Linux since it is smaller and therefore faster.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/08/Select-the-operating-system-for-the-Docker-container.jpg"><img loading="lazy" src="/assets/img/posts/2020/08/Select-the-operating-system-for-the-Docker-container.jpg" alt="Select the operating system for the Docker container" /></a>
  
  <p>
    Select the operating system for the Docker container
  </p>
</div>

After you clicked OK, a Dockerfile was added to the project and in Visual Studio you can see that you can start the project with Docker now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/08/Start-the-project-in-Docker.jpg"><img loading="lazy" src="/assets/img/posts/2020/08/Start-the-project-in-Docker.jpg" alt="Start the project in Docker" /></a>
  
  <p>
    Start the project in Docker
  </p>
</div>

Click F5 to start the application and your browser will open. To prove that this application runs inside a Docker container, check what containers are running. You can do this with the following command:

<script src="https://gist.github.com/WolfgangOfner/a602fa59fe5e7037b4c22b37021fddbe.js"></script>

On the following screenshot, you can see that I have one container running with the name CustomerApi and it runs on port 32770. This is the same port as the browser opened.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/08/The-microservice-is-running-inside-a-Docker-container.jpg"><img loading="lazy" src="/assets/img/posts/2020/08/The-microservice-is-running-inside-a-Docker-container.jpg" alt="The microservice is running inside a Docker container" /></a>
  
  <p>
    The microservice is running inside a Docker container
  </p>
</div>

## The Dockerfile explained

Visual Studio generates a so-called multi-stage Dockerfile. This means that several images are used to keep the output image as small as possible. The first line in the Dockerfile uses the ASP .NET Core 3.1 runtime and names it base. Additionally, the ports 80 and 443 are exposed so we can access the container with HTTP and HTTPs later.

<script src="https://gist.github.com/WolfgangOfner/0f4c1669f8090d6baaeac74be982e0ef.js"></script>

The next section uses the .NET Core 3.1 SDK to build the project. This image is only used for the build and won&#8217;t be present in the output container. As a result, the container will be smaller and therefore will start faster. Additionally the projects are copied into the container.

<script src="https://gist.github.com/WolfgangOfner/c5cec4a97f13b38096338844d92047ec.js"></script>

Next, I restore the NuGet packages of the CustomerApi and then build the CustomerApi project.

<script src="https://gist.github.com/WolfgangOfner/ce138e2dc9e39931bb86df918ef609a7.js"></script>

The last part of the Dockerfile publishes the CustomerApi project. The last line sets the entrypoint as a dotnet application and that the CustomerApi.dll should be run.

<script src="https://gist.github.com/WolfgangOfner/46c47cae8a0d32a310d999afe5cb555e.js"></script>

## Conclusion

In today's DevOps culture it is necessary to change applications fast and often. Additionally, microservices should run inside a container whereas Docker is the defacto standard container. This post showed how easy it is to add Docker to a microservice in Visual Studio.

You can find the code of this demo on <a href="https://github.com/WolfgangOfner/.NETCoreMicroserviceCiCdAks/tree/AddDocker" target="_blank" rel="noopener noreferrer">GitHub</a>.