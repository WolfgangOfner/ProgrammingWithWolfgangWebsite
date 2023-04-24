---
title: Create a VPC Connection between Azure and Timescale
date: 2022-08-15
author: Wolfgang Ofner
categories: [Cloud]
tags: [PostgreSQL, Timescale, Azure, VNet peering, VNet, Azure CLI]
description: This tutorial explains how to create a VNet peering connection between your Azure tenant and Timescale.
---

This week, I was helping a customer of mine to migrate from an on-prem database to a cloud-hosted <a href="https://www.timescale.com" target="_blank" rel="noopener noreferrer">TimescaleDB</a>. Since the customer is using Azure, they wanted to host their new TimescaleDB in Azure. 
Timescale offers to host the database on Azure and also allows a private connection via VPC (virtual private cloud) peering. This allows customers to peer a VNet with the VNet of Timescale and therefore only allow traffic coming from this VNet. As a result, it is not possible to connect to the database over the internet.

Unfortunately, I had some problems creating the VPC peering, and therefore want to describe how I achieved it.

## Introduction

There is an article about <a href="https://kb-managed.timescale.com/en/articles/5489252-setting-up-a-vpc-on-azure" target="_blank" rel="noopener noreferrer">Setting up a VPC on Azure</a> in the Timescale knowledge base. I only found this article after I emailed the support (which replied very fast). After trying to follow this guide, I realized that some commands were not working in the Azure CLI and also that the commands were more complicated than needed. With that, I mean that if a query returned a value, instead of writing this value into a variable, the guide stated to find the variable from the output and assign it to a variable by hand.

If you follow this guide, you will see what is not working on the official documentation and you also won't need to assign any output values by hand. They will be assigned automatically.

## Let's get started

This article assumes that you already have a TimescaleDB with VPC running in Azure. If not, log into your Timescale account and create a new VPC in the desired Azure region. Wait until the state of the VPC is active and then create a new database with the previously created VPC as its location. Note that you won't be able to access this database until you finish the VPC peering.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-connection-to-the-TimescaleDb-was-refused.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-connection-to-the-TimescaleDb-was-refused.jpg" alt="The connection to the TimescaleDb was refused" /></a>
  
  <p>
   The connection to the TimescaleDb was refused
  </p>
</div>

All of the following guide will be done in the command line using <a href="https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2" target="_blank" rel="noopener noreferrer">PowerShell</a>, the <a href="https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli" target="_blank" rel="noopener noreferrer">Azure CLI</a> and <a href="https://github.com/aiven/aiven-client" target="_blank" rel="noopener noreferrer">Aiven CLI</a> on Ubuntu. In theory, it is possible to create a VPC peering in the Timescale portal, but this does by far not include all the necessary steps and therefore won’t work.

## Create an Application in your AAD

Log into your Azure account using the Azure CLI and set the subscription you want to use (this is only necessary if your account has multiple subscriptions). 

<script src="https://gist.github.com/WolfgangOfner/2fa99fa9667cf94db0bf68e56a825820.js"></script>

Create an application in your AAD with the following command. You can use whatever display name you prefer.

<script src="https://gist.github.com/WolfgangOfner/77214098bb4b6776be1ab4468dc91926.js"></script>

This app uses the --sign-in-audience AzureADandPersonalMicrosoftAccount flag which will enable multiple tenants to log into this application. However, only your tenant has the credentials for the authentication. 

Here I found the biggest problem with the official guide. This uses the --available-to-other-tenants flag, which to my knowledge does not exist and therefore won't work. Make sure to use the --sign-in-audience flag instead.

## Create a Service Principal

Next, create a service principal for the previously created AAD application. 

<script src="https://gist.github.com/WolfgangOfner/4f5e7da7559fc1edfcefd0766a66da4b.js"></script>

This service principal will be used later to peer your VNet with the VNet of Timescale.

## Set a Password for the Application

You will use the previously created AAD application to log into Azure. Therefore, you will need its password. You can retrieve the password by simply resetting the current one. 

<script src="https://gist.github.com/WolfgangOfner/c0a19601e3e3c46acbe7a4cb806b927c.js"></script>

This command will give you a warning to be careful because the output contains credentials. You can ignore this warning since that's exactly what we wanted to do.

## Gather Information about your VNet, Resource Group, and Subscription

This step assigns the id of your VNet, the resource group it is located in, your subscription id, and your tenant id into variables. Make sure to replace \<YOUR_PEERING_NAME\> with a name of your choosing and enter your VNet name in the first line of the following code:

<script src="https://gist.github.com/WolfgangOfner/306e3aa8b00abce2137c0883222b116c.js"></script>

## Assign the Network Contributor Role to the Service Principal

The previously created service principal will be used to create the peering from your VNet to the Timescale VNet. Therefore, the service principal will need the Network Contributor Role. The following commands will query the id of this role and then assign it to the service principal.

<script src="https://gist.github.com/WolfgangOfner/6a8a8f809f23393956c495fff534daf9.js"></script>

The --scope flag limits the role assignment to the VNet resource.

## Create a Service Principal for the TimescaleDB application

The Timescale Tenant on Azure contains an application that can be used to create a peering from your Timescale VPC project to your VNet. To be able to do that, the Timescale AD application needs a service principal in your subscription. You can create this service principal with the following code.

<script src="https://gist.github.com/WolfgangOfner/a2919558718462ea97f89592e4e7a3db.js"></script>

Note that you need the "Application Administrator" permission to be able to execute the code above. If you do not have this permission, you will get the following error message:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Insufficient-permissions-to-create-the-service-principal.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Insufficient-permissions-to-create-the-service-principal.jpg" alt="Insufficient permissions to create the service principal" /></a>
  
  <p>
   Insufficient permissions to create the service principal
  </p>
</div>

## Create a Custom Role for the Network Peering

The Timescale application needs the "Microsoft.Network/virtualNetworks/peer/action" permission to create the network peering. Since you always want to give the least amount of permissions, it is recommended to create a custom role that contains only this permission. To make the creation of the role in the command line easier, save the following code into a JSON file. Replace \<YOUR_SUBSCRIPTION_ID\> with your actual subscription id and optionally, change the name of the role.

<script src="https://gist.github.com/WolfgangOfner/6f70ecdab6f6420b288e1b7d88092fee.js"></script>

Next, execute a role definition create and pass the JSON file as a parameter:

<script src="https://gist.github.com/WolfgangOfner/d58c5052916e9ddbeec9a77bd6e19d16.js"></script>

Lastly, assign this new custom role to the previously created Timescale service principal:

<script src="https://gist.github.com/WolfgangOfner/6405396499646e9df4a81f6416f590d1.js"></script>

## Create an Access Token for the Aiven CLI

Log into your account in the Timescale portal and select your account icon on the top right, switch to the Authentication tab, and then click on "Generate token"

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Generate-a-new-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Generate-a-new-access-token.jpg" alt="Generate a new access token" /></a>
  
  <p>
   Generate a new access token
  </p>
</div>

This opens a new window where you can enter a name for your access token and configure its expiration time.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Configure-the-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Configure-the-access-token.jpg" alt="Configure the access token" /></a>
  
  <p>
   Configure the access token
  </p>
</div>

After you clicked on generate token, the token is generated.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Copy-the-access-token.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Copy-the-access-token.jpg" alt="Copy the access token" /></a>
  
  <p>
   Copy the access token
  </p>
</div>

Make sure to copy the access token since this is the only time that you have access to the token.

Additionally, I would recommend you enable two-factor authentication in your account settings.

### Install the Aiven CLI

The Aiven CLI installation needs Python (pip) to be installed on your system. To install it, use the following code:

<script src="https://gist.github.com/WolfgangOfner/6bb003fa6b638cc7f14bc0faf5746153.js"></script>

Next, install the Aiven CLI.

<script src="https://gist.github.com/WolfgangOfner/fb0cb0e6b65bbfaba9d11bc7a5f44ced.js"></script>

Use the Aiven CLI to log into your Timescale account. Make sure to change \<YOUR_USER\> with your Timescale user.

<script src="https://gist.github.com/WolfgangOfner/c39add583c21c4fc9203751ac34a697d.js"></script>

After you execute the login, pass your previously created access token.

### Retrieve the VPC Project ID

The following code works because there is only 1 VPC per region. Note to replace timescale-azure-switzerland-north with your location if you are not using Switzerland North. The project ID is always 36 characters long, as far as I know.

<script src="https://gist.github.com/WolfgangOfner/d3efc30bc211516b1786feb2b3a0a43d.js"></script>

### Create Peering Connection

The VPC project id and some of the previously created variables are now needed to create a peering connection from the Timescale VNet into your VNet. Use the following code to create the connection:

<script src="https://gist.github.com/WolfgangOfner/01290722a1d36ab342c56b37a4c0063f.js"></script>

Note that the input variables starting with user_ must be lowercase since the Aiven API can only handle lower-case inputs.

### Check the Peering Status and Assign Variables

Creating the peering connection might take some time but usually, it is only a couple of seconds. Before you proceed, make sure with the following command that the state of the connection is ACTIVE.

<script src="https://gist.github.com/WolfgangOfner/58dbb968bf15286c3d8d6cd8b209e4c8.js"></script>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/Check-the-peering-state.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/Check-the-peering-state.jpg" alt="Check the peering state" /></a>
  
  <p>
   Check the peering state
  </p>
</div>

If the state is not ACTIVE, wait a bit and retry the command from above. If the state is INVALID_SPECIFICATION or REJECTED_BY_PEER, check that VNet you passed as a parameter exists and that the Timescale application was given the proper permissions. After you checked that, repeat the command from above and the peering connection should be created.

The output of this command is horrendous but you have to copy the value of to-tenant-id and to-network-id to the variables aiven_vnet_id and aiven_tenant_id. Make sure to replace the placeholder with your actual values.

<script src="https://gist.github.com/WolfgangOfner/142c28ef0b178724c38bc6c8b9dcf2bc.js"></script>

The tenant Id is a GuId and the VNet id should look something like "/subscriptions/\<SUBSCRIPTION_GUID}>/resourceGroups/...

### Create the VNet peering from your VNet to your VPC

Log out of the Azure CLI and then log in with your service principal into your tenant and also into the Timescale tenant.

<script src="https://gist.github.com/WolfgangOfner/93553931e2fc885d48c51db8524701ef.js"></script>

After you successfully logged into both tenants, create the VNet peering between your VNet and the Timescale VNet

<script src="https://gist.github.com/WolfgangOfner/c9266da9c0da3cb38e5097866b4a9846.js"></script>

You can check the state of your peering connection with the following command:

<script src="https://gist.github.com/WolfgangOfner/6107313f6bf2a9852c2acb58dd7b736c.js"></script>

Right after you created the peering connection, the state will be APPROVED and after a couple of seconds, it should switch to PENDING_PEER.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-peering-was-approved-and-is-pending.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-peering-was-approved-and-is-pending.jpg" alt="The peering was approved and is pending" /></a>
  
  <p>
   The peering was approved and is pending
  </p>
</div>

Wait a bit and the peering state should switch to ACTIVE

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-peering-is-active.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-peering-is-active.jpg" alt="The peering is active" /></a>
  
  <p>
   The peering is active
  </p>
</div>

If you follow the official documentation, note that the command to check the state is cut off and won't work.

## Test the Connection

With the peering connection in place, test if you can log into your Timescale database. Make sure that you are connecting from within your peered VNet, otherwise, the connection won't work.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/08/The-TimescaleDb-login-worked.jpg"><img loading="lazy" src="/assets/img/posts/2022/08/The-TimescaleDb-login-worked.jpg" alt="The TimescaleDb login worked" /></a>
  
  <p>
   The TimescaleDb login worked
  </p>
</div>

Note that I used pgAdmin to test the connection despite using Azure Data Studio at the beginning of this tutorial. The PostgreSQL extension of Azure Data Studio was constantly crashing and I could not get it working again.

## Clean up your Resources

If you do not need your resources anymore, make sure to clean up everything you have created.

### Delete the VNet Peering

First, delete the VNet peering with the following command.

<script src="https://gist.github.com/WolfgangOfner/983b1726eb27042a59ad768c2361d608.js"></script>

### Delete both Role Bindings

Next, retrieve the Ids of the role bindings and then delete both.

<script src="https://gist.github.com/WolfgangOfner/e70699383e11e7a65f7a1ed229b4f283.js"></script>

### Delete the Custom Role

After you deleted the role binding, delete the previously created custom role.

<script src="https://gist.github.com/WolfgangOfner/d952ecd581fe79affb4878336a6183f9.js"></script>

If you used a different name for the custom role, make sure to replace "VnetPeerCreator" with your name.

### Delete the Applications from your AAD

Lastly, delete both applications from your AAD.

<script src="https://gist.github.com/WolfgangOfner/2fc3cb09031a926805f932fa342aaa6f.js"></script>
 
Make sure that you have the "Application Administrator" permission to delete the app with the Aiven service principal.

## Conclusion

This post showed how you can create a database on Timescale and how to create a private peering connection between your Azure subscription and the Timescale network. Setting up the VNet peering allows only connections from within your VNet to access the database. This approach enables you to let Timescale manage your database while it is not accessible over the internet and therefore should be quite secure.