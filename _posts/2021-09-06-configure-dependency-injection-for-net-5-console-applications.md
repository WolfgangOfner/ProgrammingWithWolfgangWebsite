---
title: Configure Dependency Injection for .NET 5 Console Applications
date: 2021-09-06
author: Wolfgang Ofner
categories: [Programming]
tags: [C#, .NET 5 Dependency Injection]
description: Dependency Injection helps to write more testable and overal better applications and can be easily configured for .NET 5 console applications.
---

Back in the .NET framework days dependency injection was not the easiest task. Fortunately, Microsoft made it a first class citizen with the introduction of .NET Core. This is especially true for ASP .NET Core application where dependency injection can be used with a single line of code.

Unfortunately, .NET Core (and .NET 5) console applications do not come preconfigured for dependency injection. Therefore, this post will show you how to configure it for you .NET 5 console application.

## Configure Depndency Injection for a .NET 5 Console Application

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ConsoleDependencyInjection" target="_blank" rel="noopener noreferrer">Github</a>.

Create a new .NET 5 (.NET Core also works) application and install the Microsoft.Extensions.Hosting NuGet package. Next, create the following method which creates a DefaulBuilder and also allows you to register your instances with the dependency injection module.

<script src="https://gist.github.com/WolfgangOfner/9b2677b1e0106ec20f3875020a92e7d2.js"></script>
 
The AddTransient method configures dependency injection to create a new instance of the object everytime it is needed. Alternatively, you could use AddScoped or AddSingleton. Scoped objects are the same within a request, but different across different requests and Singleton objects are the same for every object and every request.

You can add as many services as your application needs.

## Use Dependency Injection in a .NET 5 Console Application

The dependency injection module is already configured and now you can use it. Pass the Services of the previously created IHostBuilder to a new method where you can instanciate a new object with it.

<script src="https://gist.github.com/WolfgangOfner/9f88d28d485ec3b32e1327e10b8558b8.js"></script>

The GreetWithDependencyInjection method uses dependency injection to create a new instance of the IGreeter class. Since I previously configured to use the ConsoleGreeter for the IGreeter interface, I get an instance of ConsoleGreeter. This is normal dependency injection functionality and nothing console application specific though.

After the object is instantiated, you can use it like any other object and, for example, call methods like Greet on it.

<script src="https://gist.github.com/WolfgangOfner/a0bc95521a077a0922057d97c7002460.js"></script>

## Use Constructor Injection 

Creating objects using dependency injection is good but it is still too complicated. It would be better if the needed objects are created automatically in the constructor. This is where constructor injection comes in handy. Again, this is nothing console application specific, just good old dependency injection but you create a class that accepts one or more interfaces in the constructor. The dependency injection module automatically passes the right object into the constructor without any developers work needed.

Let's take a look at the ConsoleGreeter class.

<script src="https://gist.github.com/WolfgangOfner/5001e210a6c09d42d78291ddaea8452d.js"></script>

This class takes an IFooService object in the constructor and then uses this object to call the DoCool() stuff method inside the Greet() method. This enebales developers to change the dependency injection configuration and therefore change the bevhavior of the application without touching the classes that use these objects.

## Testing the Dependency Injection

Start the application and you should see the following output in your console window.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Testing-the-Dependency-Injection.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Testing-the-Dependency-Injection.jpg" alt="Testing the Dependency Injection" /></a>
  
  <p>
   Testing the Dependency Injection
  </p>
</div>

When you replace the ConsoleGreeter with the ApiGreeter in the dependency injection configuration and start the program again, you should see a different greeting message.

<script src="https://gist.github.com/WolfgangOfner/ca44e7bdce1fca23ce072703480dfc17.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/Testing-the-changed-DI-Configuration.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/Testing-the-changed-DI-Configuration.jpg" alt="Testing the changed DI Configuration" /></a>
  
  <p>
   Testing the changed DI Configuration
  </p>
</div>

## Conclusion

Dependency injection helps developers to write more testable and overall better applications. .NET 5 and .NET Core do not come with DI pre-configured but as you have seen in this post, it is very easy to configure it. All you have to do is to install the Microsoft.Extensions.Hosting NuGet package and add a couple lines of code.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ConsoleDependencyInjection" target="_blank" rel="noopener noreferrer">Github</a>.

