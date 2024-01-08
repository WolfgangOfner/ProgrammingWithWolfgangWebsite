---
title: Article - Azure Arc - The Bridge to the Cloud Part 2
date: 2023-12-04
author: Wolfgang Ofner
categories: [Article]
tags: [Kubernetes, Azure Arc, On-premises, .NET, C#, Azure DevOps, CI-CD]
description: This article explains how to deploy a .NET application to an on-premises Kubernetes cluster using Azure Arc and how to configure Azure DevOps or the deployment pipeline for it. It also provides a theoretical introduction to hybrid cloud architectures.
---

This fall, I'm delving into a comprehensive four-part series exploring hybrid cloud solutions through Kubernetes and Azure Arc. The seccond article, titled "Azure Arc - The Gateway to the Cloud" (Azure Arc - Die Brücke zur Cloud), has been recently featured in the renowned German Windows .developer magazine, even making its front page. 

The article is available <a href="https://entwickler.de/cloud/deployment-hybrid-cloud-azure-arc" target="_blank" rel="noopener noreferrer">online</a>, but please note that it is in German and requires a subscription to access.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2023/12/windows-developer-01-24.jpg"><img loading="lazy" src="/assets/img/posts/2023/12/windows-developer-01-24.jpg" alt="windows developer 01/24" /></a>
  <p></p>
</div>

Below, you'll find the article's introduction in English and German:

This article describes how to deploy a .NET application to an on-premises Kubernetes cluster using Azure Arc and how to configure Azure DevOps or the deployment pipeline for it.

The first part of this series provided a theoretical introduction to hybrid cloud architectures. On the one hand, there are hardware solutions from Microsoft, such as Azure Stack HCI or Azure Stack Hub, with which Azure services can be operated in your own data center. On the other hand, there is a software solution with Azure Arc, which allows infrastructure that is operated outside of Azure to be managed with Azure. Outside of Azure means “on premises” in your own data center, but also with other cloud providers such as AWS or Google Cloud. Azure Arc allows you to manage physical and virtual (e.g. VMware or Azure Stack HCI) Linux and Windows servers as well as SQL servers and Kubernetes clusters.

Dieser Artikel zeigt, wie eine .NET-Anwendung mit Hilfe von Azure Arc automatisch in einen On-premises-Kubernetes-Cluster deployt wird und wie dafür Azure DevOps bzw. die Deployment Pipeline konfiguriert werden muss.

Der erste Teil dieser Serie hat eine theoretische Einführung in Hybrid-Cloud-Architekturen gegeben. Auf der einen Seite gibt es Hardwarelösungen von Microsoft, wie Azure Stack HCI oder Azure Stack Hub, mit denen Azure Dienste im eigenen Rechenzentrum betrieben werden können. Auf der anderen Seite gibt es mit Azure Arc eine Softwarelösung, mit der Infrastruktur, die außerhalb von Azure betrieben wird, mit Azure verwaltet werden kann. Außerhalb von Azure bedeutet „on premises“ im eigenen Rechenzentrum, aber auch bei anderen Cloud-Anbietern wie AWS oder Google Cloud. Azure Arc erlaubt es, physische und virtuelle (z. B. VMware oder Azure Stack HCI) Linux- und Windows-Server sowie SQL-Server und Kubernetes-Cluster zu verwalten.