---
title: 'Blazor - Getting Started'
date: 2020-06-22
author: Wolfgang Ofner
categories: [ASP.NET, Frontend]
tags: [.NET Core, Blazor, 'C#', SignalR]
description: Blazor was introduced with .NET Core 3.0 and is a web UI single page application (SPA) framework. Developers write the code in HTML, CSS and C#.
---
Blazor was introduced with .NET Core 3.0 and is a web UI single page application (SPA) framework. Developers write the code in HTML, CSS, C#, and optionally Javascript. Blazor was developed by Steve Sanderson and presented  in July 2018. The main advantage over Javascript frameworks is that you can run C# directly in the browser which should be appealing for enterprise developers who don't want to deal with Javascript

## Blazor Features

Blazor comes with the following features:

  * Run C# code inside your browser as WebAssembly (WASM)
  * Blazor is a mix of browser and Razor
  * WASM is more locked down than Javascript and therefore more secure
  * Messages between the browser and the backend are sent via SignalR
  * There is no direct DOM access but you can interact with the DOM using Javascript
  * Modern browser support WASM: Firefox, Chrome, Edge, Safari (IE 11 does not)
  * Components can be shared via Nuget

There are two different versions: Blazor Server and Blazor Webassembly. I will talk about the difference in more detail in my next post. For now, you only have to remember that the Server version runs on the server and sends code to the browser and the Webassembly version runs directly in the browser and calls APIs, like Angular or React apps.

## Create your First Blazor Server App

To follow the demo you need Visual Studio 2019 and at least .NET Core 3.0. You can find the source of the demo on <a href="https://github.com/WolfgangOfner/Blazor-Server" target="_blank" rel="noopener noreferrer">GitHub</a>.

To create a new Blazor App, select the Blazor template in Visual Studio.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Select-the-Blazor-App-template.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Select-the-Blazor-App-template.jpg" alt="Select the Blazor App template" /></a>
  
  <p>
    Select the Blazor App template
  </p>
</div>

After entering a name and location, select Blazor Server App, and click on Create.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Create-a-Blazor-Server-App.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Create-a-Blazor-Server-App.jpg" alt="Create a Blazor Server App" /></a>
  
  <p>
    Create a Blazor Server App
  </p>
</div>

This creates the solution and also a demo application. Start the application and you will see a welcome screen and a menu on the left side. Click on Fetch data to see some information about the weather forecast or on Counter to see a button which increases the amount when you click it.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/The-counter-function-of-the-demo-app.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/The-counter-function-of-the-demo-app.jpg" alt="The counter function of the demo app" /></a>
  
  <p>
    The counter function of the demo app
  </p>
</div>

All these features are implemented with HTML, CSS, and C# only. No need for Javascript.

### Create a new Component

Open the Counter.razor file in the Pages folder and you can see the whole code for the implementation of the Counter feature.

<script src="https://gist.github.com/WolfgangOfner/ed5e1aaa61641daf8335c4ecd362ac8a.js"></script>

On the top, you have the page attribute which indicates the route. In this example, when you enter /counter, this page will be rendered. The logic of the functionality is in the code block and the button has an onclick event. This event calls the IncrementCount method which then increases the count of the currentCode variable.

### Create a new Page

In this section, I will add a new Blazor component with a dropdown menu, event handling, and binding of a variable.

Right-click on the Pages folder and add a Blazor Component with the name DisplayProducts. Then add the following code:

<script src="https://gist.github.com/WolfgangOfner/92fed086c53691a3a66805142b774986.js"></script>

This code sets the route to products and displays a headline. In the code block, I override the OnInitialized method and create a class Product. The OnInitialized method is executed during the load of the page. You might know this from Webforms. Next, I add a dropdown menu and add each element of my Products list.

<script src="https://gist.github.com/WolfgangOfner/1dbb95e15b8fe01e885814ae8a7dd25b.js"></script>

As the last step, I add an onchange event to the dropdown menu and the code of the executed method in the code block. The selected value will be displayed below the dropdown menu. If you haven't selected anything, the whole div tag won't be displayed. My whole component looks like the following:

<script src="https://gist.github.com/WolfgangOfner/fa46865da518b050a16be5a326bf100f.js"></script>

Run the application, navigate to /products and you will see the dropdown menu. Select a product and it will be displayed below the dropdown.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Testing-my-first-Blazor-Component.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Testing-my-first-Blazor-Component.jpg" alt="Testing my first Blazor Component" /></a>
  
  <p>
    Testing my first Blazor Component
  </p>
</div>

## Conclusion

Blazor is a new frontend framework that enables developers to run C# in the browser. This might be a great asset for enterprises that already use .NET but don&#8217;t want to deal with Javascript frameworks.

You can find the source of the demo on <a href="https://github.com/WolfgangOfner/Blazor-Server" target="_blank" rel="noopener noreferrer">GitHub</a>.