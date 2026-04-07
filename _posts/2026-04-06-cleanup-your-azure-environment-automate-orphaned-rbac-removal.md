---
title: Clean Up Your Azure Environment - Automate Orphaned RBAC Removal
date: 2026-04-06
author: Wolfgang Ofner
categories: [Youtube, Cloud]
tags: [Azure, Automation Account, PowerShell]
description: Learn how to automate the removal of orphaned Azure role assignments ("Identity not found") using Azure Automation, PowerShell, and Managed Identities
---

Maintaining a clean Azure environment is essential for security, compliance, and staying within subscription limits. Over time, as users are removed or managed identities are deleted, their role assignments often linger as "Identity not found" or "Unknown" entries. This "spring housekeeping" is a vital task for any platform engineer.

## Why Clean Up Orphaned Roles?

While an orphaned role assignment might seem harmless since the identity it points to no longer exists, there are several compelling reasons to keep your IAM blade tidy:

* **Reduce Attack Surface:** Although Entra ID uses unique identifiers, keeping legacy permissions around is a poor security practice that can lead to identity overlap issues.
* **Subscription Limits:** Azure has a hard limit of 4,000 role assignments per subscription. Orphaned roles count toward this limit, and in large environments, you can hit this ceiling faster than expected.
* **Audit Readiness:** Auditors often view a high number of "Identity not found" entries as a red flag, indicating an immature identity lifecycle management process.
* **Operational Performance:** A massive number of role assignments can slow down the loading time of the Azure Portal and impact the latency of security API queries.

## Identifying and Removing the "Ghosts"

The process involves identifying entries where the display name or sign-in name is null or empty. While this can be done manually for a quick check, it is far more efficient to handle this through automation—especially if you regularly create and destroy resources for demos or development.

By using an Azure Automation account with a System-Assigned Managed Identity, you can create a "set it and forget it" workflow. This allows the environment to periodically scan itself and remove any role bindings that no longer point to a valid object.

## The Critical Lesson: Entra ID Permissions

A major pitfall when automating this cleanup is the level of visibility the automation identity has. To determine if a role assignment is truly "orphaned," the script must be able to check the directory. 

If the Managed Identity does not have the **Directory Reader** role in Microsoft Entra ID, it may fail to resolve valid users and mistakenly flag every single role assignment for deletion. This could lead to accidentally locking everyone out of a subscription. Always ensure your automation tools have the proper read permissions in the directory to distinguish between a "ghost" and a legitimate user.

## Conclusion

Automating your Azure housekeeping ensures your environment remains secure, lean, and compliant. Whether you run a cleanup manually after a large project or schedule it to run monthly, it is a powerful way to maintain professional standards in your cloud infrastructure.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Clean%20Up%20Your%20Azure%20Environment%20-%20Automate%20Orphaned%20RBAC%20Removal">GitHub</a>.

This post was AI-generated based on the transcript of the video "Clean Up Your Azure Environment - Automate Orphaned RBAC Removal".

## Video - Clean Up Your Azure Environment - Automate Orphaned RBAC Removal

<iframe width="560" height="315" src="https://www.youtube.com/embed/nAARvP2GmB4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>