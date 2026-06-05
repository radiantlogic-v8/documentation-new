\---

title: v7.4.22 Release Notes
description: v7.4.22 Release Notes
---

# RadiantOne v7.4.22 Release Notes

June 9, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.



<b>IMPORTANT NOTICE:</b>

As part of our 2026 roadmap, we are implementing critical Java platform upgrades across the Identity Data Management product line to maintain compliance with supported Java versions and ensure long-term security and performance.

Why this matters:

OpenJDK 8 reaches end of life (EOL) in November 2026. After this date, it will no longer receive security patches or updates. Customers running on unsupported Java versions will be out of compliance with security and support requirements, which could introduce operational and security risks.



Effective immediately, Identity Data Management v7 is transitioning from OpenJDK 8 to AWS Corretto JDK 8.

This update is delivered as part of the Identity Data Management v7.4.22 patch release.

AWS Corretto JDK 8 extends Java 8 support through December 2030, ensuring continued security updates within the v7 maintenance window.

Customers must upgrade to v7.4.22 as soon as possible to remain on a supported and compliant runtime.



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

* Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022
* Windows Servers Core
* Red Hat Enterprise Linux v5+
* Fedora v24+
* CentOS v7+
* SUSE Linux Enterprise v11+
* Ubuntu 16+
* Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide.

## Security-Vulnerability-Fixes

* \[IV4-433, SQ-1177]: Fix to address CVE-2025-68161.
* \[IV4-436, SQ-998]: Fix to address CVE-2025-48913.
* \[IV4-587, SQ-1511, SQ-1560 and SQ-1600]: Fix to address CVE-2026-34480 and CVE-2026-34477.
* \[IV4-659]: Fix to address CVE-2026-35554, CVE-2026-33558, CVE-2025-58057, CVE-2026-42583.
* \[IV4-660]: Fix to address CVE-2012-0881, CVE-2013-4002, CVE-2020-11979, XRAY-87173.
* \[IV4-661]: Fix to address CVE-2022-41853.
* \[IV4-662]: Fix to address CVE-2025-14813, CVE-2026-5598 and CVE-2026-0636.
* \[IV4-663]: Fix to address CVE-2026-42198.
* \[IV4-664]: Fix to address CVE-2026-5795,CVE-2026-2332,CVE-2025-11143.



## Improvements

* \[IV4-121, IV4-342]: Added a new feature to support cross-store password policy specifically flowing password related operational attributes from the persistent cache to the backend directory.
* \[IV4-375, SQ-554]: Added a new PER\_NODE\_LISTENER mode for the AD Password Filter Connector. In this mode, the password filter listener runs on every node in the cluster, allowing password change events to be received and processed by any node.
* \[IV4-376, SQ-922]: The Directory Browser now persists the configured maximum attribute rows value, so your preferred setting is retained across sessions.
* \[IV4-377, SQ-670]: Added a configurable Control Panel session timeout.
* \[IV4-407, SQ-1095]: The resource-export command now supports a new --direct-chain option for naming-context exports. When enabled, the export bundle contains only the requested naming context (and everything beneath it) plus the minimal parent branch needed, excluding unrelated sibling branches and trimming parent virtual-tree files, which makes it easier to move a single branch between environments without bringing the entire tree.
* \[IV4-455, SQ-1210]: Added an option to run Global Identity Builder upload with or without forcing correlation \& recomputation for identities that are already linked.
* \[IV4-504, SQ-1251]: The log level for “adjusted map clock” messages has been lowered to debug.
* \[IV4-506]: The JDK has been updated to use Amazon Corretto.
* \[IV4-516, IV4-626]: Remove deprecated TLS/SSL protocols TLSv1.1, TLSv1, SSLv2Hello.
* \[IV4-523, SQ-1274]: Updated the access log CSV appender configuration to use a date/time-based naming pattern for archive files and to switch from the minimum to the “no max” file index.
* \[IV4-536, SQ-1318]: The vdsconfig hdap store backup command now returns a non-zero exit code if any zip/unzip operation fails, and will also fail when the generated zip archive is corrupted.
* \[IV4-549]: Added temporary log level feature, allowing logs to have their levels changed for a set period of time before reverting back to the previous level.
* \[IV4-553]: Added cluster logs downloader with log timestamp range selection.
* \[IV4-562]: Improved handling for delayed data propagation in Microsoft Entra data sources.
* \[IV4-563]: Added support for Google BigQuery.
* \[IV4-588, SQ-1491]:  Improved compatibility with Salesforce SCIM servers to support more reliable connectivity.
* \[IV4-598]: Improved the change event capture UI in Synchronization to make the AD Password Filter mode look like a combo box.
* \[IV4-599]: Added a new Global Identity Builder task that allows users to re-upload unresolved entries from any identity source. Added a new checkbox on the UI “Allow Re-correlation" on the identity source configuration page to enable this feature.
* \[IV4-624]: Improved stability of AD Password Filter in "Per Node" mode.
* \[IV4-652, SQ-1601]: Add Support for Accept Header override on all SCIM requests.



## Bug Fixes

* \[IV4-129]: Fixed an issue for network latency graphs when server name contains special characters.
* \[IV4-310, SQ-994]: Fixed an issue with user deletion related to views from an Active Directory backend with persistent caching. This fixes an issue where a user that is deleted, restored, and deleted again from the Active Directory backend remains visible in the persistent cache. In order for this fix to work, the naming context's dn has to be provided in the Active Directory Sync connector's configuration.
* \[IV4-418, SQ-1114]: Fixed an issue with hexadecimal escape chars in directory browser search.
* \[IV4-434, SQ-1184]: Fixed an issue that prevented the ZooKeeper Backup command from functioning when run as the SYSTEM user on Windows.
* \[IV4-453, SQ-1229]: Fixed an issue so that the Global Identity Builder project configuration will now be unlocked only if the Cache Refresh type is set to NONE.
* \[IV4-463, 1135]: Fixed an external ZooKeeper ensemble configuration drift during cluster downscaling. When zookeeper cluster nodes are downsized, the zkExternalEnsemble field in the stored cluster configuration is now automatically synchronized with the updated zk.servers list in cloud.properties. This eliminates the need for manual ZooKeeper configuration updates post-downsize.
* \[IV4-477]: Fixed an issue that prevented real-time cache refresh for Okta groups.
* \[IV4-479, SQ-862]: Fixed an issue so that dynamic members under cn=directory administrators,ou=globalgroups,cn=config are now allowed to view SCIM schemas.
* \[IV4-482, SQ-1255]: Fixed an issue by adding inter-cluster related attributes vdsSyncCursor and vdsSyncState into schema definition in case the schema enforcement is checked on replicas.
* \[IV4-484, SQ-1212]: Fixed email alert issues so that sending mail no longer fails with a “STARTTLS is required” error, and updating SMTP credentials in the UI now takes effect immediately without restarting the scheduler.
* \[IV4-485, SQ-1249]: Fixed an issue where Inter-cluster replication could not be working proper after hot initialization.
* \[IV4-507]: Fixed an issue where sibling content nodes with the same RDN displayed incorrect advanced properties in the Directory Namespace UI; the Advanced Settings tab now shows the correct properties for each node.
* \[IV4-518]: Fixed an issue when the license was updated, the UI continued to show the old license type because the license value was being cached at startup and never refreshed. The code has been corrected to always read the latest value from the license cache, ensuring the UI now reflects the current license type after updates.
* \[IV4-527, SQ-1324]: Fixed an issue where filters beginning with an AND (\&) followed by an OR (|) did not work correctly, ensuring these filter combinations now function as expected for both JSON and standard filters.
* \[IV4-535, SQ-1328]: Fixed an issue where mutual authentication was not working for all internal TLS/SSL connections.
* \[IV4-541, SQ-1355]: Fixed an issue where group membership synchronization for large AD groups (over 1,500 members) became inconsistent when the DirSync connector was pinned to a failover domain controller, causing mixed membership lists and login failures. The solution enforces sticky server affinity so the initial and all subsequent range-based member pages are retrieved from the same DC, eliminating mixed-DC snapshots while maintaining existing failover behavior.
* \[IV4-551, SQ-1385]: Fixed an issue that caused add value(s) and delete value(s) of members on Entra ID groups to fail when the value(s) were greater than one.
* \[IV4-552, SQ-1381]: Fixed an issue so that log failure notification is now attempted via implicit TLS, then STARTTLS, then plain SMTP, regardless of the port number that is configured (i.e. whether to use implicit TLS vs STARTTLS vs plain SMTP will not be deduced from the port number). Global timeouts are now configured for all SMTP/SMTPS connections to prevent hangs during protocol mismatch or network stalls.
Timeout for creating SMTP/SMTPS socket connections = 5 seconds
Timeout for reading SMTP/SMTPS responses = 10 seconds
Timeout for writing SMTP/SMTPS payload bytes = 5 seconds
* \[IV4-555]: Fixed an issue where LDAP filters combining child attributes from different namespaces (e.g. (\&(data--color=yellow)(l--city=Novato))) silently returned zero results. Each namespace is now joined independently, and AND/OR groups that mix namespaces, nest, or use NOT on sub-document attributes now return the correct matches.
* \[IV4-558, SQ-1444]: Fixed an issue so that password/secret values are now masked in the web\_access.log for the password reset, OIDC provider, and keystore password requests.
* \[IV4-566, SQ-1458]: Fixed an issue where the JSON attribute values were incorrectly formatted for paged searches.
* \[IV4-574, SQ-1480]: Fixed an issue where the periodic cache refresh could previously leave the cache in an incomplete state during leadership switches.
* \[IV4-591, SQ-1471]: Fixed an issue where in some environments, incomplete replication settings could trigger a generic error and prevent status updates. Improved reliability for cloud replication monitoring. The collector now safely ignores incomplete entries, continues processing valid replication data, and uses fallback sources when needed. This helps keep replication status visible and up to date.
* \[IV4-619]: Fixed an issue where saving Active Directory connector properties was throwing an error.
* \[IV4-631, SQ-1573]: Resolved queue reliability issues on follower nodes where global sync events could stall or be skipped. Ensured all queued events are consistently processed without loss. Fixed stale search results so queue storage no longer returns non-existent entries.
* \[IV4-654, SQ-1603]: Fixed an issue that was preventing the ability to scroll down in the Edit Computed Attribute window to reach the Validate, OK, Cancel buttons.



## Known Issues/Important Notes

* CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18 tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at `/radiantone/<version>/<clusterName>/config/vds\_server.conf`
* If the environment variable RLI\_CLI\_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI\_CLI\_VERBOSE is not defined, or is already set to true, no action is required.

For known issues reported after the release, please see the Radiant Logic Knowledge Base:
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update\_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

