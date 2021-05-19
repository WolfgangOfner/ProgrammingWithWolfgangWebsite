---
title: C# 9.0 - What's new
date: 2020-11-16
author: Wolfgang Ofner
categories: [Programming]
tags: [NET 5.0, 'C#', 'C# 9.0']
description: Microsoft release .NET 5 and C# 9.0. Let's take a look at some cool new features of the new language version.
---

Microsoft released with .NET 5 also C# 9.0. This version of C# focuses mainly on productivity improvements and tries to help developers to reduce their time typing.

You can find the code of this demo on [Github](https://github.com/WolfgangOfner/CSharp-9.0).

## Record Types

My favorite feature of C# 9.0 is record types. They allow you to define a class with its properties and a constructor in one line. A base class with an inherited class looked as follows so far:

```csharp
public class Student : Person
{
    public Student(int grade, int age, string name) : base(age, name)
    {
        Grade = grade;
    }

    public int Grade { get; set; }
}

public class Person
{
    public Person(int age, string name)
    {
        Age = age;
        Name = name;
    }

    public int Age { get; set; }

    public string Name { get; set; }

    public string SaySomething()
    {
        return "Hello, I am a Person";
    }
}
```

With C# 9.0, you can define both classes with its properties, constructors, and even the SaySomething method with the following code:

```csharp
public record Student(int Grade, int Age, string Name) : Person(Age, Name);

public record Person(int Age, string Name)
{
    public string SaySomething()
    {
        return "Hello, I am a Person";
    }
}
```

This should reduce the typing required for simple class definitions.

## Init Only Setters

The next new feature is Init only setters. They allow you to set a value for a property when you create the object but then prohibit you from setting a new value for the property. All you have to do for that is using int instead of set in the property definition:

```csharp
public class InitOnlySetter
{
    public string Name { get; init; }
}
```

You can set the value for Name when you create the object but you will get a compiler error if you try to set a new value.

```csharp
var initOnlySetter = new InitOnlySetter
{
    Name = "Wolfgang"

// not allowed
initOnlySetter.Name = "Smith";
```

## Improved Pattern Matching
The pattern matching which was first introduced in C# 7 got new keywords. Now you can concatenate the check of your expression with not, and, and or. In the following code, I check if the provided character either a lowercase or uppercase letter but not a number:

```csharp
private static void PatternMatchingEnhancements(char character)
{
    var isLetter = character is (>= 'a' and <= 'z') or (>= 'A' and <= 'Z') and not (>= '0' and <= '9');
    Console.WriteLine($"{character} is a letter and not a number: {isLetter}");
}
```

## Top-Level Statements

Top-Level statements remove all the boilerplate around a class like using statements and a namespace. A typical hello world application would look as follows:

```csharp
using System;

namespace CSharp9
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

With the new top-level statements, you can create the same application with a single line of code:

```csharp
System.Console.WriteLine("Hello World!");
```

Running this application is merely a gimmick feature to me but I think it has the potential to reduce to time developer using typing repetitive definitions and therefore might help improve productivity.

## Fit and Finish

The last feature is called fit and finish and allows you to leave out the type definition when you create a new class. The following code creates a new object of the class FitAndFinish and sets the Name property:

```csharp
FitAndFinish fitAndFinish = new() { Name = "Wolfgang" };

Console.WriteLine($"Hello {fitAndFinish.Name}");
```

Since the type of the name is in front of the variable, the compiler knows what type this variable instantiates. I am not too excited about this feature because I always use var and therefore can't use it but it's nice to have this feature if someone needs it.

## Conclusion

Today, I gave a quick overview of the new features in C# 9.0. Nothing is too spectacular and the focus was clearly on increasing the developer productivity but I think especially records might be useful in the future.

You can find the code of this demo on [Github](https://github.com/WolfgangOfner/CSharp-9.0).