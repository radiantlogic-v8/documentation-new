---
title: v7.4.1 Release Notes
description: v7.4.1 Release Notes
---

# RadiantOne v7.4.1 Release Notes

April 12, 2022

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS36230]: The Data Analysis PDF report generation now uses the JavaScript library to convert HTML page to PDF instead of using BIRT.

-	[VSTS40240]:  Improved the decouple of checking intervals among "Per User" and "Per Computer" Limits. Added a checkbox in the Special IP Address section.

-	[VSTS42250]: Added the queue monitoring tab to the global sync pipeline page which allows a user to view statistics for the pipeline's queue and view, edit and resent, or delete failed messages in the queue.

-	[VSTS42490]: The View Designer runtime preview now removes trailing backslash from node label.

-	[VSTS42491]: The Join URL is now properly generated for join profiles.

-	[VSTS42505]: Advanced edit for specialized custom data sources (SCIMv2, DSML/SPML, AWS, Azure, Kafka) updates changed properties on the edit custom data source page.

-	[VSTS42563]: Import dialog local file browse button does not hide on resize or focus.

-	[VSTS42582]: ServiceProviderConfig metadata reported by SCIM2 server has been updated to reflect current functionality.

-	[VSTS42665]: Removed minimized JavaScript files and instead the JavaScript files are included.

-	[VSTS42686]: Global Sync mappings page generates a simple objectClass source event filter when the source object class is changed.

-	[VSTS42695]: Directory Browser properly handles adding and viewing entries with a '+' character in the RDN.

-	[VSTS42707]: Global Sync and Persistent Cache Refresh default custom alerts are created with the "preset" property set to false so that they appear under custom alerts by default.

-	[VSTS42784]: Fixed the description and built-in documentation for the "concat" function which contained an error in one of the provided function call examples.

-	[VSTS42809]: Specialized custom data source settings pages fixed for follower nodes when redirecting to the leader.

-	[VSTS42821]: Added the ability to expand and collapse complex/canonical attributes in the SCIM resource type mapping UI and map to either subattributes or the parent attribute.  Special case handling added for Core Group Schema member attribute.

-	[VSTS42827]: Made the filter parameter optional to avoid missing filter parameter error on redirect.  Lowered the initial log chunk size to 200 from 1000.

-	[VSTS42833]:  When user creates a cache on a naming context that is already used as a source naming context (capture) in a Global Sync pipeline, a warning message will warn you that the pipeline capture connector must be re-configured.

-	[VSTS42835]: Saving in the view designer is now disabled for proxy views.

-	[VSTS42953]: Added a DN patterns input field to the resource type configuration page.

-	[VSRS42967]: Global sync queue monitoring page is updated to display message attributes in an editable table, displays the failure reason on the message header, and removes unneeded columns from the summary table.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Servers Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base at: https://support.radiantlogic.com 

## Bug Fixes

### Normal

-	[VSTS42154]: Fixed a bug where SCIM Patch wasn't always working correctly when an array of values was being passed in the client request.

-	[VSTS42181]: Added logic to correctly collect data for persistent cached systems because they have null targetDns under the hood.

-	[VSTS42280]: Fixed a bug where sorting SCIM resource types by primary object class was not functioning.

-	[VSTS42643]: Fixed a bug where the trigger was not created when using mysql as the source by updating the MariaDB JDBC driver to version 2.7.3. 

-	[VSTS42674]: Fixed a bug where SCIM patch replace operations on a complex attribute sometimes generated extra double quotes around values.

-	[VSTS42706]: In the Directory Namespace tab, when editing a LDAP Proxy naming context, users now can edit the interception script and build the interception jar directly in the user interface from the "Proxy Advanced" tab.

-	[VSTS42710]: Fixed an issue that caused too many events to be processed when a sync pipeline is deployed on a branch in HDAP.

-	[VSTS42744]: Allows the backlink attribute to be generated from direct relationships between groups even if nesting relationship is not enabled.

-	[VSTS42757]: Fixed an issue where the password policy's grace login was not working properly through the proxy layer when pass-thru authorization is enabled.

-	[VSTS42765]: Fixed an issue so that the certificate login now does not redirect to the login screen on timeout.

-	[VSTS42768]: Fixed an issue where persistent cache could not be initialized from a view created in Context Builder that contained a large filter. The method would return different results for the same strings. Removed the recursion of findStringIgnoreTrim() method and implemented an iterative solution to not overflow the stack. 

-	[VSTS42772]: Disabled the SAML Attribute Service Soap endpoints.

-	[VSTS42774]: Fixed an issue where optimization on ACI enforcement did not work properly for users with groups from multiple domains when Linked Attributes was not configured to contain all groups.

-	[VSTS42776]: Fixed an issue where password policy's restricting changes in certain duration was enforced only for self-change operations.

-	[VSTS42826]: Fixed an issue with the search result tree display that was caused by case insensitivity.

-	[VSTS42902]: Fixed an issue that could prevent the connector to stop properly when a topology is removed. Fixed a timeout problem when deleting topologies with connectors. Fixed a potential connection leak after a topology is removed.

-	[VSTS42906]: Fixed an issue where Linked Attributes optimization for member-group relationship was not working for users with groups from multiple domains.

-	[VSTS42908]: Fixed an issue with the sync engine distribution that could potentially lead to improper distribution across the cluster after a node reboots (pipeline not registered or processed in multiple nodes concurrently).

-	[VSTS43091]: Fixed a problem of being unable to browse entries using Main Control Panel -> Directory Browser after Test Authentication fails on the tab.

-	[VSTS42973]: Validate values entered as attribute names in RadiantOne LDAP schema to prevent cross-site scripting attacks.

## Known Issues/Important Notes

-	The following options have been removed from Context Builder-Schema Manager: Default Attribute Mapping editor, Load LDAP Schema (for mappings)

-	The following options have been removed from Context Builder-View Designer: Default Views Generator, Sentence View tab, Verb parameter, Add to Context Catalog button, Virtual Tree Generation, and Data Source Management. 

-	The SCIMv1 API to RadiantOne has been deprecated. Only SCIMv2 is supported. SCIMv2 URLs have changed between v7.3 and v7.4. Please reference the Web Services API Guide in v7.4 for examples on querying RadiantOne via SCIMv2.

-	For synchronization, rules-based transformation templates are not included. They are planned for a future v7.4 patch release.

-	The installation process has changed. There are no longer .exe and .bin installer files. A zip file is provided for Windows, and a tar file for Linux. After the files are extracted to the location where you want RadiantOne to be installed, you can use either a web-based install (use \radiantone\vds\bin\setup.bat/.sh) or install-sample.properties with Instance Manager to install in a silent mode. See the RadiantOne Installation Guide for details.

-	RadiantOne-specific environment variables used/set during installation are no longer used. You will not have or need RLI_HOME or RLI_JAVA_HOME.

For known issues reported after the release, please see the Radiant Logic Knowledge Base:
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact
support@radiantlogic.com.

