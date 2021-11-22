---
title: Flyweight Pattern in .NET Core 3.1
date: 2020-07-12
author: Wolfgang Ofner
categories: [Design Pattern]
tags: [.NET Core 3.1, 'C#', Software Architecture]
description: The Flyweight pattern is a structural design pattern that helps you to share objects and therefore reduce the memory usage of your application.
---
The Flyweight pattern is a structural design pattern that helps you to share objects and therefore reduce the memory usage of your application.

## When to use the Flyweight Pattern

You want to use the flyweight pattern when you have many objects which don't change. A real-life example would be a restaurant. They serve many dishes but the meals are always the same (maybe the only vary in size). For example, when you go to McDonald's and five order a Big Mac meals, you get five times the same meal.

The flyweight pattern helps to keep the memory usage of your application low and also helps to speed up the processing of your objects. The flyweight pattern works well in combination with the <a href="/strategy-pattern/" target="_blank" rel="noopener noreferrer">strategy pattern</a>.

## Flyweight Pattern Implementation

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/.NETCore-FlyweightPattern" target="_blank" rel="noopener noreferrer">Github</a>.

The flyweight pattern is very simple, therefore I will keep this demo short. For this demo, imagine that I have a fast food place selling different meals. To keep it simple, I serve only burger and pizza meals.

First, I create the IMealFlyweight interface which has a definition for the name property and a serve method which takes a string for the size of the meal as the parameter.

<script src="https://gist.github.com/WolfgangOfner/8f81d6fd2fde77963c7f67a3def04489.js"></script>

Next, I implement concrete classes for the pizza and burger meal. Following, you can see the implementation of the pizza meal:

<script src="https://gist.github.com/WolfgangOfner/a0319805960b60b9e15c43cb01fbea08.js"></script>

The pizza meal sets its name in the constructor and the serve method writes to the console that the meal got served. Already the last step is to create a factory that creates the meal objects for me. As previously mentioned, the main goal of the flyweight pattern is to re-use objects. The factory achieves this by re-using existing objects or creating new ones if they don't exist. The objects get saved in a dictionary which I use as a cache. In a bigger application, this might be a fast cache like Redis.

Note that I added a Thread.Sleep when creating new objects to simulate more real-world behavior.

<script src="https://gist.github.com/WolfgangOfner/20700892af2ec7fdf754c67b795129b3.js"></script>

That's it already. The flyweight pattern is implemented and can be tested now. To test the implementation, I added a print method to the factory which prints the number of items in the cache and their name. In the main method, I create for meal objects and print the cache state before and after the creation.

<script src="https://gist.github.com/WolfgangOfner/b2d594cd17ad1c1e7905ea48399aec25.js"></script>

### Testing the Implementation

When running the application, you will see that there are no items in the cache and then slowly the medium-sized meals are created. The large meals are created way faster because they are read from the cache. After serving all four meals, the cache still has only two items, as expected.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/07/Testing-the-Flyweight-Pattern-Implementation.jpg"><img loading="lazy" src="/assets/img/posts/2020/07/Testing-the-Flyweight-Pattern-Implementation.jpg" alt="Testing the Flyweight Pattern Implementation" /></a>
  
  <p>
    Testing the Flyweight Pattern Implementation
  </p>
</div>

## Conclusion

The flyweight pattern is a very simple design pattern that can help you to reduce memory usage when you have many objects that won't change. Another benefit of the pattern is that it can help to speed up your application and as seen, it is very easy to implement.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/.NETCore-FlyweightPattern" target="_blank" rel="noopener noreferrer">Github</a>.