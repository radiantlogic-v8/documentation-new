---
title: v7.4.4 Release Notes
description: v7.4.4 Release Notes
---

RadiantOne v7.4.4 Release Notes

February 2, 2023

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4

These release notes contain the following sections: 

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS44216]: Improvement to display a hyperlink to the schema (.orx) used for a view on Context Builder > View Designer and Main Control Panel > Directory Namespace nodes.

-	[VSTS44577]: Improvement to the graphapi custom data source so that entries returned from Azure AD will have a memberOfDisplayName attribute which mirrors the contents of the memberOf attribute, but will contain the displayName of the group instead of the guid.

-	[VSTS44578]: Improved the password policy dictionary check process to support a "contains" match instead of just an exact match. Set "enablePwdPolicyDictionarySubstringCheck" : true either in the ZooKeeper vds_server.conf settings or using vdsconfig command line utility, if you want the password policy to enforce a “contains” match. Note that the value “true” must be in all lowercase.

-	[VSTS44594]: Added a scroll bar for the topology list on Main Control Panel > Global Sync tab.

-	[VSTS44605]: Added the full RadiantOne version/revision to the RootDSE vendorversion attribute.

-	[VSTS44612]: Added an option to vdsconfig execfile command to continue executing
commands despite errors. Use: `vdsconfig execfile <file> -ignoreError`

-	[VSTS44650]: Improvement to remove the "Display all servers nodes" options from the Settings menu on the Main Control Panel > Directory Browser tab as it is irrelevant.

-	[VSTS44696]: Added new commands to the vdsconfig utility to allow global profile upload and global profile reset tasks to be launched from the command line. The new commands are globalprofile-upload, and globalprofile-reset.

-	[VSTS44702]: Improvement for ACI evaluation performance in cases where the search request returns a large result set. 

-	[VSTS44704]: Removed redundant and overly verbose logs from INFO level when fetching range attributes.

-	[VSTS44746]: Improvement to make the maximum number of concurrent active ADAP paged searches configurable on Main Control Panel > Settings > Server Front End > Other Protocols.

-	[VSTS44792]: Updated JDK version to 8u362-b09.
Supported Platforms

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

-	[VSTS42703]: Fixed subtree delete operations processing from the Main Control Panel > Directory Browser.

-	[VSTS43877]: Fixed an issue where local secure connection (ldaps) could not be established when mutual authentication is set as required.

-	[VSTS44184]: Fixed a bug that prevented the root naming contexts, and browsing the DIT in some Control Panel dialog boxes for eDirectory LDAP backends.

-	[VSTS44337]: Change CPLDS retry on error behavior to not retry until next cycle.

-	[VSTS44415]: Fix to not display the Context Builder tab on follower-only FID cluster nodes.

-	[VSTS44446]: Fixed the ADD ATTRIBUTE button behavior on the Main Control Panel > Directory Browser from being hidden when the attribute name is too long in the “add attribute dialog” window.

-	[VSTS44483]: Fixed an issue with cache initialization failing due to improperly formatted JSON values being returned from the Saviynt custom data source. 

-	[VSTS44529]: Fixed an issue with connection pooling causing RadiantOne to send anonymous binds through the RLI Router to Active Directory backends for modify requests when pass-through authorization was enabled.

-	[VSTS44613]: Fixed an issue with the scimclient2 custom object that was preventing it from working with SCIM attributes containing hyphenated names.

-	[VSTS44621]: Fixed LDAP object class syntax parsing during schema extraction, so that it accepts situations when there is no space between the OID and the opening parenthesis, and properly parses it.

-	[VSTS44624]: Fixed an issue where the Main Control Panel > Settings tab was not displaying properly on follower FID cluster nodes.

-	[VSTS44632]: Fixed issues in the add-orx-schema and remove-orx-schema vdsconfig commands that was causing successful command responses to be returned even on connection failures.

-	[VSTS44659]: Fixed an issue that was preventing virtual attributes defined for labels and link nodes from being saved properly.

-	[VSTS44671]: Fixed an issue that was preventing nested groups from being unnested properly.

-	[VSTS44675]: Fixed an issue with custom Message of the Day HTML not displaying properly. 

-	[VSTS44683]: Fixed an issue with the Global Sync code generator when creating mappings using local variables. 

-	[VSTS44694]: Fixed an issue with connectivity to a backend Active Directory when a user name or base DN contains escaped characters. This was causing authentication errors noticed during persistent cache refresh operations because connections in the pool were using the incorrectly formatted user name/base DN.

-	[VSTS44709]: Fixed an issue where some parameter values were being incorrectly quoted when calling vdsconfig using the ADAP interface. This was causing commands containing argument values with special characters like double quotes to fail with: "Error: the computed expression is not in the expected format: ATTRIBUTENAME=EXPRESSION.\"\r\n}"

-	[VSTS44711]: Fixed an issue virtualizing Salesforce backends due to an issue with checking the JDBC driver.

-	[VSTS44715]: Fixed a problem with the web-based installer that was causing an error when trying to use it to install a patch from v7.4.2 or v7.4.3 to v7.4.4.

-	[VSTS44745]: Fixed an issue with the HDAP triggers capture connector not properly detecting changes on a persistent cache of a Global Identity Builder view that has been configured as a source in a sync pipeline.

-	[VSTS44759]: Fixed an issue with the dictionary check settings not being saved properly for password policies configured from the RadiantOne Main Control Panel.

-	[VSTS44815]: Fixed an issue with the Derby database service not accepting connections when it is running as a Windows service.

## Known Issues

Related to [VSTS44715] in the Release Notes: The following error appears when using the RadiantOne web UI for applying the v7.4.4 patch. This error is only seen when updating from v7.4.2 or v7.4.3 to v7.4.4 using the web UI. ERROR com.rli.install.web.filters.ExceptionFilter:36 - Caught unexpected exception.

To avoid this issue, use the command line method to apply the patch. For more details, see https://support.radiantlogic.com/hc/en-us/articles/12795702674964-Known-Issue-Updating-from-v7-4-3-to-v7-4-4 

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: 
https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact:

support@radiantlogic.com
