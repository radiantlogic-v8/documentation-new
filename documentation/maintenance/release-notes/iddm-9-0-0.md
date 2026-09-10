---
title: RadiantOne IDDM v9.0 Release Notes
description: RadiantOne IDDM v9.0 Release Notes
---

# RadiantOne Identity Data Management v9.0 Release Notes

September 10, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v9.0
These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Security Vulnerability Fixes

- [V9-555]: Fix to address the following CVEs: CVE-2026-2332, CVE-2026-41707, CVE-2026-47884, CVE-2026-75595, CVE-2026-10050, CVE-2026-47842, CVE-2026-47857, CVE-2026-47863, CVE-2026-47874, CVE-2026-47879, CVE-2026-47885, CVE-2026-47886, CVE-2026-47889, CVE-2026-59276, CVE-2026-59281, CVE-2026-59282, CVE-2026-59283, CVE-2026-59284, CVE-2026-59316, CVE-2026-59322, CVE-2026-59324, CVE-2026-59903, CVE-2026-62243, CVE-2026-73088, CVE-2026-73089, CVE-2025-11143, CVE-2026-6790, CVE-2026-47843, CVE-2026-47845, CVE-2026-47856, CVE-2026-47883, CVE-2026-47887, CVE-2026-47888, CVE-2026-47890, CVE-2026-47891, CVE-2026-47892, CVE-2026-59292, CVE-2026-59314, CVE-2026-64607, CVE-2026-14456, CVE-2026-33818, CVE-2026-38752, CVE-2026-38753, CVE-2026-38754, CVE-2026-38755, CVE-2026-39821, CVE-2026-46600, CVE-2026-47848, CVE-2026-47893, CVE-2026-56853, CVE-2026-56858, CVE-2026-56859, CVE-2026-56860, CVE-2026-56862, CVE-2026-59313, CVE-2026-75899, CVE-2026-76172, CVE-2026-75975 and CVE-2026-75931.
- [V9-400]: Fix to address: CVE-2026-53669 and CVE-2026-53666.

## Improvements

- [API-3853]: Updates to OpenJDK Java v25 and Lucene v10.
- [V9-105]: Added a dedicated configurable port for the Quartz scheduler server to avoid issues with two RMI listeners ending up on port 1099. 
- [V9-138]: Migrated Custom Banner & Message of the Day Configurations from Classic Control Panel into the new Control Panel: Admin > Control Panel Configuration section.
- [V9-139]: Migrated Server Backend > Connection Pooling/Other from the Classic Control Panel to the new control panel under Tuning > Limits > Backends.
- [V9-141]: Migrated Global Joins from the Classic Control Panel to the new control panel. Directory Namespace > Namespace Design > select Root Naming Context > Advanced Settings > expand Global Joins.
- [V9-147]: Improvement so Config promotion now shows a preview of resources that will be imported prior to the import.
- [V9-158]: Improvement to allow config promotion to select naming contexts regardless of their location within the tree, rather than only allowing selection of root contexts.
- [V9-181]: Added an Analyze section to the Control Panel left navigation menu and migrated Usage & Activity from Classic Control Panel to here.
- [V9-207]: Suppressed a spurious NullPointerException reported in the update install logs.
- [v9-232]: Improvement so that RadiantOne Directory (HDAP) write triggers now capture only changes relevant to the consuming pipeline, rather than every store write. Previously, pipelines sharing a store—or limited to a branch or object type—still processed unrelated changes, increasing queue size, memory use, and processing. Out-of-scope changes are now dropped at the source, keeping queues proportional to each pipeline’s actual workload.
- [V9-282]: Improvements to editing JSON attributes from Control Panel > Directory Browser. The ability to update the record directly from the JSON preview modal has also been introduced.
- [V9-284]: Added the following configurable properties to Control Panel > Tuning > Attributes handling: Attributes excluded from search results, Multi-valued attributes, and Keyword attributes for context search.
- [V9-289]: Added batch update support for Entra ID backends for group member and owner write operations. Batch Writes can be enabled on the Entra ID data source and you can configure the batch size as well.
- [V9-290]: Reduced JWT size growth to prevent large Authorization headers from causing request failures.
- [V9-327, SQ-1350, SQ-1538]: Improvement so that follower-only nodes don't stop when a new leader node is elected.
- [V9-347, SQ-668]: Added a performance improvement that makes ResyncUtil skip entries that were not modified after cluster disconnection, thus reducing the number of entries to process.

## Bug Fixes

- [V9-135]: Fixed a NullPointerException when the DoS filter configuration is persisted as null.
- [V9-148]: Fixed an issue where Config Promotion did not gracefully recover when settings change.
- [V9-154]: Fixed an issue where granular Config Promotion validation rule enforced sync topology incorrectly.
- [V9-209, SQ-1249]: Fixed an issue where Inter-cluster replication could not be working proper after hot initialization.
- [V9-221]: Fixed an issue that was producing false errors in the persistent cache and RadiantOne Directory (HDAP) initialization logs.
- [V9-294]: Fixed an issue where the computed attribute function descriptions are were not displayed correctly.
- [V9-344, SQ-1715]: Fixed an issue where the internal RadiantOne LDAP control (OID 9.9.999.412.1.1.422) was incorrectly forwarded to downstream LDAP proxy backends.
- [V9-374]: Fix to address invalid persistent cache periodic refresh CRON expressions so they are rejected by the UI and REST API at configuration time instead of silently freezing the cache at runtime.
- [V9-389]: Fix so that certificate rejections on the RadiantOne Service REST/ADAP port are now logged. Previously nothing was written to vds_server.log or adap_access.log.
- [V9-414]: Fixed an issue where AD DirSync connector change events with Fetch Entry enabled could omit or only partially include large multi-valued Active Directory attributes (for example group member values) when AD returned ranged attribute pages such as member;range=0-1499. Fetch Entry now expands those ranged attributes to the full attribute before the event is published, and fails closed by dropping incomplete ranged attributes if expansion cannot complete.
- [V9-418]: Fixed an issue related to Microsoft Entra ID data sources showing OFFLINE in the Control Panel while working correctly in Directory Browser.
- [V9-448, SQ-1570]: Fixed a problem where a directory store could become unusable after an interrupted background copy between cluster nodes. If replication was cut short — for example by a node restart or a network drop — the store could be left with an incomplete index file and would fail to load, reporting an unexpected file read error. Replicated data is now published only once it has been fully and verifiably copied, so an interrupted transfer simply retries and leaves the previous good copy in place.
- [V9-515]: Fixed an issue with the fid-0 pod restarting perpetually after a fresh install of Identity Data Management from a backup.
- [V9-520]: Fixed an issue where encrypted attributes were not working properly from Control Panel > Directory Browser.
- [V9-522]: Fixed an issue with data preview returning 500 for LDAP DNs containing / ; or + on a multi-node cluster.
- [V9-533]: Fixed an issue where the Global Identity Builder reported ERRORS when creating a project.
- [V9-540]: Fixed an issue where Global Identity Builder pages could fail to load on projects with a large number of identities, by calculating the identity and correlation counts in the background instead of on every page refresh.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:
- [V9-517]: Large file uploads greater than 1 GB from Control Panel > Manage > File Manager are inconsistent.
- performance degradation!!??

For known issues reported after the release, please see the Radiant Logic Knowledge Base:
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
