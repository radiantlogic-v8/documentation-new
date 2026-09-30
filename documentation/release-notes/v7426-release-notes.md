---
title: v7.4.26 Release Notes
description: v7.4.26 Release Notes
---

# RadiantOne v7.4.26 Release Notes

October 2, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.
These release notes contain the following sections:

* [Supported Platforms](#supported-platforms)

* [Security Vulnerability Fixes](#security-vulnerability-fixes)

* [Improvements](#improvements)

* [Critical Bug Fixes](#critical-bug-fixes)

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
- [IV4-793, SQ-1897]: Updated log4j dependencies in external Zookeeper to version 2.25.5 to address:CVE-2026-49844.

## Improvements

- [IV4-343, SQ-1014]: Added a new capability to support universal password policy updates across RadiantOne directory stores and across clusters.
- [IV4-378, SQ-577]: The Action=dump diagnostic command now includes activity from cache refresh and Sync event-processor threads, similar to existing LDAP worker-thread dumps. Each dump entry shows the pipeline, event type, session/sequence IDs, and event ID, with sensitive DN attributes obfuscated in the output.
- [IV4-538, SQ-1350]: Added debug logging for paged LDAP searches and index searchers: it records when a paged-results cursor is opened, closed, aged out or abandoned, and when an index searcher is acquired and released. A periodic message also appears when a paged search producer is blocked because the client has stopped reading pages. This helps find what is holding index files open when block replication fails with `AccessDeniedException` on a follower node.
- [IV4-542, SQ-1397]: Added an option to register external token validators for SCIM, similar to ADAP external validators.
- [IV4-561, SQ-1412]: Removed out of the box "grant read access to all" ACI. 
- [IV4-567, SQ-1473]: Improvement for synchronization to restore detailed SyncUpload INFO logging for the upload/init lifecycle (with DN and error sanitization), and fixed isFromUpload so it is correctly preserved through mapping and newly generated transform/rule code.
- [IV4-568, SQ-1468]: Added LDIF compare enhancement to support excluding specific DNs/subtrees from comparison and delta generation.
- [IV4-572, SQ-1464]: Added "Only process unresolved entries" checkboxes/mode to single and bulk upload in the Global Identity Builder.
- [IV4-577, SQ-1512]: Added an improvement to the inter-cluster replication for RadiantOne Directory to support asymmetric configuration of encrypted attributes.
- [IV4-594, SQ-1514]: Added an improvement so that Users are warned when multiple pipelines share rules-based transformation mappings files and are given the choice to automatically regenerate the transformation scripts for the other pipelines.
- [IV4-616, SQ-1565]: Added an improvement to the Active Directory DirSync connector to now automatically fail back to the Primary domain controller after a failover, once the Primary is available again. A new connector property, "Switch to Primary Server (in polling intervals)", controls this behavior (default 0 = disabled; 1 = every poll; n > 1 = every n polls). This avoids staying on a Failover DC indefinitely and removes the need for a manual cursor reset.
- [IV4-621, SQ-1350, SQ-1538]: Improvement so that follower-only nodes don't stop when a new leader node is elected.
- [IV4-669, SQ-666]: Improvement so that RadiantOne Directory (HDAP) write triggers now capture only changes relevant to the consuming pipeline, rather than every store write. Previously, pipelines sharing a store—or limited to a branch or object type—still processed unrelated changes, increasing queue size, memory use, and processing. Out-of-scope changes are now dropped at the source, keeping queues proportional to each pipeline’s actual workload.
- [IV4-671, SQ-1943]: Added a performance improvement that makes ResyncUtil skip entries that were not modified after cluster disconnection, thus reducing the number of entries to process.
- [IV4-677, SQ-1905]: Added installer/updater cleanup mode to remove unneeded update artifacts.
- [IV4-685, SQ-1661]: Added a new server setting, concurrentWriteWaitTimeLimit, that limits how long a write operation waits when many clients modify the same entry at the same time, for example many membership changes to a large group. When the limit is reached, the write is rejected with a "time limit exceeded" error (LDAP code 3) and is not applied, so the client can safely retry it. A write reported as failed is never applied, and a write reported as successful is always applied. The value is in seconds and the setting is disabled by default (0), which keeps the current behavior.
Also improved: concurrent changes to the same entry sent through a follower node are now combined the same way as on the leader, so bursts of group membership updates complete much faster.
- [IV4-732, SQ-1693]: Added a new settings page (Settings -> Monitoring -> License Expiration Notification) to allow users to configure the license expiration email alert settings.
- [IV4-735, SQ-1736]: Account lockout and password-related attributes are now synchronized by CPLDS to the target store, so a locked account and its lockout details are reflected on both sides.
Entry creation and modification details (who created or last changed an entry, and when) can now also be included in the synchronization.
- [IV4-745, SQ-1706]: Dead-letter queues that are already open are now reported as a separate collector row ({pipelineId}#dlqueue, type SYNC_DEADLETTER) with size, pipeline metrics include a deadLetterQueueSize property, and a disabled default dead-letter queue size alert (threshold 0) is created when a new sync topology is installed.
- [IV4-747, SQ-1701]: The Sync Engine log path and rollover settings are configurable in the Control Panel.
- [IV4-754, SQ-1773]: The option to use SSL (property/checkbox) has been added for license expiration notification settings.
- [IV4-759, SQ-1798]: Improved resiliency of global sync processing by preventing a processing node from silently halting event handling, which could previously cause queues to accumulate until the node was restarted.
- [IV4-785, SQ-1833]: The Clustermonitor setting and the Server Control Panel Dashboard graphs it feeds are deprecated and hidden from the Main Control Panel, because the store makes the leader poll the administrative port of every node every few seconds; a deployment that already has it enabled can still turn it off from the Clustermonitor settings page opened by its direct URL.
- [IV4-787, SQ-666]: New global and per connector/pipeline HDAP trigger event filter fields added to the real-time persistent cache refresh and sync topology/pipeline pages.  Global trigger event filtering enabled page added on the settings tab under synchronization -> trigger event filtering.

## Critical Bug Fixes

- [IV4-541, SQ-1355]: Fixed group membership sync inconsistency for large AD groups (>1500 members) when DirSync connector is pinned to failover DC.
- [IV4-719, SQ-1570]: Fixed a problem where a directory store could become unusable after an interrupted background copy between cluster nodes. If replication was cut short — for example by a node restart or a network drop — the store could be left with an incomplete index file and would fail to load, reporting an unexpected file read error. Replicated data is now published only once it has been fully and verifiably copied, so an interrupted transfer simply retries and leaves the previous good copy in place.
- [IV4-768, SQ-1803]: Fixed an issue where AD-to-AD password synchronization stopped applying password changes after a few successful syncs until RadiantOne was restarted.
- [IV4-779, SQ-1843]: Fixed an issue with a move or rename on a RadiantOne Directory store that put the whole RDN into the first attribute when the entry had a multi-valued RDN like cn=Sam+uid=sammy. Renaming now removes just the old RDN value instead of the whole attribute, so other values on that attribute are kept.

## Bug Fixes

- [IV4-397, SQ-993]: Fixed an issue where max pool size was reached when ACIs involve cyclic references in groups.
- [IV4-632]: Fixed an issue with the proxy authorization for SCIM 2 protocol.
- [IV4-713, SQ-1713]: Fixed an issue so that Administrators in the `readonly` group will now have read-only access to the Synchronization tab.
- [IV4-725, SQ-1731]: Fixed an issue so that now invalid and expired bearer JWT tokens sent to ADAP now return HTTP 401 errors instead of 400.
- [IV4-740, SQ-1404]: Fixed an issue where updates on follower nodes via client connecting over Kerberos or using certificate based authentication are failing.
- [IV4-755, SQ-1779]: Fixed the Control Panel logout page reverting to the default blue instead of keeping the configured custom color theme.
- [IV4-771, SQ-1854]: Fixed an issue so that interception scripts are no longer even loaded if none of the interception methods/actions are enabled.
- [IV4-773]: Fixed an issue where AD DirSync connector change events with Fetch Entry enabled could omit or only partially include large multi-valued Active Directory attributes (for example group member values) when AD returned ranged attribute pages such as member;range=0-1499. Fetch Entry now expands those ranged attributes to the full attribute before the event is published, and fails closed by dropping incomplete ranged attributes if expansion cannot complete.
- [IV4-774, SQ-1757]: Fixed an issue so that Sync pipeline uploads are ran in tracked threads that can be interrupted. Escape hatches added to the upload sub processes (LDIF export, LDIF scan, LDIF sort, upload). Cluster-wide upload/init synchronization through ZooKeeper to prevent upload processes from being lost when leaders switch.
- [IV4-777, IV4-778]: Fixed an issue where SHA2 hash algorithm SSHA384 was not working due to the introduction of SHA3.
- [IV4-782, SQ-1877]: Fixed an issue where resource export left out dependent naming contexts when a view's LDAP data source pointed to the local RadiantOne cluster under a name other than `vds` or `vdsha`.


## Known Issues/Important Notes

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation. After the installation or update completes successfully, the variable may be reverted to false if desired. If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.

- Clustermonitor has been deprecated due to it creating instability issues with the service. 


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)
Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
