---
title: RadiantOne IDDM v8.5.6 Release Notes
description: RadiantOne IDDM v8.5.6 Release Notes
---

# RadiantOne Identity Data Management v8.5.6 Release Notes

October 22, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.6

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes
 
- [API-4860]: Fix to address: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-76183, CVE-2026-100351, CVE-2026-10050, CVE-2026-19203, CVE-2026-45820, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-79677, CVE-2026-90559, CVE-2026-93452, CVE-2026-93687, CVE-2026-100353, CVE-2026-100354, CVE-2026-102554, CVE-2026-106450, CVE-2026-106451, CVE-2026-107314, CVE-2026-108106, CVE-2026-112366.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)

## Improvements

- [API-4871]:Updated to OpenJDK 1.8.0_504.
- [API-4886, SQ-2029]:The cache init screen allows users to select existing .ldif/ldifz files from subfolders of the LDIF folder and files on any cluster node.


## Bug Fixes

- [API-4875]: Fixed an issue where the directory browser LDIF import (import_ldif) ignored directory ACIs and the role's import permissions.
- [API-4880, SQ-2015]: Fixed an issue where adding a naming context with a near-identical name caused a service outage and loss of the original naming context.
- [API-4881, SQ-2019]: Fixed an issue so that now ACIs can be created on nodes excluded by a preprocessing filter.



## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
-Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.

- [V9-517]: Large file uploads greater than 1 GB are inconsistent.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
