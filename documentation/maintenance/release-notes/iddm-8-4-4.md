---
title: RadiantOne IDDM v8.4.4 Release Notes
description: RadiantOne IDDM v8.4.4 Release Notes
---

# RadiantOne Identity Data Management v8.4.4 Release Notes

June 25, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.4.4

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes

- [API-4632]: Fix to address: CVE-2026-47825, CVE-2026-47838, CVE-2026-41008, CVE-2026-41706, CVE-2026-41001, CVE-2026-40992, CVE-2026-41715, CVE-2026-49356, CVE-2026-12143, CVE-2026-53550, CVE-2026-47825.

>[!note] Full vulnerability report details located here: [Security Vulnerability Report](../vulnerability-report)

## Bug Fixes

- [API-4624, SQ-1637]: Fixed the issue with the incorrect filter behavior when the attribute value contains special symbols.
- [API-4654, SQ-1652]: Fixed an issue where a virtual tree naming context could sometimes display an incorrect data source name if the view/dvx's data source had been directly modified in Context Builder.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
- Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
