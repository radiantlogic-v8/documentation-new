---
title: RadiantOne IDDM v8.1.3 Release Notes
description: RadiantOne IDDM v8.1.3 Release Notes
---

# RadiantOne Identity Data Management v8.1.3 Release Notes

March 28, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.1.3.

These release notes contain the following sections:

[Improvements](#improvements)

[Critical Bug Fixes](#critical-bug-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [VMR-885]: Added a JSTACK command to the ADAP util endpoint to get the stack trace of the Task Scheduler to support troubleshooting. Example: https://baseUrl/adap/util?action=jstack


## Critical Bug Fixes

- [VMR-882]: Fixed an issue where a client could issue an LDAP search request that enumerates entry DNs without being properly authorized. For details, please see the [Support Knowledge Base](https://support.radiantlogic.com/hc/en-us/articles/35748628235540-Bug-that-allows-LDAP-clients-to-search-and-enumerate-entry-DNs-bypassing-ACLs)
 
## Bug Fixes

- [VMR-883]: Fixed an issue that can cause the Task Scheduler to be intermittently unresponsive.

## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
