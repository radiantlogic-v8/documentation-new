---
title: RadiantOne IDDM v8.5.7 Release Notes
description: RadiantOne IDDM v8.5.7 Release Notes
---

# RadiantOne Identity Data Management v8.5.7 Release Notes

November 5, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.7

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Security Vulnerability Fixes
 
- [API-4892]: Fix to address: CVE-2026-10050, CVE-2026-101296, CVE-2026-101356, CVE-2026-110816, CVE-2026-110879, CVE-2026-111756, CVE-2026-115506, CVE-2026-19203, CVE-2026-2332, CVE-2026-41707, CVE-2026-47842, CVE-2026-47879, CVE-2026-47884, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322 and CVE-2026-59324.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report).


## Improvements

- [API-4896]: Improved the database proxy mount performance by only querying the selected tables instead of all tables.
- [API-4904, SQ-2087]: Fixed the upgrade from 8.5.x to 9.x failing at the HDAP export with IndexNotFoundException when a persistent cache was never initialized; the export now skips these caches and cleans up their folders, so they can be initialized after the upgrade.

## Bug Fixes

- [API-4882, SQ-1997]: Fixed an issue where the Global Identity Builder login analysis no longer stops with a NullPointerException when a global profile entry has no status attribute. This affected the analysis that runs at the end of an upload and the one launched from the Login Analysis page. The entry is now given the status the analysis computed, the rest of the analysis completes, and each such entry is reported in the task log.
- [API-4883, SQ-1994]: Fixed an issue so that now the test connection on a Microsoft Entra ID data source now fails immediately when the application is not found in the directory (AADSTS700016), instead of retrying until the configured number of retries is exhausted. The same error is not retried on a normal read. Other temporary read failures are still retried, and throttled requests are unchanged.
- [API-4889]: Fixed an issue so that now the global sync between two HDAP stores in a cluster now applies changes to entries that already exist in the target store. 
- [API-4891, SQ-1974]: Fixed an issue so that now the object builder allows joins from different secondary data sources with the same objectclass.
- [API-4895]: Fixed an issue where Global Identity Builder pages could fail to load on projects with a large number of identities, by calculating the identity and correlation counts in the background instead of on every page refresh.


## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
- Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.
- [V9-517]: Large file uploads greater than 1 GB are inconsistent.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
