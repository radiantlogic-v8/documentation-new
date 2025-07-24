---
title: v7.4.16 Release Notes
description: v7.4.16 Release Notes
---

# RadiantOne v7.4.16 Release Notes

May 29, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Supported Platforms](#supported-platforms)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements


- [IV4-24]: Added a warning to be displayed if a pattern policy regex contains spaces (e.g. in the password strength rule of a password policy).
- [IV4-35]: Improvement so that when detecting changes from Entra ID (views built using the mgraph custom data soure) the queries to Entra ID now include the header "Prefer: return=minimal" to avoid an issue with repeating tokens.
- [IV4-36]: Added support for OpenJDK 8u452-b09.
- [IV4-38]: Added the capability to override the default OCSP connection/response timeout with the user specified value.
- [IV4-53]: Added the server time to the dashboard tab in the Main Control Panel.
- [IV4-54]: Updated JNA libraries to v5.17.0.
- [IV4-60]: Added a command line option to supply an optional timeout value (-timeout property) when emptying queues using the vdsconfig empty-queues command.
- [IV4-76]: Removed the timeout for the compiled user-defined scripts endpoint to avoid returning "Failed to compile..." errors in the Main Control Panel > Synchronization tab.
- [IV4-82]: The salesforce DVX and some older custom object samples (file system) have been removed from the samples as they are now deprecated.
- [IV4-84]: Added the delete all and bulk delete options for the dead letter queue messages in the Main Control Panel > Synchronization tab.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022

-	Windows Servers Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

-	Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide.

## Security Vulnerability Fixes

- [IV4-17]: Updated the Spring framework libraries to address CVE-2025-22228.  


## Bug Fixes

- [IV4-22]: Fixed an issue where attribute values were not treated as case-sensitive during cache validation and updates. Attribute value casing is now preserved correctly in the cached entries, ensuring changes in letter case are accurately reflected.
- [IV4-30]: Fixed an issue for the default logging configuration for installing RadiantOne as a Windows services so that logs do not get overwritten.
- [IV4-37]: Fixed an issue where password policy was not working properly when performing an LDAP Modify operation via Proxy Authorization.
- [IV4-43]: Fixed an issue that sometimes caused code signing errors when using custom data sources.
- [IV4-47]: Fixed an issue where bundled JDBC drivers were not updated when applying patches. JDBC drivers are now correctly updated when applying patches.
- [IV4-50]: Fixed an issue where some vdsconfig commands (notably the sync pipeline commands) were not enforcing authentication even when enableVdsConfigAuth was set to true.
- [IV4-51]: Fixed an issue in synchronization where using ADAPTIVE mode could sometimes cause the userAccountControl attribute on AD backends to not be updated correctly.
- [IV4-52]: Fixed an issue where the license expiration date for subscription licenses was not displayed. The expiration date is now correctly shown in both the CLI tool and the Server Control Panel.
- [IV4-57]: Fixed an issue that was preventing access to the certificateUserIds attribute of users in Entra ID.
- [IV4-69]: Fixed an issue to ensure the SCIMv2 API to the RadiantOne service accepts both LDAP and SCIM/ISO timestamp formats in query filters.
- [IV4-91]: Fixed an issue where the "Reset failure count after X minutes" and "Lockout duration" values did not save and/or load properly on the Password Policy UI and in the CLI tool.
- [IV4-96]: Fixed an issue where the customer's ACIs on cn=config or cn=changelog could be removed after a restart of the RadiantOne service if those ACIs were imported from old LDIF file.
- [IV4-112]: Fix to ensure the SCIM API to the RadiantOne service properly closes the LDAP connection when an exception occurs.



## Known Issues/Important Notes

-If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation.
After the installation or update completes successfully, the variable may be reverted to false if desired.
If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

