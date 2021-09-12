---
title: Improve Azure DevOps YAML Pipelines with Templates
date: 2021-01-27
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [Azure DevOps, CI, YAML, AKS, Azure, Helm, Docker]
description: YAML pipelines can get quite long and unclear over time. Templates can be used in several pipelines reducing duplicate code.
---

YAML pipelines can get quite long and unclear over time. In programming, developers use several files to separate logic apart to make the code easier to understand. The same is possible using templates in YAML pipelines. Additionally, these templates can be used in several pipelines reducing duplicate code.

## YAML Pipelines without Templates

[In my last post](/deploy-kubernetes-azure-devops), I worked on a pipeline that built a .NET 5 application, ran tests, pushed a docker image, and deployed it to Kubernetes using Helm. The pipeline hat 143 lines of code in the end. It looked like a wall of text and might be overwhelming at first glance.

<script src="https://gist.github.com/WolfgangOfner/930afa356112ef2caf15d863c17a3e49.js"></script>

You can find this pipeline on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/CustomerApi-CI.yml" target="_blank" rel="noopener noreferrer">Github</a>. If you go through the history, you will see how it evolved over time.

## What Pipeline Templates are 

Templates let you split up your pipeline into several files (templates) and also allow you to reuse these templates either in the same or in multiple pipelines. As a developer, you may know the Separation of Concerns principle. Templates are basically the same for pipelines. 

You can pass parameters into the template and also set default values for these parameters. Passing parameters is not mandatory because a previously defined variable would still work inside the template. It is best practice to pass parameters to make the usage more clear and make the re-usage easier.

Another use case for templates is to have them as a base for pipelines and enforce them to extend the template. This approach is often used to ensure a certain level of security in the pipeline.

## Create your first Template

I like to place my templates in a templates folder inside the pipelines folder. This way they are close to the pipeline and can be easily referenced inside the pipeline.

### Create Templates without Parameters

The first template I create is for the build versioning task. To do that, I create a new file, called BuildVersioning.yml inside the templates folder and copy the BuildVersioning task from the pipeline into the template. The only additionaly step I have to take is use step: at the beginning of the template and intend the whole task. The finished template looks as follows:

<script src="https://gist.github.com/WolfgangOfner/72708ad4760695e7da8138451bf3936c.js"></script>

### Create Templates with Parameters

Creating a template with parameters is the same as without parameters except that parameters get places at the beginning of the file. This section starts with the parameters keyword and then lists the parameter name, type, and a default value. If you don't have a default value, leave it empty.

<script src="https://gist.github.com/WolfgangOfner/a3aa8e09ac88333f0d3ddd44bf75a4fe.js"></script>

After the parameters, add the steps keyword and add the desired tasks.

## Use Templates in the Azure DevOps YAML Pipeline

I placed all tasks in a couple of templates. To reference these templates use the template keyword and the path to the file:

```yaml
<script src="https://gist.github.com/WolfgangOfner/754474f9c3bce6355281e5b9064a98e6.js"></script>
```

If a template needs parameters, use the parameters key word and add all needed parameters:

<script src="https://gist.github.com/WolfgangOfner/7e6d7f9ddec6dd1817ddca215b4e23e8.js"></script>

I put all tasks into templates and tried to group what belongs together. The pipeline looks as follows now:

<script src="https://gist.github.com/WolfgangOfner/1722a650a642897cf0699b86733e7640.js"></script>

The pipeline has now 51 instead of 143 lines of code and I find it way easier to find certain parts of the code. 

## Running the Pipeline

After you added your templates, run the pipeline and you will see that it works the same way as before.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/01/The-pipeline-works-with-the-templates.jpg"><img loading="lazy" src="/assets/img/posts/2021/01/The-pipeline-works-with-the-templates.jpg" alt="The pipeline works with the templates" /></a>
  
  <p>
   The pipeline works with the templates
  </p>
</div>

## Conclusion

Templates are great to simplify Azure DevOps YAML pipelines. Additionally, they are easy to reuse in multiple pipelines and help so to speed up the development time of new pipelines.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).