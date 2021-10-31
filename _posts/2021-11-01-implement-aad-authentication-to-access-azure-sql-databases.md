---
title: Implement AAD Authentication to access Azure SQL Databases
date: 2021-11-01
author: Wolfgang Ofner
categories: [Cloud, Programming]
tags: [Azure, SQL, AAD, 'C#', .NET, Entity Framework Core, Azure CLI, Azure SQL]
description: Using Azure Active Directory authentication to access data from an Azure SQL Server can be implemented easily and helps you to go passwordless. 
---

Microsoft promotes going passwordless for a while now. Azure offers authentication against the Azure Active Directory where applications can acquire access tokens using their identity. Another use case would be accessing an SQL database running on Azure. Although, in theory, this sounds very easy, my experience showed that it can get tricky.

Today I want to show you how to configure Azure SQL with Azure Active Directory authentication and how to avoid annoying pitfalls.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Configure AAD Authentication for an Azure SQL Server

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi" target="_blank" rel="noopener noreferrer">Github</a>.

In one of my previous posts, I have created an SQL Server that runs all my databases. If you also have an SQL server, you have to set an Active Directory admin. This admin can be either an AAD user or a group. Without this admin, the SQL server won't be able to authenticate your users against the AAD.

You can either use the Azure portal or Azure CLI to set the Active Directory admin. If you use the portal, open your SQL server and select the Active Directory admin pane. There, click on Set admin, search for your user or group and save your selection.

If you use the Azure CLI, use the following query to get all aad users:

<script src="https://gist.github.com/WolfgangOfner/2a369b0bd181aaec0219fc066d7fc215.js"></script>

The --query parameter only filters the response to only display the principal name of the AAD user.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Get-the-principal-name-of-all-AAD-users.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Get-the-principal-name-of-all-AAD-users.jpg" alt="Get the principal name of all AAD users" /></a>
  
  <p>
   Get the principal name of all AAD users
  </p>
</div>

My AAD currently has only one user and therefore returns only this one principal name. Once you know the principal name of the group or user you want to set as admin, you can filter using the --filter flag so your query only returns this one entity. Save the return value in a variable, so you can reuse it in the next step.

<script src="https://gist.github.com/WolfgangOfner/fc620c85759c02f6ef8d58f5db8696f9.js"></script>

With the user set to the variable, use the following command to set the Active Directory admin. Replace the resource group and server name with your corresponding values.

<script src="https://gist.github.com/WolfgangOfner/40e53882bd0d349e93a7101783148bc7.js"></script>


<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Set-the-Active-Directory-admin.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Set-the-Active-Directory-admin.jpg" alt="Set the Active Directory admin" /></a>
  
  <p>
   Set the Active Directory admin
  </p>
</div>

## Configure the Test Application to use AAD Authentication 

XXX Check ob AAD log in mit pw funktioniert wenn admin nicht in master db eingetragen ist. XXX

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi" target="_blank" rel="noopener noreferrer">Github</a>.

Open the SQL management tool of your choice, for me, it's Microsoft SQL Server Management Studio (SSMS), and log in with the user you previously set as the Active Directory admin.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Log-in-using-the-server-admin-user.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Log-in-using-the-server-admin-user.jpg" alt="Log in using the server admin user" /></a>
  
  <p>
   Log in using the server admin user
  </p>
</div>

You should be able to log in and see all the databases on the server.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-login-was-successful.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-login-was-successful.jpg" alt="The login was successful" /></a>
  
  <p>
   The-login-was-successful
  </p>
</div>

Now it is time to test the login with a test application. To use AAD authentication when developing, you have to sign in to Visual Studio. Visual Studio then uses this user to request an access token and authenticate you to the SQL server. Since you should not use the admin account for your application, I log in with a different user.

Before you can use your test application, you have to make some small changes. First, install the following NuGet packages:

<script src="https://gist.github.com/WolfgangOfner/ac7e15877b4f3d482ba16bb0c3b214ab.js"></script>

Next, create a custom SQL authentication provider. This class requests an access token from the AAD.

<script src="https://gist.github.com/WolfgangOfner/4faaf043f6fed35b567e61b71e2024d7.js"></script>

With the authentication provider set up, register your DbContext in the Startup.cs class and add the previously created authentication provider.

<script src="https://gist.github.com/WolfgangOfner/df5aeda2699ce2218a0e771b7864ccc8.js"></script>

Lastly, set the following connection string in your appsettings.json file.

<script src="https://gist.github.com/WolfgangOfner/a3b7c8ee3529784c771142559c03002e.js"></script>

## Testing the AAD Authentication

If you are using my demo application, make sure that you have set the "UseInMemoryDatabase" setting in the appsettings.json and appsettings.Development.json files to false. Otherwise, the application will use an in-memory database. 

When you start the demo application, you will see the Swagger UI. Execute the Get request for Customer and you will see the following error message:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-login-to-the-Customer-database-failed.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-login-to-the-Customer-database-failed.jpg" alt="The-login-to-the-Customer-database-failed" /></a>
  
  <p>
   The-login-to-the-Customer-database-failed
  </p>
</div>

The login failed because the user logged in to Visual Studio has no access to the Customer database. You have to add your users to the database before they can access it.

### Add Users to your Database

Log in to the database with the user you previously set as the admin. Add your Visual Studio user with the following code and also give the user the desired roles. 

<script src="https://gist.github.com/WolfgangOfner/9141fb00fad16c11cee75d3e756b931c.js"></script>

Now you should be able to log in with this user. If you use SSMS, make sure that you select the Customer database as the default database. If you don't set Customer as your default database, SSMS will use the Master database and since the user does not exist in this database, the login will fail.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/The-user-does-not-exist-in-the-Master-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/The-user-does-not-exist-in-the-Master-database.jpg" alt="The user does not exist in the Master database" /></a>
  
  <p>
   The user does not exist in the Master database
  </p>
</div>

## Try the Test Application again

Start the test application and execute the Get request again. This time you should get some customers. You may get the following error though:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Login-to-the-SQL-server-failed.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Login-to-the-SQL-server-failed.jpg" alt="Login to the SQL server failed" /></a>
  
  <p>
   Login to the SQL server failed
  </p>
</div>

If you google this error message, you won't find much helpful information. Also, Microsoft's documentation doesn't mention anything about this error. 

The problem you encounter here is that your user exists in multiple tenants and the authentication provider does not know which tenant it should use. To fix this problem, you have to add the tenant where the SQL server resides to your authentication provider.

<script src="https://gist.github.com/WolfgangOfner/ff225ea73729718378fbafe7b4a4e412.js"></script>

Replace the XXX with your actual tenant Id.

Run your application again and now you should be able to retrieve the data from the database.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Successfully-retrieved-data-from-the-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Successfully-retrieved-data-from-the-database.jpg" alt="Successfully retrieved data from the database" /></a>
  
  <p>
   Successfully retrieved data from the database
  </p>
</div>

To verify that you loaded the data from the right database, log in to your database using SSMS and query the Customers in your Customer database. The result should be the same as you saw previously in your test application.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/11/Query-customers-from-the-database-using-SSMS.jpg"><img loading="lazy" src="/assets/img/posts/2021/11/Query-customers-from-the-database-using-SSMS.jpg" alt="Query customers from the database using SSMS" /></a>
  
  <p>
   Query customers from the database using SSMS
  </p>
</div>

## Improving the Test Application

The test application can retrieve data using the AAD authentication but the code is not pretty yet. Especially the part where the tenant Id is hardcoded into the authentication provider. Let's improve this code a bit.

First add a new property, TenantId to the appsettings.json file.

<script src="https://gist.github.com/WolfgangOfner/0097a26acdf4da885007bb9c39134765.js"></script>

Next, add a constructor to your CustomAzureSqlAuthProvider with a string as the parameter. This string will contain the tenant Id. Assign the parameter to a private variable. Then replace the hard-coded tenant Id with the new private variable.

<script src="https://gist.github.com/WolfgangOfner/e45dd2710f31631e342d0fcacc2e9e07.js"></script>

Lastly, read the value of the tenant Id from the appsettings.json file and pass it to the constructor of your authentication provider in the Startup.cs class.

<script src="https://gist.github.com/WolfgangOfner/2623f3a357887415caa6a529ae240219.js"></script>

Run your application again to make sure that everything still works.

## Conclusion

Azure Active Directory authentication to access your databases is a great feature to get rid of passwords. This should also streamline the development process since you don't have to share passwords with new developers. All you have to do is to add the developer to the desired database so they can log in. 

There may be some roadblocks on the way and Microsoft's documentation only showcases the happy path of the integration. This post should help you with the most common pitfalls and shows how to avoid them.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).