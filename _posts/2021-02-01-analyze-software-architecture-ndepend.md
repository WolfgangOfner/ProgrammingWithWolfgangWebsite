---
title: Analyze Software Architecture with NDepend
date: 2021-02-01
author: Wolfgang Ofner
categories: [Miscellaneous]
tags: [Software Architecture, Tools, NDepend, NET Core 3.1, C#, ASP.NET Core MVC, Visual Studio]
---

A part of my job as a software consultant is to analyze existing software to find room for improvement to make the software better or to avoid these mistakes if the software is rewritten soon. The focus areas of your analysis vary depending on the requirements and there are also many good tools out there to help you.

Today, I will give a high-level overview of how I approach the analysis of a software project using NDepend. 

## NDepend

NDepend is a tool for .NET developers that gives deep insight into the codebase. The tool can be installed as a Visual Studio extension and analyzes your code and then gives you different graphs and dashboards to dig deeper into found issues. NDepend comes with a lot of pre-configured rules to analyze the code. These rules can be easily modified or extended to fit your needs. For this post, I will stick with the default rules

Note: NDepend provided me with a free license but they didn't get a preview version of this article nor do I accept any change requests in this article from them. Everything written here is my independent opinion.

### Install NDepend

You can download a 14 day trial version from the <a href="https://www.ndepend.com/download" target="_blank" rel="noopener noreferrer">NDepend website</a>. After your download is finished, extract the zip file and run the installer. This will install the Visual Studio extension.

Unfortunately, you have to keep this folder. If you delete it, the extension won't work anymore. Also if you use Visual Studio to install the extension, you only get redirected to the download page. I would like it better if I could install the Visual Studio extension and don't have to keep the folder.

### Analyze a .NET Core Software Project

If you are a reader of my blog, you know that I am a big fan of microservices. One big advantage of them is that they are small and simple. "Unfortunately" they are not great to showcase an analysis tool because there is not much to analyze. Instead, I will use the open-source NopCommerce. You can download the project from <a href="https://github.com/nopSolutions/nopCommerce/tree/4.30-bug-fixes" target="_blank" rel="noopener noreferrer">Github</a>. Unpack the zip file and then open the solution which is inside the src folder.

### Create a new NDepend project

Before you can create an NDepend project to analyze the solution, you have to build it. After the build is finished (it might take quite some time) go to Extensions --> NDepend and select Attach New NDepend Project to Current VS Solution.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Create-a-new-NDepend-project.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Create-a-new-NDepend-project.jpg" alt="Create a new NDepend project" /></a>
  
  <p>
   Create a new NDepend project
  </p>
</div>

This opens a new window where you can select the solution file you want to analyze. By default, the Nopcommerce solution file should already be selected. There you can also see all selected dlls. NDepend analyzes dlls rather than the solution file. That's the reason why you have to build the solution before you can analyze it.


<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Select-the-solution-file.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Select-the-solution-file.jpg" alt="Select the solution file" /></a>
  
  <p>
   Select the solution file
  </p>
</div>

Click on Analyze 22 .NET Assemblies and NDepend will analyze them and then create a dashboard with its findings.

### The NDepend Dashboard

The dashboard might look quite overwhelming at first but it is quite simple. One thing I don't like is that you have to add the code coverage results after the dashboard is created and then run the whole analysis process again. It would be nice if you could add the code coverage results before analyzing the project the first time. 

To add a code coverage you have to create it first. In Visual Studio select Test --> Analyze Code Coverage for all Tests (or the shortcut CRTL+U. CRTL+K). This runs all tests and then adds the Code Coverage Results panel. There you can export the results. 

In the NDepend dashboard click on the code coverage and then select the previously exported file. Run the NDepend code analysis again and you should see the code coverage in the dashboard.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/The-NDepend-dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/The-NDepend-dashboard.jpg" alt="The NDepend dashboard" /></a>
  
  <p>
   The NDepend dashboard
  </p>
</div>

The dashboard gives you a nice overview of the project so you know what you are getting into. For example, you can see that the solution has 78755 lines of code but only 7.56% code coverage. This is already a very bad sign. The technical debt is displayed as 38.16% which equals to 856 days of work according to NDepend. I don't know how NDepend comes up with this estimation but it gives you a good overview that the code of NopCommerce is probably in pretty bad shape.

A nice feature of the dashboard is that you can basically click everywhere to get more information. For example, click on the issues and you will get a list of all the issues with an explanation of what's wrong there. It also navigates you directly to the corresponding class or method.

The graphs of the dashboard are more or less empty at the moment because they show the changes over time. I think this is a nice feature. Even if the technical debt is not too accurate, its trend still might be useful. For example, if you are at the beginning of a sprint at 30% and at the end of the sprint at 36%, you can see that you probably created a lot of technical debt and should plan some time soon to fix it.

### Analyze Dependencies between DLLs

When you start analyzing an already existing project, it is always hard to get started and to figure out which projects are the center of the solution. NDepend helps you here with an interactive Dependency Graph. You can open it via Extensions --> NDepend --> Dependency Graph. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/The-dependency-graph.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/The-dependency-graph.jpg" alt="The dependency graph" /></a>
  
  <p>
   The dependency graph
  </p>
</div>

NopCommerce is a big solution but on the graph, you can see that it looks like that the solution is separated into three parts and the core parts are on the right of the graph containing dlls like Nop.Web and Nop.Core. Now that you have a starting point, you can dig deeper into the important dlls. For example, Nop.Web.Framework. You can easily zoom in with your mouse and see all dependencies inside this project. If you click on a namespace, for example, Nop.Web.Framework.Mvc, it gets highlighted in orange and shows you all calls to other namespaces and where it is used. This shows that the namespace is the core of the whole dll.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Dependencies-of-a-namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Dependencies-of-a-namespace.jpg" alt="Dependencies of a namespace" /></a>
  
  <p>
   Dependencies of a namespace
  </p>
</div>

You can learn a lot about the solution with the Dependency Graph even before you saw a line of code.

### Cyclomatic Complexity

The cyclomatic complexity is a metric that is used to indicate the complexity of code. It measures every available path through a method or class. For example, the following method has a cyclomatic complexity of 2 because there are two available paths.

```csharp
public string SoSomething(int i = 0)
{
    if (i == 0)
    {
        return "zero";
    }
    else
    {
        return "not zero";
    }
}
```

A rule of thumb is that a method should not have a cyclomatic complexity of more than 7. More than 7 means that the code is too complicated to efficiently understand and change.

NDepend gives you a graphical overview of all namespaces and their cyclomatic complexity. Click on Extensions --> NDepend --> Code Metrics. There you can select the level, for example, method or namespace, and what you want to display. Select Cyclomatic Complexity and then Top 10. This highlights the 10 methods with the highest complexity.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Code-metrics-overview.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Code-metrics-overview.jpg" alt="Code metrics overview" /></a>
  
  <p>
   Code metrics overview
  </p>
</div>

I am not a big fan of the optical presentation but it can give you a starting point to look into the most complex methods. The list of the top 10 methods is way more useful to me. You can find it on the right when you use the Code Metrics or you can click on Method Complexity on the dashboard-

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Cyclomatic-complexity-top-10.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Cyclomatic-complexity-top-10.jpg" alt="Cyclomatic complexity top 10" /></a>
  
  <p>
   Cyclomatic complexity top 10
  </p>
</div>

The list tells you the Namespace, class, and method and its cyclomatic complexity. Even before looking into the code, you can see that it's terrible because the complexity is in the hundreds. Remember, the rule of thumb says not more than 7 and then you see 123 or even 253 here. This is going to be a problem if developers have to touch this code.

### Technical Debt

Technical debt describes the impact of the cost of additional work when you choose to implement a feature as fast as possible instead of taking a better approach. The more technical debt you acquire, the harder it will be to implement new features. That is the reason why projects which are 3-5 year olds see a drastic increase in time needed per feature.

Let's look at a real-life example. Instead of saving 20 years for a house, you take the shortcut and get a mortgage from the bank. You have to repay the debt with interest over the next 20 years. If you don't repay the debt, it will increase due to the interest until you are unable to repay the mortgage and the bank will take your house.

The same principle applies in software. If you always take shortcuts, the debt will increase until it's too much and it will be almost impossible to implement new features because you introduce too many new features or have to change too much code.

The NDepend dashboard shows the technical debt percentage, gives a rating, and estimates how much work you would need to invest to fix this debt. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/The-NDepend-dashboard.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/The-NDepend-dashboard.jpg" alt="The NDepend dashboard" /></a>
  
  <p>
   The NDepend dashboard
  </p>
</div>

AS you can see NDepend calculated the technical debt with 38.16%, gave the rating D, and estimates that it will take 856 days, or 3 years to fix it. No technical debt is not the goal and even if these 856 are estimated too high, it gives you an idea about the condition of the solution. With the complex dependencies, the missing code coverage combined with the technical debt, I can say that the NopCommerce solution is in pretty bad shape, even before looking at the code itself.

NDepend aims at pointing out problems but also at helping you to resolve them. If you click on debt on the dashboard, you can see all issues listed on the right side. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/02/Overview-of-the-debt.jpg"><img loading="lazy" src="/assets/img/posts/2021/02/Overview-of-the-debt.jpg" alt="Overview of the technical debt" /></a>
  
  <p>
   Overview of the technical debt
  </p>
</div>

By default it's sorted by the time it takes to fix the issues but if you quickly go through the list, it gives you another indication about the bad state of the solution. You see a lot of code should be tested, method too big, too many parameters, type too big, too many fields, and so on. This all indicates that the methods and objects are very big and complex. Therefore they are hard to test or extend.

## Analyze the Software Architecture

So far, I used NDepend to get an overview of all the problems and get an indication that the NopCommerce solution is in a pretty bad state. But even if NDepend said that everything is good, the condition could be really bad. In this section, I want to show you a couple of fast indications to get a first opinion of the state of the project.

### Test Quality

Code coverage only tells you a part of the story, 7.56% like in NopCommerce is way too low though. Even if you have a high code coverage, you could have bad tests or are missing the edge cases of methods. Let's have a look at the following method and its test.

```csharp
public int Divide(int firstNumber, int secondNumber)
{
    return firstNumber / secondNumber;
}

[Fact]
public void Divide_DividesTwoInts_ShouldReturnResult()
{
    var result= _testee.Divide(10, 
    result.Should().Be(2);
}
```

This results in 100% code coverage. But if you think about the code, you will quickly see some flaws. If the second parameter is 0, you try to divide by 0 which is not allowed, and end in an exception. This means even with your 100% code coverage, your code produces an exception. Another problem you might see is that the result of the division is an integer. This means that the result is rounded and might lead to unexpected results, besides that it is very inaccurate.

#### Test Quality in NopCommerce

As you have seen in the section above, the code coverage gives you the first indication but you always should look at the tests themselves to classify their quality. NopCommerce has a code coverage of merely 7.56% but let's have a look at the quality of the existing tests. Since we have an ASP.NET Core MVC project, let's check the tests of the controllers first. Unfortunately, there is only one test and as you can see on the following code sample, even this test is useless and doesn't help at all.


```csharp
[TestFixture]
public class CategoryControllerTests : Nop.Tests.TestsBase
{
    public override void SetUp()
    {
        base.SetUp();
    }
}
```

If you look through the tests, you will find a couple of tests for validators, automapper config, and models. Most of the tests are useless, for example, creating an object and then checking if the properties you set are still the same value. These tests only help you to get your code coverage percentage up but it doesn't help the business running good software. 

Missing tests might indicate a problem with the architecture and/or too complicated classes which makes them untestable.

## Analyze the Project Structure

After checking the lack of tests and the previously discovered complexity of too big classes, methods, and so on, I want to check if that's the case. To do that I will start at the controllers and then go from layer to layer. I would expect a three-tier architecture where the controller takes a request and then calls a service. The service contains all the business logic and calls a repository. This repository handles all database operations. There could be more layers like a domain layer or a shared code library but this shouldn't change too much.

Since NopCommerce is an e-commerce shop, I guess that products, customers, and orders should be one of the main controllers. When you open the ProductController or the OrderController you will see that they have 3403 respectively 2826 lines of code. That is way too many!

The constructor of the ProductController looks as follows:

```csharp
public ProductController(IAclService aclService,
    IBackInStockSubscriptionService backInStockSubscriptionService,
    ICategoryService categoryService,
    ICopyProductService copyProductService,
    ICustomerActivityService customerActivityService,
    ICustomerService customerService,
    IDiscountService discountService,
    IDownloadService downloadService,
    IExportManager exportManager,
    IImportManager importManager,
    ILanguageService languageService,
    ILocalizationService localizationService,
    ILocalizedEntityService localizedEntityService,
    IManufacturerService manufacturerService,
    INopFileProvider fileProvider,
    INotificationService notificationService,
    IPdfService pdfService,
    IPermissionService permissionService,
    IPictureService pictureService,
    IProductAttributeParser productAttributeParser,
    IProductAttributeService productAttributeService,
    IProductModelFactory productModelFactory,
    IProductService productService,
    IProductTagService productTagService,
    ISettingService settingService,
    IShippingService shippingService,
    IShoppingCartService shoppingCartService,
    ISpecificationAttributeService specificationAttributeService,
    IStoreContext storeContext,
    IUrlRecordService urlRecordService,
    IWorkContext workContext,
    VendorSettings vendorSettings)
{
    _aclService = aclService;
    _backInStockSubscriptionService = backInStockSubscriptionService;
    _categoryService = categoryService;
    _copyProductService = copyProductService;
    _customerActivityService = customerActivityService;
    _customerService = customerService;
    _discountService = discountService;
    _downloadService = downloadService;
    _exportManager = exportManager;
    _importManager = importManager;
    _languageService = languageService;
    _localizationService = localizationService;
    _localizedEntityService = localizedEntityService;
    _manufacturerService = manufacturerService;
    _fileProvider = fileProvider;
    _notificationService = notificationService;
    _pdfService = pdfService;
    _permissionService = permissionService;
    _pictureService = pictureService;
    _productAttributeParser = productAttributeParser;
    _productAttributeService = productAttributeService;
    _productModelFactory = productModelFactory;
    _productService = productService;
    _productTagService = productTagService;
    _settingService = settingService;
    _shippingService = shippingService;
    _shoppingCartService = shoppingCartService;
    _specificationAttributeService = specificationAttributeService;
    _storeContext = storeContext;
    _urlRecordService = urlRecordService;
    _workContext = workContext;
    _vendorSettings = vendorSettings;
}
```

There are a couple of important principles in software development. My favorite is the Single Responsible Principle (SRP) and Keep it simple stupid (KISS). If you see a constructor like this you already know that this class does more than one thing and is not simple at all. A massive constructor like this makes it also almost impossible to test because you have to fake every parameter before you can even start writing your first test.

### Complexity of methods

In the previous section, I analyzed that the controllers are way too complicated. In this section, I will look into a method and try to find the service and repository layer (if they exist) and analyze their complexity. An online store needs products and without knowing anything about online shops, I would guess that this is a simple operation and therefore the method should be simple. Unfortunately, that's not the case in NopCommerce. NDepend analyzed a cyclomatic complexity of 53 which is way higher than the maximum recommended 7. The method has almost 200 lines of code and looks as follows:

```csharp
[HttpPost, ParameterBasedOnFormName("save-continue", "continueEditing")]
[FormValueRequired("save", "save-continue")]
public virtual IActionResult Create(CustomerModel model, bool continueEditing, IFormCollection form)
{
    if (!_permissionService.Authorize(StandardPermissionProvider.ManageCustomers))
        return AccessDeniedView
    if (!string.IsNullOrWhiteSpace(model.Email) && _customerService.GetCustomerByEmail(model.Email) != null)
        ModelState.AddModelError(string.Empty, "Email is already registered");
    if (!string.IsNullOrWhiteSpace(model.Username) && _customerSettings.UsernamesEnabled &&
        _customerService.GetCustomerByUsername(model.Username) != null)
    {
        ModelState.AddModelError(string.Empty, "Username is already registered");

    //validate customer roles
    var allCustomerRoles = _customerService.GetAllCustomerRoles(true);
    var newCustomerRoles = new List<CustomerRole>();
    foreach (var customerRole in allCustomerRoles)
        if (model.SelectedCustomerRoleIds.Contains(customerRole.Id))
            newCustomerRoles.Add(customerRole);
    var customerRolesError = ValidateCustomerRoles(newCustomerRoles, new List<CustomerRole>());
    if (!string.IsNullOrEmpty(customerRolesError))
    {
        ModelState.AddModelError(string.Empty, customerRolesError);
        _notificationService.ErrorNotification(customerRolesError);

    // Ensure that valid email address is entered if Registered role is checked to avoid registered customers with empty email address
    if (newCustomerRoles.Any() && newCustomerRoles.FirstOrDefault(c => c.SystemName == NopCustomerDefaults.RegisteredRoleName) != null &&
        !CommonHelper.IsValidEmail(model.Email))
    {
        ModelState.AddModelError(string.Empty, _localizationService.GetResource("Admin.Customers.Customers.ValidEmailRequiredRegisteredRole"
        _notificationService.ErrorNotification(_localizationService.GetResource("Admin.Customers.Customers.ValidEmailRequiredRegisteredRole"));

    //custom customer attributes
    var customerAttributesXml = ParseCustomCustomerAttributes(form);
    if (newCustomerRoles.Any() && newCustomerRoles.FirstOrDefault(c => c.SystemName == NopCustomerDefaults.RegisteredRoleName) != null)
    {
        var customerAttributeWarnings = _customerAttributeParser.GetAttributeWarnings(customerAttributesXml);
        foreach (var error in customerAttributeWarnings)
        {
            ModelState.AddModelError(string.Empty, error);
        }

    if (ModelState.IsValid)
    {
        //fill entity from model
        var customer = model.ToEntity<Customer>
        customer.CustomerGuid = Guid.NewGuid();
        customer.CreatedOnUtc = DateTime.UtcNow;
        customer.LastActivityDateUtc = DateTime.UtcNow;
        customer.RegisteredInStoreId = _storeContext.CurrentStore.
        _customerService.InsertCustomer(custome
        //form fields
        if (_dateTimeSettings.AllowCustomersToSetTimeZone)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.TimeZoneIdAttribute, model.TimeZoneId);
        if (_customerSettings.GenderEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.GenderAttribute, model.Gender);
        if (_customerSettings.FirstNameEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.FirstNameAttribute, model.FirstName);
        if (_customerSettings.LastNameEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.LastNameAttribute, model.LastName);
        if (_customerSettings.DateOfBirthEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.DateOfBirthAttribute, model.DateOfBirth);
        if (_customerSettings.CompanyEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.CompanyAttribute, model.Company);
        if (_customerSettings.StreetAddressEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.StreetAddressAttribute, model.StreetAddress);
        if (_customerSettings.StreetAddress2Enabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.StreetAddress2Attribute, model.StreetAddress2);
        if (_customerSettings.ZipPostalCodeEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.ZipPostalCodeAttribute, model.ZipPostalCode);
        if (_customerSettings.CityEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.CityAttribute, model.City);
        if (_customerSettings.CountyEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.CountyAttribute, model.County);
        if (_customerSettings.CountryEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.CountryIdAttribute, model.CountryId);
        if (_customerSettings.CountryEnabled && _customerSettings.StateProvinceEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.StateProvinceIdAttribute, model.StateProvinceId);
        if (_customerSettings.PhoneEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.PhoneAttribute, model.Phone);
        if (_customerSettings.FaxEnabled)
            _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.FaxAttribute, model.Fa
        //custom customer attributes
        _genericAttributeService.SaveAttribute(customer, NopCustomerDefaults.CustomCustomerAttributes, customerAttributesXm
        //newsletter subscriptions
        if (!string.IsNullOrEmpty(customer.Email))
        {
            var allStores = _storeService.GetAllStores();
            foreach (var store in allStores)
            {
                var newsletterSubscription = _newsLetterSubscriptionService
                    .GetNewsLetterSubscriptionByEmailAndStoreId(customer.Email, store.Id);
                if (model.SelectedNewsletterSubscriptionStoreIds != null &&
                    model.SelectedNewsletterSubscriptionStoreIds.Contains(store.Id))
                {
                    //subscribed
                    if (newsletterSubscription == null)
                    {
                        _newsLetterSubscriptionService.InsertNewsLetterSubscription(new NewsLetterSubscription
                        {
                            NewsLetterSubscriptionGuid = Guid.NewGuid(),
                            Email = customer.Email,
                            Active = true,
                            StoreId = store.Id,
                            CreatedOnUtc = DateTime.UtcNow
                        });
                    }
                }
                else
                {
                    //not subscribed
                    if (newsletterSubscription != null)
                    {
                        _newsLetterSubscriptionService.DeleteNewsLetterSubscription(newsletterSubscription);
                    }
                }
            }
    
        //password
        if (!string.IsNullOrWhiteSpace(model.Password))
        {
            var changePassRequest = new ChangePasswordRequest(model.Email, false, _customerSettings.DefaultPasswordFormat, model.Password);
            var changePassResult = _customerRegistrationService.ChangePassword(changePassRequest);
            if (!changePassResult.Success)
            {
                foreach (var changePassError in changePassResult.Errors)
                    _notificationService.ErrorNotification(changePassError);
            }
    
        //customer roles
        foreach (var customerRole in newCustomerRoles)
        {
            //ensure that the current customer cannot add to "Administrators" system role if he's not an admin himself
            if (customerRole.SystemName == NopCustomerDefaults.AdministratorsRoleName && !_customerService.IsAdmin(_workContext.CurrentCustomer))
                contin
            _customerService.AddCustomerRoleMapping(new CustomerCustomerRoleMapping { CustomerId = customer.Id, CustomerRoleId = customerRole.Id });
    
        _customerService.UpdateCustomer(custome
        //ensure that a customer with a vendor associated is not in "Administrators" role
        //otherwise, he won't have access to other functionality in admin area
        if (_customerService.IsAdmin(customer) && customer.VendorId > 0)
        {
            customer.VendorId = 0;
            _customerService.UpdateCustomer(custome
            _notificationService.ErrorNotification(_localizationService.GetResource("Admin.Customers.Customers.AdminCouldNotbeVendor"));
    
        //ensure that a customer in the Vendors role has a vendor account associated.
        //otherwise, he will have access to ALL products
        if (_customerService.IsVendor(customer) && customer.VendorId == 0)
        {
            var vendorRole = _customerService.GetCustomerRoleBySystemName(NopCustomerDefaults.VendorsRoleName);
            _customerService.RemoveCustomerRoleMapping(customer, vendorRol
            _notificationService.ErrorNotification(_localizationService.GetResource("Admin.Customers.Customers.CannotBeInVendoRoleWithoutVendorAssociated"));
    
        //activity log
        _customerActivityService.InsertActivity("AddNewCustomer",
            string.Format(_localizationService.GetResource("ActivityLog.AddNewCustomer"), customer.Id), customer);
        _notificationService.SuccessNotification(_localizationService.GetResource("Admin.Customers.Customers.Added"
        if (!continueEditing)
            return RedirectToAction("List");
        return RedirectToAction("Edit", new { id = customer.Id });

    //prepare model
    model = _customerModelFactory.PrepareCustomerModel(model, null, tru
    //if we got this far, something failed, redisplay form
    return View(model);
}
```

A controller should only take the request and then call services that handle the business logic. From a first glimpse, it looks like the controller does all the business logic already. This would also mean that you can't reuse the code to create a product because it is in the controller and not in a service class. Additionally, the controller does way more than creating a product that violates the Single Responsible Principle. Due to its insanely high complexity, it is also almost impossible to write adequate tests for the code. 

Previously, I said that I will dive down the different layers but after seeing the controller I feel like I have seen enough to give a first verdict.

## Code Reusability and APIs

Code reusability is an important factor when it comes to development speed and maintenance costs in the future. I like microservices and one feature of them is that they have many APIs which allow code to be shared easily. 

Let's look at the following use case: you have your NopCommerce online shop and then get the task to develop a mobile app for your store. With a modern microservice architecture, you only have to build the mobile app which then calls all your APIs to load data or create orders. This should be done fairly quickly. What about our existing NopCommerce solution?

As far as I have seen there are no APIs in the whole solution and as previously mentioned, all the business logic is in the controller. This means that it is not even possible to create a shared library of the service layer to share the code with the mobile app. While looking over the controller methods, I also saw that security checks like if the user has the right role are done in each controller method. Additionally, these checks read certain cookie values that are tied to the online shop and won't be available in your mobile app. 

I have spent maybe half an hour in the code but can already tell you that it's not possible to reuse the code without a lot of unnecessary extra work. 

## Last Thoughts on Analyzing Software Architecture

You can analyze the software architecture of a project with many goals in mind. It totally depends on the requirements of your analyzes. For example, if you should find out why software is running slowly, you would use a profiler or some measurement tools to find out which parts of your software are running slow. Then you can focus on these areas to improve the performance.

Another aspect of analyzing a software project could be the deployment process. I haven't talked about this at all but in a modern DevOps culture, all changes should be automatically tested and deployed (either after a change is committed or at the end of a sprint) and also should be reviewed before it gets merged in your master branch. Analyzing this process could span the build and deployment pipeline, what technologies are used, for example, Docker, and go even as far as analyzing how running the software works. For example, if you run it in Kubernetes with auto-scaling or if your application just crashes when it's out of resources.

Even if it's not directly analyzing the software architecture, it makes sense to look at the planned and recently finished features. If there are only new features and no refactoring tasks and if the features took quite some time, you can already guess that the software is in a bad shape. Here it is also your job as a consultant or architect to intervene and try to convince the product owner/manager to spend more time refactoring.

## Conclusion

This post gave you a high-level overview of how you can get started when analyzing the architecture of a software project. Look out for untestable code because this is often an indication of too complex code or a bad software architecture and keep software principles like the Single Responsible Principle, Separation of Concerns, and KISS in mind. Use tools to get a starting point and then start there to dive into the solution in more detail.

I used NDepend to analyze the NopCommerce solution and get an overview of its state. If this post sounded like bashing NopCommerce, this was not my intention. I used it because I wanted to show you a realistic piece of software and pointed out my findings. If they were all great I would have mentioned that too. Unfortunately, the negative ones totally outranked the good ones. I hope NDepend improves the installation process in the future so you can install it as an extension in Visual Studio without downloading and keeping the NDepend folder somewhere on your computer. 

NDepend was easy to use and give me a great overview of the state of the project and provided useful links to dive into the pain points of the solution. For example, I found quickly super complicated methods and could fairly easily make a list of the top 10 things I want to improve. I am not believing too much in the amount of work it tells me to fix the technical debt but it gives me an indication. 856 days is massive and should be definitively lower. Also, the graphs on the dashboard are nice to point out the trend where the project is going. If the graphs show that the technical debt went up by quite a bit over the last month, it might be easier to convince your manager to do fewer new features and fix more of the technical debt in the next sprint. 

I mentioned a couple of times that I am a big fan of microservices. If you want to learn more about microservices, see my series ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

Note: NDepend provided me with a free license but they didn't get a preview version of this article nor do I accept any change requests in this article from them. Everything written here is my independent opinion.