---
title: .NET 6 Minimal APIs - Getting Started
date: 2021-11-22
author: Wolfgang Ofner
categories: [ASP.NET, Programming]
tags: [.NET 6, 'C#', REST, API, Swagger]
description: To speed up development, Minimal APIs in .NET 6 allow developers to configure APIs with only a couple of lines of code.
---

Microsoft released .NET 6 and the most talked topic of this new version is minimal API. The promise of minimal APIs is that you can write APIs with barely any code. When I read the announcement, I wasn't sure if I like this new feature. 

Now that it is released, let's try minimal APIs and see if it is any good.

You can find the code of this demo on <a href="https://github.com/WolfgangOfner/MinimalApi" target="_blank" rel="noopener noreferrer">GitHub</a>.

## Prerequisites for .NET 6

Before you can use .NET 6, you have to download <a href="https://visualstudio.microsoft.com/downloads/" target="_blank" rel="noopener noreferrer">Visual Studio 2022</a>. You can use the Community edition free of charge. This version offers the same features as the Professional one but does not allow you to use it for commercial projects.

## Create your first Minimal API project

Open Visual Studio and select create a new project. On this page, select ASP.NET Core Web API and click Next.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Select-the-API-template.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Select-the-API-template.jpg" alt="Select the API template" /></a>
  
  <p>
   Select the API template
  </p>
</div>

Provide a name for your new project and on the next page make sure to uncheck "Use controllers (uncheck to use minimal APIs).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Use-minimal-APIs.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Use-minimal-APIs.jpg" alt="Use minimal APIs" /></a>
  
  <p>
   Use minimal APIs
  </p>
</div>

This creates a new Web API project. If you take a look at the project structure, you will see that it is minimal indeed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-minimal-API-project-structure.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-minimal-API-project-structure.jpg" alt="The minimal API project structure" /></a>
  
  <p>
   The minimal API project structure
  </p>
</div>

The only file of interest in this project is the Program.cs file. This file configures the whole application.
Program.cs
<script src="https://gist.github.com/WolfgangOfner/23382500bffe39718e7855714ae8b583.js"></script>

If you are familiar with the Startup.cs file, you will see many similarities like app.UseHttpsRedirect or services.AddSwaggerGen(). The method app.MapGet configures an endpoint for HTTP requests and returns five random weather forecasts. You can test this using the Swagger UI. 

Start your application and you will see the Swagger UI. Execute the Get method and you will see five random weather forecasts.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Testing-the-Swagger-UI.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Testing-the-Swagger-UI.jpg" alt="Testing the Swagger UI" /></a>
  
  <p>
   Testing the Swagger UI
  </p>
</div>

### Edit the Minimal API project

The default minimal API project is already very small but you can make it even smaller. In the launchSettings.json file, replace "swagger" with "" for the launchUrl. Then edit the Program.cs file with the following code:

<script src="https://gist.github.com/WolfgangOfner/fe3919080342235801716b8ec8cd87da.js"></script>

When you start your application, you will see the Hello World string in your browser.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Return-a-string-from-the-API.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Return-a-string-from-the-API.jpg" alt="Return a string from the API" /></a>
  
  <p>
   Return a string from the API
  </p>
</div>

### Configure Post Requests

Additionally to MapGet, there are MapPost, MapDelete and MapPut to configure the respective HTTP methods. Use MapPost and then a Lambda function to create a simple HTTP Post endpoint.

<script src="https://gist.github.com/WolfgangOfner/f99dec47f652cdbfa7713deb855e8706.js"></script>

This endpoint takes in int and if the value is greater than zero, it returns Accepted, otherwise it returns Bad Request. The example is very simple but you could adept this method to do some more complicated operations like writing something to a database.

When you use Postman to test the Post method and send a number greater than zero, you will the a HTTP 202 status code.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-valid-request-returns-accepted.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-valid-request-returns-accepted.jpg" alt="The valid request returns accepted" /></a>
  
  <p>
   The valid request returns accepted
  </p>
</div>

If you send a number smaller than zero, you will get a HTTP 400 status code.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-invalid-request-returns-bad-request.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-invalid-request-returns-bad-request.jpg" alt="The invalid request returns bad request" /></a>
  
  <p>
   The invalid request returns bad request
  </p>
</div>

Could be a more complex method like loading something from the database

## Will I use Minimal APIs?

Minimal APIs are very simple but currently I don't see myself ever using them. Especially for beginners, this might be too confusing since the template is using top-level statements and is hiding a lot of important aspects of programming. If you take a look at the Program.cs file again, you will see that there are no usings, namepsace, class or methods. These are important concepts and I think it will be more confusing for new programmers to see them only sometimes.

Additionally, the whole configuration is in the same file and method now. Previously, the Startup.cs had two different methods to configure the application and the Program.cs file configured the web server. This is now all crammed into one file. This means that the whole configuration is in one place, but this also means that the file can get quite big and unclear if there is a lot of configuration. Actually, it is not only configuration but it is also the logic of the endpoints.

Maybe I am just bad with adapting to change and in a while I will love this new approach. Currently, I don't see that happening and will continue using controllers even for small APIs.

## Conclusion

Microsft's big focus of .NET 6 is to remove boiler plate code and make applications as simple as possible. Minimal APIs allow developers to create APIs with basically a single file where they can configure the application but also write the code of the endpoints.

So far, I am not a big fan but time will tell how good this feature is.

You can find the code of this demo on <a href="https://github.com/WolfgangOfner/MinimalApi" target="_blank" rel="noopener noreferrer">GitHub</a>.