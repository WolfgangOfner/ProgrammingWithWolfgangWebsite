---
title: CQRS in ASP .NET Core 3.1
date: 2020-04-16
author: Wolfgang Ofner
categories: [Design Pattern, ASP.NET]  
tags: [.NET Core 3.1, 'C#', CQRS, Docker, Docker-Compose, Mediator, MediatR, Microservice, RabbitMQ, Swagger]
description: CQRS stands for Command Query Responsibility Segregation and is used to use different models for read and for write operations.
---
CQRS stands for Command Query Responsibility Segregation and is used to use different models for read and for write operations. In this post, I will explain how I implemented CQRS in my microservices and how to use the mediator pattern with it to get even more abstraction.

You can find the code of  the finished demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

## What is CQRS?

CQRS or Command Query Responsibility Segregation is a design pattern to separate the read and write processes of your application. Read operations are called Queries and write operations are called Commands. Open one of the two microservices and you will see in the service project two folders, Command and Query. Inside the folder, you can see a handler and a command or query. They are used for the mediator, <a href="/mediator-pattern-in-asp-net-core-3-1" target="_blank" rel="noopener noreferrer">which I will describe in my next post</a>.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/04/Operations-are-split-in-Commands-and-Queries.jpg"><img loading="lazy" src="/assets/img/posts/2020/04/Operations-are-split-in-Commands-and-Queries.jpg" alt="Operations are split in Commands and Queries in CQRS" /></a>
  
  <p>
    Operations are split in Commands and Queries
  </p>
</div>

In the following examples, you will see that CQRS is simpler than it sounds. Simplified it is only a split of the read and write operations in different classes.

### Taking a look at a Query

In the CustomerApi solution, you can find the GetCustomerByIdQueryHandler inside the service project. Since this class is a query, it is used to read data. Inside the class is a Handle method, which calls the repository to get the first customer where the id matches the passed id.

<script src="https://gist.github.com/WolfgangOfner/b6b961f3774cfdb4711ee43a247f2e32.js"></script>

### Taking a look at a Command

In the CustomerApi solution, you can find the CreateCustomerCommandHandler inside the service project. This class also has a Handle method but this time it executes a write operation.

<script src="https://gist.github.com/WolfgangOfner/009df6b39f3aa128cf9dabafd80f5466.js"></script>

### Advantages of CQRS

CQRS offers the following advantages:

  * Separation of Concern, therefore simpler classes and models
  * Better scalability since you can have a microservice only for queries and one only for commands. Reads occur often way more often than writes.
  * Better performance as you can use a database for reading and a database for writing. You could also use a fast cache like Redis for the reading.
  * Event sourcing: it is not part of CQRS but they are often used together. Event sourcing is a collection of events that enables you to have the exact state of an object at any time.

### Disadvantages of CQRS

As always, CQRS also comes with some downside:

  * More complexity especially in bigger systems because often you have reads which also update some data, for example, a user logs in (read) and you want to store its IP and time of login (write).
  * Eventual consistency when using a database for writing and one for reading. The read database needs to be synchronized to hold the new data. This could take a while.
  * Not applicable in all projects: CQRS brings some complexity to your system and especially simple applications that do only basic CRUD operations shouldn&#8217;t use CQRS.

## Conclusion

This post gave a short overview of CQRS and how it can be used to separate the read and write operations in your application. In my demo code, I only use it to separate these operations but you could put the queries and commands in different solutions that allow you to independently scale them. 

<a href="/mediator-pattern-in-asp-net-core-3-1" target="_blank" rel="noopener noreferrer">In my next post</a>, I will describe the mediator pattern and how I use it to remove dependencies between commands and queries.

You can find the code of  the finished demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).