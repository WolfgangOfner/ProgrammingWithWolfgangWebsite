---
title: Style the Azure Portal your Way
date: 2025-09-01
author: Wolfgang Ofner
categories: [Frontend, Miscellaneous]
tags: [Azure, CSS]
description: Use the open-source browser extension Stylus to change the look of any website, including the Azure Portal.
---

In the world of cloud management, the Azure portal is a daily tool for many. However, its built-in styling options can feel limited, often leaving users with a less-than-ideal visual experience. This post provides a simple, yet powerful solution to this common frustration, allowing you to take control of the Azure portal's appearance and tailor it to your personal preferences.

## The Problem with Azure Portal's Styling

Many users have a "pet peeve" with the current portal design, which is limited to just a "light mode" and a "dark mode." While functional, these themes don't cater to those who prefer a more personalized experience. The light mode can be too bright for some, and even the dark mode may have elements that are uncomfortable on certain monitors.

## The Solution: The Stylus Browser Extension

A simple and effective solution to this problem is a browser extension called Stylus. Available for all major browsers, this open-source tool allows you to inject your own custom CSS onto any website, including the Azure portal. This gives you complete control over the portal's visual appearance, letting you change everything from background colors to font styles.

## Step-by-Step Guide to Customizing Your Portal

- **Install the Stylus Extension:** First, download and install the Stylus extension for your preferred browser.
- **Create a New Style:** Once installed, click the Stylus icon and select "Create a new style." Be sure to specify that this style should apply only to `portal.azure.com`.
- **Inject Your Custom CSS:** Here's where the magic happens. You can write CSS rules to change any element on the page. Use your browser's developer tools (F12) to inspect the specific elements you want to change (e.g., the top bar, the sidebar, text color).
- **Use !important:** To ensure your custom styles override the portal's default styling, you'll need to add the `!important` keyword to your CSS rules.

## Benefits of This Approach

- **Total Customization:** You are no longer limited by the built-in themes. You can create a style that is comfortable and productive for you.
- **Open Source:** The Stylus extension is open-source, giving you transparency and peace of mind. You can find the code on [GitHub](https://github.com/openstyles/stylus).
- **Simple to Use:** The process is straightforward, requiring only a basic understanding of CSS and your browser's developer tools.

## Conclusion

Personalizing a tool you use every day can significantly improve your workflow and overall experience. By leveraging a simple and powerful open-source extension like Stylus, you can transform your Azure portal from a rigid workspace into a comfortable and efficient environment tailored to your exact preferences. This simple trick demonstrates the power of browser extensions to reclaim control over your digital workspace.

You can find all the code sample on <a href="https://github.com/WolfgangOfner/Youtube/tree/main/Style%20the%20Azure%20Portal%20your%20Way" target="_blank" rel="noopener noreferrer">GitHub</a>.

This post was AI-generated based on the transcript of the video "Video - Style the Azure Portal your Way" and reviewed by me.

## Video - Style the Azure Portal your Way

<iframe width="560" height="315" src="https://youtu.be/HkPk8NWu5X0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>