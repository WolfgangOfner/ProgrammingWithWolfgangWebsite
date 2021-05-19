---
title: Built-in Filter in ASP.NET MVC
date: 2018-01-20T16:53:11+01:00
author: Wolfgang Ofner
categories: [ASP.NET]
tags: [Action, Attribute, Controller, filter, MVC]
description: Filters provide a simple and elegant way to implement cross-cutting concerns in your ASP.NET MVC application. Filter achieve this by injecting code into the request processing. Examples of cross-cutting concerns are logging and authorization.
---
Filters provide a simple and elegant way to implement cross-cutting concerns in your ASP.NET MVC application. Filter achieve this by injecting code into the request processing. Examples of cross-cutting concerns are logging and authorization.

## Five Types of Filter

ASP.NET MVC has five types of filter built-in which allow you to implement additional logic during the request processing.

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Filter Type
      </td>
      
      <td>
        Interface
      </td>
      
      <td>
        Default Implementation
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        Action
      </td>
      
      <td>
        IActionFilter
      </td>
      
      <td>
        ActionFilterAttribute
      </td>
      
      <td>
        Runs before and after the action method
      </td>
    </tr>
    
    <tr>
      <td>
        Authentication
      </td>
      
      <td>
        IAuthenticationFilter
      </td>
      
      <td>
        None
      </td>
      
      <td>
        Runs first, before any other filters or the<br /> action method and can run again after<br /> the authorization filters
      </td>
    </tr>
    
    <tr>
      <td>
        Authorization
      </td>
      
      <td>
        IAuthorizationFilter
      </td>
      
      <td>
        AuthorizeAttribute
      </td>
      
      <td>
        Runs second, after authentication, but<br /> before any other filters or the action method
      </td>
    </tr>
    
    <tr>
      <td>
        Exception
      </td>
      
      <td>
        IExceptionFilter
      </td>
      
      <td>
        HandleErrorAttribute
      </td>
      
      <td>
        Runs only if another filter, the action method,<br /> or the action result throws an exception
      </td>
    </tr>
    
    <tr>
      <td>
        Result
      </td>
      
      <td>
        IResultFilter
      </td>
      
      <td>
        ActionFilterAttribute
      </td>
      
      <td>
        Runs before and after the action method
      </td>
    </tr>
  </table>
</div>

Before the framework invokes an action, it inspects the method definition to see if it has attributes. If the framework finds one, the methods of this attribute are invoked. As you can see, the ActionFilterAttribute is implemented by IActionFilter and IResultFilter. This class is abstract and enforces you to implement it. The AuthorizeAttribute and HandleErrorAttribute classes already contain useful features therefore you don&#8217;t have to derive from them.

## Applying a Filter to an Action or Controller

It is possible to apply one or more filters to an action or controller. A filter which is often used is the Authorize attribute. If the Authorize attribute is applied to an action, only users which are logged in can invoke this action. If the attribute is applied to the controller, it applies to all actions.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Apply-filter-to-action-and-controller.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Apply-filter-to-action-and-controller.jpg" alt="Apply filter to action and controller" /></a>
  
  <p>
    Apply filter to action and controller
  </p>
</div>

On the example above, I applied the Authorize attribute to the controller which means that every action of this controller can be invoked only by logged in users. Additionally, I applied the attribute to the DoAdminStuff and set the Roles to Admin which means that only users which have the admin role are allowed to invoke this action. This example also shows that some attributes can have a parameter to specify the action.

## Applying Authorization Filters

In the last section, I already used one of the two attributes of the Authorize attribute. <span class="fontstyle0">The available properties are: </span>

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        Users
      </td>
      
      <td>
        Comma-separated usernames which are allowed
      </td>
    </tr>
    
    <tr>
      <td>
        Roles
      </td>
      
      <td>
        Comma-separated role names
      </td>
    </tr>
  </table>
</div>

If several roles are declared, then the user must have at least one of these roles.

## Applying Authentication Filters

Authentication filters run before any other filter and can also run after an action has been executed but before the ActionResult is processed.

### The IAuthenticationFilter Interface

The Authentication filter implements IAuthenticationFilter which implements two methods:

  * <span class="fontstyle0">void OnAuthentication(AuthenticationContext context);</span>
  * <span class="fontstyle0">void OnAuthenticationChallenge(AuthenticationChallengeContext context);</span>

The <span class="fontstyle0">OnAuthenticationChallenge method is invoked whenever a request fails the authentication or authorization process. The parameter is an AuthenticationChallengeContext object which is derived from ControllerContext. The AuthenticationChallengeContext class has two useful properties:</span>

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        ActionDescriptor
      </td>
      
      <td>
        Returns an ActionDescriptor that describes the action method to which the filter has been applied
      </td>
    </tr>
    
    <tr>
      <td>
        Result
      </td>
      
      <td>
        Sets an ActionResult that expresses the result of the authentication challenge
      </td>
    </tr>
  </table>
</div>

## Applying Exception Filters

Exception filters are only executed if an unhandled exception has been thrown when invoking an action. An exception can be thrown by:

  * Another filter
  * The action itself
  * During the action result execution

Microsoft provides the HandleErrorAttribute for exception handling. This class implements the IExceptionFilter interface. The HandleErrorAttribute class has three properties:

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Type
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        ExceptionType
      </td>
      
      <td>
        Type
      </td>
      
      <td>
        The exception type handled by this filter. It will also handle exception types that inherit from the specified value but will ignore all others. The default value is System.Exception, which means that, by default, it will handle all standard exceptions.
      </td>
    </tr>
    
    <tr>
      <td>
        View
      </td>
      
      <td>
        string
      </td>
      
      <td>
        The name of the view template that this filter renders. If you do not specify a value, it takes  a default value of Error, so by default, it renders /Views/<currentControllerName>/ Error.cshtml or /Views/Shared/Error.cshtml.
      </td>
    </tr>
    
    <tr>
      <td>
        Master
      </td>
      
      <td>
        string
      </td>
      
      <td>
        The name of the layout used when rendering this filter’s view. If you do not specify a value, the view uses its default layout page.
      </td>
    </tr>
  </table>
</div>

As summary: When an unhandled exception of the type specified by ExceptionType is encountered, this filter will render the view specified by the View property

If an exception occurs in your development environment, you will get the famous yellow screen of death. To prevent this from happening, you have to set the customsError attribute to the web.config file.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/CustommError-in-web.config.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/CustommError-in-web.config.jpg" alt="CustommError in web.config" /></a>
  
  <p>
    CustommError in web.config
  </p>
</div>

The customError attribute redirects the request to the location specified at the defaultRedirect attribute. The default value for the mode attribute is RemoteOnly, which means that all local requests see the yellow screen of death.

### Applying the HandleError attribute

Applying the HandleError attribute to an action enables you to prevent the application from crashing and also enables you to provide some useful error message and help to the user. You can specify an ExceptionType and then send the request to a specific view and provide some information about what went wrong.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Apply-HandleError-on-an-action.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Apply-HandleError-on-an-action.jpg" alt="Apply HandleError on an action" /></a>
  
  <p>
    Apply HandleError on an action
  </p>
</div>

On the screenshot above, you can see two different versions of how to use the HandleError attribute. The first line with the attribute only would redirect to /Error/ErrorMessage because I defined this destination in the defaultRedirect attribute in the web.config. This page can only show a generic error message which might not help the user at all.

Therefore you can also specify which exception might happen and then redirect the request to a specific view. In the example above, I redirect all ArgumentOutOfRangeException to the ErrorMessage view. This view can be either in the view folder of the controller or in the shared view folder.

### Displaying information with the HandleErrorInfo view model

The HandleError attribute passes the HandleErrorInfo view model to your view. The properties of the HandleErrorInfo view model are:

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Type
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        ActionName
      </td>
      
      <td>
        string
      </td>
      
      <td>
        <span class="fontstyle0">Returns the name of the action method that generated the exception</span>
      </td>
    </tr>
    
    <tr>
      <td>
        ControllerName
      </td>
      
      <td>
        string
      </td>
      
      <td>
        <span class="fontstyle0">Returns the name of the controller that generated the exception</span>
      </td>
    </tr>
    
    <tr>
      <td>
        Exception
      </td>
      
      <td>
        Exception
      </td>
      
      <td>
        <span class="fontstyle0">Returns the exception</span>
      </td>
    </tr>
  </table>
</div>

In the ErrorMessage view, I can use this view model to give the user a proper error description and provide some help to solve the problem.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Hepful-error-message-in-the-view.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Hepful-error-message-in-the-view.jpg" alt="Hepful error message in the view" /></a>
  
  <p>
    Helpful error message in the view
  </p>
</div>

I know that my error message is not the best and I bet that you can come up with a better one. I also provided a link, so the user can easily return to the page where he came from.

## Applying Action Filters

Action filters can be used for anything. I use them for performance checks to find problems with the execution of actions.

### Using the IActionFilter interface

The IActionFilter interface has two methods:

  * void OnActionExecuting(ActionExecutingContext filterContext)
  * void OnActionExecuted(ActionExecutedContext filterContext)

The OnActionExecuting method is called before an action method is invoked. The parameter, ActionExecutingContext has two properties:

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Type
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        ActionDescriptor
      </td>
      
      <td>
        ActionDescriptor
      </td>
      
      <td>
        Provides details of the action method
      </td>
    </tr>
    
    <tr>
      <td>
        Result
      </td>
      
      <td>
        ActionResult
      </td>
      
      <td>
        The result for the action method. A filter can cancel the request by setting this property to a non-null value
      </td>
    </tr>
  </table>
</div>

The OnActionExecuted method is called after the action is completed and has 5 properties:

<div class="table-responsive">
  <table class="table table-striped table-bordered table-hover">
    <tr>
      <td>
        Name
      </td>
      
      <td>
        Type
      </td>
      
      <td>
        Description
      </td>
    </tr>
    
    <tr>
      <td>
        ActionDescriptor
      </td>
      
      <td>
        ActionDescriptor
      </td>
      
      <td>
        Provides details of the action method
      </td>
    </tr>
    
    <tr>
      <td>
        Canceled
      </td>
      
      <td>
        bool
      </td>
      
      <td>
        Returns true if the action has been canceled by another filter
      </td>
    </tr>
    
    <tr>
      <td>
        Exception
      </td>
      
      <td>
        Exception
      </td>
      
      <td>
        Returns an exception thrown by another filter or by the action method
      </td>
    </tr>
    
    <tr>
      <td>
        ExceptionHandled
      </td>
      
      <td>
        bool
      </td>
      
      <td>
        Returns true if the exception has been handled
      </td>
    </tr>
    
    <tr>
      <td>
        Result
      </td>
      
      <td>
        ActionResult
      </td>
      
      <td>
        The result for the action method; a filter can cancel the request by setting this property to a non-null value
      </td>
    </tr>
  </table>
</div>

### Implementing an Action Filter

I created a new class called MyActionAttribute which derives from FilterAttribute and IActionFilter. In the OnActionExecuting method, I check if the browser is Chrome. If the request comes from Chrome, I return an HttpUnauthorizedResult. Again, this is not the most useful implementation but I think you get what you can do with this method. For now, I don&#8217;t implement anything in the OnActionExecuted method. This is no problem. Just be careful because Visual Studio throws a NotImplementedException if you let Visual Studio create the method.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/The-action-filter-class-implementation.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/The-action-filter-class-implementation.jpg" alt="The action filter class implementation" /></a>
  
  <p>
    The action filter class implementation
  </p>
</div>

To use my new filter, I apply it to the CheckFilter action. Note that you don&#8217;t have to write MyActionAttribute when applying it as attribute. MyAction is enough.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Applying-the-action-filter-attribute-to-an-action.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Applying-the-action-filter-attribute-to-an-action.jpg" alt="Applying the action filter attribute to an action" /></a>
  
  <p>
    Applying the action filter attribute to an action
  </p>
</div>

When you call this action from Chrome, you can see that the access is denied for the user.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Result-of-the-action-filter.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Result-of-the-action-filter.jpg" alt="Result of the action filter" /></a>
  
  <p>
    Result of the action filter
  </p>
</div>

&nbsp;

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Unauthorized-result-in-Chrome.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Unauthorized-result-in-Chrome.jpg" alt="Unauthorized result in Chrome" /></a>
  
  <p>
    Unauthorized result in Chrome
  </p>
</div>

### Implementing the OnActionExecutedMethod

As I already mentioned, I often use action filter to measure the execution time of an action. To do that, I start a Stopwatch in the OnActionExecuting method and stop it in the OnActionExecuted method. Afterwards, I print the execution time.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Implementation-of-the-PerformanceAction-attribute.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Implementation-of-the-PerformanceAction-attribute.jpg" alt="Implementation of the PerformanceAction attribute" /></a>
  
  <p>
    Implementation of the PerformanceAction attribute
  </p>
</div>

To see different results, I added Thread.Sleep with a random number, so that the execution will take somewhere between some milliseconds and two seconds.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Applying-the-PerformanceAction-attribute.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Applying-the-PerformanceAction-attribute.jpg" alt="Applying the PerformanceAction attribute" /></a>
  
  <p>
    Applying the PerformanceAction attribute
  </p>
</div>

The print of the execution time is printed before the content of the action because the action filter is executed before the result of the action is processed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-filter.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-filter.jpg" alt="Result of performance test with the action filter" /></a>
  
  <p>
    Result of performance test with the action filter
  </p>
</div>

## Applying Result Filters

The IResultFilter which is implemented by result filters has two methods:

  * void OnResultExecuting(ResultExecutingContext filterContext)
  * void OnResultExecuted(ResultExecutedContext filterContext)

The OnResultExecuting method is called after an action has returned an action result but before this result is executed. The OnResultExecuted method is called after the action result is executed. The ResultExecutingContext and ResultExecutedContext parameter has the same properties as the action filter parameter and also have the same effects.

### Implementing a Result Filter

To demonstrate how the result filter works, I repeat the performance test but this time I measure the time between the start and the end of the execution of the ActionResult. To do that, I implement the IResultFilter and work with the OnResultExecuting and OnResultExecuted method.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Implementation-of-the-ResultAction-attribute.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Implementation-of-the-ResultAction-attribute.jpg" alt="Implementation of the ResultAction attribute" /></a>
  
  <p>
    Implementation of the ResultAction attribute
  </p>
</div>

The next step is applying the filter to an action and call the action to see the result.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Applying-the-result-filter-attribute-to-an-action.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Applying-the-result-filter-attribute-to-an-action.jpg" alt="Applying the result filter attribute to an action" /></a>
  
  <p>
    Applying the result filter attribute to an action
  </p>
</div>

When you look at the output, you see a difference in the result of the action filter output. The print of the measured time is beneath the output of the action. This behavior is caused by the fact that the result filter is processed after the ActionResult. Therefore the result is printed and then afterward the measured time is added.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-filter-1.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-filter-1.jpg" alt="Result of performance test with the action filter" /></a>
  
  <p>
    Result of performance test with the action filter
  </p>
</div>

## Filtering without Filter

In the previous examples, I showed how to create implementations of filters by implementing the desired interface. The Controller class already implements the IAuthenticationFilter, IAuthorizationFilter, IActionFilter, IResultFilter, and IExceptionFilter interfaces. It also provides empty virtual implementations for each of the methods. Knowing this, you can override the desired methods directly in the controller and achieve the same outcome as the filter classes did.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Applying-filtering-in-a-controller-without-filter-attributes.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Applying-filtering-in-a-controller-without-filter-attributes.jpg" alt="Applying filtering in a controller without filter attributes" /></a>
  
  <p>
    Applying filtering in a controller without filter attributes
  </p>
</div>

If you call the Index action of the FilteringWithoutFilter controller, you will see the same result as previously with the attributes.

&nbsp;

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-and-result-filter.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Result-of-performance-test-with-the-action-and-result-filter.jpg" alt="Result of performance test with the action and result filter" /></a>
  
  <p>
    Result of performance test with the action and result filter
  </p>
</div>

I have to admit that I am not a big fan of this approach. The big advantage of ASP.NET MVC is Separation of Concerns. When using filtering within a controller, you lose this advantage. The only time when it might make sense to use filtering directly in a controller is when this class is a base class for other controllers.

I recommend using the attribute approach.

### Simply combining Action and Result Filter

If you look closely, you can see that I combine the action filter method OnActionExecuting and the result filter method OnResultExecuted. You can do this yourself by implementing the IActionFilter and IResultFilter interface or by deriving from ActionFilterAttribute which implements both interfaces. The advantage of deriving from ActionFilterAttribute is that you don&#8217;t have empty methods which are not implemented.

## Applying Global Filters

If you want to apply filter to all your actions, you can use global filters. If you are using the MVC template, the framework already creates the FilterConfig.cs file under the App_Start folder. Since I didn&#8217;t use the template, I create the file myself. This class has one static method, RegisterGlobalFilters. The FilterConfig.cs is pretty similar to the RouteConfig.cs. To add a new filter, add it to the filters collection with add.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Register-a-filter-globally-in-FilterConfig.cs_.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Register-a-filter-globally-in-FilterConfig.cs_.jpg" alt="Register a filter globally in FilterConfig.cs" /></a>
  
  <p>
    Register a filter globally in FilterConfig.cs
  </p>
</div>

Note that the namespace is Filter, not Filter.App_Start.

The HandleErrorAttribute will always be defined as global filter in ASP.NET MVC. It is not mandatory to define the HandleErrorAttribute as global filter but it is the default exception handling and will render the /Views/Shared/Error.cshtml view if an exception happens.

To register a filter a, you have to pass an instance of the filter class. The name contains the Attribute prefix. If you use the class as attribute, you can omit the Attribute prefix. Additionally, you have to add the RegisterGlobalFilters call in the Global.asx file.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2018/01/Content-of-the-Global.asx.jpg"><img loading="lazy" src="/assets/img/posts/2018/01/Content-of-the-Global.asx.jpg" alt="Content of the Global.asx" /></a>
  
  <p>
    Content of the Global.asx
  </p>
</div>

## Conclusion

In this post, I showed all five types of built-in filters in the ASP.NET MVC framework and discussed how to use them to address cross-cutting concerns effectively. These filters help you to extend the logic of your controller and actions while a request is processed.

For more details about how built-in filters work, I highly recommend the books <a href="http://amzn.to/2mgRbTy" target="_blank" rel="noopener">Pro ASP.NET MVC 5</a> and <a href="http://amzn.to/2mfQ0nA" target="_blank" rel="noopener">Pro ASP.NET MVC 5 Plattform</a>.

You can find the source code on <a href="https://github.com/WolfgangOfner/MVC-Filter" target="_blank" rel="noopener">GitHub</a>.