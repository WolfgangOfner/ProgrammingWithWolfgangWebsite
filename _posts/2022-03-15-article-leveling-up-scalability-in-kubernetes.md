---
title: Article - Leveling Up Scalability in Kubernetes
date: 2022-03-15
author: Wolfgang Ofner
categories: [Article]
tags: [Kubernetes, Azure Kubernetes Service, Helm, Azure, Docker, KEDA, Azure Service Bus, Scaling]
description: Explore scalability in Kubernetes with my windows .developer article. Learn about Horizontal Pod Autoscaler and KEDA for modern applications.
---

I am excited to announce that my first solo article has been published in the German "windows .developer" magazine’s April 2022 issue. The article, titled "Leveling Up Scalability in Kubernetes", delves into the intricacies of scalability in Kubernetes using the open-source tool KEDA (Kubernetes event-driven Architecture). The article even made it on the cover page of the magazine.

The article is available <a href="https://entwickler.de/kubernetes/ein-level-up-fur-die-skalierung-in-k8s" target="_blank" rel="noopener noreferrer">online</a>, but please note that it is in German and requires a subscription to access.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2022/03/windows-developer-04-22.jpg"><img loading="lazy" src="/assets/img/posts/2022/03/windows-developer-04-22.jpg" alt="windows developer 04 22" /></a>
  <p></p>
</div>

Below, you'll find the article's introduction in English and German:

Kubernetes provides the Horizontal Pod Autoscaler, which allows adjusting the number of running application instances based on CPU or memory utilization. However, modern applications often rely on multiple components and need to respond to external events. KEDA (Kubernetes-based Event-Driven Autoscaling) offers a simple and flexible solution for that purpose.

Kubernetes bietet mit dem Horizontal Pod Autoscaler die Möglichkeit, auf Basis von CPU- oder RAM-Auslastung die Anzahl der laufenden Applikationsinstanzen zu verändern. Allerdings sind moderne Anwendungen oftmals von einer Vielzahl von Komponenten abhängig und müssen auf externe Ereignisse reagieren können. KEDA bietet dafür eine einfache und flexible Lösung.