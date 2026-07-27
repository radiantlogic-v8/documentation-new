---
title: v7.4.23 Release Notes
description: v7.4.23 Release Notes
---

# RadiantOne v7.4.23 Release Notes

July 16, 2026

> [!WARNING]
> **Installers for Identity Data Management 7.4.22 and 7.4.23 have been removed.**
>
> If you are looking for the features introduced in either of these releases, we strongly recommend upgrading to Identity Data Management **7.4.24** instead.
>
> For additional information, including the reason for this change and any required actions, please refer to the [customer advisory document](./customer-advisory-document). 


These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)
* [Security Vulnerability Fixes](#security-vulnerability-fixes)
* [Critical Bug Fixes](#critical-bug-fixes)
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

- [IV4-720]: Fix to address: CVE-2026-54512, CVE-2026-54513, CVE-2026-44249, CVE-2026-5429, CVE-2026-45416, CVE-2026-50010, and CVE-CVE-2026-42198.


## Improvements

- [IV4-288, SQ-668]: ResyncUtil now generates ADD and DELETE operations by default for multi-valued attributes instead of REPLACE operations. An optional flag `-r true` allows switching back to the old REPLACE operation if needed.
- [IV4-628, SQ-1563]: Additional validation has been added when deleting a Global Identity Builder project.
- [IV4-712, SQ-1631]: Entra ID (mgraphclient) data sources now allow a "Graph API Filter" option that can be set on content/container nodes. This allows filtering of users/groups and other objects. 
- [IV4-717]: Added the Catalog name field to the extract database wizard in schema editor.


## Bug Fixes

- [IV4-676, SQ-1637]: Fixed an issue with the incorrect filter behavior when the attribute value contains special symbols.
- [IV4-686, SQ-1684]: Fixed an issue where the hierarchy builder was causing it to throw a NullPointerException.
- [IV4-687, SQ-1688]: Fixed an issue in Global Sync where change detection for Entra group topologies only exposed a generic memberdelta attribute, without indicating which members were added versus removed.
- [IV4-711, SQ-1705]: Fixed a memory leak affecting real-time caches that leverage HDAP triggers, related to changes that are refreshed from a single directory store exposing several object types (one aggregation/join per object class), similar to how Global Identity Builder generates the global profile view. On busy systems the affected process could grow in memory over time. Memory is now released correctly; no configuration change is required.
- [IV4-715, SQ-1712]: Fixed an issue by adding input validation to the vdsconfig data source commands so that failover inputs are validated.
- [IV4-721, SQ-1695]: Fixed an issue where inter-cluster replication would throw an NPE.
- [IV4-722, SQ-1715]: Fixed an issue where the internal IDDM LDAP control (OID 9.9.999.412.1.1.422) was incorrectly forwarded to downstream LDAP proxy backends.

## Known Issues/Important Notes

- CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18 tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at `/radiantone/<version>/<clusterName>/config/vds_server.conf`

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click: [Radiant Logic Downloads](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)

Once logged in, navigate to: `Customer Downloads/update_installers/7.4/<PatchVersion>/`

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
