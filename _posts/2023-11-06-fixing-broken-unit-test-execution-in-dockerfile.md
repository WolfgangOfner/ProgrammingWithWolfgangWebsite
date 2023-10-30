---
title: Fixing Broken Unit Test Execution in Dockerfile
date: 2023-11-06
author: Wolfgang Ofner
categories: [Docker, Programming]
tags: [Docker, Azure DevOps, CI, DevOps, xUnit]
description: Optimize your workflow with this guide on running unit tests in a Dockerfile and extracting results in Azure DevOps Pipeline.
---

In my demos, I frequently feature code snippets from my ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero) series.

Everything was running like a charm during spring, but upon revisiting it in October, I stumbled upon a puzzling scenario - a broken build. Especially since nothing had changed since I ran the pipeline successfully the last time

In this post, I will explain how to fix this issue and update the pipeline accordingly.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Analysing the Problem

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

When I attempted to run the pipeline, I encountered an error when the pipeline was trying to retrieve the test results from the container it had created. The error message indicated that the container containing the test results could not be located.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/11/The-testcontainer-was-not-found.jpg"><img loading="lazy" src="/assets/img/posts/2023/11/The-testcontainer-was-not-found.jpg" alt="The testcontainer was not found" /></a>
  
  <p>
   The testcontainer was not found
  </p>
</div>

Upon a thorough examination of the build process, it became evident that the tests were not being executed, leading to the absence of a layer within the image that should have contained the test results. To identify the root cause of this abrupt termination of the test execution, I delved into the Dockerfile. Let's take a closer look at the relevant part of the Dockerfile:

<script src="https://gist.github.com/WolfgangOfner/fd98199a767eb9377ddce9e2d1de4b95.js"></script>

This portion of the Dockerfile employs the BuildId build argument and uses it as the label for the test layer. This label plays a crucial role after the build process, as it's used to identify the layer containing the test results, enabling the pipeline to extract them from the image.

Through my investigation, I discovered that the tests were only executed when the line "FROM build AS test" was present. This statement is essential to ensure that the correct image is used for running the tests.

## Resolving the Issue and Re-enabling the Unit Tests

Docker provides a useful parameter called `--target`, which allows you to selectively execute specific portions of the Dockerfile. This parameter enables us to trigger the execution of tests using the following command:

<script src="https://gist.github.com/WolfgangOfner/61e4d8d37553c82c650582e71bc8bbb6.js"></script>

However, it's important to note that you can only pass one `--target` parameter at a time. As a result, you'll need to execute the `docker build` command separately for each target in your Dockerfile, such as "tests" and "dacpac." Additionally, it's necessary to run a `docker build` command without specifying any targets to build the image as originally intended. While this may appear somewhat complex and time-consuming, Docker caches each layer. Thus, when you run `docker build` with the "test" target, and subsequently execute a `docker build` without specifying any targets, the second run will complete within seconds due to the cached layers. This approach ensures efficient building while re-enabling the execution of unit tests.

## Updating the CI Pipeline with the Necessary Modification

To successfully address this issue, the final step involves updating the pipeline to incorporate the building of both the "test" and "dacpac" stages, followed by the regular Docker build process. Implement the following command within the <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/templates/DockerBuildAndPush.yml" target="_blank" rel="noopener noreferrer">DockerBuildAndPush.yml</a> file:

<script src="https://gist.github.com/WolfgangOfner/2672f94b46ee63b0b745773f4c214425.js"></script>

When you execute the pipeline, you'll observe three Docker build tasks in action, and the pipeline will complete successfully. It's worth noting that the first build task ("Run tests") consumed 1 minute and 12 seconds, while the second and third build tasks ("Build Database" and "Build Docker Container") finished in just 23 seconds and 4 seconds, respectively.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/11/The-Pipeline-succeded-with-the-three-docker-build-tasks.jpg"><img loading="lazy" src="/assets/img/posts/2023/11/The-Pipeline-succeded-with-the-three-docker-build-tasks.jpg" alt="The-Pipeline succeded with the three docker build tasks" /></a>
  
  <p>
   The-Pipeline succeded with the three docker build tasks
  </p>
</div>

This updated configuration ensures the smooth execution of your pipeline while efficiently building the necessary components.

## Conclusion

In conclusion, we encountered a puzzling issue in our microservices project, where unit tests were no longer executing as expected. 

By leveraging Docker's `--target` parameter, we were able to selectively run the required stages of our Dockerfile, thereby re-enabling the execution of unit tests. These changes were seamlessly integrated into our CI pipeline, resulting in a successful build process.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).