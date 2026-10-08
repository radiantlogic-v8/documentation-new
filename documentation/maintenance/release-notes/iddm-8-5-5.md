---
title: RadiantOne IDDM v8.5.5 Release Notes
description: RadiantOne IDDM v8.5.5 Release Notes
---

# RadiantOne Identity Data Management v8.5.5 Release Notes

October 7, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.5

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes
 
- [API-4861]: Fix to address: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-59969, CVE-2026-10050, CVE-2026-101898, CVE-2026-101901, CVE-2026-101903, CVE-2026-101905, CVE-2026-101906, CVE-2026-101907, CVE-2026-101909, CVE-2026-102276, CVE-2026-102278, CVE-2026-18036, CVE-2026-19203, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-71891, CVE-2026-84439, CVE-2026-8942, and CVE-2026-91777.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)


## Improvements

- [API-4752, SQ-1798]: Improved resiliency of global sync processing by preventing a processing node from silently halting event handling, which could previously cause queues to accumulate until the node was restarted.
- [API-4842, SQ-1943]: Added a performance improvement that makes ResyncUtil skip entries that were not modified after cluster disconnection, thus reducing the number of entries to process.


## Bug Fixes

- [API-4851, SQ-1404]: Fixed an issue where updates on follower nodes via client connecting over Kerberos or using certificate based authentication are failing.
- [API-4864, SQ-1968]: Fixed an issue in which large numbers of searches with timelimits could potentially exhaust the system's threads.
- [API-4866, SQ-1979]: Fixed an issue that caused join computed attributes to be lost on object builder save.


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
