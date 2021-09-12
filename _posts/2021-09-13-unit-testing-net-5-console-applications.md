---
title: Unit Testing .NET 5 Console Applications with Dependency Injection
date: 2021-09-13
author: Wolfgang Ofner
categories: [Programming]
tags: [C#, .NET 5, Dependency Injection, xUnit, Moq, FluentAssertions]
description: Creating unit tests for a .NET 5 console application that uses dependency injection only takes a couple of lines of code to configure the service provider.
---

[In my last post](/configure-dependency-injection-for-net-5-console-applications), I created a .NET 5 console application and configured dependency injection. This was pretty straight-forward and only needed a couple of lines of code. 

Today, I will show you how to create unit tests when using dependency injection in a .NET 5 (or .NET Core) console application.

## Create Unit Tests using xUnit

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ConsoleDependencyInjection" target="_blank" rel="noopener noreferrer">Github</a>.

Create a new .NET 5 test project using xUnit and create a reference to the main project. You can use any unit testing and faking framework you like. For this demo, I am using xUnit and Moq. Additionally, I am using FluentAssertions to make the assertions more readable.

Implementing unit tests for a .NET 5 console application with dependency injection is the same as for any other project. The only minor difficulty is how to test the following method which creates an instance of IGreeter and then calls the Greet() method on it.

<script src="https://gist.github.com/WolfgangOfner/b8e6b599f0c2eb55f9eef6106c415068.js"></script>

The difficulty when testing this method is the IServiceProvider which has to be configured to be able to create an instance of the IGreeter interface.

### Create a fake Service Provider

The solution to the problem is to create a fake IServiceProvider and IServiceScope object. The IServiceProvider fake then can be configured to return a fake IServiceScopeFactory object. This fake object can be used as the IServiceProvider parameter of the GreetWithDependencyInjection() method. The full code looks as follows:

<script src="https://gist.github.com/WolfgangOfner/c6d4b6871b8ab9420ff9ef70761734a7.js"></script>

The code in the constructor might look complicated but if you start a new project, all you have to do is to copy it into the new project and you are good to go.

### Test Classes without the IServiceProvider Interface

As previously mentioned, every other class besides the Program.cs can be tested as you are used to. For example, testing the ConsoleGreeter is straight-forward. Create a new object of the ConsoleGreeter, add a fake interface in the constructor  and then call the method you want to test. The method should return the value you expect.

<script src="https://gist.github.com/WolfgangOfner/cb8445e0c5406d2a3c4a0983430b2ced.js"></script>

## Testing the Unit Tests

Run all the unit tests and you should see both running successfully.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/09/The-Tests-ran-successfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/09/The-Tests-ran-successfully.jpg" alt="The Tests ran successfully" /></a>
  
  <p>
   The Tests ran successfully
  </p>
</div>

## Conclusion

Creating unit tests for a .NET 5 console application that uses dependency injection only takes a couple of lines of code to configure the service provider. This code can be copied to any new project, making it even easier to set up.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ConsoleDependencyInjection" target="_blank" rel="noopener noreferrer">Github</a>.