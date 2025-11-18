---
title: v7.4.19 Release Notes
description: v7.4.19 Release Notes
---
# RadiantOne v7.4.19 Release Notes

November 18, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)
* [Security Vulnerability Fixes](#security-vulnerability-fixes)
* [Critical Bug Fixes](#critical-bug-fixes)
* [Bug Fixes](#bug-fixes)
* [Known Issues/Important Notes](#known-issuesimportant-notes)
* [Patch Installers](#patch-installers)
* [How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [IV4-40]: Improved logs during cache initialization related to non-existent dvx files.
- [IV4-293, SQ-763]: Added an improvement to the scimclient2 template to extract the schema from Zoom backends. Add two properties to the scimclient2 custom data source: "notflattencomplexattributes : true" and "useBaseSearchOnList : true"
- [IV4-316, SQ-739]: Added an option to determine if the "Bind requires password" will allow anonymous bind or not. Customers can choose which behavior to enforce.
- [IV4-373, SQ-819]: Added a new command to the vdsconfig command line utility to check if a circular reference exists in dvx files.
- [IV4-374, SQ-901]: Improvements to simplify aspects of license key checking.
- [IV4-388]: Added support for OpenJDK 8u472.

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

## Bug Fixes

- [IV4-211, SQ-622]: Fixed an issue where certain special characters would break uniqueness enforcement on LDAP attributes.
- [IV4-264]: Fixed an issue where default pipeline alerts were not removed when the sync topology was deleted. 
- [IV4-301, SQ-803]: Fixed an issue of defaulting to non-SSL ports when using the reset-cluster-command even if SSL is configured. The new implementation guarantees that SSL will be used by default on vdsha and replicationjournal, if it is configured.
- [IV4-314, SQ-833]: Fixed an issue in the ldif-utils.bat/sh where LDIF comparisons failed when attribute values contained a space hyphen space (" - ") string of characters.
- [IV4-325, SQ-660]: Fixed an issue For Entra ID custom object, where all entries, such as members were not always included.
- [IV4-326, SQ-912]: Fixed issues with global identity builder where the wizard was building up calls to the backend and where the backend calls were leaking connection resources.
- [IV4-329, SQ-909]: Fixed an issue where the memberOf attribute from Entra ID backends was sometimes not returning all groups. Also allow the value of the memberOf attribute to be either a computed DN (matching the location of the groups in the RadiantOne namespace) or the displayname of the groups.
- [IV4-334, SQ-887]: Fixed an issue in query processing that led to incorrect query results in cases of complex searches that included JSON attribute matching.
- [IV4-344, SQ-952]: Fixed an issue of a Null Pointer Exception thrown during migration when the migration export does not include any certificates.
- [IV4-345, SQ-979]: Fixed an issue where members of the Directory Administrators group could not generate a new server LDAP schema.
- [IV4-346, SQ-819]: Fixed an issue where recursive links in naming contexts would break the control panel and naming context tree.
- [IV4-351, SQ-882]: Fixed an issue where the ADAP bulk operations endpoint did not always return a proper JSON structure even in the event of an unexpected exception.

## Known Issues/Important Notes

- CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18 tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at /radiantone/<version>/<clusterName>/config/vds_server.conf
- TLS v1.2 is not supported when in FIPS-mode. This is planned to be supported in v7.4.20.
- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation.
After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
