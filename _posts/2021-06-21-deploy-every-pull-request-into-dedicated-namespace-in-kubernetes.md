---
title: Deploy every Pull Request into a dedicated Namespace in Kubernetes
date: 2021-06-21
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes]
description: Deploying every feature into a dedicated environment allows you to deliver fast and reliable features. 
---

Kubernetes enables developers to deploy quickly into test and production environments. Following the principles of DevOps of deploying fast and often, we should not stop there. Rather DevOps should enable developers to deploy each feature to a dedicated environment for it to be tested and therefore be deployed into production as fast as possible.

This post will show you how to deploy every pull request into its own Kubernetes namespace with its own unique URL. Doing so will bring projects one step closer to continuous deployments.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Deploy the Helm package during a Pull Request Build

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

If you have not enabled CI builds during pull requests, see [Run the CI Pipeline during a Pull Request](/run-the-ci-pipeline-during-pull-request) for more information on how to run your pipeline.

Deploying the Helm package during the pull request is almost the same as the deployment to the test environment:

<script src="https://gist.github.com/WolfgangOfner/8429d8a38c011946519a8d23f8d3653f.js"></script>

The most notable change is the condition that checks the source branch of the build. Since the CI and CD pipeline are separated and the CD pipeline is triggered by the CI pipeline, you can not access the source branch directly. Therefore you have to reference the source branch of the CI build. A pull request branch always starts with refs/pull. You can check this with the following condition:

<script src="https://gist.github.com/WolfgangOfner/b98ad3a5d1a972122c0ffc9fc43c717f.js"></script>

The next change to the regular deployment is obtaining the pull request id. The pull request id is great to distinguish between pull requests and therefore will be used as part of the URL and namespace. Since the CD pipeline is triggered by the CI pipeline and not the pull request directly, it is not possible to access the pull request id through the built-in variable System.PullRequest.PullRequestId. Instead, I use the following PowerShell command which is placed inside the GetPrId.yaml template:

<script src="https://gist.github.com/WolfgangOfner/8db776cd1ca9187f87b9076ec0ab3656.js"></script>

For the Kubernetes namespace, use a meaningful name and add the pull request id, for example, customerapi-pr-123. The URL almost works the same way, for example, pr-123.customerapi.programmingwithwolfgang.com. If you followed this series and have the DNS already configured for subdomains, then you do not have to change anything in the DNS settings. If you haven't made the DNS configuration, see [Configure custom URLs to access Microservices running in Kubernetes](/configure-custom-urls-to-access-microservices-running-in-kubernetes) for more information.

## Cleaning up the Pull Request Deployments

As you have seen, deploying pull requests is quite easy. It is also important to not forget to clean them up after someone reviewed them. Otherwise, your Kubernetes cluster will be full soon. 

Deleting the previously created namespace inside the Azure DevOps YAML pipeline is quite simple:

<script src="https://gist.github.com/WolfgangOfner/4baac64aa588117648a2beb7a451c8f9.js"></script>

This code reads the pull request id to find the correct namespace name and then uses kubectl to delete the Kubernetes namespace. The more interesting question is how you can control when the namespace gets deleted. The code above runs immediately after the deployment is finished. This means that you create a new namespace and in the next step delete it again.

Having control over when the stage runs can be achieved with approvals in Azure DevOps. 

### Add an Approval before deleting the Pull Request Namespace

To add an approval go to Pipelines and then Environment in your Azure DevOps project. There you can see your environment for deleting the namespace, in my case customerapi-PR-Delete, when you ran the deployment already at least once. If you can't see it, click on New environment and add it with the same name as in your pipeline.

Click on the environment and then click on the three dots on the top right and select Approvals and checks. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Open-the-Environment-Settings.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Open-the-Environment-Settings.jpg" alt="Open the Environment Settings" /></a>
  
  <p>
   Open the Environment Settings
  </p>
</div>

This redirects you to a new page where you can click on Approvals.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Add-an-Approval-before-the-deployment.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Add-an-Approval-before-the-deployment.jpg" alt="Add an Approval before the deployment" /></a>
  
  <p>
   Add an Approval before the deployment
  </p>
</div>

Select who is allowed to approve and optionally configure the timeout and if the approver is allowed to approve their own deployment.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Configure-the-Approval.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Configure-the-Approval.jpg" alt="Configure the Approval" /></a>
  
  <p>
   Configure the Approval
  </p>
</div>

When you create a new Pull Request, you will see that after the deployment succeeded, an approval is necessary to execute the deletion step. Often the approver is someone from QA or marketing. This person often checks if the feature looks as requested and if the basic functionality is as expected. More in-depth tests should be automated.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-Deployment-needs-to-be-approved.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-Deployment-needs-to-be-approved.jpg" alt="The Deployment needs to be approved" /></a>
  
  <p>
   The Deployment needs to be approved
  </p>
</div>

For more detailed explanations about approvals in Azure DevOps, see [Approvals for YAML Pipelines in Azure DevOps](/deployment-approvals-yaml-pipeline).

## Testing the Pull Request Deployment

Create a new pull request to trigger the CI pipeline.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Create-a-new-Pull-Request.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Create-a-new-Pull-Request.jpg" alt="Create a new Pull Request" /></a>
  
  <p>
   Create a new Pull Request
  </p>
</div>

As you can see on the screenshot above, the pull request id is 61. 

After the Help deployment is finished, the task also prints the URL of the new service. As you can see the URL pr-61.customer.programmingwithwolfgang.com matches the pull request id.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-Pull-Request-got-deployed-to-an-unique-URL.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-Pull-Request-got-deployed-to-an-unique-URL.jpg" alt="The Pull Request got deployed to an unique URL" /></a>
  
  <p>
   The Pull Request got deployed to an unique URL
  </p>
</div>

Click on the URL and your browser opens the previously deployed microservice. As you can see, the URL works and also has a valid SSL certificate that was created automatically. For more information about creating SSL certificates inside your Kubernetes cluster, see [Automatically issue SSL Certificates and use SSL Termination in Kubernetes](/automatically-issue-ssl-certificates-and-use-ssl-termination-in-kubernetes)

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/Everything-works-as-expected.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/Everything-works-as-expected.jpg" alt="Everything works as expected" /></a>
  
  <p>
   Everything works as expected
  </p>
</div>

When you open your Kubernetes dashboard or check your namespaces in the Azure portal, you will see the Kubernetes namespace corresponding to the pull request id.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/06/The-namespace-matches-the-PR-id.jpg"><img loading="lazy" src="/assets/img/posts/2021/06/The-namespace-matches-the-PR-id.jpg" alt="The namespace matches the PR id" /></a>
  
  <p>
   The namespace matches the PR id
  </p>
</div>

## Further Improvements

As you can see, this demo uses a very simple pull request deployment and only uses the Helm package for the microservice. This microservice has no connection to a queue service or a database. You have to consider how much the PR deployment in your project needs.

In case you want a full application with queue and database, then add them in the PR deployment. The steps are basically the same as in the other deployments and you can use the PR id again to distinguish the PR database from the test or production database.

If you add additional services, make sure to not forget to delete them. Especially database can be expensive in Azure if you never delete them.

## Conclusion

Modern DevOps environments should strive to deploy as fast and as often as possible. To achieve this, deploy every feature into a dedicated environment and if it passes the tests, deploy it to your production environment. This allows developers to deliver features faster and also helps to narrow down bugs due to the small scope of each deployment.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).