---
title: RadiantOne IDDM v8.5.4 Release Notes
description: RadiantOne IDDM v8.5.4 Release Notes
---

# RadiantOne Identity Data Management v8.5.4 Release Notes

September 23, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.4

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Security Vulnerability Fixes
 
- [API-4852]: Fix to address: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-84961, CVE-2026-85152, CVE-2026-10050, CVE-2026-18149, CVE-2026-19203, CVE-2026-19534, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59295, CVE-2026-59296, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-68497, CVE-2026-78254, CVE-2026-84292, CVE-2026-84394, CVE-2026-84445, CVE-2026-84890, CVE-2026-84933, CVE-2026-85014, CVE-2026-85024, CVE-2026-85091, CVE-2026-87776, CVE-2026-87795, CVE-2026-87823, CVE-2026-87824, CVE-2026-87825, CVE-2026-87877, CVE-2026-90560, CVE-2026-93748, and CVE-2026-93750.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)

## Improvements

- [API-4805]: The Clustermonitor setting and the Server Control Panel Dashboard graphs it feeds are deprecated and hidden from the classic Control Panel with the other retired components, because the store makes the leader poll the administrative port of every node every few seconds; FID logs a deprecation warning at startup while the store is still enabled.
- [API-4834, SQ-1812]:Entra ID users can now return optional "risky user" attributes and "fido2AuthenticationMethod" attributes. For details see https://learn.microsoft.com/en-us/graph/api/resources/riskyuser?view=graph-rest-1.0 and https://learn.microsoft.com/en-us/graph/api/resources/fido2authenticationmethod?view=graph-rest-1.0
- [API-4840, SQ-1631]: Entra ID (mgraphclient) data sources now allow a "Graph API Filter" option that can be set on content/container nodes. This allows filtering of users/groups and other objects.

## Bug Fixes

- [API-4837, SQ-1812]: Fixed an issue where the Microsoft Entra ID connector ignored the attribute list a caller requested and decided what to retrieve from the view's full attribute list instead. 
- [API-4847]: Fixed an issue with an empty merged link base DN.
- [API-4843]: Fixed an issue where the file manager could not access the vds_server/conf/data_sources/csv folder.


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
