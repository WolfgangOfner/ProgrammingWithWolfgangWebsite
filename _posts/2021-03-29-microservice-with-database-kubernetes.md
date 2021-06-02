---
title: Use a Database with a Microservice running in Kubernetes
date: 2021-03-29
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [DevOps, SQL, CI-CD, Azure DevOps, Azure, Docker, Kubernetes, AKS]
description: Configure microservices in Azure DevOps to use securely share connection strings and use different databases, depending on your environment.
---

I showed [in my last post](/deploy-dacpac-linux-azure-devops) how to automatically deploy database changes to your database. In this post, I will extend my microservice to use this database and also extend the deployment to provide a valid connection string.

## Update the Microservice to use a Database

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

So far, the microservice used an in-memory database. I want to keep the option to use the in-memory database for local debugging. Therefore, I add the following value to the appsettings.Development.json file:

```json
"BaseServiceSettings": {
  "UseInMemoryDatabase": true
}
```

If you want to run the microservice locally with a normal database, set this value to false. Next, I add the connection string to the database to the appsettings.json file:

```json
"ConnectionStrings": {
  "CustomerDatabase": "" // -> use 'User Secrets' for local debugging
}  
```

It is a best practice to use User Scripts when you are dealing with sensitive data in your local environment. To add User Secrets, right-click on your project and select Manage User Scripts.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Add-User-Secrets.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Add-User-Secrets.jpg" alt="Add User Secrets" /></a>
  
  <p>
   Add User Secrets
  </p>
</div>

After adding the settings, we only need one more change in the Startup.cs class. Here we change the configuration of the in-memory database to either configure a real database connection or the in-memory one, depending on the settings:

```CSharp
bool.TryParse(Configuration["BaseServiceSettings:UseInMemoryDatabase"], out var useInMem

if (!useInMemory)
{
    services.AddDbContext<CustomerContext>(options =>
    {
        options.UseSqlServer(Configuration.GetConnectionString("CustomerDatabase"));
    });
}
else
{
    services.AddDbContext<CustomerContext>(options => options.UseInMemoryDatabase(Guid.NewGuid().ToString()));
}
```

To use an SQL Server, you have to install the Microsoft.EntityFrameworkCore.SqlServer NuGet package. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Install-the-SQL-Server-NuGet-package.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Install-the-SQL-Server-NuGet-package.jpg" alt="Install the SQL Server NuGet package" /></a>
  
  <p>
   Install the SQL Server NuGet package
  </p>
</div>

Additionally, comment out the code in the constructor of the CustomerContext. The data was used as initial values for the in-memory database.

```CSharp
public CustomerContext(DbContextOptions<CustomerContext> options) : base(options)
{
    //var customers = new[]
    //{
    //    new Customer
    //    {
    //        Id = Guid.Parse("9f35b48d-cb87-4783-bfdb-21e36012930a"),
    //        FirstName = "Wolfgang",
    //        LastName = "Ofner",
    //        Birthday = new DateTime(1989, 11, 23),
    //        Age = 30
    //    },
    //    new Customer
    //    {
    //        Id = Guid.Parse("654b7573-9501-436a-ad36-94c5696ac28f"),
    //        FirstName = "Darth",
    //        LastName = "Vader",
    //        Birthday = new DateTime(1977, 05, 25),
    //        Age = 43
    //    },
    //    new Customer
    //    {
    //        Id = Guid.Parse("971316e1-4966-4426-b1ea-a36c9dde1066"),
    //        FirstName = "Son",
    //        LastName = "Goku",
    //        Birthday = new DateTime(1937, 04, 16),
    //        Age = 83
    //    }
    /
    //Customer.AddRange(customers);
    //SaveChanges();
}
```

If you want, run the application locally and test the database connection.

## Pass the Connection String in the CI/CD Pipeline

Providing the connection string in the CI/CD pipeline is simpler than you might think. All you have to do is add the following code to the values.release.yaml file inside the API solution. 

```yaml
secrets:
  connectionstrings:
    ConnectionStrings__CustomerDatabase: __ConnectionString__
```

This code sets the connection string as secret in Kubernetes. Since the hierarchy is the same as in the appsettings.json file, Kubernetes can pass it to the microservice. The only difference is that the json file uses braces for hierarchy whereas secrets use double underscores (\_\_). The value for \_\_ConnectionString\_\_ will be provided by the ConnectionString variable during the tokenizer step in the pipeline.

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

Using a database with your microservice works the same way as with all .NET 5 applications. Due to the already existing CI/CD pipeline which is using Helm to create the deployment package, there was barely any change necessary to pass the connection string to the microservice during the deployment.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).