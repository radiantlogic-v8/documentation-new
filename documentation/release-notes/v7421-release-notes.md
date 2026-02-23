---
title: v7.4.21 Release Notes
description: v7.4.21 Release Notes
---
# RadiantOne v7.4.21 Release Notes

February 23, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)
* [Security Vulnerability Fixes](#security-vulnerability-fixes)
* [Critical Bug Fixes](#critical-bug-fixes)
* [Improvements](#improvements)
* [Bug Fixes](#bug-fixes)
* [Known Issues/Important Notes](#known-issuesimportant-notes)
* [Patch Installers](#patch-installers)
* [How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-   Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022
-   Windows Servers Core
-   Red Hat Enterprise Linux v5+
-   Fedora v24+
-   CentOS v7+
-   SUSE Linux Enterprise v11+
-   Ubuntu 16+
-   Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide. 

## Security-Vulnerability-Fixes
- [IV4-440]: Fix to address CVE-2025-12383.
- [IV4-441, 443 and 444]: Fix to address CVE-2025-48924 and CVE-2025-8916.

## Improvements

- [IV4-372]: Improvement to the SCrypt parameters to strengthen the computational cost based on the latest security evaluation.
- [IV4-380]: Added a new "Allow Anonymous Access Legacy Behavior" checkbox to the Settings -> Security -> Access Control page. When anonymous access is disabled, the RadiantOne LDAP service rejects simple bind requests that include a non-empty bind DN but no password, returning this error:
“Password must be provided: simple bind operations are not allowed to contain a bind DN without a password.” This behavior complies with RFC 4513.
To allow the RadiantOne LDAP service to process these requests as anonymous binds in accordance with RFC 2251 and to treat a bind DN with no password as an anonymous user, enable the ALLOW ANONYMOUS ACCESS LEGACY BEHAVIOR option.
- [IV4-391, SQ-662]: External token validators feature now supports multiple "Expected scope" values. They can be specified as a comma separated list of scope values in the token validators page.
- [IV4-393, SQ-650]: Improvement to allow users to change the access log timestamp format to ISO format and allows users to change the timezone for the access log timestamps.
- [IV4-410,462 SQ-1108]: Added "JDBC Fetch Size" field to database content and container nodes in the directory namespace tab and view designer.
- [IV4-413]: Introduced an optional "Usage Analytics" feature that periodically records instance metrics to local CSV files. The collected data helps analyze trends and variations in server traffic over time.
- [IV4-419]: Updated to OpenJDK 8u482-b08. 
- [IV4-467, SQ-1236]: Added the capability to capture the underlying connection's peer SSL/TLS certificates in global interception scripts.

## Bug Fixes

- [IV4-256]: Fixed an issue so that now the Sync topology title is truncated to prevent it from breaking the page.
- [IV4-319, SQ-875]: Fixed an issue where password policy wasn't honoring the stronger algorithm upgrade on p-cache.
- [IV4-323]: Fixed an issue where Real-time cache refresh diagnostics now properly detects and creates required dependency cache locations when pointing to children nodes of proxy views.
- [IV4-349, SQ-994]: Fixed a user deletion synchronization issue that occurs when using an Active Directory backend with persistent caching. It fixes an issue where a user that is deleted, restored, and deleted again from the Active Directory backend remains visible in the persistent cache. In order for this fix to work, the naming context's DN has to be provided in the Active Directory Sync connector's configuration.
- [IV4-385, SQ-1020]: Fixed the typo in the birthdate attribute in the default ldapschema_55.ldif file.
- [IV4-390, SQ-1005]: Fixed an issue where the persistent search connector did not normalize DNs.
- [IV4-396, SQ-960]: Fixed an issue so that preprocessing filters can now be added to custom object views.
- [IV4-406, SQ-1096]: Validate computed attribute can now distinguish between 2 sibling nodes with the same RDN attribute.
- [IV4-414, SQ-1097]: Fixed an issue where the Global Identity Builder authentication settings were not saved to the view the file automatically.
- [IV4-416, SQ-1113]: Fixed an issue where the replication thread gets stuck due to an invalid operation DN.
- [IV4-422, SQ-1158]: Fixed an issue where the custom password policy's lockout setting was not functioning properly.
- [IV4-424, SQ-1131]: Fixed an issue where AD‑to‑HDAP global sync topologies could set an incorrect user account control value in the target HDAP store.
- [IV4-435, SQ-1183]: Fixed an issue where modify operations on encrypted attributes were not working properly.


## Known Issues/Important Notes

- CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18 tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at /radiantone/<version>/<clusterName>/config/vds_server.conf
- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.