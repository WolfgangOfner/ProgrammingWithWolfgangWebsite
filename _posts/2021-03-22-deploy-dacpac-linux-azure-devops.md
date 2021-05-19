---
title: Automatically Deploy your Database with Dacpac Packages using Linux and Azure DevOps
date: 2021-03-22
author: Wolfgang Ofner
categories: [DevOps, Cloud]
tags: [DevOps, SSDT, SQL, Dacpac, CI-CD, Azure DevOps, Azure, Docker]
description: Use a custom Docker container to deploy Dacpac packages to an SQL Server using a Linux build environment in Azure DevOps.
---

I showed [in my last post](/automatically-deploy-database-changes) how to use SSDT to create a dacpac package and how to deploy it locally. The SSDT project uses .NET Framework 4.8 which means that it runs only on Windows. Azure DevOps has a task to deploy dacpac packages, but it also only supports Windows. To be able to use a Linux environment, I will create a .NET Core project to build the dacpac package and build my own Docker container with the sqlpackage installed to deploy the dacpac to an SQL Server.

## Use .NET Core to create the Dacpac package

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

I have created a new folder in my solution, Database, which contains the SQL project. To build this project in a Linux environment, I add a new .NET Core 3.1 Class Library called CustomerApi.Database.Build. Next, I replace the SDK type with MSBuild.Sdk.SqlProj/1.11.4 and set the SQLServerVersion SqlAzure because I want to deploy it to an Azure SQL database.

```xml
<Project Sdk="MSBuild.Sdk.SqlProj/1.11.4">
  <PropertyGroup>
    <TargetFramework>netcoreapp3.1</TargetFramework>
    <SqlServerVersion>SqlAzure</SqlServerVersion>
  </PropertyGroup>

</Project>
```

This references the MSBuild.Sdk.SqlProj project which can be found on <a href="https://github.com/rr-wfm/MSBuild.Sdk.SqlProj/" target="_blank" rel="noopener noreferrer">Github</a>. Unfortunately, this project doesn't support .NET 5 yet, that's why I use .NET Core 3.1.

### Add Scripts to the Deployment Project

The created Dacpac package should execute SQL scripts before and after the deployment. To achieve that, I create a folder Scripts which contains two subfolders called, PostScripts and PreScripts. The folders contain the Script.PostDeployment, respectively the Script.PreDeployment script. 

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Structure-of-the-scripts.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Structure-of-the-scripts.jpg" alt="Structure of the scripts" /></a>
  
  <p>
   Structure of the scripts
  </p>
</div>

These scripts contain all SQL scripts which should be executed. The PostScripts folder contains the 00_AddCustomers script and therefore, I have added it to the Script.PostDeployment file.

```text
:r ./00_AddCustomers.sql
```

Additionally, I have to add the following code to the .csproj file:

```xml
  <ItemGroup>
    <Content Remove="Scripts\**\*.sql" />
    <None Include="Scripts\**\*.sql" />
  </ItemGroup>

  <ItemGroup>
    <PostDeploy Include=".\Scripts\PostScripts\Script.PostDeployment.sql" />
    <PreDeploy Include=".\Scripts\PreScripts\Script.PreDeployment.sql" />
  </ItemGroup>
```

This code configures the execution of the scripts before and after the deployment.

Be aware that the scripts are executed every deployment. If your script inserts data, you have to make sure that it checks the data before it inserts it. I am using a merge statement to update existing data or create it if it doesn't exist. This script looks complicated but is quite simple. 

```sql
SET NOCOUNT ON

MERGE INTO [dbo].[Customer] AS Target
USING (VALUES
('9f35b48d-cb87-4783-bfdb-21e36012930a', 'Wolfgang','Ofner', '1989-11-23', 31),
('654b7573-9501-436a-ad36-94c5696ac28f', 'Darth','Vader', '1977-05-25', 43),
('971316e1-4966-4426-b1ea-a36c9dde1066', 'Son','Goku', '1937-04-16', 84)
) AS Source (Id, FirstName, LastName, Birthday, Age)
ON (Target.Id = Source.Id)
WHEN MATCHED AND (
	NULLIF(Source.Id, Target.Id) IS NOT NULL OR 
	NULLIF(Target.Id, Source.Id) IS NOT NULL OR 
	NULLIF(Source.FirstName, Target.FirstName) IS NOT NULL OR 
	NULLIF(Target.FirstName, Source.FirstName) IS NOT NULL OR 
	NULLIF(Source.LastName, Target.LastName) IS NOT NULL OR 
	NULLIF(Target.LastName, Source.LastName) IS NOT NULL OR
	NULLIF(Source.Birthday, Target.Birthday) IS NOT NULL OR 
	NULLIF(Target.Birthday, Source.Birthday) IS NOT NULL)THEN
 UPDATE SET
  Id = Source.Id,
  FirstName = Source.FirstName,
  LastName = Source.LastName,
  Birthday = Source.Birthday,
  Age = Source.Age
  
WHEN NOT MATCHED BY TARGET THEN
 INSERT(Id, FirstName, LastName, Birthday, Age)
 VALUES(Source.Id, Source.FirstName, Source.LastName, Source.Birthday, Source.Age)
WHEN NOT MATCHED BY SOURCE  THEN
 DELETE;

DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [dbo].[Customer]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[dbo].[Customer] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
```

### Add Tables to the Deployment Project

Lastly, I have to add the tables for my database. You can either add the SQL script in the root folder, or you can reference the SSDT project. Since I am lazy, I reference the SSDT project with the following code in the .csproj file

```xml
  <ItemGroup>
    <Content Include="..\CustomerApi.Database\dbo\**\*.sql" />
  </ItemGroup>
```

This adds the Tables folder with the Customer table to the solution.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Referencing-the-tables.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Referencing-the-tables.jpg" alt="Referencing the tables" /></a>
  
  <p>
   Referencing the tables
  </p>
</div>

### Finished Project and Build Problems

The finished .csproj file looks as following:

```xml
<Project Sdk="MSBuild.Sdk.SqlProj/1.11.4">
  <PropertyGroup>
    <TargetFramework>netcoreapp3.1</TargetFramework>
    <SqlServerVersion>SqlAzure</SqlServerVersion>
  </PropertyGroup>

  <ItemGroup>
    <Content Include="..\CustomerApi.Database\dbo\**\*.sql" />
  </ItemGroup>

  <ItemGroup>
    <Content Remove="Scripts\**\*.sql" />
    <None Include="Scripts\**\*.sql" />
  </ItemGroup>

  <ItemGroup>
    <PostDeploy Include=".\Scripts\PostScripts\Script.PostDeployment.sql" />
    <PreDeploy Include=".\Scripts\PreScripts\Script.PreDeployment.sql" />
  </ItemGroup>

</Project>
```

If you get an error building the project, add the following code to the MSBuild.exe.config:

```xml
<assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
  <dependentAssembly>
    <assemblyIdentity name="System.Numerics.Vectors" publicKeyToken="b03f5f7f11d50a3a" culture="neutral" />
    <bindingRedirect oldVersion="0.0.0.0-4.1.3.0" newVersion="4.1.4.0" />
  </dependentAssembly>
</assemblyBinding>
```

You can find the file under C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin (The path will vary, depending on your version, e.g. Professional, Enterprise, etc.). This is a known MSBuild bug which exists for around a year already.

## Build the Database Project in the Dockerfile to create a Dacpac Package

After finished the database build project, it is time to include it in Dockerfile so it gets built in the CI/CD pipeline. The Dockerfile is located in the CustomerApi folder and contains already all statements to build the projects and run the tests. First, add a copy statement to copy the project inside the container: 

```docker
COPY ["CustomerApi.Database.Build/CustomerApi.Database.Build.csproj", "CustomerApi.Database.Build/"]
```

Next, add the following section:

```docker
FROM build AS dacpac
ARG BuildId=localhost
LABEL dacpac=${BuildId}
WORKDIR /src
RUN dotnet build "CustomerApi.Database.Build/CustomerApi.Database.Build.csproj" -c Release -o /dacpacs --no-restore
```

This code creates an intermediate container and labels it so you can access it later. Additionally, it builds the project and generates the dacpac package this way. If you were following this series, then you have seen the same method to collect the test results and code coverage.

### Upload the Dacpac Package

After building the Dacpac package, you have to extract it from the Docker container and upload it as build artifact. This is done in the DockerBuildAndPush template which is located under pipelines/templates. Add the following code after the PublishCodeCoverage task:

```powershell
- pwsh: |
    $id=docker images --filter "label=dacpac=${{ parameters.buildId }}" -q | Select-Object -First 1
    docker create --name dacpaccontainer $id
    docker cp dacpaccontainer:/dacpacs $(Build.ArtifactStagingDirectory)/dacpacs
    docker rm dacpaccontainer
  displayName: 'Copy DACPACs'

- task: PublishBuildArtifacts@1    
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)/dacpacs'
    ArtifactName: 'dacpacs'
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
  displayName: 'Publish DACPAC'
```

This code takes a container with the dacpac label and extracts the dacpac file (This is the same as the extraction of the code coverage and test results). Then it uploads (publishes) it for the Azure DevOps agent.

## Create a Linux Container to Deploy the Dacpac package

The Azure DevOps team has an open <a href="https://github.com/microsoft/azure-pipelines-tasks/issues/8408" target="_blank" rel="noopener noreferrer">Github</a> issue from 2018 about deploying dacpac on Linux. Unfortunately, we haven't gotten any news if and when they will implement it. Therefore, I will use a Linux Docker container with sqlpackage installed to deploy the database. The Dockerfile was originally created by a colleague of mine. I have created a new folder, Infrastructure, in the root folder and added the Dockerfile there. 

```docker
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q -O /opt/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2134311 && unzip -qq /opt/sqlpackage.zip -d /opt/sqlpackage && chmod +x /opt/sqlpackage/sqlpackage && rm -f /opt/sqlpackage.zip

RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' && \
    apt-get update && \
    apt-get install -y powershell
```

I also have uploaded the container to <a href="https://hub.docker.com/repository/docker/wolfgangofner/linuxsqlpackage" target="_blank" rel="noopener noreferrer">Dockerhub</a> and will use it in the CI/CD pipeline.

## Deploy your Database using the Dacpac Package

To deploy the dacpac package to the database, you should use a deployment task in your CI/CD pipeline. This task runs as a container job using the previously mentioned linux container with the sqlpackage installed. This deployment also runs only after the build succeeded and only if the build reason is not a pull request The code for that looks as follows:

```yaml
- deployment: DeployDatabase
  dependsOn: Build
  condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))
  displayName: 'Deploy Database'   
  environment: Database 
  container: linuxsqlpackage
  strategy:
    runOnce:
      deploy:
        steps:
        - template: templates/DatabaseDeploy.yml
          parameters:          
              connectionString: $(ConnectionString)
              dacpacPath: "$(Agent.BuildDirectory)/dacpacs/$(ArtifactName).Database.Build.dacpac"
```

This deployment executes the DatabaseDeploy template which takes two parameters, connectionString and dacpacPath. The template looks as follows:

```yaml
parameters:
  - name: blockOnPossibleDataLoss
    type: string
    default: false 
  - name: generateSmartDefaults
    type: string
    default: true
  - name: connectionString
    type: string
    default:
  - name: dacpacPath
    type: string
    default:

steps:
  - download: current
    artifact: 'dacpacs'
    displayName: 'Download DACPAC'
  - pwsh: |
      /opt/sqlpackage/sqlpackage /a:Publish /p:BlockOnPossibleDataLoss=${{ parameters.blockOnPossibleDataLoss }} /p:GenerateSmartDefaults=${{ parameters.generateSmartDefaults }} /tcs:"${{ parameters.connectionString }}" /sf:"${{ parameters.dacpacPath }}"    
    displayName: 'Deploy DACPAC'
```

The deployment downloads the previously published dacpac artifact and the executes a sqlpackage publish with the connection string to the database and the path of the dacpac package.

## Testing the Database Deployment

I added the database deployment also to the OrderApi. You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

Before you can run the pipelines, you have to replace the SQLServerName variable with your server URL:

```yaml
SQLServerName: wolfgangmicroservicedemoserver.database.windows.net # replace with your server url
```

Additionally, you have to add the DbUser and DbPassword variables in the pipeline. You can add the DbUser variable as a normal variable if you want. The DbPassword variable must be added as a secret variable though, otherwise, everyone can see the password.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Add-secret-variables-to-your-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Add-secret-variables-to-your-pipeline.jpg" alt="Add secret variables to your pipeline" /></a>
  
  <p>
   Add secret variables to your pipeline
  </p>
</div>

Run both (CustomerAPi and OrderApi) pipelines and you should see both databases deployed on your database server.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/Deploying-the-database-in-the-CI-CD-pipeline.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/Deploying-the-database-in-the-CI-CD-pipeline.jpg" alt="Deploying the database in the CI-CD pipeline" /></a>
  
  <p>
   Deploying the database in the CI-CD pipeline
  </p>
</div>

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/03/The-databases-got-deployed-on-the-server.jpg"><img loading="lazy" src="/assets/img/posts/2021/03/The-databases-got-deployed-on-the-server.jpg" alt="The databases got deployed on the server" /></a>
  
  <p>
   The databases got deployed on the server
  </p>
</div>

## Conclusion

Dacpac is great to automate the database deployment including schema updates and the execution of scripts. Currently, the deployment is only supported on Windows but with a bit of tweaking, I was able to use .NET Core 3.1 and my own Linux Docker container to build and deploy it using Linux. Setting up everything is a bit of work but after you have done it once, you can easily copy and paste most of it into future projects. 

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).