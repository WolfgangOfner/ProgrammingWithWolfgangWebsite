---
title: Automatically deploy Database Changes with SSDT
date: 2021-03-08
author: Wolfgang Ofner
categories: [DevOps]
tags: [DevOps, SSDT, SQL]
description: Use SSDT (SQS Server Data Tools) to generate Dacpac packages and deploy them automatically to an SQL Server.
---

[In my last post](/automate-database-deployments), I talked about deploying database changes automatically. Today, I will show how to use SSDT (SQS Server Data Tools) to generate a Dacpac package and how to deploy it to your SQL server.

## Prepare your Environment

Before you can get started, you have to download the custom SSDT Tools from [Github](https://github.com/4tecture/SSDTDataMigration/releases). These custom tools are an extension of the [MSBuild.Sdk.SqlProj](https://github.com/rr-wfm/MSBuild.Sdk.SqlProj/) project and are necessary to be able to open the SSDT project file (*.sqlproj) with Visual Studio.

## Getting to know the SSDT Project Structure

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ssdt-demo" target="_blank" rel="noopener noreferrer">Github</a>.

Open the .sqlproj file with Visual Studio and you will see the project structure. There are two relevant folders inside the project, Scripts, and Tables.

### The Scripts folders

The Scripts folder contains the PostScripts, PreScripts, and ReferenceDataScripts subfolders.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-Scripts-folder-contains-SQL-scripts.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-Scripts-folder-contains-SQL-scripts.jpg" alt="The Scripts folder contains SQL scripts" /></a>
  
  <p>
   The Scripts folder contains SQL scripts
  </p>
</div>

Scripts in the PreScripts folder are executed before the deployment whereas scripts in the PostScripts and ReferenceDataScripts folders are executed after the deployment. There are two folders after the deployment for a better separation of concern but it would also be fine if you put all your scripts into the PostScripts folder. You can execute any SQL script you want, except schema changes. Schema changes are defined in the Tables folder.

### The Tables folder

The Tables folder contains the definition of your tables. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-definitions-of-all-tables.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-definitions-of-all-tables.jpg" alt="The definitions of all tables" /></a>
  
  <p>
   The definitions of all tables
  </p>
</div>

The MigrationScriptsHistory table is needed to store all executed migrations. All other tables are customer-defined and you can add whatever tables you need, for example, the Product table:

<script src="https://gist.github.com/WolfgangOfner/1ebe90dbd186d742597959aebeef6c91.js"></script>

If you double-click on the SQL file in Visual Studio, you can see the script file and the designer to edit the file.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-SQL-Designer-in-Visual-Studio.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-SQL-Designer-in-Visual-Studio.jpg" alt="The SQL Designer in Visual Studio" /></a>
  
  <p>
   The SQL Designer in Visual Studio
  </p>
</div>

## Generate the Database using SSDT

I have added two tables, Customer and Product, and want to deploy this new database to my database server. Since Docker is awesome, I use a Docker container for my SQL Server. You can start an SQL Server 2019 with the following command:

<script src="https://gist.github.com/WolfgangOfner/94b1712cd9a33918334147ca500c171d.js"></script>

If you connect to your server, using tools like the SQL Server Management Tool, you will see that there is no database yet.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/No-database-is-on-the-server.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/No-database-is-on-the-server.jpg" alt="No database is on the server" /></a>
  
  <p>
   No database is on the server
  </p>
</div>

To deploy the new database, right-click the .sqlproj file in Visual Studio and select Publish.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Publish-the-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Publish-the-database.jpg" alt="Publish the database" /></a>
  
  <p>
   Publish the database
  </p>
</div>

This opens the Publish Database window.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Configure-the-database-deployment.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Configure-the-database-deployment.jpg" alt="Configure the database deployment" /></a>
  
  <p>
   Configure the database deployment
  </p>
</div>

As you can see, the connection string is empty. Click on edit and enter your database server information.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Provide-the-connection-settings.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Provide-the-connection-settings.jpg" alt="Provide the connection settings" /></a>
  
  <p>
   Provide the connection settings
  </p>
</div>

This creates the connection string and now you can click on Publish to deploy your database.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Deploy-the-database.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Deploy-the-database.jpg" alt="Deploy the database" /></a>
  
  <p>
   Deploy the database
  </p>
</div>

The publish process should only take a couple of seconds and Visual Studio will tell you when it is finished.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-publish-succeeded.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-publish-succeeded.jpg" alt="The publish succeeded" /></a>
  
  <p>
   The publish succeeded
  </p>
</div>

That's already it. Refresh your SQL server and you will see the new database with its three tables.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-database-and-tables-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-database-and-tables-got-created.jpg" alt="The database and tables got created" /></a>
  
  <p>
   The database and tables got created
  </p>
</div>

## Applying changes to an existing Database

If you already have an existing database and want to apply changes, for example, adding a new column, you can simply add it to the existing table. Open the Product table and add a price column as a decimal. The code looks as follows:

<script src="https://gist.github.com/WolfgangOfner/22bfb9217f632e31d567ad931fee5cfe.js"></script>

That's already all you have to do. Publish the project again and update your SQL server to see the new column in the Product table.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-Product-table-got-a-new-column.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-Product-table-got-a-new-column.jpg" alt="The Product table got a new column" /></a>
  
  <p>
   The Product table got a new column
  </p>
</div>

## Configure the Target Platform

If you don't use an SQL Server 2019 then you have to configure your target platform before you can publish the project. Right-click the .sqlproj file and select Properties. Select the desired target platform in the Project Settings tab.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Configure-the-target-platform.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Configure-the-target-platform.jpg" alt="Configure the target platform" /></a>
  
  <p>
   Configure the target platform
  </p>
</div>

## Conclusion

SSDT offers a simple solution to automating your database deployments. It automatically checks the schema on the deployed database and compares it with the schema in your SSDT project. If there is a change, these changes are applied. This allows for fast changes and even allows for setting up environments for new developers fast and easily. The demo was very simple but should give you enough knowledge to get started.

[In my next post](/deploy-dacpac-linux-azure-devops), I will show how to build the SSDT project in your CI/CD pipeline and how to deploy it to an Azure SQL Database.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/ssdt-demo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).