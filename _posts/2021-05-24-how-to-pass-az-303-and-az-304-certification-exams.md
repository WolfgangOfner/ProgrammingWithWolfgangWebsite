---
title: How to pass the AZ-303 and AZ-304 Certification Exams
date: 2021-05-24
author: Wolfgang Ofner
categories: [Cloud, Miscellaneous]
tags: [DevOps, Azure DevOps, Azure, Azure Functions, YAML, Azure App Services, Cosmos DB, Azure CLI, Azure SQL, Azure VM, Learning, Certification, Exam]
description: Tips to prepare for the AZ-303 and AZ-304 exam and earn your Azure Solutions Architect Expert Certification.
---

Two weeks ago, I passed the AZ-304 exam and today I passed the AZ-303 exam giving me the Azure Solutions Architect Expert certification.

This post will give you an overview of the exams what methods I used to study and my tips to pass the certification.

## Exam Preparation

The first step of your exam journey should be figuring out what topics are covered in the exam. Download the skills measured for the <a href="https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4psD6" target="_blank" rel="noopener noreferrer">AZ-303: Microsoft Azure Architect Technologies</a> or for the <a href="https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4pCWz" target="_blank" rel="noopener noreferrer">AZ-304: Microsoft Azure Architect Design</a> exam. 

These documents give you an overview of the needed skills and outline any changes or updates to the exam. Do not be fooled by the simple document though. During the exam, you are expected to have in-depth knowledge of the needed technologies. You can find more details about the questions in the [Difficulty of the Exam](/how-to-pass-az-303-and-az-304-certification-exams/#difficulty-of-the-exam) section further down.

### Pluralsight

If you are fairly new to Azure or some  of the topics covered in the exam, get a Pluralsight subscription and go through the videos in the <a href="https://app.pluralsight.com/paths/certificate/microsoft-azure-architect-technologies-az-303" target="_blank" rel="noopener noreferrer">Microsoft Azure Architect Technologies (AZ-303)</a> and the <a href="https://app.pluralsight.com/paths/certificate/microsoft-azure-architect-design-az-304" target="_blank" rel="noopener noreferrer">Microsoft Azure Architect Design (AZ-304)</a> paths.

I started with the AZ-304 exam and therefore also started the AZ-304 path on Pluralsight. All courses in this learning path are remarkable and give a great overview of all the topics covered in the exam and furthermore give some additional more in-depth knowledge about the technologies.

After finishing the AZ-304 path, I started to watch the videos of the AZ-303 path but I did not learn anything new from them. It is possible that I was slightly burned out after all the videos or that the topics were too similar. If you study for the exam, I suggest giving them a shot and so that you may see for yourself if they help or not.

### Microsoft Learning Paths

After getting a great overview of all technologies, I wanted to go more into the details of every technology and used the learning paths from Microsoft. These learning paths cover all technologies in the exam and are a combination of theory and practical tasks, whereby you get a sandbox into Azure and must apply what you learned before. This could be, for instance, creating two new VNets with VMs in them. Then peer these VNets and check the connection between the VMs. The great thing about this is that you do not need to pay anything and do not even have to provide your credit card information. You can find the learning paths of the <a href="https://docs.microsoft.com/en-us/learn/certifications/exams/az-303?tab=tab-learning-paths" target="_blank" rel="noopener noreferrer">AZ-303</a> and <a href="https://docs.microsoft.com/en-us/learn/certifications/exams/az-304?tab=tab-learning-paths" target="_blank" rel="noopener noreferrer">AZ-304</a> exams on their certification page. 

### Whizlabs

With the Pluralsight courses finished and reading through hundreds of pages of documentation, I felt ready to take some practice questions. I decided to use <a href="https://www.whizlabs.com/learn/course/microsoft-azure-az-304" target="_blank" rel="noopener noreferrer">Whizlabs</a>, mostly because of their price of around $20 USD for four practice tests which you can retake as often as you want and also write comments to the questions.

I took the first practice test and felt not too bad but was surprised to see that I had only achieved around 60%. I went through each question and also read the comments of other test-takers. This led me to realize that around half of the questions are wrong and often my answers were actually correct. Many comments pointed that out and the support of Whizlabs acknowledged the issues and promised to fix them. But months later, the questions are still wrong.

Despite how cheap Whizlabs is, I can not recommend using it due to all the wrong answers and confusion that they are causing.

### MeasureUp

<a href="https://www.measureup.com" target="_blank" rel="noopener noreferrer">MeasureUp</a> is the test platform officially recommended by Microsoft. The AZ-304 exam has 162 test questions and the AZ-303 one has 166 questions. The questions are in the same format as the actual certification, meaning that there are case studies, single-choice, multiple-choice and drag-and-drop questions.

The practice tests are expensive ranging from 91€ for the 30-day access to 110€ for the one-year or download version. If you pass the test on MeasureUp, they give you a passing guarantee and if you fail your exam twice, you are refunded the full amount of the practice tests. They also often have deals where you can get 20% or 30% off.

The website can be awful, for example, Chrome didn't work most of the time for me and there are a couple of buttons that are only clickable if you hit the right pixel. However, once you started the practice test, everything is great. You can even configure the test exam to either have random questions, or questions that you got wrong the last time, or questions that you have not seen in a while.

The first time I took the AZ-304 test exam I achieved 74% and for the AZ-303, I only received 64%. But it showed me what was expected from me during the exam and helped me to dig even deeper into the technologies covered by the exams.

MeasureUp is expensive but totally worth the price and I highly recommend getting it before taking the exam.

### How to study

Everyone studies differently. Some prefer videos, some prefer reading and others like hands-on experience.

My recommendation is to try everything and see what works best for you. For me, watching the Pluralsight videos was a great starting point. Afterward, I copied the whole learning paths of the AZ-303 and AZ-304 exams into a Word file. I printed the document and highlighted it by hand. When I found something I didn't know, I added it at the end of the document under notes. I already studied this way during my university time and it works great for me. You can find the document in different formats on <a href="https://github.com/WolfgangOfner/Azure-Solutions-Architect-Expert-notes" target="_blank" rel="noopener noreferrer">GitHub</a>.

You should also get enough hands-on experience. I had this experience before I studied the documentation and it helped me greatly in understanding the topic. I would recommend that you create most of the services which are covered in the exam and play around a bit and look at all the panes of the service in the Azure portal. 

The last recommendation I can give you is to purchase the MeasureUp practice exams. They are worth it but also give you an insight into the way the questions will be and may furthermore boost your confidence when you can achieve a high score in the practice tests.

## AZ-303 vs AZ-304

The topics covered in the two exams are very similar but you have to know different aspects of them. The AZ-303 exam is more about how to set up something and its technical limitations. For example, you have to be able to set up a VNet, add VMs and then configure VNet peering using the Azure CLI and Azure PowerShell modules. Additionally, you must know what VM Skus you should use for specific workloads and what database sizes you can use with the different Azure SQL offerings.

The AZ-304 focuses more on what service you should use to build a solution. For example, you have to know if you should use Azure Front Door or Azure Traffic Manager to implement the requirements. Usually, you don't have to write code here but be prepared to know at least basic commands. 

I started with the AZ-304 because it fits better with my professional experience and I was more interested in it. I never had any doubt of failing the exam and got a score of 880 out of 1000. Then I started preparing for the AZ-304 which was way harder for me, mostly because of all the Azure PowerShell which I have never used before. Usually, I use Azure CLI but the exam forces you to be proficient in all technologies. Before the exam I was a bit doubtful of passing it but surprisingly to me, I browsed through the exam and got a score of 930 out of 1000.

## Taking the Exam

There are two options for taking the exam: at an official test center or at home. In the past, I took an exam at the test center but for the AZ-303 and AZ-304, I decided to take the online exam. Both options offer exactly the same exams, so you can select whatever you are more confident with.

The exam itself takes 130 minutes but plan for three hours with the ID check and some survey questions from Microsoft. This is plenty of time to go through your answers a couple of times. I finished both exams in under an hour.

The AZ-303 exam had 48 questions for me and the AZ-304 had 62. You should expect the number of questions to be in that range. To pass you need a score of at least 700 out of 1000. Note that Microsoft uses a dynamic scoring system which means that 700 out of 1000 doesn't equal 70%.

After finishing both exams, you get the Azure Solutions Architect Expert certification and badge.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/Azure-Solutions-Architect-Expert-Badge.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/Azure-Solutions-Architect-Expert-Badge.jpg" alt="Azure Solutions Architect Expert Badge" /></a>
  
  <p>
   Azure Solutions Architect Expert Badge
  </p>
</div>

### Taking the Exam at a Test center

I took a test at a test center a couple of years ago and it wasn't the most pleasant experience. First, you have to travel to their location, make sure you are one time, and bring an official ID. Next, you have to place all your belongings like your wallet, phone, and watch into a locker and then get escorted into a room full of computers where you take your exam. My test center had a mouse from the 90s and it was quite a hassle working with it. I didn't feel comfortable there but there is nothing wrong with taking the exam at a test center.

### Taking the Exam Online

Due to the pandemic, there were no test centers open in my location and therefore I took both exams online. To take the exams from home, you have to have a stable internet connection, a webcam, and a microphone. You are not allowed to use headphones though.

Taking the exam from home was way more comfortable for me. First, you don't have to travel there and additionally, you can use your computer, mouse and keyboard, and your chair which you are already familiar with. The check-in starts 30 minutes before the exam is scheduled. You get a link on your phone and have to take a picture of your ID and yourself. Then take four pictures of your surroundings and you get placed into the waiting queue. After a couple of minutes, a proctor will contact you either via voice message or chat and they may ask you some questions, such as, to show them your desk. Then they start the exam for you and the official exam begins.

After you are done with the exam, you will immediately get your score and how you did in each of the areas of the exam.

### Difficulty of the Exam

When I started with the practice exams, I was surprised by how hard the questions were. It is important to focus on the question and read it word for word. Sometimes a single word can change the answer to the question. I had two questions in my exam where I had no clue about the answer. In this situation, take a breath and try to rule out false answers. Often you have one or two answers which are completely wrong and so you are left with only two possible answers. If you still have no clue, take a guess. You don't lose any points for a wrong answer. Never leave a question unanswered!

During the practice exams, I felt way more at ease with the AZ-304 compared to the AZ-303 ones. Funnily enough, the AZ-303 exam felt easier than the AZ-304 one. I guess that I got a bit lucky with my questions there.

## Conclusion

The AZ-303: Microsoft Azure Architect Technologies and AZ-304: Microsoft Azure Architect Design certification exams require a lot of studying and hands-on experience but if you prepared diligently, you will pass the exams to earn your certification and learn a lot about the different technologies in Azure.