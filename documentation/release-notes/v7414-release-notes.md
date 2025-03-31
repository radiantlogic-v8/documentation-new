---
title: v7.4.14 Release Notes
description: v7.4.14 Release Notes
---

# RadiantOne v7.4.14 Release Notes

March 28, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Supported Platforms](#supported-platforms)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Critical Bug Fixes](#critical-bug-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022

-	Windows Servers Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

-	Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, please see: [https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/](https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/)

## Security Vulnerability Fixes

-	[VSTS47427]: Updated ZooKeeper Netty libraries to address CVE-2025-24970.

## Critical Bug Fixes

-	[VSTS47392]: Fixed an issue where a client could issue an LDAP search request that enumerates entry DNs without being properly authorized. For details, please see the [Support Knowledge Base](https://support.radiantlogic.com/hc/en-us/articles/35748628235540-Bug-that-allows-LDAP-clients-to-search-and-enumerate-entry-DNs-bypassing-ACLs)

## Bug Fixes

-	[VSTS47363]: Fixed an issue where Password Policy Request Control (1.3.6.1.4.1.42.2.27.8.5.1) was rejected when its criticality is set as true in the request.
-	[VSTS47495]: Fixed a regression (in v7.4.13 only) which caused some unwanted LDAP controls to be forwarded to LDAP proxy backends on some LDAP search requests.
-	[VSTS47487]: Fixed a regression where setting the VDS HTTP and HTTPS ports in the settings page was incorrectly setting the control panel HTTP and HTTPS ports.



## Known Issues/Important Notes


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

