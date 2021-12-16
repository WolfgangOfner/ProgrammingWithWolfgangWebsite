---
title: Use AAD Authentication for Applications running in AKS to access Azure SQL Databases
date: 2021-12-06
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [Azure, SQL, AAD, Azure CLI, Azure SQL, AKS, Kubernetes, Managed Identity]
description: Removing passwords and using identities to access resources is the way to go for new applications. This post shows you how to configure your application running in AKS to access an Azure SQL database.
---

Removing passwords and using identities to access resources is the way to go for new applications. In my last posts [Use AAD Authentication for Pods running in AKS](/use-aad-authentication-for-pods-running-in-aks) and [Implement AAD Authentication to access Azure SQL Databases](/implement-aad-authentication-to-access-azure-sql-databases), I showed you how to enable AAD for Azure Kubernetes Service and how to use AAD authentication to access an Azure SQL database. 

In this post, I want to show you how to use your own managed identity to configure an application running in AKS to access an Azure SQL database. 

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Configure AKS for AAD Authentication

You can find the details about the configuration of the AKS cluster in my previous post [Use AAD Authentication for Pods running in AKS](/use-aad-authentication-for-pods-running-in-aks). Here is the short version to set up your AKS cluster:

Set up some variables before you start. Make sure to replace <YourAzureSubscriptionId> with the subscription id where your AKS cluster is running.

<script src="https://gist.github.com/WolfgangOfner/6d8c0345231d7214627bda6f9ca7a47d.js"></script>

Assign the Managed Identity Operator and Virtual Machine Contributor role to the managed identity of the AKS cluster.

<script src="https://gist.github.com/WolfgangOfner/23bff74abc3a525743af89dbade2a6cf.js"></script>

Next, add and install the aad-pod-identity Helm chart. See [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm) for more information about Helm charts.

<script src="https://gist.github.com/WolfgangOfner/49ece58a8d86c5d3192eee38140435fa.js"></script>

Lastly, create a new managed identity. This managed identity will be used to authentication the application in your Azure SQL database.

<script src="https://gist.github.com/WolfgangOfner/1485648644bc1b14dc16c5d1334fdca0.js"></script>

## Configure the Azure SQL Server and Database for AAD Authentication

You can find the details about the configuration of the Azure SQL Server and database in my previous post [Implement AAD Authentication to access Azure SQL Databases](/implement-aad-authentication-to-access-azure-sql-databases). Here is the short version to set up your AKS cluster:

Set a user or group as admin of your SQL server. You can use the portal or the CLI.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/Set-the-SQL-Server-Admin.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/Set-the-SQL-Server-Admin.jpg" alt="Set the SQL Server Admin" /></a>
  
  <p>
   Set the SQL Server Admin
  </p>
</div>

If you use the Azure portal, don't forget to click Save after selecting a user or group.

Login to your SQL server with this admin user (or a member of the admin group) using AAD Authentication. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/Log-in-using-the-server-admin-user.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/Log-in-using-the-server-admin-user.jpg" alt="Log in using the server admin user" /></a>
  
  <p>
   Log in using the server admin user
  </p>
</div>

Open a new query window and set some permission for your previously created managed identity. 

<script src="https://gist.github.com/WolfgangOfner/dc3fff10d6b45b68092b3a6c67c3b559.js"></script>

Make sure to change the database name and/or the managed identity name if you are not using the same names as I do.

## Configure your Application running in AKS to use AAD Authentication

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi" target="_blank" rel="noopener noreferrer">GitHub</a>.

There are a few things you have to do before you can use AAD authentication for your SQL Server. 

First, add two files to the Helm chart of your application, aadpodidentity and aadpodidentitybinding. Aadpodidentity creates a resource of type AzureIdentity and configures the name of the managed identity, its resource id and client id.

<script src="https://gist.github.com/WolfgangOfner/f44cd86ef67db843987861d1aa2d79e5.js"></script>

The second file, creates a resource of type AzureIdentityBinding and tells your application what managed identity it should use to acquire the authentication token.

<script src="https://gist.github.com/WolfgangOfner/c911f9e207b252f956558ee79b8b5764.js"></script>

If you do not want to use Helm or the values.yaml file, you can use normal strings in both files. You can find the resource id and client id in the previously created variables when creating the managed identity.

Add the previously created new values to the values.yaml file:

<script src="https://gist.github.com/WolfgangOfner/595ee57c4e5e7a99fbca728a52617026.js"></script>

The variables starting and ending with two underscores (\_\_) will be replaced in the CD pipeline. You can read more about this in [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

Next, add the following label in the deployment.yaml file in your Helm chart in the labels section of metadata and template.

<script src="https://gist.github.com/WolfgangOfner/fbe9b10777d3555e84adfc7ff646c028.js"></script>

This label is necessary for the AzureIdentityBinding resource to select the right deployment. Make sure that the value of the label matches the value of the selector in the aadpodidentitybinding.yaml file.

## Configure the CD Pipeline 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/CustomerApi-CD.yml" target="_blank" rel="noopener noreferrer">GitHub</a>.

The connection string is different when using AAD authentication. Since you don't need a username or password anymore, make sure to edit your connection string. It should something like this:

<script src="https://gist.github.com/WolfgangOfner/8f9e4f5d4154f6c0373f8fd7cdb38237.js"></script>

Lastly, make sure to add the new variable to your pipeline. 

<script src="https://gist.github.com/WolfgangOfner/1e0d738ee344ede7a34723a9bcec1605.js"></script>

Also add the client and resource id and the tenent id as secret to your pipeline.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/Add-secrets-to-the-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/Add-secrets-to-the-pipeline.jpg" alt="Add secrets to the pipeline" /></a>
  
  <p>
   Add secrets to the pipeline
  </p>
</div>

## Test the Implementation

Check-in your code and let the Azure DevOps pipeline run. After the deployment is finished, go to your application and you should be able to load your data from the database.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/Retrieving-data-from-the-database-works.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/Retrieving-data-from-the-database-works.jpg" alt="Retrieving data from the database works" /></a>
  
  <p>
   Retrieving data from the database works
  </p>
</div>

## Conclusion

Getting started with AAD authentication is not easy and Microsoft's documentation is incomplete and a bit misleading at the time of this writing. There are several approaches and it took me some time to get it working. Once you figured out how it works, it is quite simple to configure, as you have seen in this post.

In my next post, I will show you how to make the necessary changes in the CI pipeline so that everything gets configured and deployed automatically.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/tree/master/CustomerApi" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).