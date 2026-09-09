---
title: RadiantOne IDDM v8.5.3 Release Notes
description: RadiantOne IDDM v8.5.3 Release Notes
---

# RadiantOne Identity Data Management v8.5.3 Release Notes

September 9, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.3

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes
 
- [API-4813]: Fix to address: CVE-2025-11143, CVE-2026-2332, CVE-2026-6790, CVE-2026-10050, CVE-2026-14456, CVE-2026-41707, CVE-2026-47842, CVE-2026-47843, CVE-2026-47845, CVE-2026-47848, CVE-2026-47856, CVE-2026-47857, CVE-2026-47863, CVE-2026-47874, CVE-2026-47879, CVE-2026-47883, CVE-2026-47884, CVE-2026-47885, CVE-2026-47886, CVE-2026-47887, CVE-2026-47888, CVE-2026-47889, CVE-2026-47890, CVE-2026-47891, CVE-2026-47892, CVE-2026-47893, CVE-2026-53666, CVE-2026-53669, CVE-2026-54399, CVE-2026-54428, CVE-2026-54876, CVE-2026-55856, CVE-2026-55857, CVE-2026-55858, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59292, CVE-2026-59313, CVE-2026-59314, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-64607, CVE-2026-71290, CVE-2026-84304, CVE-2026-84375.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)

## Improvements

- [API-4809]: Added missing additional clause tab for configuration parameters modal under Advanced Settings for content nodes in Control Panel > Directory Namespace.
- [API-4814]: Hardened the SSO OIDC login into the control panel when Google is used as the IDP.

## Bug Fixes

- [API-4773, SQ-1815]: Fixed an issue where a restarted node during rolling cluster restarts could misdetect missing queued changes, causing recovery delays, change-queue timeouts, and excessive warning logs.
- [API-4801]: Added cursor-epoch-ms as an internal, operational attribute reserved for Radiant Logic's usage to address failures when schema checking is enabled for RadiantOne Directory stores.
- [API-4803]: Fixed an issue so logging now redacts individual sensitive values by field name instead of reshaping the payload. Secrets in JSON and form bodies, headers, query strings, and URL fragments are replaced with XXXX, and JSON Web Tokens are detected and masked wherever they appear. All remaining content is logged unchanged, so diagnostic payloads stay complete and readable while no credentials are written to the logs.
- [API-4804]: Fixed an issue where merge links now allow updating the connection string base DN.
- [API-4806]: Fixed an issue where the LDAP content node parent DN setting can now be set to empty.




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
