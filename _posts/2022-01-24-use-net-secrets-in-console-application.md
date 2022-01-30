---
title: Use .NET Secrets in a Console Application
date: 2022-01-24
author: Wolfgang Ofner
categories: [Programming]
tags: [.NET 6, Git]
description: .NET 6 allows developers to set up the configuration of secrets with only a couple of lines of code to prevent sensitive data from being committed to the source control. 
---

.NET Core made it easy to configure your application. Currently, I am working on a .NET 6 console application and this showed me that especially ASP.NET MVC makes it easy to set up middleware such as dependency injection. When using a console application, it is not hard but it requires a bit more work than the web application.

In this post, I would like to show you how to use .NET secrets in your .NET 6 console application.

## Create a new .NET 6 console application

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ReadSecretsConsole" target="_blank" rel="noopener noreferrer">GitHub</a>.

Create a new .NET 6 console application using your favorite IDE or the command line. First, add install the following two NuGet packages

<script src="https://gist.github.com/WolfgangOfner/b3a085f76152cb88cf498c91e492dbb3.js"></script>

Next, create a new class, that will read the appsettings file and also the NETCORE_ENVIRONMENT environment variable.

<script src="https://gist.github.com/WolfgangOfner/97af59ae00a6613e73b9fbf35844ca13.js"></script>

The NETCORE_ENVIRONMENT variable is the default variable to configure your environment in .NET. This variable contains values such as Development or Production and can be used to read a second appsettings file for the specific environment. For example, in production, you have a file called appsettings.Production.json which overrides some values from the appsettings.json file.

Next, add a new file, called appsettings.json, and add the following code there:

<script src="https://gist.github.com/WolfgangOfner/4b3e5573ad6dda58e426831bb1c4db5d.js"></script>

This file contains a username and password. Values that should never be checked into source control!

Lastly, add the following code to your Program.cs file:

<script src="https://gist.github.com/WolfgangOfner/a33309dee971c892df29ab2e1232104f.js"></script>

This code creates a new instance of SecretAppsettingReader and then reads the values from the appsettings.json file. Start the applications and you should see the values printed to the console.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/01/Read-the-values-from-appsettings.jpg"><img loading="lazy" src="/assets/img/posts/2022/01/Read-the-values-from-appsettings.jpg" alt="Read the values from appsettings" /></a>
  
  <p>
   Read the values from appsettings
  </p>
</div>

## Add Secrets to your Application

The application works and reads the username and password from the appsettings file. If a developer adds his password during the development, it is possible that this password gets forgotten and ends up in the source control. To mitigate accidentally adding passwords to the source control, .NET introduced secrets.

To add a secret, right-click on your project and then select "Manage User Secrets" in Visual Studio.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/01/Add-a-User-Secret.jpg"><img loading="lazy" src="/assets/img/posts/2022/01/Add-a-User-Secret.jpg" alt="Add a User Secret" /></a>
  
  <p>
   Add a User Secret
  </p>
</div>

This should create a secrets.json file and add the Microsoft.Extensions.Configuration.UserSecrets NuGet package. Sometimes Visual Studio 2022 doesn't install the package, so you have to install it by hand with the following command:

<script src="https://gist.github.com/WolfgangOfner/2f7863d7718d7037e057a40669db96f1.js"></script>

You can use the secrets.json file the same way as you would use the appsettings.json file. For example, add the "MySecretValues" section and a new value for the "Password":

<script src="https://gist.github.com/WolfgangOfner/948e3b63024eefc2c46fe970dc4a4db7.js"></script>

 There is one more thing you have to do before you can use the secrets.json file. You have to read the file using AddUserSecrets in the SecretAppsettingReader file:

 <script src="https://gist.github.com/WolfgangOfner/738e7df25fd84626b78e88b9e7e0170b.js"></script>

 The AddUserSecrets method takes a type that indicates in what assembly the secret resides. Here I used Program, but you could use any other class inside the assembly.

 Start the application and you should see that the password is the same value as in the secrets.json file.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/01/The-password-was-read-from-the-secret.jpg"><img loading="lazy" src="/assets/img/posts/2022/01/The-password-was-read-from-the-secret.jpg" alt="The password was read from the secret" /></a>
  
  <p>
   The password was read from the secret
  </p>
</div>
 
 When you check in your code into Git, you will see that there is no secrets.json file to be checked in. Therefore, it is impossible to check in your secrets like passwords.

## Conclusion

Secrets help developers to keep their repositories free of passwords and other sensitive information like access tokens. .NET 6 allows you to set up these secrets with only a couple of lines of code. 
 
You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ReadSecretsConsole" target="_blank" rel="noopener noreferrer">GitHub</a>.