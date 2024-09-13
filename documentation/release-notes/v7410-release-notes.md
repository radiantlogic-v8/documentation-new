---
title: v7.4.10 Release Notes
description: v7.4.10 Release Notes
---

# RadiantOne v7.4.10 Release Notes

May 13, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerabilities](#security-vulnerabilities)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS42503]: Improvement to allow an admin to create an LDAP proxy with an empty remote base DN. 
-	[VSTS45390]: Added a new metric (adapProcessingCount) to cn=monitor, and to the node-monitor collector. This metric allows a user to track the number of active requests that ADAP is currently processing at a given point in time. 
-	[VSTS45434]: Adds a capability to override the default OCSP responder with the user defined one. 
-	[VSTS45744]: Improved the zk-export command to output a user-friendly error when the specified ZooKeeper node path is invalid. 
-	[VSTS45745]: Optimize the persistent cache real time refresh of auto generated groups.
-	[VSTS45788]: Updated the condition builder component in Global Sync. When an existing condition is deleted and the rule definition is saved, the condition is now removed when returning to the screen. In the Target Attribute Mappings table, a row is now disabled if a custom input condition is selected.  
-	[VSTS45974]: Added persistent cache refresh optimizations to the UI for handling concurrent updates on large groups to avoid increased response times.
-	[VSTS46095]: Added support for credential-less SMTP for email alerts. 
-	[VSTS46117]: Password policy changes are now logged in the audit log. 
-	[VSTS46144]: Rebranded  RadiantOne FID+ICS to Identity Data Management in Server Control Panel 
-	[VSTS46145]: Rebranded RadiantOne to RadiantOne Identity Data Management on the web-based installer, update installer and the control panel login. 
-	[VSTS46146]: Renamed LDAP View to Model-Driven View (Virtual Tree) in entry statistics report to match UX config. 
-	[VSTS46147]: Added a vertical scroll bar to the entry statistics result table section. 
-	[VSTS46186]: Updated the verbiage of the Global Identity Builder test authentication to detail what is required to support authentication. 
-	[VSTS46201]: Added the support of LDAP Pre-read Control and LDAP Post-read Control. 
-	[VSTS46228]: Added the capability to suppress partial results result code and error message. 
-	[VSTS46277]: The warning message in the Push Mode Replication window is now relocated next to the Ensure Push Mode option for clarity. 
-	[VSTS46355]: Added new warning message to Naming Contexts that already have a Persistent Cache defined to warn the admin that the persistent cache may need reconfigured and reinitialized if this configuration is modified.
-	[VSTS46432]: Updated the Search Expression helper text to remove mention of needing to be a member of our delegated admin groups to avoid confusion. 
-	[VSTS46448]: Removed NTLM settings in UX as they are deprecated. 
-	[VSTS46451]: Added a privileged group of doing inter-cluster replication without going through the ACI enforcement. 
-	[VSTS46520]: ADAP now supports a new returnMode query parameter that can be set to either array or ldapschema. This controls how the JSON response is formatted when ADAP returns a search response. 
-	[VSTS46662]: Updated JDK version to 8u412-b08 
-	[VSTS46701]: Improved the loading for object class attributes for a data source in the view join wizard and added a check to prevent the user from being blocked from continuing in the wizard. 
-	[VSTS46731]: The AD Password filter capture connector will now ignore Unprocessed Continuation Reference(s) errors and report them as a warning in the capture connector logs, instead of considering them as normal errors. 
-	[VSTS46755]: Improved content recorded in the ADAP access log.

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

For specific hardware requirements of each, please see: [https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/](/system-requirements/v74-system-requirements/)

## Security Vulnerabilities

-	[VSTS46070]: Upgraded commons-fileupload to 1.5 to address CVE-2023-24998.   
-	[VSTS46073, 46074-46078,46080, 46083,46085 46087]: Upgraded Jersey libraries to 2.34 to address CVE-2021-28168. 
-	[VSTS46082]: Upgraded the commons-httpclient  to version 3.1-jenkns-3 to address CVE-2022-24898. 
-	[VSTS46084]: Upgraded to Jackson 2.13.5 to address CVE-2023-35116. 
-	[VSTS46086]: Upgraded guava libraries to 32.0.0-jre to address CVE-2018-10237 and CVE-2020-8908. 
-	[VSTS46410]: Upgraded Opensaml to 2.6.6  to remediate potential vulnerabilities.  
-	[VSTS46537]: Upgraded postgresql jar to remediate potential vulnerabilities. 
-	[VSTS46538]: Upgraded commons-compress library to remediate potential vulnerabilities. 
-	[VSTS46637]: Upgraded the spring core version to 5.3.34 and spring security version to 5.7.12 to address CVE-2024-22257 and CVE-2024-22259. 
-	[VSTS46638]: Upgraded bouncy castle jars to address CVE-2024-30172 and CVE-2024-30171. 

## Bug Fixes

-	[VSTS44937]: Changed the format of global sync mappings and rules configuration folders to use a hash instead of pipeline and topology names to avoid filename size limits. 
- 	[VSTS45391]: Fixed an issue with the cn=schema modifyTimestamp computation and made the cluster consistent. 
-	[VSTS45774]: Fixed an issue where the cluster monitor was not displaying results (CPU, JVM memory usage, and/or disk space) with the Cluster Monitor option enabled in the Cluster Monitor Store Settings. 
-	[VSTS46058]: Fixed an issue that prevented creation of groups for Okta backends when a cache is configured. 
-	[VSTS46158]: Fixed an issue so now the computed mapping definition in the Global Identity Builder Wizard automatically formats attribute names with hyphens. 
- 	[VSTS46238]: Fixed an issue that could cause target attribute mappings to get overwritten in rules-based topologies that shared the same rule set name. Improved input validation and auto-generated names for mapping files. 
-	[VSTS46286]: Fix so that the source and destination naming context boxes are editable and the user can enter any DN. 
-	[VSTS46322]: Fixed an issue where while clicking on a topology in Global Sync, the search functionality on the Pipelines page was not working.  
-	[VSTS46325]: Fixed an issue with the mappings (json files) still remaining on file system even if they are deleted from a Transformation Rule > Action. You can now select and use these mapping files when you add a new target attribute mapping action in rules.
-	[VSTS46327]: Fixed an issue where accidental value overwrites were occurring when the same variable name was being used in different rule sets. Rule variable names are now forced to be unique across rule sets and this validation is enforced in the Global Sync UI. 
-	[VSTS46339]: Fixed non-wildcard searches and active user creation for Okta backends. 
-	[VSTS46344]: Fixed an issue so that DoS filter will no longer be applied to admin endpoints. 
-	[VSTS46417]: Fixed an issue where the delete schema was not working on the follower nodes. 
-	[VSTS46418]: Fixed an issue in the backup restore command so that it can be executed on persistent cache naming contexts. 
-	[VSTS46421]: Fix to include support for resource export/import commands for rules-based topologies when used with naming contexts that are part of a global sync topology. 
-	[VSTS46424]: Fixed an issue where message of the day was not showing in the control panel login page. 
-	[VSTS46453]: Fixed an issue where the merge links were preventing modifications of extended join attributes from working properly.
-	[VSTS46454]: Fixed an issue where the custom RootDSE request experienced a significant delay when searched.   
-	[VSTS46455]: Fixed an issue with installing External ZooKeeper as a Windows service. 
-	[VSTS46459]: Fixed an issue so that read-only accounts are not able to change ZooKeeper config. 
-	[VSTS46473]: Fixed the lookupAttribute function to handle the integer representation of scopes (0, 1, or 2) being passed in as Strings which caused the function to return no results. 
-	[VSTS46481]: Fixed an issue which prevented successful running of the uninstaller on Windows. 
-	[VSTS46497]: Fixed an issue where ACL did not return client requested attributes and paged search results correctly when targetFilter was used. 
-	[VSTS46502]: Fixed an issue with Global Sync that could prevent update and delete operations from being detected in HDAP stores.
-	[VSTS46508]: Fixed an issue with ldif-utils that was causing attribute-level changes to be removed from the output. 
-	[VSTS46517]: Fixed an issue where the Control Panel > Directory Namespace tabs were wrapping and hiding content on smaller screens. The Tab toggle screen size is now adjusted. 
- 	[VSTS46527]: Fixed an issue where disabled external token validators were still being evaluated. 
-	[VSTS46539]: Fixed an issue in SCIM2 base searches which sometimes caused an error to be returned when the meta version field was unable to be generated. 
-	[VSTS46540]: Fixed an issue in mappings-based transformations where functions that used parameters utilizing granular change detection values (such as replaced, added, or deleted attribute values) were not being saved properly and were nonfunctional. 
-	[VSTS46545]: Fix so that the Test Event functionality in Global Sync now allows typing in of source dn. 
-	[VSTS46548]: Fixed an issue where the Global Sync > Rules-based Transformation > Rules UI mappings did not clear all values from all of the columns. 
-	[VSTS46584]: Fixed an issue where the custom date/time picker box from the Usage & Activity->Network Latency of the server control panel was not closing. 
-	[VSTS46702]: Fixed an issue with AD Password Filter not working after a stop and start of the AD Password Filter connector.
-	[VSTS46737]: Fixed an issue that was preventing Audit reports from being generated.
-	[vsts46746]: Fixed an issue with wizards not accessible on follower node's Main Control Panel if the RadiantOne service is stopped.
-	[VSTS46751]; Fixed an issue where uploads in Global Sync were not working when the source of the pipeline was a persistent cached view. 
-	[VSTS46759]: Fixed an issue in global sync that was causing apply events with EventType.SKIP to throw an unnecessary exception during the apply phase.
-	[VSTS46776]: Fixed an issue that disabled vds_server.log logging when vdsconfig.logging was enabled and vdsconfig was called via ADAP requests.
-	[VSTS46804]: Fixed errors during migrations for the logging configuration appenders related to losing connection to ZooKeeper.

## Known Issues/Important Notes

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

