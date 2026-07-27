---
title: v7.4.24 Release Notes
description: v7.4.24 Release Notes
---
# RadiantOne v7.4.24 Release Notes

July 27, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)
* [Security Vulnerability Fixes](#security-vulnerability-fixes)
* [Critical Bug Fixes](#critical-bug-fixes)
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

- [IV4-738]: Fix to address CVE-2026-49844.


## Critical-Bug-Fixes

- [IV4-736, SQ-1769]: Fixed a regression introduced in IDDM 7.4.22 that could cause Active Directory proxy cache initialization to fail or complete with only a subset of the backend entries. The regression could also result in incomplete or failed periodic cache refreshes. 

> [!note] We strongly recommend that customers running versions 7.4.22 or 7.4.23 with Active Directory caches as part of their Directory Namespace configuration upgrade to version 7.4.24 as soon as possible. Refer to our [customer advisory document](./customer-advisory-document) for more details regarding this item.

## Known Issues/Important Notes

- This version contains a fix for an important regression that was introduced in RadiantOne Identity Data Management (IDDM) versions 7.4.22 and 7.4.23. We strongly recommend all customers with persistent caches on Active Directory to upgrade to v7.4.24 at their earliest convenience. This regression affects cache initialization and periodic cache refresh operations on cached LDAP proxies connected to Microsoft Active Directory. The issue occurs when IDDM initializes its cache. To do this, it must use Active Directory range retrieval queries to retrieve all values of a large multi-valued attribute for any entry. Depending on the affected configuration, cache initialization or periodic refresh may fail, stop progressing, or complete with incomplete data. 

- CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18 tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at /radiantone/<version>/<clusterName>/config/vds_server.conf

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
