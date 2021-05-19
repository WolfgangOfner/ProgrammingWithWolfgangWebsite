---
title: Get xUnit Code Coverage from Docker
date: 2020-11-23
author: Wolfgang Ofner
categories: [DevOps, Docker]
tags: [Azure DevOps, 'C#', Docker, xUnit]
description: Getting code coverage in Azure DevOps when runrning xUnit tests inside a Docker container during the build can be hard.
---
Getting code coverage in Azure DevOps is not well documented and the first time I configured it, it took me quite some time to figure out how to do it. It gets even more complicated when you run your tests inside a Docker container during the build.

<a href="/run-xUnit-inside-docker-during-ci-build" target="_blank" rel="noopener noreferrer">In my last post</a>, I showed how to run tests inside a container during the build. Today, I want to show how to get the code coverage of these tests and how to display them in Azure DevOps.

Code coverage gives you an indication of how much of your code is covered by at least one test. Usually, the higher the better but you shouldn't aim for 100%. As always, it depends on the project but I would recommend having around 80%.

## Setting up xUnit for Code Coverage

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

### Install Coverlet

I use coverlet to collect the coverage. All you have to do is installing the Nuget package. The full Nuget configuration of the test projects looks as following:

```xml  
<ItemGroup>
   <PackageReference Include="FakeItEasy" Version="6.2.1" />
   <PackageReference Include="FluentAssertions" Version="5.10.3" />
   <PackageReference Include="Microsoft.NET.Test.Sdk" Version="16.8.0" />
   <PackageReference Include="xunit" Version="2.4.1" />
   <PackageReference Include="xunit.runner.visualstudio" Version="2.4.3">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
   </PackageReference>
   <PackageReference Include="coverlet.msbuild" Version="2.9.0">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
   </PackageReference>
</ItemGroup>  
```

I am using FakeItEasy to mock objects, FluentAssertions for a more readable assertion and xUnit to run the tests.

### Collect the Code Coverage Results

After installing coverlet, the next step is to collect the coverage results. To do that, I edit the Dockerfile to enable collecting the coverage results, setting the output format, and the output directory. The code of the tests looks as follows:

```docker 
FROM build AS test  
ARG BuildId
LABEL test=${BuildId}
RUN dotnet test --no-build -c Release --results-directory /testresults --logger "trx;LogFileName=test_results.trx" /p:CollectCoverage=true /p:CoverletOutputFormat=json%2cCobertura /p:CoverletOutput=/testresults/coverage/ -p:MergeWith=/testresults/coverage/coverage.json  Tests/CustomerApi.Test/CustomerApi.Test.csproj  
RUN dotnet test --no-build -c Release --results-directory /testresults --logger "trx;LogFileName=test_results2.trx" /p:CollectCoverage=true /p:CoverletOutputFormat=json%2cCobertura /p:CoverletOutput=/testresults/coverage/ -p:MergeWith=/testresults/coverage/coverage.json  Tests/CustomerApi.Service.Test/CustomerApi.Service.Test.csproj  
RUN dotnet test --no-build -c Release --results-directory /testresults --logger "trx;LogFileName=test_results3.trx" /p:CollectCoverage=true /p:CoverletOutputFormat=json%2cCobertura /p:CoverletOutput=/testresults/coverage/ -p:MergeWith=/testresults/coverage/coverage.json  Tests/CustomerApi.Data.Test/CustomerApi.Data.Test.csproj
```

The output format is json and Cobertura because I want to collect the code coverage of all tests and merge them into the summary file. This is all done behind the scenes, all you have to do is using the MergeWith flag where you provide the path to the json file. You could also build the whole solution if you don&'t want to configure this. The disadvantage is that you will always run all tests. This might be not wanted, especially in bigger projects where you want to separate unit tests from integration or UI tests.

This is everything you have to change in your projects to be ready to collect the coverage. The last step is to copy the results out of the container and display them in Azure DevOps.

## Display the Code Coverage Results in Azure DevOps

In my last post, I explained how to copy the test results out of the container using the label test=${BuildId}. This means that besides the test results, the coverage results are also copied out of the container already. All I have to do now is to display these coverage results using the PublishCodeCoverageResults tasks from Azure DevOps. The code looks as follows:

```yaml  
- task: PublishCodeCoverageResults@1
  inputs:
    codeCoverageTool: 'Cobertura'
    summaryFileLocation: '$(System.DefaultWorkingDirectory)/testresults/coverage/coverage.cobertura.xml'
    reportDirectory: '$(System.DefaultWorkingDirectory)/testresults/coverage/reports'
  displayName: 'Publish code coverage results' 
```

The whole code to copy the everything out of the container, display the test results and the code coverage looks as this:

```yaml  
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
```

Save the changes and run the CI pipeline. After the build is finished, you will see the Code Coverage tab in the summary overview where you can see the coverage of each of your projects.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2020/11/Code-Coverage-Results.jpg"><img loading="lazy" src="/assets/img/posts/2020/11/Code-Coverage-Results.jpg" alt="Summary of the Code Coverage Results" /></a>
  
  <p>
    Summary of the Code Coverage Results
  </p>
</div>

## Conclusion

The code coverage shows how much of your code is covered by at least one test. This post showed how easy it can be to display these results in Azure DevOps, even when the build runs inside a Docker container.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).