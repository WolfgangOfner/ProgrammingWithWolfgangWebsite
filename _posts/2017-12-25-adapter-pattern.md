---
title: Adapter Pattern
date: 2017-12-25T16:31:34+01:00
author: Wolfgang Ofner
categories: [Design Pattern]
tags: ['C#', Software Architecture]
---
The adapter pattern is one of the most useful patterns in my eyes. Therefore I want to explain what the adapter is and present a simple real life example on how it can be used.

## The Adapter Pattern in real life

It works the same way as a real-life adapter, for example for a power outlet. If you travel from the European Union to Switzerland or the US your normal power plug won&#8217;t fit into the power outlet. Hence you have to get an adapter which can link the power outlet with the power plug. This example perfectly describes how the adapter pattern works.

## The Adapter Pattern in software development

The adapter pattern is often used in combination with third-party libraries. For example, your client needs to utilize a specific interface and a library which you have to use doesn’t use this Interface or the library expects a different Interface. This is where the adapter comes to use. The adapter sits between the client and the library and connects them together. Like in the real world an adapter helps two classes which are not compatible to work together.

On the other hand, if you develop the library, you can provide support for future adapters so your users can implement it easily into their application.

## UML Diagram

[<img loading="lazy" class="aligncenter wp-image-494" src="/assets/img/posts/2017/12/Adapter-pattern-UML-diagram.jpg" alt="Adapter pattern UML diagram" width="700" height="518" />](/assets/img/posts/2017/12/Adapter-pattern-UML-diagram.jpg)

The UML diagram for the adapter pattern is pretty simple. The client wants to call an operation on the Adaptee. To do that the client implements the Adapter interface and calls the Operation method. The ConcreteAdapter implements the method and calls the AdaptedOperation of the adaptee. After the execution, the ConcreteAdapter returns the information needed to the client.

Let&#8217;s look at a real time example

## Implementation of the Adapter Pattern

As an example, I import a list of my employees and then use a third party tool to a fancy header and footer to the list while printing it. Let&#8217;s say that my internal SAP system returns my employees as string array. The third-party tool expects a list of strings though. Therefore I need an adapter which to enable me to use the library with my string array.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/SAP.png"><img loading="lazy" src="/assets/img/posts/2017/12/SAP.png" alt="SAPSystem implementation" width="445" height="262"  /></a>
  
  <p>
    Internal employee management system
  </p>
</div>

The third-party tool called FancyReportingTool is pretty simple too. It is instantiated with an interface which will provide the data for printing in the ShowEmployeeList method. The interface I provide during the instantiating of the FancyReportingTool is the Adapter interface, which is implemented by the concrete adapter.

The constructor of the library asks for an interface. Because of this interface, it is possible for me to use the adapter. Remember this when creating libraries yourself. It&#8217;s good practice to provide support for future adapters.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/FancyReportingTool.png"><img loading="lazy" src="/assets/img/posts/2017/12/FancyReportingTool.png" alt="FancyReportingTool implementation" /></a>
  
  <p>
    FancyReportingTool implementation
  </p>
</div>

The last missing piece is the ConcreteAdapter which is called EmployeeAdapter. This class inherits from the interface and form the SAPSystem. The adapter gets the employees from the SAPSystem class and converts the array into a list and returns it. The FancyReportingTool can print this list now.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/EmplyeeAdapter.png"><img loading="lazy" src="/assets/img/posts/2017/12/EmplyeeAdapter.png" alt="EmplyeeAdapter implementation" /></a>
  
  <p>
    EmplyeeAdapter implementation
  </p>
</div>

### The output

With everything set up, I can create an instance of the interface, an instance of the FancyReportingTool with this interface and then call the ShowEmplyeeList on the FancyReportingTool object. This will get the employee data from my internal SAPSystem, convert it and use the third party library to print the data to the console.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2017/12/Output.png"><img loading="lazy" src="/assets/img/posts/2017/12/Output.png" alt="Output with data from the adapter" /></a>
  
  <p>
    Output with data from the adapter
  </p>
</div>

In addition to the employee adapter, I could implement another adapter. The additional adapter could work as a data provider for my inventory and then send it to the third-party library for a nice print out.

## Related Patterns

In my eyes there are three related patterns which are worth to take a look at when learning the adapter pattern.

  * Repository
  * Strategy
  * Facade

The repository and strategy pattern often implement an adapter whereas the facade is pretty similar to the adapter pattern. The difference between facade and adapter is that the facade usually wraps many classes to simplify interfaces. On the contrary the adapter mostly only wraps a single class.

## Conclusion

In this example, I showed how to use the adapter pattern to combine two incompatible classes. This pattern is often used in combination with third-party libraries which have to be used.

You can find the source code of the example on <a href="https://github.com/WolfgangOfner/AdapterPattern" target="_blank" rel="noopener">GitHub</a>.