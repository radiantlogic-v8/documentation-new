---
title: v7.4.5 Release Notes
description: v7.4.5 Release Notes
---

RadiantOne v7.4.5
Release Notes


May 4, 2023

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections: 

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS40649]: Added support for SSL between RadiantOne nodes and the ZooKeeper ensemble when RadiantOne is running in FIPS mode.

-	[VSTS41438]: Improve the ability to harden RadiantOne from brute force attacks on the HTTP endpoints by adding a DoS filtering configuration into Main Control Panel > Settings > Security > DoS Filtering.

-	[VSTS41439]: Added the requirement to enter the current password in order to change the Directory Administrator password.

-	[VSTS44260]: Added a configurable email message for license expiration notifications.

-	[VSTS44544]: Added support for migrating specific Global Sync topologies across environments using the vdsconfig utility resource-traverse, resource-export and resource-import commands.

-	[VSTS44612]: Added an option to the vdsconfig utility’s execfile command to continue executing commands despite errors. Use: `vdsconfig execfile <file> -ignoreError`.

-	[VSTS44636]: Added IBM DB2 TIMESTAMP data type support in the DB Timestamp Connector.

-	[VSTS44649]: Introduced an audit log (RLI_HOME/vds_server/logs/audit.log) to store changes made through the Control Panel, vdsconfig command line utility, or through other REST API to indicate who the author of the change was, which application it was made from, and a rough description of what was modified. 

-	[VSTS44733]: Improved memory management to avoid garbage collection pauses during the creation and sorting of images containing large entries (e.g. groups) used for persistent cache periodic refreshes. 

-	[VSTS44788]: Updated the RadiantOne Salesforce JDBC driver to use Salesforce API v57.  The instance name is also now optionally configurable in the RadiantOne data source URL.

-	[VSTS44846]: Added a warning message on the Main Control Panel > Dashboard tab when the logged in user’s password is going to expire or is expired. Also fixed the Control Panel login to display a password reset screen if the user’s password is expired.

-	[VSTS44870]: Improvement to automatically enable “Password never expires” in password policies when the “Password expires after 0d” value is set using the vdsconfig command line utility.

-	[VSTS44879]: Added a sample custom data for virtualizing Saviynt as a backend.

-	[VSTS44881]: Added a configurable banner to display important information on all screens of the product. The banner can be configured from Main Control Panel > Settings > Server Front End > Administration.

-	[VSTS44883]: Improvement to make the “message of the day” title displayed in Main Control Panel editable from Main Control Panel > Settings > Server Front End > Administration.

-	[VSTS44896]: Improved the IBM ACI Migration Utility Tool. Added support for scanning only the base DN specified in the ServerURL. Added support for paging, and ldap filter. Added support for using LDAPOperations2 instead of JNDI. Improved messages output by the tool and added basic input validation.

-	[VSTS44920]: Improvement to add the left outer join option to Main Control Panel > Context Builder > View Designer > Advanced Settings tab.

-	[VSTS44966]: Improvement to direct the Help link in Main Control Panel to: https://developer.radiantlogic.com/ 

-	[VSTS44980]: Improvement to display the “Message of the Day” in the Control Panel until the user consents and manually closes it. 

-	[VSTS44981]: Improvement so that logging out of Control Panel is more explicit with a message stating your logout was successful.

-	[VSTS44983]: Added integrity assurance for RadiantOne log files by introducing signing and locking mechanisms.

-	[VSTS44984]: Added Support for advanced search filters on JSON indexes with sub filters composed of OR conditions.

-	[VSTS44989]: Improvement for Global Sync input condition for attribute mappings to have an Add icon when a condition is not set. If an input condition is specified, the icon will become an Edit icon.

-	[VSTS45002]: Improved bind processing for proxy views containing merge tree configurations, to take into consideration the state of the user account in the primary backend and avoid checking the account in other merged backends if the bind fails related to an expired password, a disabled account, an expired account, a locked account, or if the user must reset their password.

-	[VSTS45013]: Added name validation in external token validator settings.

-	[VSTS45028]: Improvement to support the tree delete control when deleting entries in ADAP bulk mode. The tree delete control can be activated by including the "deletetree" parameter to the delete operation with a boolean value of true.

-	[VSTS45095]: Improvement so the task log viewer in Server Control Panel is read-only.

-	[VSTS45148]: Upgraded jars to Apache CXF 3.4.10 to address CVE-2022-46364.

-	[VSTS45150]: Removed the docs webapp from the install to address CVE-2022-46364 and CVE-2016-1000027. Help contents within Control Panel now redirect to the documentation website: https://developer.radiantlogic.com 

-	[VSTS45151]: Removed the OpenID Connect webapp to address: CVE-2015-5211, CVE-2018-1270 and CVE-2016-1000027.

-	[VSTS45152]: Updated Kafka client to 3.4.0.

-	[VSTS45154]: Updated the slf4j-api-1.7.21.jar to 1.7.26 to address: CVE-2018-8088

-	[VSTS45155]: Updated the spring-core-5.3.20.jar to 5.3.27 and Spring Security to 5.7.8 to address: CVE-2016-1000027

-	[VSTS45156]: Removed maven ant tasks jar from the reporting-birt folder to address: CVE-2017-1000487

-	[VSTS45188]: Updated JDK version to 8u372-b07.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Server Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base at: https://support.radiantlogic.com
## Bug Fixes

-	[VSTS41441]: Fix to remove access to the Server Control Panel > Log Viewer tab from logged in users that are associated with the read-only privilege.

-	[VSTS43579]: Fix to add missing referrer-policy headers and remove X-XSS-Protection ones that have been deprecated.

-	[VSTS44691]: Fixed an issue with binds failing against cached credentials from a backend ODSEE due to how the hash algorithm was storing the value in lower case in the cache. 

-	[VSTS44708]: Fixed an issue where subsequent modifications on pwdLastLogonTime may accumulate, resulting it degraded modification performance.

-	[VSTS44849]: Fixed an issue that was preventing custom password policies from being saved properly.

-	[VSTS44917]: Fixed an issue with defining computed attributes in Context Builder > View Designer on content nodes that contain joins where attributes returned from secondary sources overlap in name with some attributes from the primary object.

-	[VSTS44918]: Fixed a parsing issue when passing the RadiantOne install location to the migration utility with the generate-migration-plan command.

-	[VSTS44992] Fixed an issue with the Context Builder > Schema Manager failing to load database schemas on a follower node due to the content length being set improperly.

-	[VSTS45005]: Fixed an issue where the linked attribute optimizations (async indexing) was not properly saved and loaded in Main Control Panel for Universal Directory stores.

-	[VSTS45012]: Fixed an issue where computed attribute configurations were not saving.

-	[VSTS45019]: Fixed an issue where the ADAP paged searches failed due to the distribution of queries by the load balancer. These requests are now handled and redirected internally by RadiantOne as needed to prevent this problem. 

-	[VSTS45066]: Fixed an issue where the Java process does not terminate once the RadiantOne installation using the web UI is complete.

-	[VSTS45089]: Fixed an issue with Context Builder > Schema Manager not using the proxy property configured in the custom data source to query SCIM data sources resulting in schema extractions failing.

-	[VSTS45091]: Fixed a regression which may cause ACI's containing a target filter to not function properly.

-	[VSTS45099]: Fixed an issue where the option to Export LDIF in Main Control Panel was not available for logged in users associated with the read-only privilege. 

-	[VSTS45115]: Fixed the Context Builder > View Designer process to properly return entries in Runtime Preview for content nodes that are built from multiple tables containing identical attributes.

-	[VSTS45147]: Fixed an issue that was preventing the actualdn attribute to be properly computed in cached LDAP views built with the -vpp optimization.

-	[VSTS45175]: Fixed an issue where clicking an email link in the Global Identity viewer resulted in blocked content by adding mailto source to the CSP header. 

-	[VSTS45244]: Fixed an issue with using the web installer to apply a RadiantOne patch/update that was causing the update to end with an error indicating “text file busy”.

## Known Issues

Related to [VSTS44715] in the v7.4.4 Release Notes: The following error appears when using the RadiantOne web UI for applying the v7.4.4 patch. This error is only seen when updating from v7.4.2 or v7.4.3 to v7.4.4 using the web UI. ERROR com.rli.install.web.filters.ExceptionFilter:36 - Caught unexpected exception.

To avoid this issue, use the command line method to apply the patch. For more details, see https://support.radiantlogic.com/hc/en-us/articles/12795702674964-Known-Issue-Updating-from-v7-4-3-to-v7-4-4 

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from:

https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact:

support@radiantlogic.com
