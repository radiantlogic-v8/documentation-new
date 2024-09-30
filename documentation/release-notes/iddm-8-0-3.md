---
title: RadiantOne IDDM v8.0.3 Release Notes
description: RadiantOne IDDM v8.0.3 Release Notes
---

# RadiantOne Identity Data Management v8.0.3 Release Notes

July 15, 2024

This patch release is only needed to provide support for updating from v7.4 to v8.1.0. It contains no features or bug fixes otherwise.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [INTERNAL]: Update migrations to support upgrading from v7.4 to v8.0.3 as an interim path to upgrade to v8.1.0.
- [VMR-850]: Added support for Snowflake for real-time persistent cache refreshes: Timestamp Connector type.
- [VMR-866]: Added support to manage all LDIF files under `<RLI_HOME>/vds_server/conf` from File Manager. 

## Security Vulnerability Fixes

- [VMR-594]: Upgraded commons-codec-1.14.jar to remediate potential vulnerabilities.
- [VMR-779, 861,862]: Upgraded Spring libraries to 5.3.39 to address CVE-2024-38809 and CVE-2024-38808 and to remediate potential vulnerabilities.
- [VMR-863]: Upgraded Apache CXF libraries to 3.5.9 to address CVE-2024-32007.
- [VMR-864]: Upgraded Jackson libraries to 2.17.2 to remediate potential vulnerabilities. 

## Bug Fixes

- [VMR-860]: Fixed an issue that caused the Salesforce JDBC driver to be corrupted after patches resulting in problems virtualizing Salesforce data.
- [VMR-873]: File manager improved to display the error reason in the error popup and to hide action buttons when they are not eligible.
 
## Known Issues

Links to SDC client documentation in the Environment Operations Center interface do not work. Reference the following links for the documentation: [SDC Client Docs](../environment-operations-center-guide/secure-data-connectors/deploy-sdc-client)

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
