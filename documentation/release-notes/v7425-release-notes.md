---
title: v7.4.25 Release Notes
description: v7.4.25 Release Notes
---

# RadiantOne v7.4.25 Release Notes

August 24, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)

* [Security Vulnerability Fixes](#security-vulnerability-fixes)

* [Improvements](#improvements)

* [Bug Fixes](#bug-fixes)

* [Known Issues/Important Notes](#known-issuesimportant-notes)

* [Patch Installers](#patch-installers)

* [How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-   Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022
-   Windows Servers Core
-   Red Hat Enterprise Linux v5+
-   Fedora v24+
-   CentOS v7+
-   SUSE Linux Enterprise v11+
-   Ubuntu 16+
-   Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide. 

## Security-Vulnerability-Fixes

- [IV4-756, SQ-1778]: Fix to address: CVE-2026-60147. Updated JDK to Corretto 8.502.07.1.
- [IV4-761]: Fix to address: CVE-2026-10050, CVE-2026-6790, CVE-2026-59901, CVE-2026-8763, CVE-2026-59650, CVE-2026-58062, CVE-2026-58060, CVE-2026-14682, CVE-2026-12860, CVE-2026-58061, CVE-2026-13506, CVE-2026-58059, CVE-2026-12816, CVE-2026-12803, CVE-2026-59651 and CVE-2026-1218. 

## Improvements

- [IV4-763, SQ-1144]: Added the following de-obfuscated method to determine leadership in custom tasks: ScriptHelper.isCurrentNodeLeader. 

## Bug Fixes

- [IV4-760]: Fixed a performance issue in the Microsoft Entra ID (Azure AD) connector where retrieving very large groups could take an excessive amount of time to return — up to several hours for groups with very large membership. Such groups are now processed efficiently and returned in seconds.
- [IV4-765, SQ-1815]: Fixed an issue where a restarted node during rolling cluster restarts could misdetect missing queued changes, causing recovery delays, change-queue timeouts, and excessive warning logs.

## Known Issues/Important Notes

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
