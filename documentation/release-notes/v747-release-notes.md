---
title: v7.4.7 Release Notes
description: v7.4.7 Release Notes
---

# RadiantOne v7.4.7 Release Notes

August 14, 2023

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [VSTS42865]: Updated Bootstrap to version 3.4.1. Updated jQuery to version 3.7.0. Updated Angular to version 1.8.3 to address security vulnerabilities.

- [VSTS44396]: Added a query timeout property for the database timestamp capture connector for persistent cache refresh to avoid the connector waiting indefinitely when the database server isn’t responding quickly.

- [VSTS44649]: Added an audit log to track configuration changes made to RadiantOne. This log is located in RLI_HOME/vds_server/logs.

- [VSTS44882]: Updated GSON libraries and other related Google library dependencies to their latest compatible versions.

- [VSTS44902]: Added support for RadiantOne administrators to disable the ability to set log level to OFF for RadiantOne logs.

- [VSTS44903]: Added checks for logging failures, in which case an email alert gets sent in the event of logging failure. The feature is enabled out of the box but needs to be configured to be able to send emails. In the event of a logging failure, this feature will make an attempt to alert the user, but will gracefully fail and will not interfere with the application's state if the attempt fails.

- [VSTS44916]: Improved the display of TLS/SSL protocols to show the ones that are actually enabled in RadiantOne rather than simply the JDK's default enabled protocols list.

- [VSTS44982]: Added a last logon time in the upper right corner of the Main Control Panel for the currently logged in user.

- [VSTS45064]: Improved the SCIM2 custom data source connection test to better verify validity of credentials.

- [VSTS45093, 45423, 45463]: Added the ability to generate an Entry Statistics Report from Main Control Panel > Settings > Configuration.

- [VSTS45148]: Upgraded jars to Apache CXF 3.4.10 to address: CVE-2022-46364 and CVS-2022-46363.

- [VSTS45154]: Updated the slf4j-api-1.7.21.jar to 1.7.26 to address: CVE-2018-8088.

- [VSTS45157]: Removed reporting-web.war from the build dependencies and added it as a file to be deleted during migrations to address: CVE-2017-9096.

- [VSTS45160]: Updated the fastxml jackson dependencies to address: CVE-2022-42004 and CVE-2020-36518.

- [VSTS45163]: Upgraded opensaml v2.5.3 jar to v2.6.5 to address: CVE-2017-16853 and CVE-2013-6440.

- [VSTS45164]: Updated Apache PDFBox and FontBox library versions to 2.0.28 to address: CVE-2021-2790.

- [VSTS45198]: Added a new property in vds_server.conf (useInterceptionErrorCodeOnViews) that controls how error codes are returned from interception scripts in virtual views. This allows virtual views to return a return code other than 1 if that is the desired behavior. By default, virtual views always return error code 1 no matter what is set in the interception script.

- [VSTS45254]: Improvement to display the upload complete message only after an upload has been run.

- [VSTS45261]: Added a checkbox to enable/disable Integrity Assurance for logging. Enabling the checkbox will change the archive format to: zip_sig

- [VSTS45283]: Improvement so that the MOTD (Message of the Day) popup isn’t bypassed when using PKI Authentication.

- [VSTS45285]: Improvement to support defining complex ACIs with the target URL syntax: (target="ldap:///`<targeted DN>?<list of attributes>`") For example, the following would allow access to a group by only the group’s owner, (targetattr="*")(target="ldap:///o=My Company?manager,owner,role")(targetscope = "subtree")(version 3.0;acl "Group owner access only";allow (all)(userdn = "ldap:///self");)

- [VSTS45307, 45317]: Added support for a configurable banner to display on all RadiantOne web applications.

- [VSTS45327]: Added support for a new property (srvRecordLimit) to control the number of servers read from AD Domain SRV records. This is configurable from Main Control Panel > Settings > Server Backend.

- [VSTS45337]: Added a test authentication button in Main Control Panel > Directory Browser > search result window to allow for testing authentication for a user returned in a search.

- [VSTS45356]: Improvement to the Main Control > Settings > Server Backend > Custom Data Source > drop-down list to remove the test/beta options AWS and Azure to avoid confusion.

- [VSTS45359]: Improvement to make Global Sync pipeline transformation mode available during uploads.

- [VSTS45383]: Updated the library org.yaml:snakeyaml:1.30 to org.yaml:snakeyaml:2.0 to address CVE-2017-9096.

- [VSTS45431]: Updated JDK version to jdk8u382-b05.

- [VSTS45452]: Improved the OIDC provider configuration settings for logging into Main Control Panel to allow it to be enabled/disabled as needed.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

- Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022

- Windows Server Core

- Red Hat Enterprise Linux v5+

- Fedora v24+

- CentOS v7+

- SUSE Linux Enterprise v11+

- Ubuntu 16+

- Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base at: https://support.radiantlogic.com

## Bug Fixes

- [VSTS44915]: Fix to address a problem of LDAP schema extraction when the directory manager password contains semicolons. Fix is to prevent semicolons from being used in passwords for the directory manager.

- [VSTS44952]: Fixed an issue where virtual attributes configured for child nodes were not returned properly (e.g. they were not shown on the Main Control Panel > Directory Browser for these entries).

- [VSTS45027]: Fixed an issue where the update installer failed to return to the prompt once the update process was complete.

- [VSTS45142]: Fixed an issue where Content/Container nodes in Context Builder > View Designer containing the same RDN attribute were not properly distinguished by table/object name.

- [VSTS45175]: Fixed an issue where the email hyperlinks were being blocked in the Global Identity Viewer.

- [VSTS45187]: Fixed a periodic cache refresh issue that would prevent new cron expressions from being applied after a failure of communication with the backend during a refresh cycle.

- [VSTS45242]: Fixed an issue with the Okta custom data source not properly calling the Okta API to update the status and password attributes of entries in Okta, and inaccurately returning a successful result code (200) even though the attribute values were not updated.

- [VSTS45284]: Fixed an issue with the browser tree display/search in the Manage Group window where sub-levels were not returning properly.

- [VSTS45304]: Fixed a performance issue for Universal Directory stores when they are queried with a mix of presence filters and determinant attributes filtering.

- [VSTS45313]: Fixed an issue where the linked attribute optimizations were not properly saved and loaded for Universal Directory (HDAP) stores.

- [VSTS45350]: Fixed an issue with the Global sync log viewer when redirecting to another node with special characters in the logs.

- [VSTS45353]: Fixed multiple issues related to the migration utility not functioning properly when migrating naming contexts configured for inter-cluster replication.

- [VSTS45360]: Fixed patch operations and extension schemas in Scim2 client (RadiantOne virtualizing SCIMv2 service as backends).

- [VSTS45364]: Fixed an issue that was preventing the RadiantOne Windows services from restarting properly, causing them to return “Error 200: The code segment cannot be greater than or equal to 64K”. The RadiantOne FID and RadiantOne FID Management Console services display as prunsrv.exe instead of java.exe when viewing the details in Windows Task Manager.

- [VSTS45368]: Fixed an issue where forward slashes in ADAP calls were not supported.

- [VSTS45386]: Fixed an issue where search results tree DNs were incorrectly being case sensitive when building the result tree.

- [VSTS45413]: Fix so that ADAP bind credentials are properly encrypted and encoded in base64. Apache HTTP logs disabled in control panel logs.

- [VSTS45414]: Fixed an issue so that Directory Administrator group members are now able to access the Global Identity Viewer.

- [VSTS45415]: Fixed an issue with the Global Identity Viewer causing it to return "Unable to access the RadiantOne Service” in the UI.

- [VSTS45420]: Fixed an issue in Global Identity Viewer where the entries searched in data sources other than “global profile” were not loading correctly.

- [VSTS45430]: Fixed an issue where whitespace characters combined with multi-valued RDNs could cause some LDAP searches to fail.

- [VSTS45448]: Fixed an issue that was preventing the real time cache refresh from processing events on cached views of Universal Directory (HDAP) stores.

- [VSTS45494]: Fixed an issue where the attribute’s virtual name was not editable in Context Builder.

- [VSTS45498]: Fixed an issue so that now authorization header data for custom data source backend requests is now redacted from debug logs.

- [VSTS45501]: Fixed an issue where collector filtering would fail if the value contained a colon.

- [VSTS45502]: Fixed an issue with resource-export and resource-traverse commands that caused failures when the RadiantOne configuration being scanned contained a cache refresh topology.

- [VSTS45514]: Fixed an issue where replication monitoring does not function properly when the cluster is deployed behind a Load Balancer and the ADAP service has its own separate endpoint.

- [VSTS45520]: Fixed an issue where the refresh and auto-refresh were not working in the task scheduler when creating and initializing a cache.

- [VSTS45553]: Fixed an issue where an updated CRON expression for periodic cache refresh is saved without requiring a restart.

- [VSTS45554]: Fixed an issue causing dialog boxes in Main Control Panel > Directory Browser to be incorrectly formatted.

- [VSTS45607]: Changed the behavior of database connectors for persistent cache refreshes to trim trailing whitespace in values originating from columns with a CHAR SQL type. This was preventing delete operations from being processed correctly and applied to the persistent cache.

- [VSTS45611]: Fixed an issue causing the Server Control Panel to not be able to display information properly on the Usage & Activity > Server Information page.

- [VSTS45620]: Fix the logout experience for Insights, Reports and Administration console to be more explicit and clearer that the user has properly logged out.

- [VSTS45628]: Fixed an issue that can cause the web-based update installer to display a successful update, but indicate a “Failure while running installer”, even though no errors are returned in the install log.

- [VSTS45670]: Fix to remove the file locking and shutdown rollover from integrity insurance.

- [VSTS45673]: Fixed an issue with Main Control Panel > Context Builder > View Designer > Content Node > Attributes Virtual Name Display.

- [VSTS45727]: Fixed an issue with the node display paging process in the Main Control Panel > Dashboard tab. 

## Known Issues

Customers that have deployed virtual views of Okta please be advised that all virtual views of Okta must be manually reconfigured after updating to v7.4.7. Details can be found in knowledge article referenced below.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: 

support@radiantlogic.com
