---
title: Free Website Hosting with Azure
date: 2020-06-07
author: Wolfgang Ofner
categories: [Cloud]
tags: [Azure, Azure Functions, Azure Static Web Apps, 'C#', Cosmos DB, React]
description: Azure Static Web Apps is a great tool to host your application for free around the globe. It integrates with GitHub actions and builds your website automatically for you.
---
<a href="/azure-static-web-apps/" target="_blank" rel="noopener noreferrer">Last week, I talked about hosting your static website with Azure Static Web Apps.</a> Today, I will extend this example using a free Cosmos DB for the website data and Azure Functions to retrieve them. This approach will give you free website hosting and global distribution of your website.  
You can find the demo code of the Azure Static Web App <a href="https://github.com/WolfgangOfner/React-Azure-Static-Web-App" target="_blank" rel="noopener noreferrer">here</a> and the code for the Azure Functions <a href="https://github.com/WolfgangOfner/AzureFunctions-CosmosDb" target="_blank" rel="noopener noreferrer">here</a>.

## Azure Cosmos DB

Cosmos DB is a high-end NoSQL database that offers incredible speed and global distribution. Cosmos DB is way too comprehensive to talk about all the features here. I am using it because it offers a free tier which should give you enough compute resources for a static website.

### Create a Free Tier Cosmos DB

In the Azure Portal search for Azure Cosmos DB, select it and click on Create or select Azure Cosmos DB from the left panel and then click on Create Azure Cosmos DB account.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Create-a-new-Cosmos-DB.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Create-a-new-Cosmos-DB.jpg" alt="Create a new Cosmos DB" /></a>
  
  <p>
    Create a new Cosmos DB
  </p>
</div>

On the next page, select a resource group and make sure that the Free Tier Discount is applied. After filling out all information click on Review + create.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Set-up-the-free-tier-of-the-Cosmos-DB.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Set-up-the-free-tier-of-the-Cosmos-DB.jpg" alt="Set up the free tier of the Cosmos DB" /></a>
  
  <p>
    Set up the free tier of the Cosmos DB
  </p>
</div>

The deployment will take around ten minutes.

### Add Data to the Cosmos Database

After the deployment is finished, navigate to the Data Explorer tab in your Cosmos DB account. Click on New Container and a new tab is opened on the right side. There enter a Database id, Container id, and Partition key and click OK.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Create-a-new-catabase-and-container-in-the-Azure-Cosmos-DB.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Create-a-new-catabase-and-container-in-the-Azure-Cosmos-DB.jpg" alt="Create a new database and container in the Azure Cosmos DB" /></a>
  
  <p>
    Create a new database and container in the Azure Cosmos DB
  </p>
</div>

Open the newly created database and the Products container and click on New Item. This opens an editor where you can add your products as JSON.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Add-data-to-the-container.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Add-data-to-the-container.jpg" alt="Add data to the container for your Free Website Hosting " /></a>
  
  <p>
    Add data to the container
  </p>
</div>

Again, Azure Cosmos DB is too big to go into any details in this post. For the free hosting of your website, it is only important to know that I added the data for the website into the database. The next step is to edit the Azure Function so it doesn't return a static list but uses the Azure Cosmos DB instead.

## Using an Azure Function to read Data from Cosmos DB

I am re-using the Azure Function from my last post. If you don&#8217;t have any yet, create a new Azure Function with an HTTP trigger. To connect to the Cosmos DB, I am installing the Microsoft.Azure.Cosmos NuGet package and create a private variable with which I will access the data.

<script src="https://gist.github.com/WolfgangOfner/922db02f8459c52f5825e670fb3ef93f.js"></script>

Next, I create a method that will create a connection to the container in the database.

<script src="https://gist.github.com/WolfgangOfner/c010540435c90e9133b11cb443ff2847.js"></script>

To connect to the Azure Cosmos DB container, you have to enter your URI and primary key. You can find them in the Keys tab of your Cosmos DB account.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Get-the-Uri-and-Primary-Key-of-the-Cosmos-DB.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Get-the-Uri-and-Primary-Key-of-the-Cosmos-DB.jpg" alt="Get the Uri and Primary Key of the Cosmos DB for your Free Website Hosting " /></a>
  
  <p>
    Get the Uri and Primary Key of the Cosmos DB
  </p>
</div>

In the next method, I am creating an iterator that will return all my products. I add these products to a list and return the list. You can filter the query by providing a filter statement in the GetItemQueryIterator method.

<script src="https://gist.github.com/WolfgangOfner/0ca774b18e68337656d43c8e969406c4.js"></script>

In the Run method of the Azure Function, I am calling both methods and convert the list to a JSON object before returning it.

<script src="https://gist.github.com/WolfgangOfner/0c0200452fe8144da7c7d6696f5192b7.js"></script>

I keep the Product class as it is.

<script src="https://gist.github.com/WolfgangOfner/716ee39715864f194b9400377ec8bdfd.js"></script>

Start the Azure Function, enter the URL displayed in the command line and you will see your previously entered data.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Test-the-Azure-Function-locally.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Test-the-Azure-Function-locally.jpg" alt="Test the Azure Function locally" /></a>
  
  <p>
    Test the Azure Function locally
  </p>
</div>

The last step is to deploy the Azure Function. In my last post, I already imported the publish profile. Since nothing has changed, I can right-click on my project, select Publish and then Publish again.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/Publish-the-Azure-Function.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/Publish-the-Azure-Function.jpg" alt="Publish the Azure Function for your Free Website Hosting " /></a>
  
  <p>
    Publish the Azure Function
  </p>
</div>

## Testing the Free Website Hosting Implementation

Open the URL of your Azure Static Web App and the data from the Cosmos DB will be displayed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/06/The-data-from-the-database-is-displayed-in-the-React-app.jpg"><img loading="lazy" src="/assets/img/posts/2020/06/The-data-from-the-database-is-displayed-in-the-React-app.jpg" alt="The data from the database is displayed in the React app" /></a>
  
  <p>
    The data from the database is displayed in the React app
  </p>
</div>

## Conclusion

Today, I showed how to use Azure Cosmos DB, Azure Functions and Azure Static Web Apps to achieve free website hosting and also a global distribution of the website. You can find the demo code of the Azure Static Web App <a href="https://github.com/WolfgangOfner/React-Azure-Static-Web-App" target="_blank" rel="noopener noreferrer">here</a> and the code for the Azure Functions <a href="https://github.com/WolfgangOfner/AzureFunctions-CosmosDb" target="_blank" rel="noopener noreferrer">here</a>.

During Ignite in September 2020, Microsoft announced new features for Static Web Apps. From now on it is also possible to host Blazor apps and the connection with the Azure Function got improved a lot. You can find my post about it <a href="/azure-static-web-app-with-blazor/" target="_blank" rel="noopener noreferrer">here</a>.