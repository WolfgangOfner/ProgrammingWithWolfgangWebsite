---
title: Improve Azure DevOps YAML Pipelines with Templates
date: 2021-01-27
author: Wolfgang Ofner
categories: [DevOps, Kubernetes]
tags: [Azure DevOps, CI, YAML, AKS, Azure, Helm, Docker]
---

YAML pipelines can get quite long and unclear over time. In programming, developers use several files to separate logic apart to make the code easier to understand. The same is possible using templates in YAML pipelines. Additionally, these templates can be used in several pipelines reducing duplicate code.

## YAML Pipelines without Templates

[In my last post](/deploy-kubernetes-azure-devops), I worked on a pipeline that built a .NET 5 application, ran tests, pushed a docker image, and deployed it to Kubernetes using Helm. The pipeline hat 143 lines of code in the end. It looked like a wall of text and might be overwhelming at first glance.

```yaml
name : CustomerApi-CI
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - CustomerApi/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  AzureSubscription: 'AzureServiceConnection' # Name of the Service Connection
  ApiName: 'customerapi'
  ClusterResourceGroup: MicroserviceDemo  
  ChartPackage: '$(Build.ArtifactStagingDirectory)/$(ApiName)-$(Build.BuildNumber).tgz'  
  ChartPath: 'CustomerApi/CustomerApi/charts/$(ApiName)'
  HelmVersion: 3.5.0
  ImageName: 'wolfgangofner/$(ApiName):$(Build.BuildNumber)'
  K8sNamespace: '$(ApiName)-test'
  KubernetesCluster: 'microservice-aks'

stages:
- stage: Build
  displayName: Build image
  jobs:  
  - job: Build
    displayName: Build and push Docker image
    steps:
    
    - task: BuildVersioning@0
      displayName: 'Build Versioning'
      inputs:
        versionSource: 'gitversion'
        doInstallGitVersion: true
        GitVersionInstallerSource: 'choco'
        GitVersionInstallerVersion: '5.0.1'
        doUseLatestGitVersionInstallerVersion: false
        paramAssemblyVersion: '7'
        paramAssemblyFileVersion: '7'
        paramAssemblyInformationalVersion: '6'
        paramOverwriteFourthDigitWithBuildCounter: false
        paramVersionCode: '2'
        doAssemblyInfoAppendSuffix: false
        doConvertAssemblyInfoToLowerCase: true
        buildNumberVersionFormat: '3'
        buildNumberAction: 'replace'
        doReplaceAssemblyInfo: false
        doReplaceNuspec: false
        doReplaceNpm: false
        doReplaceDotNetCore: true
        filePatternDotNetCore: |
          **\*.csproj
          **\*.props
        paramDotNetCoreVersionType: '3'
        doReplaceAndroid: false
        doReplaceiOS: false
        doReplaceCustom: false
        doShowWarningsForUnmatchedRegex: false
        excludeFilePattern: |
          !**/bin/**
          !**/obj/**
          !**/node_modules/**
          !**/packages/**

    - task: Docker@1      
      inputs:
        containerregistrytype: 'Container Registry'
        dockerRegistryEndpoint: 'Docker Hub'
        command: 'Build an image'
        dockerFile: '**/CustomerApi/CustomerApi/Dockerfile'
        arguments: '--build-arg BuildId=$(Build.BuildId) --build-arg PAT=$(PatMicroserviceDemoNugetsFeed)'
        imageName: '$(ImageName)'
        useDefaultContext: false
        buildContext: 'CustomerApi'
      displayName: 'Build the Docker image'

    - pwsh: |
       $id=docker images --filter "label=test=$(Build.BuildId)" -q | Select-Object -First 1
       docker create --name testcontainer $id
       docker cp testcontainer:/testresults ./testresults
       docker rm testcontainer
      displayName: 'Copy test results' 
    
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'VSTest'
        testResultsFiles: '**/*.trx'
        searchFolder: '$(System.DefaultWorkingDirectory)/testresults'
      displayName: 'Publish test results'

    - task: PublishCodeCoverageResults@1
      inputs:
        codeCoverageTool: 'Cobertura'
        summaryFileLocation: '$(System.DefaultWorkingDirectory)/testresults/coverage/coverage.cobertura.xml'
        reportDirectory: '$(System.DefaultWorkingDirectory)/testresults/coverage/reports'
      displayName: 'Publish code coverage results'

    - task: Docker@1      
      inputs:
        containerregistrytype: 'Container Registry'
        dockerRegistryEndpoint: 'Docker Hub'
        command: 'Push an image'
        imageName: '$(ImageName)'
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
      displayName: 'Push the Docker image to Dockerhub'
    
    - task: HelmInstaller@0
      displayName: 'Install Helm $(HelmVersion)'
      inputs:
        helmVersion: $(HelmVersion)
        checkLatestHelmVersion: false
        installKubectl: true
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
      
    - task: HelmDeploy@0
      displayName: 'helm package'
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureResourceGroup: $(ClusterResourceGroup)
        kubernetesCluster: $(KubernetesCluster)
        command: 'package'
        chartPath: $(ChartPath)
        chartVersion: $(Build.BuildNumber)
        save: false
        namespace: '$(K8sNamespace)'
      condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))   
    
    - task: HelmDeploy@0
      displayName: 'Helm upgrade release'
      inputs:
        connectionType: 'Azure Resource Manager'
        azureSubscription: $(AzureSubscription)
        azureResourceGroup: '$(ClusterResourceGroup)'
        kubernetesCluster: '$(KubernetesCluster)'
        useClusterAdmin: true
        namespace: '$(K8sNamespace)'
        command: 'upgrade'
        chartType: 'FilePath'
        chartPath: '$(ChartPackage)'
        releaseName: '$(ApiName)-$(K8sNamespace)'
        arguments: '--create-namespace'
```

You can find this pipeline on <a href="https://github.com/WolfgangOfner/MicroserviceDemo/blob/master/CustomerApi/pipelines/CustomerApi-CI.yml" target="_blank" rel="noopener noreferrer">Github</a>. If you go through the history, you will see how it evolved over time.

## What Pipeline Templates are 

Templates let you split up your pipeline into several files (templates) and also allow you to reuse these templates either in the same or in multiple pipelines. As a developer, you may know the Separation of Concerns principle. Templates are basically the same for pipelines. 

You can pass parameters into the template and also set default values for these parameters. Passing parameters is not mandatory because a previously defined variable would still work inside the template. It is best practice to pass parameters to make the usage more clear and make the re-usage easier.

Another use case for templates is to have them as a base for pipelines and enforce them to extend the template. This approach is often used to ensure a certain level of security in the pipeline.

## Create your first Template

I like to place my templates in a templates folder inside the pipelines folder. This way they are close to the pipeline and can be easily referenced inside the pipeline.

### Create Templates without Parameters

The first template I create is for the build versioning task. To do that, I create a new file, called BuildVersioning.yml inside the templates folder and copy the BuildVersioning task from the pipeline into the template. The only additionaly step I have to take is use step: at the beginning of the template and intend the whole task. The finished template looks as follows:

```yaml
steps:
  - task: BuildVersioning@0
    displayName: 'Build Versioning'
    inputs:
      versionSource: 'gitversion'
      doInstallGitVersion: true
      GitVersionInstallerSource: 'choco'
      GitVersionInstallerVersion: '5.0.1'
      doUseLatestGitVersionInstallerVersion: false
      paramAssemblyVersion: '7'
      paramAssemblyFileVersion: '7'
      paramAssemblyInformationalVersion: '6'
      paramOverwriteFourthDigitWithBuildCounter: false
      paramVersionCode: '2'
      doAssemblyInfoAppendSuffix: false
      doConvertAssemblyInfoToLowerCase: true
      buildNumberVersionFormat: '3'
      buildNumberAction: 'replace'
      doReplaceAssemblyInfo: false
      doReplaceNuspec: false
      doReplaceNpm: false
      doReplaceDotNetCore: true
      filePatternDotNetCore: |
        **\*.csproj
        **\*.props
      paramDotNetCoreVersionType: '3'
      doReplaceAndroid: false
      doReplaceiOS: false
      doReplaceCustom: false
      doShowWarningsForUnmatchedRegex: false
      excludeFilePattern: |
        !**/bin/**
        !**/obj/**
        !**/node_modules/**
        !**/packages/**
```

### Create Templates with Parameters

Creating a template with parameters is the same as without parameters except that parameters get places at the beginning of the file. This section starts with the parameters keyword and then lists the parameter name, type, and a default value. If you don't have a default value, leave it empty.

```yaml
parameters:
  - name: buildId
    type: string
    default: 
  - name: patMicroserviceDemoNugetsFeed
    type: string
    default: 
  - name: imageName
    type: string
    default: 
```

After the parameters, add the steps keyword and add the desired tasks.

## Use Templates in the Azure DevOps YAML Pipeline

I placed all tasks in a couple of templates. To reference these templates use the template keyword and the path to the file:

```yaml
- template: templates/BuildVersioning.yml
```

If a template needs parameters, use the parameters key word and add all needed parameters:

```yaml
- template: templates/DockerBuildAndPush.yml
  parameters:
      buildId: $(BuildId)
      patMicroserviceDemoNugetsFeed: $(PatMicroserviceDemoNugetsFeed)          
      imageName: $(ImageName)
```

I put all tasks into templates and tried to group what belongs together. The pipeline looks as follows now:

```yaml
name : OrderApi-CI
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - OrderApi/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  AzureSubscription: 'AzureServiceConnection' # Name of the Service Connection
  ApiName: 'orderapi'
  BuildId: $(Build.BuildId)
  BuildNumber: $(Build.BuildNumber)
  ClusterResourceGroup: MicroserviceDemo  
  ChartPackage: '$(Build.ArtifactStagingDirectory)/$(ApiName)-$(Build.BuildNumber).tgz'  
  ChartPath: 'OrderApi/OrderApi/charts/$(ApiName)'
  HelmVersion: 3.5.0
  ImageName: 'wolfgangofner/$(ApiName):$(Build.BuildNumber)'
  K8sNamespace: '$(ApiName)-test'
  KubernetesCluster: 'microservice-aks'

stages:
- stage: Build
  displayName: Build image
  jobs:  
  - job: Build
    displayName: Build and push Docker image
    steps:
 
    - template: templates/BuildVersioning.yml
    - template: templates/DockerBuildAndPush.yml
      parameters:
          buildId: $(BuildId)
          patMicroserviceDemoNugetsFeed: $(PatMicroserviceDemoNugetsFeed)          
          imageName: $(ImageName)
    - template: templates/HelmInstall.yml
      parameters: 
          helmVersion: $(HelmVersion)
    - template: templates/HelmDeploy.yml
      parameters:          
          apiName: $(ApiName)
          azureSubscription: $(AzureSubscription)
          buildNumber: $(BuildNumber)
          clusterResourceGroup: $(ClusterResourceGroup)          
          chartPackage: $(ChartPackage)
          chartPath: $(ChartPath)          
          k8sNamespace: $(K8sNamespace)
          kubernetesCluster: $(KubernetesCluster)
```

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