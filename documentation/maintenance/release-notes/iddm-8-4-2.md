---
title: RadiantOne IDDM v8.4.2 Release Notes
description: RadiantOne IDDM v8.4.2 Release Notes
---

# RadiantOne Identity Data Management v8.4.2 Release Notes

May 21, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.4.2

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements
- [API-4470, SQ-1491]: Improved compatibility with Salesforce SCIM servers to support more reliable connectivity.


## Security Vulnerability Fixes


- [API-4435]: Fix to address: CVE-2026-41675,CVE-2026-41674,CVE-2026-41672 and CVE-2026-41673. 
- [API-4460]: Fix to address: CVE-2026-40895.
- [API-4461]: Fix to address: CVE-2026-42583, CVE-2026-42587, CVE-2026-42577, CVE-2026-42579.
- [API-4462]: Fix to address: CVE-2026-41907.
- [API-4463]: Fix to address: CVE-2026-33532.
- [API-4480]: Fix to address: CVE-2026-34480 and CVE-2026-34477.
- [API-4481]: Fix to address: CVE‑2025‑5115.
- [API-4484]: Fix to address: CVE-2026-41284.

## Bug Fixes

- [API-4350, SQ-1370]: Fixed an issue that addresses the directory browser search error when using preprocessing filter that filters out parent entries.
- [API-4388, SQ-1430]: Fixed an issue where users can now login to IDDM without requiring the objectClass=person attribute.
- [API-4419]: Fixed an issue in Password Policies where “Dictionary Matching Mode” was overwritten when creating a new policy. The new policy form is now populated with the correct “Dictionary Matching Mode” value during creation.
- [API-4476]: Fixed an issue that caused interception scripts to fail to load.
- [API-4523]: Fixed an issue where saving active director connector properties was throwing an error.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.

- [API-4421]: After creating an Identity Data Management application using a migration export from v7.4.21, Rule Sets for Rules-Based Transformations are not displayed in the pipeline UI, even though the underlying `.java` code is present. 


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
