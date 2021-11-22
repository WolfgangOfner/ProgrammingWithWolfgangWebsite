---
title: C# 10.0 - What's new
date: 2021-11-15
author: Wolfgang Ofner
categories: [Programming]
tags: [.NET 6, 'C#']
description: .NET 6 and C# 10 is released. Let's have a look at the new features and how they can make the life of developers easier.
---

It is November again which means that Microsoft released a new version of .NET. This year, Microsoft released with .NET 6 a long-term support (LTS) version, and guarantees support for .NET 6 for 3 years. Along with .NET 6, Microsoft published C# 10.

In this post, I will look into some of the new features of .NET 6 in combination with C# 10.

You can find the code of this demo on <a href="https://github.com/WolfgangOfner/CSharp-10.0" target="_blank" rel="noopener noreferrer">Github</a>.

## Prerequisites for .NET 6 and C# 10

Before you can use .NET 6 and C# 10, you have to download <a href="https://visualstudio.microsoft.com/downloads/" target="_blank" rel="noopener noreferrer">Visual Studio 2022</a>. You can use the Community edition free of charge. This version offers the same features as the Professional one but does not allow you to use it for commercial projects.

## Removing Boilerplate code

When you create a new console application, you are probably used to seeing the Program.cs file that contains some usings, a namespace, the Program class, and the Main method which writes something to the console. This is a lot of code for a single console output. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-old-console-application-template.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-old-console-application-template.jpg" alt="The old console application template" /></a>
  
  <p>
   The old console application template
  </p>
</div>

Microsoft thinks that this is way more complicated than it has to be and removed all of that and reduced the program.cs file to a single line that writes a message to the console.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-default-console-application-template.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-default-console-application-template.jpg" alt="The default console application template" /></a>
  
  <p>
   The default console application template
  </p>
</div>

Another reason why Microsoft removed all the boilerplate code is to make it easier for beginners to get started. This might be true but it also hides a lot of basic knowledge that beginners should learn early on. Additionally, if you want to add a method, you have to add the class and Main method manually. 

All in all, I understand Microsoft's decision but I am not a big fan of it yet. Perhaps this will change in a year when I got used to it. Time will tell.

## Global Usings

Global usings is probably my favorite feature of C# 10 since it allows developers to create a single file and add usings there. These usings will be added automatically to every file in the project. This should reduce the number of usings in each file and will help to make the files clearer.

Let's look at some code. In the Program.cs file, initialize a new variable from a class.

<script src="https://gist.github.com/WolfgangOfner/49706d00e6fb9ee14c4f40803d799eaa.js"></script>

Note that you don't have to add a using for this class. The NullParameterChecking class looks as follows:

<script src="https://gist.github.com/WolfgangOfner/9325762261a9576c3e8ad40f01d2c0c0.js"></script>

As you can see in the code, you do not have to add brackets after the namespace. This is also a new feature and will help to reduce the indentation of the code.

Lastly, create a new file that will contain the global usings. The name of the file does not matter. I prefer naming it GlobalUsings.cs. This file contains all usings that you want to apply globally:

<script src="https://gist.github.com/WolfgangOfner/f4f987401699825275c2628bb7d38154.js"></script>

## Record Structs

C# 9 already introduced records for classes. C# 10 improves this feature and adds records for structs. You can define a struct with a single line and the compiler will automatically create properties according to the parameters of the constructor.

<script src="https://gist.github.com/WolfgangOfner/7629b8d46802b3591c337a5b91eb6e29.js"></script>

The Coordinate struct has three properties, X, Y, and Z. You can create a new struct and then access these properties the same way as if you had defined them yourselves.

<script src="https://gist.github.com/WolfgangOfner/19f07e7d8daa56cadfd5080d0585c175.js"></script>

## Null Paramter Checking

Every developer knows that we should check all parameters for null but it is a tedious task. Especially if your method has several parameters it is quite a lot of typing for such a simple task. C# 10 can create these checks almost automatically for you. All you have to do is to add one ! after the parameter and C# 10 (maybe it is Visual Studio though) will create a null check that throws an exception if the parameter is null.

<script src="https://gist.github.com/WolfgangOfner/cec0e8146a059808456becf5018804e7.js"></script>

## Conclusion

This post gave a short introduction to the new features of C# 10 and .NET 6. C# is a quite mature language therefore the changes are not that massive anymore. Maybe I am a bit slow to adapt to the new changes but so far I am not too excited about them. Allowing us to use global usings is a nice feature and also the automatic null checks of parameters will boost productivity. The other features have to prove themselves when I start using them in a real-world project. 

[In my next post](/net-6-minimal-apis-getting-started), I will take a look at minimal APIs which is probably Microsoft's most talked about feature of .NET 6. 

You can find the code of this demo on <a href="https://github.com/WolfgangOfner/CSharp-10.0" target="_blank" rel="noopener noreferrer">Github</a>.