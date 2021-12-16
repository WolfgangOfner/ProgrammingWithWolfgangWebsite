---
title: Repository Pattern in .NET Core
date: 2020-06-04
author: Wolfgang Ofner
categories: [Design Pattern]
tags: [.NET Core, 'C#', Entity Framework Core]
description: Today, I will write about implementing .the Repository Pattern in .NET core using Entity Framework Core as the unit of work.
---
A couple of years ago, I wrote about the <a href="/repository-and-unit-of-work-pattern/" target="_blank" rel="noopener noreferrer">Repository and Unit of Work pattern</a>. Although this post is quite old and not even .NET Core, I get many questions about it. Since the writing of the post, .NET core matured and I learned a lot about software development. Therefore, I wouldn't implement the code as I did back then. Today, I will write about implementing .the repository pattern in .NET core

## Why I am changing the Repository Pattern in .NET Core

Entity Framework Core already serves as unit of work. Therefore you don&#8217;t have to implement it yourself. This makes your code a lot simpler and easier to understand.

## The Repository Pattern in .NET Core

For the demo, I am creating a simple 3-tier application consisting of controller, services, and repositories. The repositories will be injected into the services using the built-in dependency injection. You can find the code for the demo on <a href="https://github.com/WolfgangOfner/.netCoreRepositoryAndUnitOfWorkPattern" target="_blank" rel="noopener noreferrer">GitHub</a>.

In the data project, I have my models and repositories. I create a generic repository that takes a class and offers methods like get, add, or update.

### Implementing the Repositories

<script src="https://gist.github.com/WolfgangOfner/f200c7eafdc3b340728f6ddc9e964df0.js"></script>

This repository can be used for most entities. In case one of your models needs more functionality, you can create a concrete repository that inherits from Repository. I created a ProductRepository which offers product-specific methods:

<script src="https://gist.github.com/WolfgangOfner/72d7270f94a932885d562d65115cae63.js"></script>

The ProductRepository also offers all generic methods because its interface IProductRepository inherits from IRepository:

<script src="https://gist.github.com/WolfgangOfner/34f1315814dd9991abbdea2f99364106.js"></script>

The last step is to register the generic and concrete repositories in the Startup class.

<script src="https://gist.github.com/WolfgangOfner/29887ad62294946cafe3ce802a7d9859.js"></script>

The first line registers the generic attributes. This means if you want to use it in the future with a new model, you don't have to register anything else. The second and third line register the concrete implementation of the ProductRepository and CustomerRepository.

### Implementing Services which use the Repositories

I implement two services, the CustomerService and the ProductService. Each service gets injected a repository. The ProductServices uses the IProductRepository and the CustomerService uses the ICustomerRepository;. Inside the services, you can implement whatever business logic your application needs. I implemented only simple calls to the repository but you could also have complex calculations and several repository calls in a single method.

<script src="https://gist.github.com/WolfgangOfner/497898c728239f13eabb410c2c152a79.js"></script>

<script src="https://gist.github.com/WolfgangOfner/de2360c746c0a00a0fd4817a53937d80.js"></script>

## Implementing the Controller to test the Application

To test the application, I implemented a really simple controller. The controllers offer for each service method a parameter-less get method and return whatever the service returned. Each controller gets the respective service injected.

<script src="https://gist.github.com/WolfgangOfner/449d07c44862ebaa5d82a00a9729d032.js"></script>

<script src="https://gist.github.com/WolfgangOfner/db2924ffb7b82933281ecb89eb3f6daa.js"></script>

When you call the create customer action, a customer object in JSON should be returned.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Test-the-creation-of-a-customer.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Test-the-creation-of-a-customer.jpg" alt="Test the creation of a customer Repository Pattern in .NET Core " /></a>
  
  <p>
    Test the creation of a customer
  </p>
</div>

## Use the database

If you want to use the a database, you have to add your connection string in the appsettings.json file. My connection string looks like this:

<script src="https://gist.github.com/WolfgangOfner/3362322935c831739349f1689c3b4161.js"></script>

By default, I am using an in-memory database. This means that you don&#8217;t have to configure anything to test the application

<script src="https://gist.github.com/WolfgangOfner/d652e6f7bb560f153d786a986999dba3.js"></script>

I also added an SQL script to create the database, tables and test data. You can find the script <a href="https://github.com/WolfgangOfner/.NETCoreRepositoryAndUnitOfWorkPattern/blob/master/NetCoreRepositoryAndUnitOfWorkPattern.Data/DatabaseScript/database.sql" target="_blank" rel="noopener noreferrer">here</a>.

## Conclusion

In today's post, I gave my updated opinion on the repository pattern and simplified the solution compared to my post a couple of years ago. This solution uses entity framework core as unit of work and implements a generic repository that can be used for most of the operations. I also showed how to implement a specific repository, in case the generic repository can&#8217;t full fill your requirements. Implement your own unit of work object only if you need to control over your objects.

You can find the code for the demo on <a href="https://github.com/WolfgangOfner/.NETCoreRepositoryAndUnitOfWorkPattern" target="_blank" rel="noopener noreferrer">GitHub</a>.