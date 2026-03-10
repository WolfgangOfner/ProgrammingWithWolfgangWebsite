---
title: Gateway API for Kubernetes Series Recap - Part 20
date: 2026-03-09
author: Wolfgang Ofner
categories: [Kubernetes, DevOps]
tags: [Azure, AKS, Kubernetes, Gateway API, Azure DevOps, CI-CD, Cert-Manager, Pull Request, Envoy Gateway API, Nginx, Traefik]
description: Recap the finale of my 19-part Kubernetes Gateway API series on AKS. I cover AGFC to Envoy while testing a failed AI script experiment. Check it out now!
---

After 19 deep-dive videos, we have finally reached the finish line of the **Kubernetes Gateway API** series. This journey grew from an original plan of 13 videos into a comprehensive 19-part masterclass on modern traffic management in AKS. 

To celebrate the finale, I decided to try something a bit different with the production.

## The Experiment: Teleprompters and AI Hallucinations

For this video, I used a teleprompter for the first time to improve my delivery and stay focused on the camera. To make the process even more "efficient," I asked Gemini (AI) to draft the script based on the transcripts of the previous 19 videos.

**The result? A complete reality check.**

While the teleprompter worked well after a few minutes of getting used to it, the AI-generated script was a disaster. It hallucinated new titles, made up technical features I never discussed, and even confused the final architecture—claiming I used AGFC in Part 19 when I actually used the Envoy Gateway. 

I decided to leave these mistakes in the video and point them out as they happen. It’s a great example of why AI isn't quite ready to replace human technical expertise just yet.

## Series Recap: 19 Parts in Review

If you missed any part of the series, here is the high-level roadmap of what we built:

| Section | Parts | Key Focus |
| :--- | :--- | :--- |
| **Foundations** | 1 - 3 | Moving beyond Ingress, AGFC setup, and multi-tenancy. |
| **DNS & Security** | 4 - 6 | Automating Azure DNS and TLS certificates with Cert-Manager. |
| **DevOps Workflows** | 7 - 10 | Dynamic PR environments, advanced routing, and Canary releases. |
| **Operations** | 11 - 12 | Monitoring with Prometheus/Grafana and WAF protection. |
| **Implementations** | 13 - 16 | Comparing NGINX, Traefik, and Envoy Gateway (my top pick). |
| **Migration & CI/CD** | 17 - 19 | Migrating from legacy Ingress to production-ready DevOps pipelines. |

## The Verdict

The **Kubernetes Gateway API** is a game-changer for anyone working with AKS. It provides the modularity and separation of concerns that Ingress simply couldn't offer. 

As for the AI experiment? I think I’ll be sticking to writing my own scripts from now on. If I decide to use the prompter again, I will ensure the words are 100% my own to maintain the technical accuracy you expect from this channel.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Gateway%20API%20for%20Kubernetes%20Series%20Recap%20-%20Part%2020">GitHub</a>.

This post was AI-generated based on the transcript of the video "Gateway API for Kubernetes Series Recap - Part 20".

## Video - Gateway API for Kubernetes Series Recap - Part 20

<iframe width="560" height="315" src="https://www.youtube.com/embed/Y11sFkvmHnY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>