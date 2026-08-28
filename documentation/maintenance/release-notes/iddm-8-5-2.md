---
title: RadiantOne IDDM v8.5.2 Release Notes
description: RadiantOne IDDM v8.5.2 Release Notes
---

# RadiantOne Identity Data Management v8.5.2 Release Notes

August 28, 2026
These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.2
These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)
[Bug Fixes](#bug-fixes)
[Known Issues](#known-issues)
[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Security Vulnerability Fixes

- [API-4783]: Fix to address the following CVEs: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-75595, CVE-2026-10050, CVE-2026-47842, CVE-2026-47857, CVE-2026-47863, CVE-2026-47874, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-59903, CVE-2026-62243, CVE-2026-73088, CVE-2026-73089, CVE-2025-11143, CVE-2026-6790, CVE-2026-47843, CVE-2026-47845, CVE-2026-47856, CVE-2026-47883, CVE-2026-47887, CVE-2026-47888, CVE-2026-47890, CVE-2026-47891, CVE-2026-47892, CVE-2026-59292, CVE-2026-59314, CVE-2026-64607, CVE-2026-14456, CVE-2026-33818, CVE-2026-38752, CVE-2026-38753, CVE-2026-38754, CVE-2026-38755, CVE-2026-39821, CVE-2026-46600, CVE-2026-47848, CVE-2026-47893, CVE-2026-56853, CVE-2026-56858, CVE-2026-56859, CVE-2026-56860, CVE-2026-56862, CVE-2026-59313, CVE-2026-75899, CVE-2026-76172, CVE-2026-75975 and CVE-2026-75931.

## Bug Fixes

- [API-4478, SQ-1811]: Fixed an issue where large file uploads up to 1 GB were not successful.
- [API-4761, SQ-1799]: Fixed a timeout issue in configuration promotion process for big configurations.
- [API-4788]: Fixed an issue where SHA2 hash algorithm SSHA384 was not working due to the introduction of SHA3.
- [API-4793,SQ-1843]: Fixed an issue with a move or rename on an HDAP store that put the whole RDN into the first attribute when the entry had a multi-valued RDN like cn=Sam+uid=sammy. Renaming now removes just the old RDN value instead of the whole attribute, so other values on that attribute are kept.

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
