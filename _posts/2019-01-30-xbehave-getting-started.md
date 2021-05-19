---
title: 'xBehave - Getting Started'
date: 2019-01-30T23:30:26+01:00
author: Wolfgang Ofner
categories: [Programming, DevOps]
tags: [ATDD, 'C#', TDD, xBehave, xUnit]
description: Today, I want to go one step further and will talk about writing acceptance tests (ATDD) using xBehave. xBehave is an extension of xUnit.
---
In my last post, I talked about writing unit tests using xUnit. Today, I want to go one step further and will talk about writing acceptance tests (ATDD) using xBehave. xBehave is an extension of xUnit for describing tests using natural language. The advantage of the natural language description is that non-technical stakeholder like a manager can read the test report and understand what was tested. You can find <a href="http://xbehave.github.io/" target="_blank" rel="noopener">xBehave on Github</a>.

## My Setup

For writing tests I use the following NuGet packages and extensions:

  * <a href="https://github.com/xunit/xunit" target="_blank" rel="noopener">xUnit </a>for unit testing
  * xBehave for acceptance tests
  * <a href="https://fluentassertions.com/" target="_blank" rel="noopener">FluentAssertions</a> for more readable assertions
  * <a href="https://fakeiteasy.github.io/" target="_blank" rel="noopener">FakeItEasy</a> to create fake objects
  * <a href="https://resharper-plugins.jetbrains.com/packages/xunitcontrib/" target="_blank" rel="noopener">xUnit Resharper Extension</a> for xUnit shortcuts in Visual Studio
  * <a href="https://www.nuget.org/packages/xunit.runner.visualstudio" target="_blank" rel="noopener">xunit.runner.visualstudio</a> for running the xBehave tests

To start, I use the code of my last demo which can be found on <a href="https://github.com/WolfgangOfner/xUnit-Getting-Started" target="_blank" rel="noopener">Github</a>.

## Execute tests with xBehave

A test in xBehave always has the attribute Scenario. As previously mentioned, xBehave describes the tests using natural language. The default describing patter is Given, When, Then. Other patterns are possible like the classic Arrange, Act, Assert or xSpec style with Establish, Because, It. You could even <a href="https://github.com/xbehave/xbehave.net/wiki/Extending-xBehave.net" target="_blank" rel="noopener">extend xBehave</a> and use your own attribute name and vocabulary. If you have more than one operation for the same, you can combine them with And, for example, &#8220;Given an employee&#8221; &#8220;And another employee&#8221;.

### Given

In the Given or Arrange phase, you set up all the objects you need to run your test. In my example test, I only need one employee object, You could set up several objects and combine them with And.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Setting-up-two-employee-objects-for-the-tests.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Setting-up-two-employee-objects-for-the-tests.jpg" alt="Setting up two employee objects for the xBehave tests" /></a>
  
  <p>
    Setting up two employee objects for the tests
  </p>
</div>

### When

In the When or Act phase, you call the methods, you want to test. In my example, I add the hours worked during the week to my employee.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Executing-a-method-with-my-test-object.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Executing-a-method-with-my-test-object.jpg" alt="Executing a method with my test object" /></a>
  
  <p>
    Executing a method with my test object
  </p>
</div>

### Then

In the Then or Assert phase, you check if the value or result is what you expected. In my example, I check if the salary of the employee has the value I expect.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Evaluate-the-result-of-the-previous-operation.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Evaluate-the-result-of-the-previous-operation.jpg" alt="Evaluate the result of the previous operation" /></a>
  
  <p>
    Evaluate the result of the previous operation
  </p>
</div>

### Repeating steps

You can always return to a previous phase. For example, after the salary check from above, you can have another method call with when and then another assert with then.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Repeating-testing-steps.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Repeating-testing-steps.jpg" alt="Repeating testing steps" /></a>
  
  <p>
    Repeating testing steps
  </p>
</div>

## Executing code before the test

In xUnit, the constructor of the class is called before a test is executed. xBehave is very similar, but instead of the constructor, it calls the method with the Background attribute. Usually, the method is also called Background but you can choose whatever name fits best for you.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Setting-up-code-before-the-test-execution.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Setting-up-code-before-the-test-execution.jpg" alt="Setting up code before the test execution" /></a>
  
  <p>
    Setting up code before the test execution
  </p>
</div>

## Adding parameters to your test

In xBehave you can add parameters to your test with the parameter Example. It works the same way as InlindeData in xUnit. You add values and then have matching parameters in the method signature.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Add-parameter-to-your-test.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Add-parameter-to-your-test.jpg" alt="Add parameter to your test" /></a>
  
  <p>
    Add parameters to your test
  </p>
</div>

Instead of Example, you can use any attribute which inherits from DataAttribute, for example, MemberData.

### Variables inside your test

If you want to assign a value to a variable within your test, you can pass this variable as a parameter. Each parameter which does not have a corresponding example value (based purely on the number of values/parameters) continues to have its default value passed (null for reference types and zero values for value types).

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Adding-a-variable-as-parameter-to-be-used-in-the-test.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Adding-a-variable-as-parameter-to-be-used-in-the-test.jpg" alt="Adding a variable as parameter to be used in the test" /></a>
  
  <p>
    Adding a variable as a parameter to be used in the test
  </p>
</div>

## Skipping a scenario

To exclude a scenario from execution, you can apply the skip attribute and provide a message. It works the same way as in xUnit.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Skipping-a-scenario.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Skipping-a-scenario.jpg" alt="Skipping a scenario" /></a>
  
  <p>
    Skipping a scenario
  </p>
</div>

## Faking objects and calls within the test

You can set up fake objects and fake calls the same way as in xUnit, using a faking framework like FakeItEasy.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Faking-objects-inside-the-test.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Faking-objects-inside-the-test.jpg" alt="Faking objects inside the test" /></a>
  
  <p>
    Faking objects inside the test (<a href="https://github.com/xbehave/xbehave.net/wiki/Can-I-use-xbehave.net-with-isolation-%28faking-mocking-substitution%29-libraries%3F" target="_blank" rel="noopener">Source xBehave</a>)
  </p>
</div>

## Teardown

If your code needs some cleanup after execution, xBehave provides you with the Teardown method. Provide a delegate to the Teardown method and xBehave will execute your method after the test was run or if an exception occured. On the following screenshot, you can see that in the Teardown method, the employee object calls the Destroy method which does whatever is necessary to clean up the employee object.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2019/01/Teardown-an-object.jpg"><img loading="lazy" src="/assets/img/posts/2019/01/Teardown-an-object.jpg" alt="Teardown an object" /></a>
  
  <p>
    Teardown an object
  </p>
</div>

## Conclusion

In this post, I gave a quick overview of xBehave and explained how to set up your scenarios and how to clean up afterward.

You can find the code of my demo on <a href="https://github.com/WolfgangOfner/xBehave-Getting-Started" target="_blank" rel="noopener">Github</a>.