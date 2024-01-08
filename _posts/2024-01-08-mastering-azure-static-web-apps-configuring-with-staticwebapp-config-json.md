---
title: Mastering Azure Static Web Apps - Configuring with staticwebapp.config.json
date: 2024-01-08
author: Wolfgang Ofner
categories: [Cloud, Programming]
tags: [Azure Static Web Apps, Jekyll, Routing, Redirect]
description: Discover how to effectively configure Azure Static Web Apps using staticwebapp.config.json. Learn to set up custom error pages, manage routing, and more for a seamless user experience
---

Over three years ago, I transitioned from Wordpress to Jekyll, which is hosted on Azure Static Web Apps. Additional details about this migration can be found in a [previous post](/we-moved-to-jekyll/). During that time, the routing was set up using the routes.json file. This was essential for tasks such as displaying a personalized 404 error page as opposed to the default Azure page.

However, this method has since been deprecated. The recommended approach now is to use the staticwebapp.config.json file for configuring the Azure Static Web App.

## Setting Up a Custom 404 Page in Azure Static Web App

The staticwebapp.config.json file is a versatile tool that can be used for configuring routing, authentication, HTTP header definitions, and much more. Given the simplicity of my blog, my primary requirement is to direct traffic to my custom 404 error page in the event of an HTTP 404 response.

To achieve this, create a staticwebapp.config.json file in the root directory of your application and insert the following code:

<script src="https://gist.github.com/WolfgangOfner/1ad5dcfa1d798c4402518d1e257fa029.js"></script>

The above code can be extended to handle additional error codes, such as HTTP 500 or 502, and display a custom error page for each HTTP error. Once the website is deployed, your custom error page should be visible in the event of an HTTP 404 error.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/01/The-custom-error-page-is-displayed.jpg"><img loading="lazy" src="/assets/img/posts/2024/01/The-custom-error-page-is-displayed.jpg" alt="The custom error page is displayed" /></a>
  
  <p>
   The custom error page is displayed
  </p>
</div>

For a comprehensive list of use cases for the configuration file, refer to the <a href="https://learn.microsoft.com/en-us/azure/static-web-apps/configuration" target="_blank" rel="noopener noreferrer">Microsoft documentation</a>.

## Conclusion

In conclusion, the transition from using routes.json to staticwebapp.config.json for configuring Azure Static Web Apps is a significant yet necessary change. This shift not only aligns with current best practices but also offers greater flexibility and control over your application. 

Whether it’s routing, authentication, or setting up custom error pages, the staticwebapp.config.json file is a powerful tool that can greatly enhance your web app’s functionality. 