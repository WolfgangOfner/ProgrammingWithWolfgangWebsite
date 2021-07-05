---
title: Fixing NuGet.targets(131,5) error The local source doesn't exist.
date: 2021-07-05
author: Wolfgang Ofner
categories: [Miscellaneous ]
tags: [NuGet]
description: Fixing the error "NuGet.targets(131,5) error The local source doesn't exist."
---

Today, I was trying to add a new NuGet package to my .NET 5 project and I got the following error message: C:\Program Files\dotnet\sdk\5.0.301\NuGet.targets(131,5): error : The local source 'C:\Users\Wolfgang\Desktop\poc-microservice-main\ProductService\ProductService.Catalog' doesn't exist. I know that the file doesn't exist because I deleted it weeks ago after helping a reader of my blog. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Installing-a-NuGet-package-failed.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Installing-a-NuGet-package-failed.jpg" alt="Installing a NuGet package failed" /></a>
  
  <p>
   Installing a NuGet package failed
  </p>
</div>

I was quite annoyed by the error message because and I couldn't find out what was wrong. Also checking the mentioned NuGet.targets file didn't helpt me. Fortunately the solution was quite simple.

Open a PowerShell window and enter the following code:

```PowerShell
dotnet new nugetconfig
```

This creates a new nuget.config file and fixed the problem for me.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/07/Create-a-new-NuGet-config-file.jpg"><img loading="lazy" src="/assets/img/posts/2021/07/Create-a-new-NuGet-config-file.jpg" alt="Create a new NuGet config file" /></a>
  
  <p>
   Create a new NuGet config file
  </p>
</div>