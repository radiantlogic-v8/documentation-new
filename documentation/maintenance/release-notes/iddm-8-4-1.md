---
title: RadiantOne IDDM v8.4.1 Release Notes
description: RadiantOne IDDM v8.4.1 Release Notes
---

# RadiantOne Identity Data Management v8.4.1 Release Notes

May 7, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.4.1

These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Security Vulnerability Fixes

This hotfix updates our container images and third‑party libraries to remediate multiple security vulnerabilities, including several high‑ and critical‑severity CVEs. It does not introduce new features or functional changes and is recommended for all customers to improve overall security posture.

- [API-4410]: Fix to address CVE-2026-22752,CVE-2026-40972,CVE-2026-40973 and CVE-2026-22740.
- [API-4432]: Fix to address: CE-2026-42035, CVE-2026-42039, CVE-2026-42044 and CVE-2026-42033.
- [API-4433]: Fix to address: CVE-2025-14813 and CVE-2026-5598.
- [API-4438]: Fix to address: CVE-2026-33558.
- [API-4439]: Fix to address: CVE-2025-66566.
- [API-4441]: Fix to address: CVE-2025-8671.

## Bug Fixes

- [API-4423]: Fixed an issue when creating a proxy using a data source on Identity Data Management v8.4.0 and configuring failover LDAP servers, clicking "Test Connection" reports a connection failure. The proxy itself is functional and browsable in the Directory Browser despite the error.
  
## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4419]: Creating a custom password policy can unintentionally overwrite the "Dictionary Matching Mode" setting on the Default Policy. For example, if the Default Policy has "Dictionary Matching Mode" set to "Contains Match," creating a new custom policy without enabling dictionary check resets the Default Policy's mode to "Exact Match."

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.

- [API-4421]: After creating an Identity Data Management application using a migration export from v7.4.21, Rule Sets for Rules-Based Transformations are not displayed in the pipeline UI, even though the underlying `.java` code is present. 

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
