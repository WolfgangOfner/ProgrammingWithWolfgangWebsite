---
title: Create Git Commits in an Azure DevOps YAML Pipeline
date: 2021-12-20
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure, Azure DevOps, Git, YAML]
description: Creating Git commits inside an Azure DevOps YAML pipeline is very easy but you may have to make some security configurations. 
---

This week I encountered the need to commit some code to a Git repository in an Azure DevOps pipeline. First, I had no idea how to could work because the repository has some branch policies and require the committer to create a pull request.

As it turns out, if you configure your pipeline with the right permissions, committing code in the pipeline is quite simple.

## Configure the Pipeline to bypass Pull Request Policies

First, you have to configure the permissions of the build service to bypass pull request policies and also to be allowed to commit to your repository. To do that, go to the Project Settings --> Repository --> select your repository and then click on the Security tab. 

Select your Build Service and set Bypass policies when pushing Contribute to allowed.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/Set-the-permissions-of-the-build-service.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/Set-the-permissions-of-the-build-service.jpg" alt="Set the permissions of the Build Service" /></a>
  
  <p>
   Set the permissions of the Build Service
  </p>
</div>

## Create a Pipeline to Checkout and Commit to Git Branches

With the permissions in place, create a new YAML pipeline. For this demo, I use this very simple one.

<script src="https://gist.github.com/WolfgangOfner/7356c049cbe91cb231119dd2a0ea01be.js"></script>

All this pipeline does is to set an email address and user name in the gitconfig file and then it writes a new file called data.txt to the root folder and commits this change. You can split all these tasks also into separate tasks and don't have to do them all in the same one.

Run the pipeline and it should finish successfully.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/The-pipeline-ran-successfully.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/The-pipeline-ran-successfully.jpg" alt="The pipeline ran successfully" /></a>
  
  <p>
   The pipeline ran successfully
  </p>
</div>

Open your repository and you should see the data.txt file there.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/12/The-test-file-got-created-and-committed.jpg"><img loading="lazy" src="/assets/img/posts/2021/12/The-test-file-got-created-and-committed.jpg" alt="The test file got created and committed" /></a>
  
  <p>
   The test file got created and committed
  </p>
</div>

This demo is very simple but still should show you everything you need to know to create commits in your pipeline yourself. I will extend this demo in a future post and will use it to change some configurations of my application for an Azure Arc deployment.

## Conclusion

This post showed how you can create Git commits inside your Azure DevOps YAML pipeline and how to configure your Build Service to bypass pull request policies. 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/AzureDevOpsGitCommit" target="_blank" rel="noopener noreferrer">GitHub</a>.