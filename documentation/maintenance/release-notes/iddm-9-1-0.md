---
title: RadiantOne IDDM v9.1 Release Notes
description: RadiantOne IDDM v9.1 Release Notes
---

# RadiantOne Identity Data Management v9.1 Release Notes

November 20, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v9.1.

These release notes contain the following sections:

- [Security Vulnerability Fixes](#security-vulnerability-fixes)
- [Improvements](#improvements)
- [Bug Fixes](#bug-fixes)
- [Deprecated Features](#deprecated-features)
- [Known Issues](#known-issues)
- [How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Security Vulnerability Fixes

- [V9-789, V9-998, and V9-1071]: Addressed the following vulnerabilities in v9.1: CVE-2026-114938, CVE-2025-22228, CVE-2026-2332, CVE-2026-22732, CVE-2026-41707, CVE-2026-47884, CVE-2026-59270, CVE-2024-38816, CVE-2024-38819, CVE-2025-41242, CVE-2025-41249, CVE-2026-19203, CVE-2026-22737, CVE-2026-22740, CVE-2026-41720, CVE-2026-41841, CVE-2026-41842, CVE-2026-41843, CVE-2026-41849, CVE-2026-41850, CVE-2026-41851, CVE-2026-45820, CVE-2026-47838, CVE-2026-47842, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59280, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-110816, CVE-2026-111756, and CVE-2026-116689.

## Improvements

- [V9-146, SQ-1127]: Object Extensions can now store their entries in a custom HDAP naming context. The new Data Source Setting has two options: Default keeps the internal `cn=extendedxjoin` store, and Custom uses Local VDS.

- [V9-184]: Added a new API to perform these actions: Disable Referral Chasing, Paged Results, Page Size (when paging is enabled), and Enable SSL. 

- [V9-212]: Added the ability to set a temporary log level that reverts to the previous level after a limited time. This is useful for temporarily enabling debug-level logging without the risk of leaving it on.

- [V9-264, SQ-668]: ResyncUtil now generates ADD and DELETE operations by default for multi-valued attributes instead of REPLACE operations. The optional flag `-r true` allows switching back to the previous REPLACE behavior if needed.

- [V9-267, SQ-577]: The `Action=dump` diagnostic command now includes activity from cache refresh and Global Sync event-processor threads, similar to existing LDAP worker-thread dumps. Each dump entry shows the pipeline, event type, session/sequence IDs, and event ID, with sensitive DN attributes obfuscated in the output.

- [V9-285]: Added a new AD password sync mechanism for self-managed deployments.

- [V9-291, SQ-1468]: Enhanced LDIF comparison to support excluding specific DNs/subtrees from comparison and delta generation.

- [V9-324, SQ-1693]: License expiration email notifications for self-managed deployments can now be configured from the Control Panel, in the License Expiration Email Notifications section of Administration > License Management.

- [V9-339, SQ-1721]: AD DirSync and AD USN Changed connectors can now detect leave-scope changes and emit a cache DELETE for the object’s previously cached DN.

- [V9-345, SQ-1729]: Added a sort control at the tree root for both Directory Browser and Namespace Design. Top-level naming contexts and sibling entries under an entry follow the same case-insensitive A–Z/Z–A sorting behavior.

- [V9-394, SQ-1706]: Dead-letter queues that are already open are now reported as a separate collector row (`{pipelineId}#dlqueue`, type `SYNC_DEADLETTER`) that includes the queue size. Pipeline metrics include a `deadLetterQueueSize` property, and a disabled default dead-letter queue size alert (threshold 0) is created when a new sync topology is installed.

- [V9-395, SQ-1701]: The Sync Engine log path and rollover settings are now configurable in the Control Panel.

- [V9-413, SQ-1798]: Improved the resiliency of Global Sync processing by preventing a processing node from silently halting event handling, which could previously cause queues to accumulate until the node was restarted.

- [V9-468, SQ-1661]: Added concurrentWriteWaitTimeLimit (seconds; default 0, disabled) to limit waits for concurrent writes to the same entry. Timed-out writes return LDAP code 3 without being applied and can be safely retried. Follower nodes now combine concurrent updates like the leader, speeding up group membership changes.

- [V9-478]: Added Cost-aware admission in Feature Management to prevent memory exhaustion during large persistent cache refreshes or Global Sync bursts. It limits concurrent changes to a memory budget (about half the heap), lets smaller changes proceed, and preserves per-entry update order. Disabled by default; changes require no restart.

- [V9-485]: The configured cache details for periodic refreshes now show Last Refresh Status and Next Scheduled Refresh.

- [V9-508]: Added FIPS support for all communications in clusters secured by Internal TLS.

- [V9-544, SQ-1874]: Browser authentication now uses HttpOnly cookies instead of Bearer tokens. Session tokens are fully cleared when users log off or close the browser.

- [V9-554, SQ-666]: Added new global and per-connector/pipeline HDAP trigger event filter fields to the real-time persistent cache refresh and sync topology/pipeline pages. Added a page for enabling global trigger event filtering under Settings > Synchronization > Trigger Event Filtering.

- [V9-561, SQ-1350]: Added debug logging for paged LDAP searches and index searchers. It records when a paged-results cursor is opened, closed, aged out, or abandoned, and when an index searcher is acquired and released. A periodic message also appears when a paged search producer is blocked because the client has stopped reading pages. This helps identify what is holding index files open when block replication fails with `AccessDeniedException` on a follower node.

- [V9-575]: Added internal TLS for communication between RadiantOne components.

- [V9-581]: Removed an incorrect option that listed Apple as a supported OIDC provider. This option no longer appears in the UI.

- [V9-631, SQ-1473]: Restored detailed SyncUpload INFO logging for the upload/init lifecycle, with DN and error sanitization. Fixed `isFromUpload` so it is correctly preserved through mapping and newly generated transform/rule code.

- [V9-655, SQ-1826]: The Salesforce JDBC driver included with RadiantOne can now authenticate to Salesforce using OAuth 2.0 JWT Bearer, alongside the existing username and password method.

- [V9-669, SQ-1644]: The inserted, updated, and deleted values of the Periodic refresh statistics collector now show the results of the most recent periodic refresh of each cache instead of a running total of every refresh. If a refresh fails, the values from the last successful refresh are retained. Custom alerts with thresholds based on the previous running totals may need new thresholds.

- [V9-679]: Improved the Analyze section of the left navigation menu. The section now appears only when at least one Analyze page is available and you have permission to view it. Header search no longer shows an empty Analyze group, and each Analyze entry has its own icon and label.

- [V9-713, SQ-1962]: RadiantOne can now keep a real-time cache of a Salesforce object using the DB Timestamp connector and `LastModifiedDate`. This configuration previously failed when the connector started, before it read any changes. Inserts and updates are captured. A deleted record is detected by the connector only when the SQL filter is `(IsDeleted=true) OR (IsDeleted=false)`. With no filter, Salesforce hides the deletion, and the cache retains the entry until a periodic refresh.

- [V9-732]: Updated to OpenJDK 25.0.5.1.

- [V9-754]: AD password sync is now configured with environment variables instead of ZooKeeper properties. Also, `vds_server.log` no longer shows startup errors caused by reading the agent registry before the HDAP store has finished initializing.

- [V9-785]: The AD Password Sync client binary is now packaged with Identity Data Management.

- [V9-800, SQ-2029]: The cache initialization screen now allows users to select existing `.ldif`/`.ldifz` files from subfolders of the LDIF folder and files on any cluster node.

- [V9-917]: Fixed the HAProxy health check for internal TLS.

- [V9-960]: Mutual authentication can now be disabled for internal TLS.

## Bug Fixes

- [V9-213, SQ-1229]: Fixed an issue so that the Global Identity Builder project configuration is now unlocked only if the Cache Refresh type is set to NONE.

- [V9-214, SQ-1114]: Fixed an issue with hexadecimal escape characters in Directory Browser searches.

- [V9-276, SQ-559]: Fixed an issue where Entra ID users could not be found when adding explicit members to a group. A new Additional Object Class field lets the member search include non-default object classes, such as Entra ID’s `azureaduser`. A search with no keywords now uses only the object class criteria. A search with keywords also matches prefixes in `displayName`, `userPrincipalName`, and `mail`.

- [V9-316, SQ-1713]: Fixed an issue so that administrators in the `readonly` group now have read-only access to the Synchronization tab.

- [V9-463, SQ-1812]: Fixed an issue where the Microsoft Entra ID connector ignored the attribute list requested by a caller and determined what to retrieve from the view's full attribute list instead.

- [V9-466, SQ-875]: Fixed an issue where `userPassword` was not automatically added to or removed from Extension Attributes (Attribute Handling) when Password Policy Enforcement was enabled or disabled on a cache. It is now added when the setting is enabled and removed when it is disabled.

- [V9-488]: Fixed an issue where the Directory Browser’s New Entry wizard did not show attributes named `name`. Users could not create an entry through the wizard when the object class required that attribute, such as `vdRole` and `vdAccessProfile` in the SailPoint ISC V3 connector. The `name` attribute now appears in the wizard and is marked as required or optional according to the schema.

- [V9-529]: Fixed an issue where custom data sources configured in v7.3 or v7.4 (for example, the Microsoft Entra ID data source, `mgraph`) showed an OFFLINE status after migration to v9. The migration now sets them to ACTIVE automatically.

- [V9-541]: Fixed an issue so that logging now redacts individual sensitive values by field name instead of reshaping the payload. Secrets in JSON and form bodies, headers, query strings, and URL fragments are replaced with `XXXX`, and JSON Web Tokens are detected and masked wherever they appear. All remaining content is logged unchanged, so diagnostic payloads stay complete and readable while no credentials are written to the logs.

- [V9-553, SQ-1854]: Fixed an issue so that interception scripts are no longer loaded if none of the interception methods/actions are enabled.

- [V9-633, SQ-1757]: Sync pipeline uploads now run in tracked threads that can be interrupted. Added escape hatches to the upload subprocesses (LDIF export, LDIF scan, LDIF sort, and upload). Added cluster-wide upload/init synchronization through ZooKeeper to prevent upload processes from being lost when leaders switch.

- [V9-634, SQ-1779]: Fixed an issue where the Control Panel logout page reverted to the default blue instead of keeping the configured custom color theme.

- [V9-635]: Fixed an issue where ReSyncUtil stopped the entire resync if an entry’s `modifyTimestamp` used a numeric UTC offset and ignored the `-m false` case-sensitive comparison option. Timestamps with UTC offsets are now read correctly, and unreadable timestamps are skipped and reported instead of stopping the run. Invalid arguments now return an error and exit code 1.

- [V9-645, SQ-1404]: Fixed an issue where updates on follower nodes failed when clients connected using Kerberos or certificate-based authentication.

- [V9-672, SQ-1968]: Fixed an issue where large numbers of searches with time limits could exhaust the system's threads.

- [V9-689]: Fixed an issue where searches on Salesforce number, currency, percent, date, date/time, and checkbox fields failed because the Salesforce JDBC driver included with RadiantOne formatted filter values correctly only for `LastModifiedDate`. The driver now formats each filter value to match the type of the field it is compared against, so these searches return results.

- [V9-694, SQ-993]: Fixed an issue where the maximum pool size was reached when ACIs involved cyclic references in groups.

- [V9-738]: Removed invalid error and warning messages from `vds_server.log` during FID startup.

- [V9-739]: Fixed an issue where the Directory Browser LDIF import (`import_ldif`) ignored directory ACIs and the role's import permissions.

- [V9-755, SQ-2015]: Fixed an issue where adding a naming context with a nearly identical name caused a service outage and loss of the original naming context.

- [V9-809]: Fixed an issue so that Global Sync between two HDAP stores in a cluster now applies changes to entries that already exist in the target store.

- [V9-818]: Fixed an issue where LDIF imports with large groups (500K+ members) ran indefinitely.

- [V9-980]: Fixed an issue where Directory Browser entries whose DNs contained an escaped backslash (`\\`) or escaped double quote (`\"`) could be created but not read, modified, or deleted, and returned 404, 400, or 500 errors.

## Deprecated Features

- [V9-545, SQ-1833]: Deprecated the cluster monitor store (`cn=clustermonitor`), its Clustermonitor setting, and the Server Control Panel Dashboard graphs it feeds. These are hidden from the Classic Control Panel. If the cluster monitor store is enabled in your environment, the Clustermonitor setting is still shown with a deprecation warning, so that you can turn it off without configuring it from the command line. After it is turned off, it can no longer be turned on. While the store is enabled, Identity Data Management logs a deprecation warning at startup. The `/cluster_monitor` REST endpoints still work, but they are marked as deprecated and no longer appear in the published API documentation.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:

- [V9-517]: File uploads larger than 1 GB are inconsistent.
- [V9-345]: In Directory Browser, when results span more than one page, only the entries on the current page are sorted, not the full result set.

For known issues reported after the release, see the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues).

## How to Report Problems and Provide Feedback

You can report problems and provide feedback through the [Support Center/Knowledge Base](https://support.radiantlogic.com).

If you do not have a user ID and password to access the site, contact support@radiantlogic.com.
