---
title: '.NET Standard - Getting Started'
date: 2019-02-12T09:35:00+01:00
author: Wolfgang Ofner
categories: [Programming]
tags: [NET, NET Core, NET Standard, 'C#']
description: Today, some of my colleagues had a discussion about .NET Standard. Is it a new framework, an extension to classic .NET framework, or to .NET Core?
---
Today, some of my colleagues had a discussion about .NET Standard. Is it a new framework, an extension to classic .NET framework, or to .NET core? Confusion was great and in today&#8217;s post, I would like to shed light on the matter.

## What is .NET Standard?

.NET Standard is a specification which defines a set of APIs which the .NET platform has to implement. It is not another .NET platform though. You can only build libraries, not executables with it. On the following screenshot, you can see that .NET Standard contains APIs from the classic .NET framework, .NET core and Xamarin.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/What-is-Net-Standard..jpg"><img loading="lazy" src="/assets/img/posts/2019/02/What-is-Net-Standard..jpg" alt="What is .NET Standard" /></a>
  
  <p>
    What is .NET Standard (<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">Source</a>)
  </p>
</div>

The following screenshot shows that it defines a set all APIs that all .NET frameworks implement.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Implementation-of-.NET-Standard.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Implementation-of-.NET-Standard.jpg" alt="Implementation of .NET Standard" /></a>
  
  <p>
    Implementation of .NET Standard (<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">Source</a>)
  </p>
</div>

&nbsp;

### The difference to Portable Class Libraries

Some of you might remember portable class libraries, which sound like .NET Standard. Both technologies have the same idea but a portable class library needs to be recompiled every time you want to use it for a different target. .NET Standard doesn&#8217;t have to be recompiled to be used for a different target. Check out the following screenshot to compare the differences:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Portable-Class-Library-vs-Net-Standard.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Portable-Class-Library-vs-Net-Standard.jpg" alt="Portable Class Library vs .NET Standard" /></a>
  
  <p>
    Portable Class Library vs .NET Standard (<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">Source</a>)
  </p>
</div>

Portable class libraries are deprecated because .NET Standard is better in every way and therefore shouldn&#8217;t be used anymore.

## Choosing the right Version

A new version of .NET Standard always contains all previous APIs and additional ones. The following screenshot shows how a new version is built on all previous ones:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Net-Standard-Versions.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Net-Standard-Versions.jpg" alt=".NET Standard Versions" /></a>
  
  <p>
    Every version is built on the previous one (<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">Source</a>)
  </p>
</div>

A .NET platform implements a specific .NET Standard version, for example .NET Core 1.0 implements .NET Standard 1.6. The enforce this backward compatibility, every .NET Standard version is immutable.

### Which Version to choose?

The best practice is to start with a high version number and implement all your features. Then target the lowest version possible. For example, start with 2.0 and then decrease to 1.6, then 1.5  until your project doesn&#8217;t compile anymore.

### Find out which Version a .NET Platform implements

Microsoft has some great <a href="https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-implementation-support" target="_blank" rel="noopener">documentation</a> about which .NET Standard version is implemented by which .NET framework version.

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        .NET Standard
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.1
      </td>
      
      <td>
        1.2
      </td>
      
      <td>
        1.3
      </td>
      
      <td>
        1.4
      </td>
      
      <td>
        1.5
      </td>
      
      <td>
        1.6
      </td>
      
      <td>
        2.0
      </td>
    </tr>
    
    <tr>
      <td>
        .NET Core
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        1.0
      </td>
      
      <td>
        2.0
      </td>
    </tr>
    
    <tr>
      <td>
        .NET Framework
      </td>
      
      <td>
        4.5
      </td>
      
      <td>
        4.5
      </td>
      
      <td>
        4.5.1
      </td>
      
      <td>
        4.6
      </td>
      
      <td>
        4.6.1
      </td>
      
      <td>
        4.6.1
      </td>
      
      <td>
        4.6.1
      </td>
      
      <td>
        4.6.1
      </td>
    </tr>
  </table>
</div>

If you are looking for a specific API, you can go to <a href="https://docs.microsoft.com/en-gb/dotnet/api/" target="_blank" rel="noopener">https://docs.microsoft.com/en-gb/dotnet/api/</a> and search for it.

Version 1.6 has around 13,000 APIs whereas version 2.0 has already around 32,000 APIs which includes for example Primitives, Collections, Linq or Files

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/APIs-of-.NET-Standard-2.0.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/APIs-of-.NET-Standard-2.0.jpg" alt="APIs of .NET Standard 2.0" /></a>
  
  <p>
    Some APIs of 2.0 (<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">Source</a>)
  </p>
</div>

&nbsp;

## Migrating an existing project

Migrating to .NET Standard just for the sake of migrating is not the best strategy. It makes sense to migrate if the heart of your library is .NET Standard compatible and if you want to use it on different .NET platform.

### How to migrate

Open the .csproj file of the classic .NET framework project you want to migrate and delete everything. Then copy a new Project tag with the target framework of netstandard in it. If you want to migrate a .NET core project, you only have to change the target framework to netstandard. For details see the following screenshot:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Migrate-to-.NET-Standard.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Migrate-to-.NET-Standard.jpg" alt="Migrate to .NET Standard" /></a>
  
  <p>
    Migrate to .NET Standard
  </p>
</div>

If you are migrating a .NET core project, you are already done. For your .NET framework project, you have to delete the AssemblyInfo.cs and the packages.config files. Then you have to reinstall your NuGet packages. The reason why you don&#8217;t have to do that for .NET core is because it uses package referencing and not the packages.config.

## Targeting multiple platforms

If you want to target multiple frameworks, for example, .NET Standard and .NET 4.6.1, you only have to change the TargetFramework tag in the .csproj file to TargetFrameworks and separate the different framework with a semicolon.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Target-multiple-platforms.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Target-multiple-platforms.jpg" alt="Target multiple platforms" /></a>
  
  <p>
    Target multiple platforms
  </p>
</div>

If you use multiple target platforms, you can use if statements to use different code, depending on your target framework:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/02/Execute-code-depending-on-the-target-platform.jpg"><img loading="lazy" src="/assets/img/posts/2019/02/Execute-code-depending-on-the-target-platform.jpg" alt="Execute code depending on the target platform" /></a>
  
  <p>
    Execute code depending on the target platform
  </p>
</div>

## Conclusion

In this short post, I explained the basics of .NET Standard and pointed out why it is better than the deprecated portable class library. Additionally, I showed how to migrate your existing project and how to target multiple platforms. For more information, I can highly recommend the Pluralsight course &#8220;<a href="https://app.pluralsight.com/library/courses/dotnet-standard-getting-started/table-of-contents" target="_blank" rel="noopener">.NET Standard: Getting Started</a>&#8221; by Thomas Claudius Huber.