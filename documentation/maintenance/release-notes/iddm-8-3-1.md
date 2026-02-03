---
title: RadiantOne IDDM v8.3.1 Release Notes
description: RadiantOne IDDM v8.3.1 Release Notes
---

# RadiantOne Identity Data Management v8.3.1 Release Notes

February 2, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.3.1

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Security Vulnerability Fixes

- [API-4031]: Updated the Race Condition to node 24 to address CVE-2025-55131.
- [API-4033]: Updated the React router to 6.30.3 to address CVE-2025-68470, CVE-2026-22029 and CVE-2025-68470.

## Bug Fixes

- [API-3994]: Fixed an issue where log errors occurred when loading the custom connector built using the IDDM Connector SDK when it included Java 9+ annotations.
- [API-4006]: Fixed issue with Object Builder computed attributes modal not populating the attributes list.
- [API-4011, SQ-1180]: Fixed an issue in which when upgrading from v8.2.2 to v8.3.0 would cause the Global Settings in the Control Panel to be lost and would throw errors on Tasks menu item.
- [API-4014, SQ-1180, SQ-1192]: Fixed an issue seen when logging into the Control Panel with an admin associated with the Directory Administrators group due to large header size related to the sheer size of the JWT tokens. 
- [API-4025, SQ-1189]: Fixed an issue with Global Setting permissions in which when upgrading from v8.2.2 to v8.3.0, when logged in as: uid=superadmin, ou=globalusers, cn=config the token validators were no longer visible in the UI and returned a "data fetching failed" error. 


## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com


If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
