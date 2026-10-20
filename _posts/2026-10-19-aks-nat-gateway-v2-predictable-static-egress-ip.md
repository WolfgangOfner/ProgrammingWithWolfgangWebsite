---
title: AKS + NAT Gateway v2 - Predictable, Static Egress IPs
date: 2026-10-19
author: Wolfgang Ofner
categories: [Youtube, Kubernetes, Cloud]
tags: [Azure, AKS, NAT Gateway]
description: Control AKS cluster egress with NAT Gateway v2 for predictable static IP addresses, zone redundancy, and seamless external firewall whitelisting.
---

Managing outbound internet traffic from a Kubernetes cluster is crucial when applications need to communicate with external APIs protected by strict firewalls. By default, Azure Kubernetes Service relies on a standard Azure load balancer for egress, which offers limited control over outgoing public IP addresses and can lead to SNAT port exhaustion under heavy workloads. Integrating Azure NAT Gateway version two directly into your cluster architecture provides predictable, static egress IP addresses and enhanced reliability.

## Why Use NAT Gateway v2 for AKS

Traditional load balancer egress configurations lack granular scaling and zone distribution control for outbound traffic. NAT Gateway version two introduces several powerful enhancements tailored for enterprise production workloads:

* **Zone Redundancy:** Automatically distributes across availability zones one, two, and three without manual configuration, increasing resilience against regional infrastructure failures.
* **Predictable Static IPs:** Assign dedicated static public IP addresses so external third-party services can easily whitelist your cluster traffic.
* **Higher Limits and Performance:** Supports double the bandwidth (up to 100 Gbits per second) and increased packet limits per connection, preventing SNAT port exhaustion in busy, chatty clusters.
* **Expanded Protocol Support:** Includes native support for ICMP ping and IPv6 alongside standard IPv4 traffic.

## Architecture and Configuration Workflow

Setting up a cluster with NAT Gateway v2 involves a straightforward infrastructure workflow using the Azure CLI:

1. **Extension and Preview Registration:** Update the AKS preview extension for the Azure CLI and register the managed NAT Gateway version two preview feature to enable the required CLI parameters.
2. **Public IP Provisioning:** Create a standard static zone-redundant public IP address in your target resource group and capture its resource ID.
3. **Cluster Creation:** Provision the AKS cluster by specifying the outbound type as managed NAT Gateway version two, attaching your pre-created static public IP address.
4. **Validation:** Deploy a lightweight testing pod inside a dedicated namespace and execute external IP check commands to verify that outgoing traffic matches your assigned static egress IP.

## Step-by-Step Implementation Guide

### 1. Register Preview Features and CLI Extensions
Before provisioning resources while the feature is in preview, update your Azure CLI AKS extension and register the NAT Gateway version two preview feature namespace. Verify that the registration status shows as registered before proceeding to cluster creation.

### 2. Create a Zone-Redundant Static Public IP Address
Provision a standard V2 static public IP address configured for zone redundancy across availability zones one, two, and three. Capture the resource ID of this public IP to link it directly during your cluster deployment.

### 3. Deploy the AKS Cluster with NAT Gateway v2
Create your AKS cluster specifying the outbound type parameter for managed NAT Gateway version two and passing your static public IP resource ID. This ensures Azure automatically provisions and attaches the NAT Gateway infrastructure during cluster creation.

### 4. Verify Egress IP Adherence
Deploy a temporary testing container image inside your cluster and run a remote IP lookup command against an external endpoint service. Confirm that the returned public IP matches the static IP address assigned to your NAT Gateway configuration, validating that external firewalls will correctly recognize your cluster traffic.

## Summary

Integrating Azure NAT Gateway version two with Azure Kubernetes Service eliminates the uncertainty of default load balancer egress. By establishing predictable static IP addresses and leveraging native zone redundancy, platform engineers can securely connect cluster workloads to external APIs while maintaining strict firewall whitelisting standards.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/AKS%20%2B%20NAT%20Gateway%20v2%20-%20Predictable%2C%20Static%20Egress%20IPs">GitHub</a>.

This post was AI-generated based on the transcript of the video "AKS + NAT Gateway v2 - Predictable, Static Egress IPs".

## Video - AKS + NAT Gateway v2 - Predictable, Static Egress IPs

<iframe width="560" height="315" src="https://www.youtube.com/embed/yuQUSF15VLg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>