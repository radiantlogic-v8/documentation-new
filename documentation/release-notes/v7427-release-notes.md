---
title: v7.4.27 Release Notes
description: v7.4.7 Release Notes
---

# RadiantOne v7.4.27 Release Notes

November 13, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)

* [Security Vulnerability Fixes](#security-vulnerability-fixes)

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
- [INT]: Critical vulnerability fix to improve the security of communication between nodes. For cluster deployments, update the RadiantOne FID leader node last. After each node is patched, it is important to ensure that all needed services are back up and running prior to patching the next node.
- [IV4-844]: Fix to address: CVE‑2026‑54399, CVE-2026-54428 and CVE-2026-64607.
- [IV4-891, SQ-2104]: Fix to address: CVE-2026-10050, CVE-2026-19203, CVE-2026-59901, CVE-2026-75595, CVE-2026-68497, CVE-2026-89425, CVE-2026-89407, CVE-2026-91776, CVE-2026-91777, CVE-2026-60589, CVE-2026-61308, CVE-2026-70907, CVE-2026-83374, CVE-2026-91464, CVE-2026-114820, CVE-2026-19032, CVE-2026-83557, CVE-2026-110879, CVE-2026-12611, CVE-2026-18659, CVE-2026-18660, CVE-2026-18661, CVE-2026-18662, CVE-2026-19864, CVE-2026-76182, CVE-2026-76184, CVE-2026-77711, CVE-2026-47842, CVE-2026-47891, CVE-2026-59270, CVE-2026-5927 and CVE-2026-59280.


## Improvements

- [IV4-146, SQ-489]:Added support to the LDAP Password Modify extended operation (OID 1.3.6.1.4.1.4203.1.11.1), so LDAP clients can change user passwords with this standard operation.
- [IV4-845, SQ-1988]:JDK updated to Corretto-8.512.09.1.


## Bug Fixes

- [IV4-224]: Fixed an issue in the Global Identity Viewer where using the globalidviewer-read/readonly access path prevented attributes from loading and even removed the Templates/Attributes UI controls.
- [IV4-821, SQ-1934]: Fixed an issue with LDAP searches failing with error 32 (No such object) when the base DN contains a hex-escaped character, such as \2D for a hyphen, on persistent cache and HDAP store naming contexts. 
- [IV4-852, SQ-2015]: Fixed an issue so that new naming context now prevents conflicts between normalized naming context DNs.
- [IV4-853, SQ-1998]: Fixed an issue so that a first-node install no longer stops with a NullPointerException when the install asks for a local ZooKeeper and also names an external ZooKeeper ensemble. The node uses the external ensemble, local ZooKeeper is not started, and the install finishes.
- [IV4-854, SQ-1997]: Fixed an issue where the Global Identity Builder login analysis no longer stops with a NullPointerException when a global profile entry has no status attribute. The entry is now given the status the analysis computed, the rest of the analysis completes, and each such entry is reported in the task log.
- [IV4-855, SQ-1994]: Fixed an issue where Test Connection on a Microsoft Entra ID data source kept retrying, until the configured number of retries was exhausted, when the application was not found in the directory (AADSTS700016). Test Connection now fails immediately on this error, and normal reads no longer retry it. Other temporary read failures are still retried, and throttled requests are unchanged.
- [IV4-858, SQ-1920]: Fixed an issue where computed attributes that look up Active Directory group memberships (tokenGroups) returned only some of a user’s groups. They now return every group.
- [IV4-863, SQ-2027]: Fixed an issue where searches that use Active Directory’s bitwise matching rules (1.2.840.113556.1.4.803 and 1.2.840.113556.1.4.804) did not return the correct entries. SharePoint’s People Picker and other AD clients that look up security groups with (groupType:1.2.840.113556.1.4.803:=2147483648) now find those groups again instead of getting an empty result.
- [IV4-864, SQ-2036]: Fixed an issue where computed attributes that were set to inactive were still computed when generating code. 
- [IV4-867, SQ-2070]: Fixed an issue where installing the 11th node in a cluster failed because the new node reused an existing server ID (“10”). 

## Known Issues/Important Notes

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
