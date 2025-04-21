---
title: v7.4.15 Release Notes
description: v7.4.15 Release Notes
---

# RadiantOne v7.4.15 Release Notes

April 22, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.15.

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [VSTS47305,47439]: Improvement so that inter-cluster replication uses internal No-TCP/IP connection for localized pushing traffic and added an immediate in-line retry logic whenever pushing traffic fails due to connection issues.  
- [VSTS47435]: Improved the default logging configuration for installing FID windows services so that logs do not get overwritten.
- [VSTS47476]: Updated the vdsconfig datasource commands to clearly indicate that the vds data source is read-only, managed internally by the IDDM server, and cannot be modified.
- [VSTS47480]: Updated the documentation for the vdsconfig set-transform-mode command to include all relevant transformation mode options.

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

For specific hardware requirements of each, please see: [https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/](https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/)


## Bug Fixes

- [VSTS47026]: Fixed an issue in Global Sync affecting ADAPTIVE mode (used in rules-based topologies) which sometimes caused redundant updates to be sent to the target naming context, even when target attribute value(s) had no changes.
- [VSTS47385]: Fixed an issue where the RadiantOne Windows service name was missing the closing parenthesis character.
- [VSTS47467]: Fixed an issue in Global Sync affecting ADAPTIVE mode (used in rules-based topologies), where events applied with the target change type INSERT did not behave consistently with those using UPDATE. In ADAPTIVE mode, both INSERT and UPDATE are expected to perform an UPSERT on the target naming context and to have the exact same functionality.
- [VSTS47486]: Fixed an issue where replaying messages from the dead letter queue caused them to get stuck in the normal queue.  
- [VSTS47512]: Fixed an issue that caused an exception when running the monitoring script on a large amount of RadiantOne nodes.
- [VSTS47514]: Fixed an issue with the cluster commands not respecting the env variables.
- [VSTS47515]: Fixed an issue for the periodic refresh delete and add validation threshold. The Control Panel now allows users to explicitly toggle each threshold to prevent the add threshold from being set to the delete threshold.
- [VSTS47522, 44435]: Fixed an issue in the Salesforce JDBC driver that interfered with the operation of all JDBC drivers.



## Known Issues/Important Notes

- If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation.
After the installation or update completes successfully, the variable may be reverted to false if desired.
If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

