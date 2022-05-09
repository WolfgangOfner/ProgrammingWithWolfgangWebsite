---
title: Use a Database with a Microservice running in Kubernetes
date: 2021-03-22
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [DevOps, SQL, CI-CD, Azure DevOps, Azure, Docker, Kubernetes, AKS]
description: Configure microservices in Azure DevOps to use securely share connection strings and use different databases, depending on your environment.
---

I showed [in my last post](/deploy-dacpac-linux-azure-devops) how to automatically deploy database changes to your database. In this post, I will extend my microservice to use this database and also extend the deployment to provide a valid connection string.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Update the Microservice to use a Database

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

So far, the microservice uses an in-memory database. I want to keep the option to use the in-memory database for local debugging. Therefore, I add the following value to the appsettings.Development.json file:

<script src="https://gist.github.com/WolfgangOfner/671b5cded4aa419a5a1fb22f9dc17ef4.js"></script>

If you want to run the microservice locally with a normal database, set this value to false. Next, I add the database connection string to the appsettings.json file:

<script src="https://gist.github.com/WolfgangOfner/c873b6db10bfa3c578f123e07596ae0e.js"></script>

It is a best practice to use User Scripts when you are dealing with sensitive data in your local environment. To add User Secrets, right-click on your project and select Manage User Scripts.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Add-User-Secrets.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Add-User-Secrets.jpg" alt="Add User Secrets" /></a>
  
  <p>
   Add User Secrets
  </p>
</div>

After adding the settings, we only need one more change in the Startup.cs class. Here we change the configuration of the in-memory database to either configure a real database connection or the in-memory one, depending on the settings:

<script src="https://gist.github.com/WolfgangOfner/92f35d72b8503ec1aa4660ff8ab6dee6.js"></script>

To use an SQL Server, you have to install the Microsoft.EntityFrameworkCore.SqlServer NuGet package. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Install-the-SQL-Server-NuGet-package.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Install-the-SQL-Server-NuGet-package.jpg" alt="Install the SQL Server NuGet package" /></a>
  
  <p>
   Install the SQL Server NuGet package
  </p>
</div>

Additionally, comment out the code in the constructor of the CustomerContext. The data was used as initial values for the in-memory database.

<script src="https://gist.github.com/WolfgangOfner/2b18897031047bbc06d19b8491f9e135.js"></script>

If you want, run the application locally and test the database connection.

## Pass the Connection String in the CI/CD Pipeline

Providing the connection string in the CI/CD pipeline is simpler than you might think. All you have to do is add the following code to the values.yaml file inside the Helm chart folder of the API solution. 

<script src="https://gist.github.com/WolfgangOfner/c7da35ecd3be2d89c38ccc7facb43fff.js"></script>

This code sets the connection string as a secret in Kubernetes. Since the hierarchy is the same as in the appsettings.json file, Kubernetes can pass it to the microservice. The only difference is that the json file uses braces for hierarchy whereas secrets use double underscores (\_\_). The value for \_\_ConnectionString\_\_ will be provided by the ConnectionString variable during the [tokenizer step](/replace-helm-variables-tokenizer) in the pipeline.

## Test the Microservice with the database

Deploy the microservice and then open the Swagger UI. Execute the POST operation and create a new customer.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Add-a-new-customer-to-the-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Add-a-new-customer-to-the-database.jpg" alt="Add a new customer to the database" /></a>
  
  <p>
   Add a new customer to the database
  </p>
</div>

Connect to the database, for example, using the SQL Management Studio and you should see the new customer there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-new-customer-was-added-to-the-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-new-customer-was-added-to-the-database.jpg" alt="The new customer was added to the database" /></a>
  
  <p>
   The new customer was added to the database
  </p>
</div>

## Conclusion

Using a database with your microservice works the same way as with all .NET 5 applications. Due to the already existing CI/CD pipeline which is using Helm to create the deployment package, there were barely any changes necessary to pass the connection string to the microservice during the deployment.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).