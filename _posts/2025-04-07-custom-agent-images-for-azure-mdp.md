---
title: Custom Agent Images for Azure Managed DevOps Pools
date: 2025-04-07
author: Wolfgang Ofner
categories: [DevOps]
tags: [Azure DevOps, Managed DevOps Pools]
description: Create and use custom Linux and Windows agents with your Managed Devops Pool.
---

Building and utilizing custom agent images for Azure DevOps Managed Pools offers a powerful and efficient approach to CI/CD. This method provides a flexible and streamlined alternative to traditional self-hosted or Microsoft-hosted agents, particularly beneficial when your pipelines demand specific software installations or unique environments.

## Understanding Managed DevOps Pools

Managed DevOps Pools present a compelling alternative to standard Azure DevOps agents. Their key advantages include:

- **Cost-effectiveness:** Billing is based solely on usage, optimizing expenditure.
- **Simplified Management:** Azure takes on the responsibility for underlying VM updates and agent software installation, significantly reducing your operational burden.
- **Enhanced Customization:** For scenarios requiring specialized software or tools that are cumbersome to install via command-line interfaces, custom agent images provide a tailored solution.

## Azure Setup for Custom Images

Setting up your Azure environment to support custom agent images involves a few critical steps:

1. **Define Variables and Create Resource Group:** Begin by establishing variables for your resource group, preferred location, and a unique name for your image gallery. Subsequently, create the resource group to house your resources.
2. **Create Azure Compute Gallery:** This central repository will store all your custom agent images, making them accessible for deployment.
3. **Grant Permissions:** A crucial step is to grant the devops infrastructure service principal "Reader" access to your Azure Compute Gallery. This permission is vital to prevent errors when Managed DevOps Pools attempt to provision agents using your custom images.
4. **Create Dev Center and Project:** A Dev Center and a project within it are established to manage the lifecycle and configuration of your DevOps pools.

## Creating and Preparing a Linux Custom Image

To create a custom Linux image suitable for your build needs:

1. **Provision an Ubuntu VM:** Deploy a new Ubuntu Virtual Machine in Azure.
2. **Install Necessary Software:** Install all required software, tools, and dependencies for your build environment. As an example, Docker might be installed for containerized workloads.
3. **Deallocate and Generalize VM:** Before capturing, the VM must be deallocated and generalized. Generalization removes unique machine-specific identifiers, ensuring the image is reusable across multiple agent instances.
4. **Capture VM as Image:** Utilize the Azure portal to capture this prepared VM. The captured image will then be stored in your Azure Compute Gallery.

## Creating and Using a Linux Managed DevOps Pool

Once your Linux custom image is ready:

1. **Create New Managed DevOps Pool:** In your Azure DevOps organization, initiate the creation of a new Managed DevOps Pool.
2. **Link to Azure DevOps Organization:** Connect the newly created pool to your specific Azure DevOps organization.
3. **Configure with Custom Image:** During the pool configuration, select your custom Ubuntu image from the Azure Compute Gallery to be used by the agents provisioned within this pool.
4. **Run Pipeline:** Execute a pipeline (e.g., a Docker build pipeline) in Azure DevOps. Observe how the Managed DevOps Pool automatically provisions a VM using your custom image and executes the pipeline steps.

## Creating and Preparing a Windows Custom Image

For a custom Windows image, the process is similar but with Windows-specific preparation steps:

1. **Provision a Windows VM:** Deploy a new Windows Virtual Machine in Azure.
2. **Install Necessary Software:** Install all required software, such as Chocolatey and specific .NET SDKs (e.g., .NET 9 SDK), to meet your pipeline's requirements.
3. **Prepare Windows Image:** Critical steps for Windows image generalization include:
    - Deleting the Panther folder within the Windows directory.
    - Enabling the CD/DVD ROM via the command line.
    - Running `sysprep.exe` with the `/generalize /shutdown /oobe` flags to generalize and shut down the VM.
4. **Capture VM as Image:** Capture the prepared Windows VM as an image and add it to your Azure Compute Gallery.

## Creating and Using a Windows Managed DevOps Pool

With your Windows custom image available:

1. **Create New Managed DevOps Pool:** Create another Managed DevOps Pool in your Azure DevOps organization.
2. **Configure with Custom Windows Image:** Select your newly created custom Windows image during the pool setup.
3. **Run Pipeline:** Execute a relevant pipeline (e.g., a .NET 9 build pipeline). The pool will automatically provision a Windows VM with your custom image and successfully run the pipeline.

## Conclusion

Leveraging custom images with Azure Managed DevOps Pools dramatically streamlines your CI/CD agent management. This approach frees you from the intricacies of manual agent installation and VM updates, as Microsoft handles these aspects. You can then concentrate on integrating the specific software and tools essential for your pipelines. This strategy not only enhances performance and scalability but also maintains an admirable level of ease of use, making it a valuable addition to any modern DevOps toolkit.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Custom%20Agent%20Images%20for%20Azure%20Managed%20DevOps%20Pools" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Custom Agent Images for Azure Managed DevOps Pools" and reviewed by me.

## Video - Custom Agent Images for Azure Managed DevOps Pools

<iframe width="560" height="315" src="https://www.youtube.com/embed/wgZUhx6hJYo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>