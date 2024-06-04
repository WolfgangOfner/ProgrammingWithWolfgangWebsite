---
title: Unpacking the Power of Chiseled Containers and AOT Compilation
date: 2025-04-15
author: Wolfgang Ofner
categories: [Docker]
tags: [Docker, .NET]
description: Explore the power of Chiseled Containers and AOT Compilation in application deployment, enhancing efficiency and security.
---

In the dynamic world of software development, chiseled containers and Ahead-of-Time (AOT) compilation have emerged as powerful tools. These technologies, while enhancing the efficiency of application deployment, also bring notable improvements to security. This blog post delves into the details of chiseled containers and AOT, offering insights into their benefits and their potential to transform the way we build and secure applications.

## Understanding Chiseled Containers

Chiseled containers are designed to be as compact as possible while maintaining the essential features of the operating system, such as Ubuntu. These chiseled images are approximately 100 MB smaller than standard Ubuntu images. Microsoft first introduced chiseled containers in the summer of 2022 for .NET 6 and has since made substantial enhancements with .NET 7 and .NET 8.

## The Importance of Chiseled Containers

Chiseled Ubuntu containers, developed in collaboration with Canonical, are similar to <a href="https://github.com/GoogleContainerTools/distroless" target="_blank" rel="noopener noreferrer">Google's distroless concept</a>. This methodology provides developers with several significant benefits:

- Compact Images: A chiseled .NET 8 container can be just a few megabytes in size (when using ahead-of-time (AOT) compilation).
- No Package Manager: The absence of an installed package manager minimizes potential attack vectors.
- No Shell: Not having a shell further reduces the attack surface.

In addition to the features mentioned above, chiseled .NET containers do not include a root user, further enhancing the security of the container.

## Understanding AOT

Ahead-of-Time (AOT) compilation, introduced with .NET 8, offers a host of benefits over the traditional deployment model:

- Quicker Startup Time: Due to their compact nature, AOT-compiled applications start up faster and handle requests more swiftly.
- Reduced Memory Usage: AOT-compiled applications consume less RAM, allowing for denser packing.
- Smaller Disk Footprint: Publishing an AOT-compiled application results in a single executable that only contains the code from external dependencies necessary to run the application. This elimination of unused dependencies results in a smaller container image and accelerates the application’s deployment.

Microsoft conducted a performance comparison of applications using the conventional runtime, a runtime-trimmed deployment, and AOT:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Performance-comparison-of-applications-using-aot-and-conventional-applications.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Performance-comparison-of-applications-using-aot-and-conventional-applications.jpg" alt="Performance comparison of applications using AOT and conventional applications" /></a>
  
  <p>
   Performance comparison of applications using AOT and conventional applications
  </p>
</div>

Please note that not all ASP.NET Core features are compatible with AOT. For more information, refer to the <a href="https://learn.microsoft.com/en-us/aspnet/core/fundamentals/native-aot?view=aspnetcore-8.0#aspnet-core-and-native-aot-compatibility" target="_blank" rel="noopener noreferrer">ASP.NET Core and Native AOT compatibility</a> and the <a href="https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/?tabs=net7%2Cwindows#limitations-of-native-aot-deployment" target="_blank" rel="noopener noreferrer">Limitations of Native AOT deployment</a> sections.

### AOT vs JIT Compilation

Just-in-Time (JIT) compilation translates the code into an intermediate form, which is then compiled into machine code by the JIT compiler at runtime. This process, which occurs at the start of the application, may increase the startup time. However, the compiler can optimize the code during runtime, potentially enhancing performance for long-running tasks.

On the other hand, Ahead-of-Time (AOT) compilation, as the name implies, compiles the code before it is used. More specifically, the code is compiled during the application's publishing phase. This method has the advantage of including only necessary references to dependencies in the published application, resulting in a smaller application size. However, the downside is that the compile time can be significantly longer than with conventional JIT compilation.

A project that uses AOT publishing employs JIT compilation when running locally and only uses AOT compilation during publishing. To enable AOT publishing, add the `PublishAot` parameter to your project file:

<script src="https://gist.github.com/WolfgangOfner/72631ebccb81ef12bfe3242d26c3aae0.js"></script>

If you decide to use AOT for your application, it's crucial to thoroughly test your application before making the switch. The choice between AOT and JIT should be made on a per-project basis.

## Experimenting with Chiseled Containers and AOT Publishing

Microsoft provides several sample applications on <a href="https://github.com/dotnet/dotnet-docker/tree/main/samples" target="_blank" rel="noopener noreferrer">GitHub</a> for testing AOT and chiseled container images. These sample apps include various Dockerfiles targeting Ubuntu or Alpine, and using chiseled and/or AOT compiled images. The image size comparison between the conventional .NET runtime, the chiseled runtime, and the chiseled runtime with AOT compilation is as follows:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Comparision-of-conventional-chiseled-and-chiseled-with-aot-images.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Comparision-of-conventional-chiseled-and-chiseled-with-aot-images.jpg" alt="Comparision of conventional chiseled and chiseled with aot images" /></a>
  
  <p>
   Comparision of conventional chiseled and chiseled with aot images
  </p>
</div>

As you can see, the conventional image is significantly larger at 146 MB, compared to the 38 MB and 25 MB of the chiseled and chiseled with AOT images, respectively.

However, this comparison only tells half the story. Container images can be either compressed or uncompressed. When stored on a disk, as in the screenshot above, they are uncompressed. However, the size of uncompressed images is not typically a concern. When images are transferred, for instance during a pull or push command, they are compressed. Therefore, the size of the compressed image, which is the actual size you have to download when deploying a new image, is far more critical. Microsoft has published a graph comparing the sizes of different images when compressed:

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/04/Container-size-improvements.jpg"><img loading="lazy" src="/assets/img/posts/2024/04/Container-size-improvements.jpg" alt="Container size improvements" /></a>
  
  <p>
   Container size improvements
  </p>
</div>

## Leveraging Chiseled Containers in Kubernetes

The reduction in container sizes achieved through the use of chiseled AOT-compiled containers can have a significant impact when deploying applications in a Kubernetes cluster. This is particularly true when operating a cluster in the cloud, where adequate image caching may not always be available, necessitating frequent downloads. Even when images are cached within your cluster, an 8 MB image will launch faster than a 100 MB one. This becomes increasingly relevant when managing a large cluster with hundreds or thousands of applications. Furthermore, the use of .NET with AOT compilation results in quicker startup times, enabling your containers to launch and be ready to handle requests even faster.
 
## Conclusion

The introduction of chiseled containers and Ahead-of-Time (AOT) compilation has revolutionized the way we deploy applications, particularly in Kubernetes clusters. By significantly reducing container sizes and improving startup times, these technologies offer substantial benefits in terms of efficiency and performance.

Moreover, the security enhancements brought about by chiseled containers cannot be overstated. With no root user and the absence of a shell or package manager, the attack surface is greatly reduced, making your applications more secure.

However, it's important to remember that these advancements are not without their challenges, and thorough testing is crucial before making the switch.