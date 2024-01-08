---
title: Configuring DNS still sucks in 2023 (featuring Azure Static Web App)
date: 2023-08-15
author: Wolfgang Ofner
categories: []
tags: [Azure, Azure Static Web Apps, Azure DNS Zone]
description: Learn how to navigate DNS configurations when moving between countries and setting up Office 365, Azure Static Web Apps, and custom domains
---

Last week, I created a new Office 365 organization since I moved from Australia to Canada, and creating a new one is the only way to move countries. Due to having a new organization, I also had to move my domain and update my DNS configuration for my email server and website which is hosted as an Azure Static Web App. 

This short post will only be a rant about DNS configurations sucking and will contain a couple of notes for myself in case I have to update the settings again in the future.

## My DNS and Website Setup

I am using Office 365 Exchange to host my emails, Azure Static Web Apps to host my website, and Azure DNS to manage my DNS settings. Additionally, I am managing my domain with a third-party company that also has a DNS and Name Server configuration. 

## Set up an Office 365 Organization with your Custom Domain

Setting up a new Office 365 organization is quite straightforward. Create a new account, select the plan you want, and purchase it. After you have set up the organization, open the <a href="https://admin.microsoft.com/" target="_blank" rel="noopener noreferrer">Office 365 Admin Center</a> and you will see a wizard that will guide you to set up your custom domain. All you have to do basically is to add a TXT entry to your DNS records to verify that you own the domain.

## Configuring a Third-Party DNS to use Azure DNS

As I mentioned before, I am "using" a third-party DNS as well as the Azure DNS. Since I only want to use the Azure DNS, I removed all records from there and changed the Name Server to the name server of my Azure DNS zone.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/08/Name-server-in-Azure-DNS-Zone.jpg"><img loading="lazy" src="/assets/img/posts/2023/08/Name-server-in-Azure-DNS-Zone.jpg" alt="Name server in Azure DNS Zone" /></a>
  
  <p>
   Name server in Azure DNS Zone
  </p>
</div>

## Configuring Custom Domains for Azure Static Web App

In theory, configuring an Azure Static Web App with a custom domain is straightforward. Go to your Azure Static Web App, open the Custom domains pane and then follow these two guides: <a href="https://learn.microsoft.com/en-us/azure/static-web-apps/custom-domain-azure-dns" target="_blank" rel="noopener noreferrer">Set up a custom domain with Azure DNS in Azure Static Web Apps</a> and <a href="https://learn.microsoft.com/en-us/azure/static-web-apps/apex-domain-azure-dns" target="_blank" rel="noopener noreferrer">Set up an apex domain with Azure DNS in Azure Static Web Apps</a>.

This worked out just fine (except for the DNS propagation "problems" that just need some time) until I realized that my website works for https://programmingwithwolfgang.com but not when I use www. I already had this problem the last time I set up the Azure Static Web App but my domain provider has an option to redirect https://www.programmingwithwolfgang.com to https://programmingwithwolfgang.com so I never bothered with that. Now I had to learn that this option was not available anymore. 

I have to admit that I didn't really know what to do and so I tried just to add another custom domain to my web app, but this time with the www and it works. Now I have two entries there and use the one without www as my default. As a result, requests to https://www.programmingwithwolfgang.com get redirected to https://programmingwithwolfgang.com but that's just fine for me. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/08/Add-custom-domains-to-an-Azure-Static-Web-App.jpg"><img loading="lazy" src="/assets/img/posts/2023/08/Add-custom-domains-to-an-Azure-Static-Web-App.jpg" alt="Add custom domains to an Azure Static Web App" /></a>
  
  <p>
   Add custom domains to an Azure Static Web App
  </p>
</div>

## Conclusion

Configuring DNS is still a pain in 2023 but if you follow the guides and test a bit, you should be able to get it going.