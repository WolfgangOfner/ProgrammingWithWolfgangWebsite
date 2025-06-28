---
title: Attach a Volume to an Azure Container App
date: 2025-02-24
author: Wolfgang Ofner
categories: [Cloud]
tags: [DevOps, Azure Container Apps, Azure Storage Account]
description: Learn how to attach an Azure File Share as a volume to an Azure Container App and how to automate its creation.
---

This post provides a comprehensive guide on attaching storage volumes to Azure Container Apps, demonstrating both a manual, Microsoft-recommended approach and a more efficient, automated method. Understanding how to persist data is crucial for stateful applications deployed on Container Apps.

## Understanding Storage in Azure Container Apps

Azure Container Apps are designed for microservices and serverless containers. While they excel at stateless workloads, many applications require persistent storage. Attaching a storage volume, typically an Azure File Share, allows your containerized applications to read from and write to a shared, durable storage location.

## Method 1: Microsoft's Recommended Approach (Manual Steps)

This method involves a series of manual steps through the Azure CLI:

1. **Define Variables:** Set up variables for your resource group, location, Container App Environment, Container App name, a globally unique storage account name, storage share name, and storage mount name.
2. **Create Resources:**
    - Create a resource group.
    - Deploy an Azure Storage Account (e.g., using standard LRS).
    - Create a storage share within the account, specifying its size and protocol (SMB is commonly used, as NFS is in preview for Container Apps).
    - Retrieve the storage account key, which is essential for the Container App to authenticate with the storage.
    - Create an Azure Container App environment, which automatically includes a Log Analytics workspace.
3. **Attach File Share to Environment:** Link the created file share to your Container App environment, defining the access mode (read/write or read-only).
4. **Create Container App:** Deploy your container app, configuring its name, environment, image, resources (CPU/RAM), and optionally secrets and environment variables.
5. **Attach Volume to Container App (Manual):** This is the most manual part:
    - Download the container app's configuration as a YAML file using `az containerapp show`.
    - Manually edit this YAML file to add the volume configuration under the `template` section (specifying volume name, type as Azure file), and then link it within the `container` section via a `volumeMounts` entry (with the mount path and the same volume name).
    - Upload the updated YAML file back to Azure using `az containerapp update`.
6. **Test:** Verify the connection by writing a file to the mounted share (e.g., via an Azure DevOps pipeline) and checking its presence in the Azure portal's storage browser.

## Method 2: Automated Approach (The Better Way)

This method streamlines the process by leveraging a comprehensive YAML file for the entire deployment:

1. **Clean Up (Optional):** Delete existing resources to start fresh.
2. **Recreate Environment and Attach Storage:** Create a new Container App environment and attach the storage account to it, similar to the first method.
3. **Create Container App with YAML Configuration:** The key difference here is that when you create the container app, you provide a single YAML file that contains all the configuration, including the volume and share details. This eliminates the need for manual downloading, editing, and re-uploading.
    - The YAML file will include sections for `volumeMounts` (defining the path inside the container, e.g., `/share`) and corresponding `volumes` (specifying the Azure file type and the storage mount name).
4. **Test:** Similar to the first method, test the file share functionality to ensure data persistence.

## Conclusion

While Microsoft provides a step-by-step manual process for attaching storage to Azure Container Apps, the automated approach using a comprehensive YAML file for deployment is significantly more efficient. This method allows for better source control integration, easier automation, and automatic updates without manual intervention, making it the preferred choice for robust and scalable deployments. By understanding these methods, you can effectively manage persistent data for your containerized applications in Azure Container Apps.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Attach%20a%20Volume%20to%20an%20Azure%20Container%20App" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Attach a Volume to an Azure Container App" and reviewed by me.

## Video - Attach a Volume to an Azure Container App

<iframe width="560" height="315" src="https://www.youtube.com/embed/20Xbq4DDluA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>