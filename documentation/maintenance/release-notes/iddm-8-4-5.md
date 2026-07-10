---
title: RadiantOne IDDM v8.4.5 Release Notes
description: RadiantOne IDDM v8.4.5 Release Notes
---

# RadiantOne Identity Data Management v8.4.5 Release Notes

July 9, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.4.5.

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes

- [API-4674]: Fix to address: CVE-2026-54512, CVE-2026-54513, CVE-2026-54514, CVE-2026-54516, CVE-2026-54517, CVE-2026-54518, CVE-2026-13006, CVE-2026-9828, CVE-2026-55955, CVE-2026-53434, CVE-2026-53404, CVE-2026-55276, CVE-2026-55956.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)

## Bug Fixes

- [API-4682]: Fixed an issue with Entra ID where all calls were being routed to the SDC service.


## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
-Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
