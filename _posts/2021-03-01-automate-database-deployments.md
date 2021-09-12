---
title: Automate Database Deployments
date: 2021-03-01
author: Wolfgang Ofner
categories: [DevOps]
tags: [DevOps, SSDT, CI-CD]
description: Automate database deployments to deploy reliable applications fast and repeatable into different environments without any manual configuration.
---

DevOps has been around for some years now and most developers know what it means. In simple terms, it stands for a culture where you automate all your steps from code merges to tests and deployment. Doing this for an application is often quite simple. It gets way harder when database changes are involved though. 

In this post, I will show you three ways how to automatically apply your changes and why one method is better than the other ones.

## Why you should automate Database Changes

In a modern DevOps culture, you want to deploy fast and often, with high quality. Achieving fast and qualitative deployments can only be done with automation. Usually, when developers get started with DevOps, they start automating the build and release process of their application. Deploying an application, for example, in .NET or a Docker container is fairly simple but it gets complicated when database changes come into play. Since it is not as straight-forward as deploying an application, database changes are often done by hand or at the start of the application. Both approaches are bad and in the following sections, I will give examples and explain why these approaches are bad in my eyes.

## Difficulties of Database Changes

I mentioned a couple of times that database changes are hard, but are they really?

Yes and no. If you have experience with deploying database changes, they are simple. If you are new to this topic, it might be hard and confusing. It is crucial that you know the base concepts of database changes. The most important rule is to never deploy breaking changes. Let's look at an example where you deploy breaking changes.

You have an online shop with a Customer table and want to remove the FaxNumber column. You change the C# code and prepare the database migration. Then you run the database migration and suddenly your application stops working. This is because the old code is still deployed and this code expects the Customer table to have a FaxNumber. 

Keep in mind that you always have to support two versions of your application. The current deployed one and the future one. If your application runs in Kubernetes and you use rolling updates, you will have both versions running until all old pods are replaced with new ones.

### How to deploy Breaking Changes

Breaking changes need to be deployed over two deployments. In the first deployment, you stop using the FaxNumber column (make it nullable), and in a second deployment delete it. This also makes rollbacks easier since you don't have to restore deleted data.

## Execute Entity Framework Core Migrations on Startup

Entity Framework allows developers to write migrations. These can be to make changes (Up) or to roll previous changes back (Down). This could be, for example, creating a new table in the Up method and deleting the method in the Down method. These migrations can be triggered in the Startup method of the application. EF then checks the history of the migrations and executes each migration that wasn't executed previously.

The migrations are executed automatically during the startup of the application but it comes with a couple of downsides. If you run your application in a modern environment, like a cloud environment or Kubernetes, you don't know when your application is evicted and restarted. This could mean that your application restarts every minute, which means that it checks every minute to execute the migration. Especially with containers, we want as fast as possible startup times. Another downside is that you have no control of the time when the migrations are applied. Maybe you want to deploy a feature but hide it behind a feature flag and then activate the feature and make the database changes later. This would require a second deployment and would make the whole process way more complex. 

Due to the downsides, try to avoid the Entity Framework migrations.

## Using Tools like FluentMigrator

If you don't have much experience with migrations and look at tools like FluentMigrator, you might think that it is something great and will help you. The FluentMigrator gives you many helper methods to write SQL code with C# and also executes the migrations during the startup of the applications. You can find the project on <a href="https://github.com/fluentmigrator/fluentmigrator" target="_blank" rel="noopener noreferrer">Github</a>.

These helper methods are, for example, .Table("") or .PrimaryKey().

<script src="https://gist.github.com/WolfgangOfner/84601c805254db9777184d02a9b4296d.js"></script>

Using the FluentMigrator makes it easy to see all migrations and also makes it fairly easy to write SQL code with C#. Though, it has the same downsides as the Entity Framework migrations and therefore shouldn't be used in modern applications.

## SQS Server Data Tools (SSDT)

SSDT is a project type for relational databases and is well integrated into Visual Studio. It enables IntelliSense support and build time validation to find problems fast and help developers to make changes easier. Its main feature is the schema comparison between an existing database and its own definition. For example, if your database has a table Customer with the column FaxNumber and the definition of the Customer table in your SSDT project doesn’t have this column, the SSDT project will delete the column automatically during the deployment. The developer has to write no code for that. On the other hand, if the SSDT project contains tables or even a database that doesn’t exist, the SSDT project will create these tables or even create a new database during the deployment (publish) process. 

Another big advantage is that SSDT allows new developers to set up new environments or a local test system very fast. The SSDT project automatically handles the versioning of the migration. This means no developer has to manually provide a version number and it guarantees that no more conflicts between multiple migrations with the same version number will occur. On the following screenshot, you can see a table where the migration history is stored.

Additionally, SSDT can execute SQL scripts before or after the deployment. This means that DBA's can write complex SQL scripts and then only have to add the script to the right folder in the project. 

Since the database changes are deployed, it is very easy to integrate this deployment into your CI/CD pipeline. In my next two posts, I will show you how to create an SSDT project and how to deploy locally, and then how to deploy it using a CI/CD pipeline in Azure DevOps.

## Conclusion

There are many ways to automatically apply database changes but you should strive for a solution that gives you full control over the execution of the changes. Entity Framework and NuGet packages like the FluentMigrator don't give you these options and therefore shouldn't be used. I recommend using SQS Server Data Tools (SSDT) to easily apply your schema changes or even execute SQL scripts.

["In my next post"](/automatically-deploy-database-changes), I will show you how to apply changes using SSDT locally.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).