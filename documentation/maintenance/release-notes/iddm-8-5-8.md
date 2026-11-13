---
title: RadiantOne IDDM v8.5.8 Release Notes
description: RadiantOne IDDM v8.5.8 Release Notes
---

# RadiantOne Identity Data Management v8.5.8 Release Notes

November 13, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.8

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Security Vulnerability Fixes
 
- [INT]: Critical vulnerability fix to improve the security of communication between nodes.
- [API-4918]: Fix to address: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-10050, CVE-2026-19203, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322 and CVE-2026-59324.

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
