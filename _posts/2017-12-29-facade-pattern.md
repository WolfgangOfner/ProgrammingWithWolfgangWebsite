---
title: Facade Pattern
date: 2017-12-29T11:41:38+01:00
author: Wolfgang Ofner
categories: [Design Pattern]
tags: ['C#', Software Architecture]
description: The Facade pattern is often used without the programmer knowing that he uses it. In this post I want to give the thing a developer often does automatically a name.
---
The Facade pattern is often used without the programmer knowing that he uses it. In this post, I want to give the thing a developer often does automatically a name.

## Goals

  * Simplify complex code to make it easier to consume
  * Expose a simple interface which is built on complex code or several interfaces
  * Expose only needed methods of a complex API or library
  * Hide poorly designed APIs or legacy code behind well designed facades

## Downsides

  * Only selected interfaces of an API will be exposed
  * The facade needs to be updated to offer more functionality from the underlying system

## UML Diagram

[<img loading="lazy" class="aligncenter wp-image-489" src="/assets/img/posts/2017/12/Facade-pattern-UML-diagram.jpg" alt="Facade pattern UML diagram" width="700" height="349" />](/assets/img/posts/2017/12/Facade-pattern-UML-diagram.jpg)

The UML diagram for the facade pattern is pretty empty. It only shows the facade which is called by a client and that it calls methods of subsystems. These subsystems can be classes within your own system but also third party libraries or calls to web services.

## Implementation without the Facade Pattern

In this example, I am implementing a fake API which provides information for books. The API has three methods: LookUpAuthor, LookUpPublisher and LookUpTitle. All three methods take the ISBN as string Parameter and also return a string. To get the information for a specific ISBN, every method has to be called.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/WithoutFacadePattern.jpg"><img loading="lazy" src="/assets/img/posts/2017/12/WithoutFacadePattern.jpg" alt="Implementation of API calls without the Facade Pattern" /></a>
  
  <p>
    Implementation of API calls without the Facade Pattern
  </p>
</div>

This is ok when you have three methods but what if you also want to get information about the year of publication, related books from the author or an excerpt of the book? This would increase the methods very quickly and as a result, would bloat the code. Imagine this code with 10 services for every attribute of a book. This would be nasty to use. The solution to this problem is to implement a facade.

You can find the source code of this example on [GitHub](https://github.com/WolfgangOfner/WithoutFacadePattern).

## Implementation of the Facade Pattern

To hide all the service calls, I implement a facade which takes the ISBN as Parameter and returns all values from the service calls. Additionally to the facade, I implement a Book class, which holds all the information about a book and which is returned by the facade. It is quite common that facades have helper classes which contain all the information from different method calls.

Implementing a facade is pretty simple. I move all the service calls into a separate class called Book Service. This class exposes only one method, LookUpBookInformation which takes the ISBN as a parameter and returns a book object. Inside the LookUpBookInformation method, I implement all the service calls which were in the main method before. The return value of every service call is mapped to a property of the book object.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/Implementation-of-the-BookService-class.jpg"><img loading="lazy" src="/assets/img/posts/2017/12/Implementation-of-the-BookService-class.jpg" alt="Implementation of the BookService class" /></a>
  
  <p>
    Implementation of the BookService class
  </p>
</div>

With this implementation, i can tidy up the main method and end up with only one method call.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/Invoking-the-BookService.jpg"><img loading="lazy" src="/assets/img/posts/2017/12/Invoking-the-BookService.jpg" alt="Invoking the BookService" /></a>
  
  <p>
    Invoking the BookService
  </p>
</div>

You can find the source code of this example on <a href="https://github.com/WolfgangOfner/FacadePattern" target="_blank" rel="noopener">GitHub</a>.

## Conclusion

In this post, I showed the Advantages of using the Facade pattern. I also presented an example without the pattern and how to refactor the code to tidy it up.