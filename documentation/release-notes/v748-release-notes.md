---
title: v7.4.8 Release Notes
description: v7.4.8 Release Notes
---

# RadiantOne v7.4.8 Release Notes

November 30, 2023

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#Bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS39766]: If SSL is not configured when sending an email, the protocol will now default to StartTLS (TLS v1.3). 

-	[VSTS44310]: PBE is used by default in installers. 

-	[VSTS44643]: Added support for requiring approvals in Global Sync, rules-based transformation.  

-	[VSTS44767]: Include the mgraph custom data source, schema, and view out of the box as opposed to only including it if “samples” are chosen during install. 

-	[VSTS44586]: Refactored the Server Control Panel > Log Viewer to improve performance and avoid having the control panel become unresponsive. 

-	[VSTS44914]: Removed the HDFS sample custom data source because it was not maintained. 

-	[VSTS45023]: Added persistent cache refresh optimization for handling concurrent updates on large groups to avoid increased response times. 

-	[VSTS45159]: Removed axis-1.4.jar from the control panel code to improve security. 

-	[VSTS45296]: Improvement to the Control Panel > Dashboard tab to ensure the green lights display only once the service has fully started. Also, when starting one node in the cluster, the start/stop buttons for the other nodes will be disabled. 

-	[VSTS45582]: Updated zip4j to v2.11.5 to address CVE-2023-22899. 

-	[VSTS45718]: Improvement to not all negative numbers for the port value in the Main Control Panel > Settings > Logs > Log Settings > Logging Failure Notification settings. 

-	[VSTS45724]: Updated the naming conventions used for naming contexts and virtual views.
  Merged Backend --> LDAP Proxy View (Merged Backend)
 	Global Profile View --> Model Driven View (Global Profile View)
 	LDAP Backend --> LDAP Proxy View
 	Virtual Tree --> Model Driven View
 	Virtual Tree (Reserved) --> Model Driven View
 	Reserved Universal Directory (HDAP) --> Directory (Reserved)
 	Universal Directory (HDAP) --> Directory
 	HDAP Store Shard Controller  -->  Directory (Store Shard Controller)
 	HDAP Store Shard --> Directory (Store Shard) 

-	[VSTS45764,46065]: Added value obfuscation for passwords in the global sync logs. 

-	[VSTS45782]: Vertical scroll bars are added to the View Designer to now allow access to content on small window sizes. 

-	[VSTS45817]: Improved vdsconfig command get-logging-property -key web.access.level to separate the "LoggingOutput" property to not corrupt the "SystemOut" JSON-formatted property. 

-	[VSTS45850]: Refactored logging failover to prevent failure during rolling updates. 

-	[VSTS45977]: Updated JDK version to 8u392. 

-	[VSTS45994]: Added a Kafka custom data source template to support picking up changes from and publishing changes to a Kafka queue. 

-	[VSTS46005]: Added a tool tip that indicates "Last Login Time" when hovering over the timestamp displayed in the top right corner of the Control Panel. 

-	[VSTS46007]: Made an improvement so that the Global sync tab no longer pollutes the jetty/web.log when FID is unreachable. 

-	[VSTS46024]: Removed the timeouts for the Global Sync pipeline transformation script to avoid problems with compiling the script. 

-	[VSTS46060]: Improvement to Control Panel to not return an error in web.log when logging into Control Panel with an admin user that doesn’t have ics-admin or ics-operator privileges. 

-	[VSTS46154]: Added support for cluster names containing underscores in the installation. 

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

For specific hardware requirements of each, please see: https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/ 

## Security Vulnerability Fixes
-	[VSTS45162] Upgraded jackson-databind-2.13.2.2.jar to 2.14 to remediate potential vulnerabilities. 

-	[VSTS45831]: Upgraded to bcprov-jdk18on:1.76 to resolve the critical vulnerability of CVE-2018-5382. 

-	[VSTS45832]: Spring libraries updated to 5.3.29 and spring-security libraries updated to 5.7.11 to address CVE-2023-34034. 

-	[VSTS45833]: Excluded Apache Batik dependency and updated Xalan dependency to version 2.7.3 to address: CVE-2018-8013 & CVE-2022-34169 

-	[VSTS45834]: Upgraded xalan libraries from 2.7.2 to 2.7.3 to address CVE-2022-34169. 

-	[VSTS45835]: Upgraded to postgresql 42.6.0 to remediate potential vulnerabilities. 

-	[VSTS45836]: Removed the spring-ldap-core library to remediate potential vulnerabilities. 

-	[VSTS45837]: Upgrade Netty in Zookeeper server embedded and client to v4.1.99 to remediate potential vulnerabilities. 

-	[VSTS45838]: Upgraded xercesImpl@2.8.1 to xerces:xercesImpl@2.9.1 to remediate potential vulnerabilities. 

-	[VSTS45839]: Removed axis@1.4 to address CVE-2019-0227 and CVE-2023-40743. 

-	[VSTS45849,45919]: Upgrade jetty in ZK embedded and FID to 9.4.53 to address CVE-2021-28165 and CVE-2023-4487. 

-	[VSTS45888]: Removed jquery-migrate-1.4.1.min.js to remediate potential vulnerabilities.


## Bug Fixes
-	[VSTS45242]: Fixed an issue with virtual views from Okta backends where updating the status and password of users was not working properly, by updating the Oktaclient custom data source to use a newer Okta API. 

-	[VSTS45269]: Fixed an issue where the checkboxes in authentication for the global profile were not saving properly. 

-	[VSTS45305]: Fixed an issue where the Directory Admins were unable to view SCIMv2 schemas and resource types in Control Panel > Settings > SCIM. 

-	[VSTS45500]: Fixed an issue where ACI filtering might not function properly if the expected attribute list is too narrow to share any attributes allowed in ACI settings. 

-	[VSTS45644]: Fixed an issue with the persistent cache monitoring log requests not properly being forwarded to the leader node. 

-	[VSTS45713]: Fixed an issue where the ACI with a deny rule in the target filter was not working properly. 

-	[VSTS45716] Fixed an issue with vdsconfig command line tool revealing passwords for certain commands. 

-	[VSTS45742]: Fixed an issue that was clearing the Main Control Panel > Settings > Server Front End > Advanced > "Run as a Windows service" checkbox on service restarts. 

-	[VSTS45771]: Fixed the edit connection string window on the Main Control Panel > Directory Namespace tab, so that the "Choose your Base DN” contents are no longer duplicated.  

-	[VSTS45772]: Fixed the task log refresh behavior in the Main Control Panel > Directory Namespace > [activity that launches a task] > Task Monitor window so that the logs are correctly tailing and it does not take the user back to the top every time it refreshes.  

-	[VSTS45786]: Fixed an issue with the "Attributes not displayed in logs for security purposes" not functioning properly for all logs. 

-	[VSTS45799]: Fixed an issue where the Main Control Panel > Replication Monitoring tab table did not allow the user to expand store names with commas in them.  

-	[VSTS45804]: Fixed incorrect memory settings format for Windows services causing custom memory sizing to be ignored. 

-	[VSTS45806]: Fixed an issue where Function Dialog produced "sub" instead of “2” in the generated code for the lookUpAttribute function. 

-	[VSTS45826]: Fixed an issue where the silent installer was incorrectly creating Windows shortcuts. 

-	[VSTS45842]: Fixed the migration tool to re-encrypt all data sources when migrating from a non-PBE to a PBE environment. 

-	[VSTS45852]: Fixed an issue that could prevent CPLDS distributing sync jobs to agents to fail after an FID leadership change. 

-	[VSTS45855]: Fixed an issue where creating a naming context with a “+” would cause the Main Control Panel to crash. Users are now prevented from creating a naming context with a “+” in the name.  

-	[VSTS45856]: Fixed an issue where error code 400 would occur when saving a content (type) node from Main Control Panel > Directory Namespace. 

-	[VSTS45863]: Fixed an issue where access to the Directory Tree wizard from the Main Control Panel > Wizards tab was blocked by CSRF. 

-	[VSTS45877]: Fixed a JavaScript loop error in the Global Sync test transformation DN browser dialog. 

-	[VSTS45904]: Fixed a java.nio.file.FileAlreadyExistsException error that was logged when upgrading from a recent version of RadiantOne that already contained Okta2 orx/dvx files. 

-	[VSTS45914]: Fixed an issue that would prevent FID and the Control Panel from automatically recovering after a complete disconnection with ZooKeeper, even after the connection is reestablished. 

-	[VSTS45927]: Fixed an issue that would prevent the RadiantOne patch updater process from terminating when SSL connectivity to ZooKeeper is used. 

-	[VSTS45930]: Fixed an issue with Global Sync configuration so that when creating a new Rule Set it now loads object classes and attributes from the nested view of a nested virtual tree. 

-	[VSTS45934]: Fixed the audit report generation to now work from follower nodes. 

-	[VSTS45935]: Fixed a bug in which ADAP authentication failed to properly resolve access rights when authenticating with the full directory manager DN (cn=Directory Manager,ou=rootUsers,cn=config). 

-	[VSTS45936]: Fixed an issue with the server startup process that would prevent a new license key from automatically being installed on other nodes of the cluster. 

-	[VSTS45976]: Fixed an issue in Main Control Panel that was causing java.util.ConcurrentModificationException errors in the Jetty web.log when navigating to Settings > Server Backend Settings.  

-	[VSTS46010]: Fixed a potential issue causing intermittent installation errors when adding follower nodes to the RadiantOne cluster when PBE is enabled. 

-	[VSTS46019]: Fixed an issue in Rules Builder where multiple attribute mappings tables were incorrectly synchronized. 

-	[VSTS46020] Fixed an issue with Context Builder not sorting files by the real date modified. 

-	[VSTS46028]: Fixed an issue where an admin user could not update their expired password during Main Control Panel logins unless they were using their full DN to login. The password reset experience now uses the user DN mapping. 

-	[VSTS46045]: Fixed an issue with the expired password reset experience in Main Control Panel where now the reset process checks the policy associated with the user to determine if the old password is required when updating an expired password. 

-	[VSTS46046]: Fixed an issue for Global Sync test transformation script that occurs when selecting a DN with spaces in it. 

-	[VSTS46048]: Fixed typo in object class mismatch dialog in Global Sync test script page. 

-	[VSTS46059]: Fixed an issue with the installer (and updater) where the RadiantOne super user password validation was failing for follower nodes. 

-	[VSTS46105]: Fixed issues related to using FIPS-mode and SSL connectivity between FID and Zookeeper when PBE is enabled during install. 

-	[VSTS46107]: Fixed an issue where the Global Sync transformation script indicates "compiled successfully" in the Main Control Panel > Global Sync tab > Test Transformation window even when it doesn't. 

-	[VSTS46159]: Fixed an issue with v2.1.7 of the Migration Utility where any folder with a white space in the file path was causing the migration command to fail.

## Known Issues/Important Notes

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

