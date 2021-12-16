---
title: Decorator Pattern in .NET Core 3.1
date: 2020-07-01
author: Wolfgang Ofner
categories: [Design Pattern]
tags: [.NET Core 3.1, 'C#', Software Architecture]
description: The decorator pattern is a structural design pattern used for dynamically adding behavior to a class without changing the class.
---
The decorator pattern is a structural design pattern used for dynamically adding behavior to a class without changing the class. You can use multiple decorators to extend the functionality of a class whereas each decorator focuses on a single-tasking, promoting separations of concerns. Decorator classes allow functionality to be added dynamically without changing the class thus respecting the open-closed principle.

You can see this behavior on the UML diagram where the decorator implements the interface to extend the functionality.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Decorator-Pattern-UML.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Decorator-Pattern-UML.jpg" alt="Decorator Pattern UML" /></a>
  
  <p>
    Decorator Pattern UML (Source)
  </p>
</div>

## When to use the Decorator Pattern

The decorator pattern should be used to extend classes without changing them. Mostly this pattern is used for cross-cutting concerns like logging or caching. Another use case is to modify data that is sent to or from a component.

## Decorator Pattern Implementation in ASP .NET Core 3.1

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/.NETCore-DecoratorPattern" target="_blank" rel="noopener noreferrer">GitHub</a>.

I created a DataService class with a GetData method which returns a list of ints. Inside the loop, I added a Thread.Sleep to slow down the data collection a bit to make it more real-world like.

<script src="https://gist.github.com/WolfgangOfner/fa035331acf7aa0ae11627abf9837665.js"></script>

This method is called in the GetData action and then printed to the website. The first feature I want to add with a decorator is logging. To achieve that, I created the DataServiceLoggingDecorator class and implement the IDataService interface. In the GetData method, I add a stopwatch to measure how long collecting data takes and then log the time it took.

<script src="https://gist.github.com/WolfgangOfner/eea5ea9d26bdacc3294bdfd679455ef0.js"></script>

Additionally, I want to add caching also using a decorator. To do that, I created the DataServiceCachingDecorator class and also implemented the IDataService interface. To cache the data, I use IMemoryCache and check the cache if it contains my data. If not, I load it and then add it to the cache. If the cache already has the data, I simply return it. The cache item is valid for 2 hours.

<script src="https://gist.github.com/WolfgangOfner/cd12af792f704815196eafd1cba51c14.js"></script>

All that is left to do is to register the service and decorator in the ConfigureServices method of the startup class with the following code:

<script src="https://gist.github.com/WolfgangOfner/f92ca0dc873abc993a9e54380b5b1457.js"></script>

With everything in place, I can call the GetData method from the service which gets logged and the data placed in the cache. When I call the method again, the data will be loaded from the cache.

<script src="https://gist.github.com/WolfgangOfner/6d505727a06be40eadf597ee2faea5a4.js"></script>

Start the application and click on Get Data. After a couple of seconds, you will see the data displayed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Displaying-the-loaded-data.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Displaying-the-loaded-data.jpg" alt="Displaying the loaded data" /></a>
  
  <p>
    Displaying the loaded data
  </p>
</div>

When you load the site again, the data will be displayed immediately due to the cache.

## Conclusion

The decorator pattern can be used to extend classes without changing the code. This helps you to achieve the open-closed principle and separation of concerns. Mostly the decorator pattern is used for cross-cutting concerns like caching and logging.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/.NETCore-DecoratorPattern" target="_blank" rel="noopener noreferrer">GitHub</a>.