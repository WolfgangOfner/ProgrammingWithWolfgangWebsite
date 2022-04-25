---
title: Create Custom Roles for Azure DevOps in Azure
date: 2021-10-04
author: Wolfgang Ofner
categories: [Cloud, DevOps]
tags: [DevOps, Azure, Azure DevOps]
description: You can create an Azure role with all the permissions you need and assign this role to a user, group, or service principal.
---

By default, the Azure DevOps service principal that is used to run a CI/CD pipeline with Azure resources gets the Contributor role assigned. This role can create new services but sometimes the Azure pipeline has to execute a task that is outside of the scope of the Contributor role, for example, adding RBAC assignments or deleting locks.

In this post, I will show you how to create a custom role in Azure and how to assign it to the Azure DevOps service principal.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Create a new Azure Custom Role

[In my next post](/update-dns-records-in-an-azure-devops-pipeline/), I want my Azure DevOps pipeline to be able to update my DNS records. Since the DNS zone is a very sensitive resource, I have added a lock so it can not be deleted. This lock also prevents the Azure DevOps pipeline from deleting DNS records. Additionally, the Contributor role of the pipeline service principal is not allowed to create new locks either. Since there is no built-in role for creating and deleting locks, I have to create my own.

To create a new role go to your subscription in the Azure portal, select the Access control (IAM) pane and then click Add under Create a custom role.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Add-a-custom-role.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Add-a-custom-role.jpg" alt="Add a custom role" /></a>
  
  <p>
   Add a custom role
  </p>
</div>

In the Create a custom role window, provide a name and a description for your new role and then click on Permissions.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Provide-a-name-and-description-for-the-new-custom-role.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Provide-a-name-and-description-for-the-new-custom-role.jpg" alt="Provide a name and description for the new custom role" /></a>
  
  <p>
   Provide a name and description for the new custom role
  </p>
</div>

In the Permissions tab, click the Add permissions button and search for locks on the flyout. Select the Write and Delete permission from the Microsoft.Authorization/locks permission.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Configure-the-permissions.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Configure-the-permissions.jpg" alt="Configure the permissions" /></a>
  
  <p>
   Configure the permissions
  </p>
</div>

Go to the Review + create tab and click Create to create the new custom role.

## Assign the Custom Role to the Azure DevOps Service Principal

After the new role is created, click on + Add and select Add role assignments on the Access control (IAM) pane of your subscription.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Add-a-new-role-assignment.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Add-a-new-role-assignment.jpg" alt="Add a new role assignment" /></a>
  
  <p>
   Add a new role assignment
  </p>
</div>

This opens a flyout where you can search for the previously created custom role and also for the service principal of your Azure DevOps pipeline. If you do not know the service principal, go to your Azure Active Directory and select Enterprise applications. You should see Azure DevOps there.


<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/Add-the-custom-role-to-the-service-principal.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/Add-the-custom-role-to-the-service-principal.jpg" alt="Add the custom role to the service principal" /></a>
  
  <p>
   Add the custom role to the service principal
  </p>
</div>

After the role was assigned, go to the Role assignments tab of the Access control (IAM) pane and you should see the previously created role assignment there. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/10/The-role-was-assigned.jpg"><img loading="lazy" src="/assets/img/posts/2021/10/The-role-was-assigned.jpg" alt="The role was assigned" /></a>
  
  <p>
   The role was assigned
  </p>
</div>

## Conclusion

Azure comes with a grave variety of pre-defined roles for your services and users. Though sometimes, you need special permissions that are not built-in. This is where custom roles come into play. You can create a role with all the permissions you need and assign this role to a user, group, or service principal. This post showed how to assign the new role to a service principal that is used by Azure DevOps and [in my next post](/update-dns-records-in-an-azure-devops-pipeline/), I will show you how to use this service principal to update DNS records in a CI/CD pipeline.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).