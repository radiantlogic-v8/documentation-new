---
title: RadiantOne IDDM v9.0.1 Release Notes
description: RadiantOne IDDM v9.0.1 Release Notes
---

# RadiantOne Identity Data Management v9.0.1 Release Notes

October 15, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v9.0.1

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)



## Security Vulnerability Fixes
 
- [V9-670]: Fix to address: CVE-2025-22228, CVE-2026-2332, CVE-2026-22732, CVE-2026-41707, CVE-2026-47304, CVE-2026-47884, CVE-2026-59270, CVE-2026-59969, CVE-2026-76183, CVE-2024-38816, CVE-2024-38819, CVE-2025-41242, CVE-2025-41249, CVE-2026-18036, CVE-2026-19203, CVE-2026-22737, CVE-2026-22740, CVE-2026-41720, CVE-2026-41841, CVE-2026-41842, CVE-2026-41843, CVE-2026-41849, CVE-2026-41850, CVE-2026-41851, CVE-2026-47302, CVE-2026-47838, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-50525, CVE-2026-50648, CVE-2026-59276, CVE-2026-59280, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-71891, CVE-2026-78254, CVE-2026-84439, CVE-2026-85091, CVE-2026-87795, CVE-2026-87823, CVE-2026-87824, CVE-2026-87825, CVE-2026-87877, CVE-2026-89425, CVE-2026-90559, CVE-2026-90560, CVE-2026-91777, CVE-2026-93452, CVE-2026-93491, CVE-2026-93687, CVE-2026-100660, CVE-2026-100661, CVE-2026-100662, CVE-2026-100663, CVE-2026-100664, CVE-2026-100665, CVE-2026-101898, CVE-2026-101901, CVE-2026-101903, CVE-2026-101905, CVE-2026-101906, CVE-2026-101907, CVE-2026-101909, CVE-2026-102276, CVE-2026-102278, CVE-2026-102554, CVE-2026-106450, CVE-2026-106451, CVE-2026-107314, CVE-2026-108106.

## Improvements

- [V9-548]: Schema manager allows users to edit the base DN on the root node for LDAP data source schemas.
- [V9-648, SQ-1218]: Added the ability to trigger a synchronize cached entry or cache delta refresh from the directory browser or directory namespace screens in the UI.
- [V9-732]: Updated to OpenJDK 25.0.4.1.

## Bug Fixes

- [V9-463, SQ-1812]: Fixed an issue where the Microsoft Entra ID connector ignored the attribute list a caller requested and decided what to retrieve from the view's full attribute list instead.
- [V9-466]: Fixed an issue where the password policy enforcement did not automatically add the userPassword attribute extension to Attribute Handling.
- [V9-546]: Fixed an issue where merge links now allow updating the connection string base DN.
- [V9-672, SQ-1968]: Fixed an issue in which large numbers of searches with timelimits could potentially exhaust the system's threads.
- [V9-697, SQ-1979 ]: Fixed an issue that caused join computed attributes to be lost on object builder save.
- [V9-719]: Fixed an issue with directory browser entries; you no longer have to click a result twice.
- [V9-739]: Fixed an issue where the directory browser LDIF import (import_ldif) ignored directory ACIs and the role's import permissions.


## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [V9-517]: Large file uploads greater than 1 GB are inconsistent.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
