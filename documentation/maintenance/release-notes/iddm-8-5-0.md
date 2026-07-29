---
title: RadiantOne IDDM v8.5.0 Release Notes
description: RadiantOne IDDM v8.5.0 Release Notes
---

# RadiantOne Identity Data Management v8.5.0 Release Notes

July 30, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.5.0

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-3665, SQ-763]: Added an improvement to the scimclient2 template to extract the schema from Zoom backends. Add two properties to the scimclient2 custom data source: "notflattencomplexattributes : true" and "useBaseSearchOnList : true"
- [API-4126]: Added a new out-of-the-box CSV data source template that allows users to create data sources from CSV files. CSV files can be managed through File Manager in the default CSV location, while still allowing users to configure a custom folder path when needed.
- [API-4170, SQ-1251]: The log level for “adjusted map clock” messages has been lowered to debug.
- [API-4264, SQ-1318]: The vdsconfig hdap store backup command now returns a non-zero exit code if any zip/unzip operation fails, and will also fail when the generated zip archive is corrupted.
- [API-4282]: Added an option to register external token validators for SCIM, similar to ADAP external validators.
- [API-4306, SQ-1412]: Removed out of the box "grant read access to all" ACI.
- [API-4353]: Removed epic and epic 2 templates from the v8-ui 
- [API-4354]: All FIPS related changes have been incorporated into v8.5.0 to make the IDDM core image (FID image) be FIPS certified in self-managed environment, which covers JCE security modules for hash, encryption, and signature; and JSSE providers for PKIX, OCSP, TLSv1.2 and TLSv1.3.
- [API-4368]: Improved handling for delayed data propagation in Microsoft Entra data sources.
- [API-4401]: Added the option to delete folders under vds_server/custom/src in File Manager.
- [API-4411]: The JSON attribute values are now displayed inline and in the JSON preview modal, eliminating the need to repeatedly click the "JSON Object" button.
- [API-4504]: Added support for OCSP CRL checking when FIPS-mode is enabled.
- [API-4516, SQ-775]: Added support for both TLS v1.2 and TLS v1.3 in FIPS mode.
- [API-4533, SQ-1562]: Added button, "Link Data Sources to Existing Schemas" to the Data Sources section.
- [API-4557, SQ-1563]: Additional validation has been added when deleting a Global Identity Builder project.
- [API-4575, SQ-1274]: Updated the access log CSV appender configuration to use a date/time-based naming pattern for archive files and to switch from the minimum to the “no max” file index.
- [API-4577]: Added cluster logs downloader with log timestamp range selection.
- [API-4616]: Removed deprecated packages property from logging configurations.
- [API-4617, SQ-1601]: Added Support for Accept Header override on all SCIM requests.
- [API-4619]: Implemented Chainguard base images across all images used in IDDM deployments, along with an optional configuration to enable a FIPS-compliant deployment for every image.
- [API-4625]: Added support for an expired‑password reset flow. Users whose passwords have expired can now set a new password and immediately authenticate using the updated credentials.
- [API-4634]: Added new endpoints /api/authentication-service/v2/login and /api/authentication-service/password_reset to be able to handle password reset flows.
- [API-4655, SQ-1628]: Added two new computed attributes: StringFromSIDValue and StringFromGUIDValue, which provide composable alternatives to StringFromSID and StringFromGUID, enabling their use in combination with other functions.

## Security Vulnerability Fixes

- [API-4574, SQ-998,SQ-1175]: Fix to address CVE-2025-48913. 
- [API-4705]: Fix to address: CVE-2025-11143, CVE-2026-2332, CVE-2026-6790, CVE-2026-10050, CVE-2026-49875, CVE-2026-50645, CVE-2026-54291, CVE-2026-54399, CVE-2026-54428, CVE-2026-54515, CVE-2026-55153, CVE-2026-55223, CVE-2026-55831, CVE-2026-55833, CVE-2026-56745, CVE-2026-56746, CVE-2026-56819, CVE-2026-59869, CVE-2026-59871, CVE-2026-59873, CVE-2026-59874, CVE-2026-59875, CVE-2026-59889, CVE-2026-59898, CVE-2026-59899, CVE-2026-59900, CVE-2026-59901, CVE-2026-39822 and CVE-2026-59921.

>[!note] Detailed vulnerability reports for the vulnerabilities addressed in this release are available here: [Security Vulnerability Report](../vulnerability-report)

## Bug Fixes

- [API-3115, SQ-510, SQ-782]: Fixed an issue in handling of null values in SCIM payloads that was impacting SailPoint compatibility.
- [API-4066, SQ-1135]: Fixed an external ZooKeeper ensemble configuration drift during cluster downscaling. When zookeeper cluster nodes are downsized, the zkExternalEnsemble field in the stored cluster configuration is now automatically synchronized with the updated zk.servers list in cloud.properties. This eliminates the need for manual ZooKeeper configuration updates post-downsize.
- [API-4089]: Fixed an issue where very long labels exceeded the dialog boundaries when Mounting a backend.
- [API-4345, SQ-1444]: Fixed an issue so that password/secret values are now masked in the web_access.log for the password reset, OIDC provider, and keystore password requests.
- [API-4410]: Fixed an issue where an unnecessary pop-up dialog message would be displayed when no modification were being made. 
- [API-4412]: Fixed an issue where remapped attributes used in computed attribute expressions were not properly remapped in the expressions.
- [API-4482, SQ-862]: Fixed an issue so that dynamic members under cn=directory administrators,ou=globalgroups,cn=config are now allowed to view SCIM schemas.
- [API-4483, SQ-1471]: Fixed an issue where in some environments, incomplete replication settings could trigger a generic error and prevent status updates. Improved reliability for cloud replication monitoring. The collector now safely ignores incomplete entries, continues processing valid replication data, and uses fallback sources when needed. This helps keep replication status visible and up to date.
- [API-4506]: Fixed an issue where TLS/SSL connections to backend data sources were failing when RadiantOne was running in FIPS-mode due to the change in JDK behavior where TLS 1.3 was configured to be used by default in the handshake negotiation, and the library used in FIPS-mode doesn’t support this TLS version yet.
- [API-4509, SQ-837]:  Fixed an issue where after patching, the SSL Protocol List is incorrectly updated to TLSv1.3 Enabled and TLSv1.2 is Disabled.
- [API-4511,SQ-453]: Fixed an issue with CRL checking via OCSP when in FIPS-mode. Since the new library is currently being recertified by NIST CMVP for FIPS 140-3, customers can use it at their discretion. ccj-4.0.0-fips.jar is the current, default NIST-certified library for FIPS 140-3 used, and ccj-4.0.1-prevalidation-fips.jar is the newer library that contains the CRL checking via OCSP fix. To use the new ccj-4.0.1-prevalidation-fips.jar library, update the following property in ZooKeeper (at /radiantone/<version>/<clusterName>/config/vds_server.conf) to a value of true and restart all RadiantOne services.
- [API-4530, SQ-837]: Fixed an issue where after patching, the SSL Protocol List is incorrectly updated to TLSv1.3 Enabled and TLSv1.2 is Disabled.
- [API-4531]: Fixed an issue in which the save button in the "Manage Group" dialog in Directory Browser would sometimes remain disabled even when changes were made.
- [API-4540]: Fixed an issue where the Manage Schema link in the Select Object from a Secondary Data Source Schema dialog redirected users to the dashboard instead of the Manage Schema page.
- [API-4547, SQ-1381]: Fixed an issue so that log failure notification is now attempted via implicit TLS, then STARTTLS, then plain SMTP, regardless of the port number that is configured (i.e. whether to use implicit TLS vs STARTTLS vs plain SMTP will not be deduced from the port number). Global timeouts are now configured for all SMTP/SMTPS connections to prevent hangs during protocol mismatch or network stalls.
  * Timeout for creating SMTP/SMTPS socket connections = 5 seconds
  * Timeout for reading SMTP/SMTPS responses = 10 seconds
  * Timeout for writing SMTP/SMTPS payload bytes = 5 seconds.
- [API-4549]:Fixed an issue where LDAP filters combining child attributes from different namespaces (e.g. (&(data--color=yellow)(l--city=Novato))) silently returned zero results. Each namespace is now joined independently, and AND/OR groups that mix namespaces, nest, or use NOT on sub-document attributes now return the correct matches.
- [API-4550]: Fixed an issue so now the UI correctly shows the selected file name and indicates that it “will be uploaded” after selection, instead of incorrectly displaying “Upload Complete!” before the upload actually occurs.
- [API-4560]: Fixed an issue with the proxy authorization for SCIM 2 protocol.
- [API-4578]: Fixed and issue for network latency graphs when server name contains special characters.
- [API-4584, SQ-1458]: Fixed an issue where the JSON attribute values were incorrectly formatted for paged searches.
- [API-4592]: Fixed an issue where the Config Promotion export fails if a sync topology uses a label as the source.
- [API-4614, SQ-1328]: Fixed an issue where mutual authentication was not working for all internal TLS/SSL connections.
- [API-4623, SQ-1573]: Resolved queue reliability issues on follower nodes where global sync events could stall or be skipped. Ensured all queued events are consistently processed without loss. Fixed stale search results so queue storage no longer returns non-existent entries.
- [API-4624, SQ-1637]: Fixed an issue with the incorrect filter behavior when the attribute value contains special symbols.
- [API-4661, SQ-1005]: Fixed an issue where the persistent search connector did not normalize DNs.
- [API-4682]: Fixed an issue with Entra ID where all calls were being routed to the SDC service.
- [API-4696, SQ-1705]: Fixed a memory leak affecting real-time caches that leverage HDAP triggers, related to changes that are refreshed from a single directory store exposing several object types (one aggregation/join per object class), similar to how Global Identity Builder generates the global profile view. On busy systems the affected process could grow in memory over time. Memory is now released correctly; no configuration change is required.
- [API-4714, SQ-1731]: Fixed an issue so that now invalid and expired bearer JWT tokens sent to ADAP now return HTTP 401 errors instead of 400.
- [API-4739, SQ-1777]:  Fixed an issue in the Directory Browser search where the DN was splitting on escaped commas.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
- Custom data sources (Entra ID, SCIM2, Okta, Kafka, etc.) continue to log to vds_server.log and do not write to their dedicated per-data source log files. Only custom data sources built with the new Connector SDK write to their dedicated per-data source log file.

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
