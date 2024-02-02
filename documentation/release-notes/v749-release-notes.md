---
title: v7.4.9 Release Notes
description: v7.4.9 Release Notes
---

# RadiantOne v7.4.9 Release Notes

February 2, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS45841]: Made an improvement so that the (main) Zookeeper.log and the rotated log will be stored in the same folder by default.  
-	[VSTS45591]: Made an improvement so that the Main Control Panel > Directory Namespace nodes are still accessible, even when the internal check to determine if a persistent cache is configured for this node fails. 
-	[VSTS46143]: The Main Control Panel > Global Sync tab was renamed to Synchronization to match new Marketing messaging. 
-	[VSTS46163]: Improved logging output for computed attributes so that runtime errors or dynamic compilation errors are easier to troubleshoot. 
-	[VSTS46167]: Renamed the Save button to OK in the Create New Attribute screen to avoid confusion because the SCIM schema is not saved until the user exits out of the Create New Attribute screen and clicks Save on the Create new Schema page. 
-	[VSTS46171]: Added a toggle to enable/disable adaptive change mode for Synchronization > Rules-based transformations to allow customers to disable this if needed, like in cases where they need more control over the LDAP operation type for handling multi-valued attributes. 
-	[VSTS46174]: Made an improvement so when the LDAP port or Admin HTTP port is disabled, automatically enable internal client SSL and set the cluster communication mode to always use SSL (instead of requiring this to be done manually). 
-	[VSTS46210]: Renamed Universal Directory and HDAP to RadiantOne Directory to match new Marketing messaging.  
-	[VSTS46219]: Improvement to remove trace level Logging from Zookeeper.  
-	[VSTS46230]: Improved the directory namespace rendering time when hundreds of naming contexts are deployed. 
-	[VSTS46340]: Made an improvement so that the permission filter warning is not output to the web.log every time a node is selected in the Directory Namespace tab. 
-	[VSTS46345]: Added AM/PM details to the Last Login Time in the Control Panel. 
-	[VSTS46360]: Made an improvement so that the ZooKeeper tab is only accessible to directory administrator users. 
-	[VSTS46370]: Updated JDK version to 8u402-b06.

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
-	[VSTS44301]: Fixed an issue where when caching is enabled in the Dynamic Group Setting, the users who were added to the global groups dynamically were not able to authenticate. The Enable Caching option in Dynamic Groups is now disabled for Dynamic Group URLs pointing to branches that are not cached.  
-	[VSTS45176]: Added new VdPrivileges: admin-write, logs-read, and security-write to allow more control/delegated administrator roles access to pages previously restricted to super users only. 
-	[VSTS45382]: Fixed an issue of being unable to configure a call to stored procedures in virtual views for MySql backends.  
-	[VSTS45561]: Fixed an issue with multi-valued SCIM attributes not being formatted correctly when they only have a single value. 
-	[VSTS45644]: Fixed an issue where the persistent cache logs are empty when the RadiantOne leader is switched to a follower node. The persistent cache monitoring log requests are now forwarded to the leader node or the agent host. 
-	[VSTS45751]: Fixed an issue with Global Identity Builder linking logic resulting from a move operation detected on a data source using an HDAP trigger. The global profile link isn’t correctly updated. 
-	[VSTS45766]: Fixed an issue where the vdsconfig get-logging property did not return a value when requested using ADAP.  
-	[VSTS45789]: Fixed an issue in Synchronization, rules-based transformation that sometimes caused target object class values to be lower-cased. Object class values will now use the exact same case as defined in the RadiantOne LDAP server schema. 
-	[VSTS45797]: Fixed an issue where the View Designer now properly handles adding duplicate content/container nodes by generating a new unique label if a duplicate is detected.  
-	[VSTS45899]: Fixed an issue where the password policy was not working with pwdChangedTime in format of microsecond. 
-	[VSTS45921]: Fixed an issue where the memory cache might return inconsistent search results if * (all user attributes) and/or + (all operational attributes) are part of the expected attributes.   
-	[VSTS46025]: Fixed an issue that was preventing the persistent cache refresh on merged trees from working properly. 
-	[VSTS46064]: Fixed an issue where the password reset token system now protects against the changing of special accounts. 
-	[VSTS46067]: Fixed an issue where both the Identity Data Analysis and Global Identity Builder Wizards were not accessible and functional from follower cluster nodes. 
-	[VSTS46115]: Fixed an issue with the following vdsconfig command: add-orx-schema. 
-	[VSTS46173]: Fixed an issue with the following vdsconfig command: add-pwd-policy. 
-	[VSTS46175]: Fixed an issue where the command line configuration tool was incorrectly accepting spaces for data source names.  
-	[VSTS46178]: Fixed an issue where the Clusters tab was not working as expected. The Clusters tab buttons now work when periods are in the cluster name.  
-	[VSTS46189]: Fixed an issue with the OIDC settings loading the incorrect Discovery URL. 
-	[VSTS46202]: Fixed an issue where LDAP queries requiring controls should be rejected if the control is critical and not supported by RadiantOne Directory. 
-	[VSTS46227]: Fixed an issue with the migration tool when attribute encryption is used that would prevent the encrypted directories to be imported back.  
-	[VSTS46238]: Fixed an issue with Synchronization, rules-based target attribute mappings getting overwritten across rules with the same name in different pipelines. 
-	[VSTS46241]: Fixed an issue with Synchronization so that it properly loads object classes and attributes from merge links. 
-	[VSTS46242]: Fixed an issue so that the AD password filter connector tries to return an entry even if the partial results exception is thrown. 
-	[VSTS46245]: Fixed an issue where the OIDC configuration in RadiantOne with additional scopes is being passed to the authorization server even though the user is only requesting the “openid” scope in the configuration. 
-	[VSTS46284]: Fixed an issue with editing Suffix Branch inclusion/exclusion from the Main Control Panel > Directory Namespace. 
-	[VSTS46367]: Fixed an issue with the web update installer which was causing the updates from v7.4.8 to fail. 
-	[VSTS46379]: Fixed an issue with the statistics analyzer settings not saving in Main Control Panel > Settings -> Logs -> Statistics. 
-	[VSTS46391]: Fixed an issue in the Synchronization transformation process when the identity linkage attribute contains a special character. The automatic target DN generation was not escaping the special characters which was causing a failure in the apply process. 
-	[VSTS46393]: Fixed an issue with using Target Filters in ACIs which was causing performance issues. 
-	[VSTS46395]: Fixed an issue in Synchronization so that the automatic code generation in rules-based topologies for the lookUpAttribute function properly uses double-quotes around the scope. 
 
## Known Issues/Important Notes
Related to VSTS46367: There is an issue with using the web update installer to update from RadiantOne v7.4.8 to v7.4.9 resulting in the following error in web.log: 

ERROR com.rli.install.web.filters.ExceptionFilter:36 - Caught unexpected exception.org.apache.jasper.JasperException: An exception occurred processing JSP page [/WEB-INF/jsp/update_confirmation.jsp] at line [61] 

Either use the command line option to update from v7.4.8 to v7.4.9. Or, you can run a shell script prior to launching the web-based UI to run the update installer. More details can be found in the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/articles/23259692147604-Known-Issue-Updating-from-v7-4-8-to-v7-4-9) 

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

