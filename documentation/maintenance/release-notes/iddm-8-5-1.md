---
title: RadiantOne IDDM v8.5.1 Release Notes
description: RadiantOne IDDM v8.5.1 Release Notes
---

# RadiantOne Identity Data Management v8.5.1 Release Notes

August 14, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.1

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-4753, SQ-1095, SQ-1758]: The resource-export command now supports a new --direct-chain option for naming-context exports. When enabled, the export bundle contains only the requested naming context (and everything beneath it) plus the minimal parent branch needed, excluding unrelated sibling branches and trimming parent virtual-tree files, which makes it easier to move a single branch between environments without bringing the entire tree.
 


## Security Vulnerability Fixes

- [API-4747]: Fix to address: CVE-2026-14257.
- [API-4764]: Fix to address: CVE-2026-2332, CVE-2026-8763, CVE-2026-59650, CVE-2026-58062, CVE-2026-59949, CVE-2026-59639, CVE-2026-59642, CVE-2026-12802, CVE-2026-59651, CVE-2026-12185, CVE-2026-58059, CVE-2026-14682, CVE-2026-13506, CVE-2026-12860, CVE-2026-58060, CVE-2026-12816, CVE-2026-58061, CVE-2026-12803, CVE-2026-59645, CVE-2026-10050, CVE-2026-8798, CVE-2026-13505, CVE-2026-13149, CVE-2026-33750, CVE-2026-69152, CVE-2026-18446, CVE-2026-16221, CVE-2026-13676, CVE-2025-11143, CVE-2026-15055, CVE-2026-13586, CVE-2026-59647, CVE-2026-58063, CVE-2026-6790, CVE-2026-54272, CVE-2026-69198, CVE-2026-69192, CVE-2026-16728, CVE-2026-16729, CVE-2026-56850, CVE-2026-15157, CVE-2026-45186, CVE-2026-7383, CVE-2026-9076, CVE-2026-34180 and CVE-2026-45447.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)


## Bug Fixes

- [API-3492, SQ-875]: Fixed an issue where password policy wasn't honoring the stronger algorithm upgrade for persistent cached views that were being used for authentication.
- [API-3896, SQ-1113]: Fixed an issue where an inter-cluster replication thread gets stuck due to an invalid operation DN.
- [API-4412]: Fixed an issue so that remapping attributes used in computed attribute expressions are now properly remapped in the expressions.
- [API-4741, SQ-1454]: Fixed an issue that could occur if a mixed-case view (DVX file) was uploaded through File Manager.
- [API-4751, SQ-1781]: Fixed an access control issue in the search API: read-only users were unable to use search because the required SCOPE_DIRECTORY_BROWSER_VIEW permission was missing. The scope has now been added, enabling read-only users to access search functionality correctly.


## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
- Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.
- In v8.5.X, enabling Password Policy Enforcement automatically enables Local Bind Only, but does not automatically add the userPassword attribute extension to Attribute Handling. As a workaround, the userPassword attribute extension must be added manually to Attribute Handling configuration.


For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues
## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
