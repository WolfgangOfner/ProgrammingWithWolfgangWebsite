---
title: Article - Azure Arc - The Gateway to the Cloud Part 4 - Databases, App Services and more
date: 2024-03-18
author: Wolfgang Ofner
categories: [Article]
tags: [Kubernetes, Azure Arc, On-premises, .NET, C#, Azure DevOps, CI-CD]
description: Uncover Azure Arc’s capabilities in managing hardware and installing Azure services outside of Azure in our latest series.
---

I am excited to announce that the third installment of this series, titled "Azure Arc - The Gateway to the Cloud Part 4 - Databases, App Services and more", has just been published in the March 2024 issue of the German "windows .developer" magazine. Stay tuned for the final part of this exciting series!

The article is available <a href="https://entwickler.de/azure/azure-arc-hybrid-cloud-datenbanken" target="_blank" rel="noopener noreferrer">online</a>, but please note that it is in German and requires a subscription to access.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2024/03/windows-developer-03-24.jpg"><img loading="lazy" src="/assets/img/posts/2024/03/windows-developer-03-24.jpg" alt="windows developer 03 24" /></a>
  <p></p>
</div>

Below, you'll find the article's introduction in English and German:

Azure Arc allows managing hardware that is operated outside of Azure. Additionally, with Azure Arc, Azure services can be installed in your own data center on a Kubernetes cluster.

In the first three articles of this series, Azure Arc was used as a tool to manage hardware that is operated outside of Azure. But Azure Arc also allows installing Azure services outside of Azure. A Kubernetes cluster with Azure Arc is needed as a basis for this. On this, Azure services such as Azure App Service or Azure Event Grid can then be installed. In addition, data services, such as Azure SQL Managed Instance or Azure Machine Learning, can be operated with Azure Arc in the Kubernetes cluster. This allows combining the advantages of Cloud and On-Premises. In the case of the Azure SQL Managed Instance, this means that Microsoft updates the SQL version and is responsible for backups. However, the data remains in your own data center, which makes it easier to meet GDPR requirements and additionally the latency for accessing the data is minimal.

Azure Arc erlaubt es, Hardware zu verwalten, die außerhalb von Azure betrieben wird. Zusätzlich können mit Azure Arc Azure-Dienste im eigenen Rechenzentrum auf einem Kubernetes-Cluster installiert werden.

In den ersten drei Artikeln dieser Serie wurde Azure Arc als Tool zum Verwalten von Hardware verwendet, die außerhalb von Azure betrieben wird. Azure Arc erlaubt es aber auch, Azure-Dienste außerhalb von Azure zu installieren. Als Basis dafür wird ein Kubernetes-Cluster mit Azure Arc benötigt. Auf diesem können dann Azure-Dienste wie Azure App Service oder Azure Event Grid installiert werden. Zusätzlich können Datendienste, wie Azure SQL Managed Instance oder Azure Machine Learning mit Azure Arc im Kubernetes-Cluster betrieben werden. Das ermöglicht es, die Vorteile von Cloud und On-Premises zu kombinieren. Im Fall der Azure SQL Managed Instance bedeutet das, dass Microsoft die SQL-Version aktualisiert und für Back-ups zuständig ist. Die Daten bleiben aber im eigenen Rechenzentrum, wodurch GDPR-Anforderungen leichter erfüllt werden können und zusätzlich die Latenz für den Zugriff auf die Daten minimal ist.