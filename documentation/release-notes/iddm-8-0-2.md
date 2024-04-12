---
title: RadiantOne IDDM v8.0.2 Release Notes
description: RadiantOne IDDM v8.0.2 Release Notes
---

# RadiantOne Identity Data Management v8.0.2 Release Notes

April 3, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.0.2.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerabilty Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [VMR-364]: Added checks for logging failures, in which case an email alert gets sent in the event of logging failure. The feature is enabled out of the box but needs to be configured to be able to send emails. In the event of a logging failure, this feature will make an attempt to alert the user, but will gracefully fail and will not interfere with the application's state if the attempt fails. 

- [VMR-500]: Improve the Secure Data Connector agent to support a proxy property for custom data sources to allow for reaching these sources through a proxy server.  

- [VMR-662]: Made an improvement so when the LDAP port or Admin HTTP port is disabled, automatically enable internal client SSL and set the cluster communication mode to always use SSL (instead of requiring this to be done manually). 

- [VMR-676]: Improved logging output for computed attributes so that runtime errors or dynamic compilation errors are easier to troubleshoot. 

- [VMR-680]: Renamed Universal Directory and HDAP to RadiantOne Directory to match new Marketing messaging. 

- [VMR-682]: Improvement to remove trace level Logging from Zookeeper. 

- [VMR-689]: Made an improvement so that the Main Control Panel > Directory Namespace nodes are still accessible, even when the internal check to determine if a persistent cache is configured for this node fails. 

- [VMR-698]: Renamed the Save button to OK in the Create New Attribute screen to avoid confusion because the SCIM schema is not saved until the user exits out of the Create New Attribute screen and clicks Save on the Create new Schema page. 

- [VMR-699]: Added a toggle to enable/disable adaptive change mode for Synchronization > Rules-based transformations to allow customers to disable this if needed, like in cases where they need more control over the LDAP operation type for handling multi-valued attributes. 

- [VMR-703]: Improved the directory namespace rendering time when hundreds of naming contexts are deployed. 

- [VMR-721]: Improvement to increase the Control Panel timeout used when backing up RadiantOne directory stores to avoid errors when backing up very large (e.g. 1 million+ entries) stores. 

- [VMR-765]: Made an improvement so that the permission filter warning is not output to the web.log every time a node is selected in the Directory Namespace tab. 

- [VMR-766]: Added AM/PM details to the Last Login Time in the Control Panel. 

- [VMR-781]: Improved the display of TLS/SSL protocols to show the ones that are actually enabled in RadiantOne rather than simply the JDK's default enabled protocols list.  

## Security Vulnerability Fixes

- [VMR-565]: Upgraded jersey-hk2 jar to 2.34 to address CVE-2021-28168. 

- [VMR-770]: Upgraded Postgres jar to 42.6.1 to remediate potential vulnerabilities. 

- [VMR-771]: Upgraded org.apache.commons:commons-comopress jar to 1.26.0 to remediate potential vulnerabilities. 

- [VMR-783]: Upgraded Spring libraries to 5.3.33 and Spring security to 5.7.12 to remediate potential vulnerabilities.   

## Bug Fixes

- [VMR-359]: Fixed an issue where when caching is enabled in the Dynamic Group Setting, the users who were added to the global groups dynamically were not able to authenticate. The Enable Caching option in Dynamic Groups is now disabled for Dynamic Group URLs pointing to branches that are not cached. 

- [VMR-429]: Fixed an issue with Context Builder > Schema Manager not using the proxy property configured in the custom data source to query SCIM data sources resulting in schema extractions failing. 

- [VMR-514]: Fixed an issue that was clearing the Main Control Panel > Settings > Server Front End > Advanced > "Run as a Windows service" checkbox on service restarts. 

- [VMR-515]: Fixed incorrect memory settings format for Windows services causing custom memory sizing to be ignored. 

- [VMR-605]: Fix to File Manager to restrict access to protected file locations. 

- [VMR-663]: Fixed an issue where the command line configuration tool was incorrectly accepting spaces for data source names. 

- [VMR-668]: Fixed an issue with the OIDC settings loading the incorrect Discovery URL. 

- [VMR-674]: Fixed an issue where both the Identity Data Analysis and Global Identity Builder Wizards were not accessible and functional from follower cluster nodes. 

- [VMR-675]: Fixed an issue with Global Identity Builder linking logic resulting from a move operation detected on a data source using an HDAP trigger. The global profile link isn’t correctly updated. 

- [VMR-677]: Fixed an issue with the following vdsconfig command: add-pwd-policy. 

- [VMR-684]: Fixed an issue where the persistent cache real-time refresh was not working on a view with a merged tree configured because the capture connectors were all listening only on the main branch/data source. 

- [VMR-685]: Fixed an issue with Synchronization so that it properly loads object classes and attributes from merge links. 

- [VMR-686]: Fixed an issue where the password reset token system now protects against the changing of special accounts. 

- [VMR-688]: Fixed an issue of being unable to configure a call to stored procedures in virtual views for MySql backends. 

- [VMR-690]: Fixed an issue where the vdsconfig get-logging property did not return a value when requested using ADAP. 

- [VMR-691]: Fixed an issue where the View Designer now properly handles adding duplicate content/container nodes by generating a new unique label if a duplicate is detected. 

- [VMR-692]: Fixed an issue where the password policy was not working with pwdChangedTime in format of microsecond. 

- [VMR-693]: Fixed an issue where the memory cache might return inconsistent search results if * (all user attributes) and/or + (all operational attributes) are part of the expected attributes. 

- [VMR-694]: Fixed an issue that was preventing the persistent cache refresh on merged trees from working properly. 

- [VMR-695]: Fixed an issue with the following vdsconfig command: add-orx-schema. 

- [VMR-700]: Fixed an issue where the Clusters tab was not working as expected. The Clusters tab buttons now work when periods are in the cluster name. 

- [VMR-702]: Fixed an issue where LDAP queries requiring controls should be rejected if the control is critical and not supported by RadiantOne Directory. 

- [VMR-704]: Fixed an issue with Synchronization, "Target Attribute Mappings" with same names in different Rules-Based-Sync Pipelines causing a file conflict and config overwrite. 

- [VMR-705]: Fixed an issue so that the AD password filter connector tries to return an entry even if the partial results exception is thrown. 

- [VMR-706]: Fixed an issue where the OIDC configuration in RadiantOne with additional scopes is being passed to the authorization server even though the user is only requesting the “openid” scope in the configuration. 

- [VMR-709]: Fixed an issue with editing Suffix Branch inclusion/exclusion from the Main Control Panel > Directory Namespace. 

- [VMR-712]: Fixed an issue with the migration tool when attribute encryption is used that would prevent the encrypted directories to be imported back. 

- [VMR-735]: Fixed an issue in Synchronization, rules-based transformation that sometimes caused target object class values to be lower-cased. Object class values will now use the exact same case as defined in the RadiantOne LDAP server schema. 

- [VMR-736]: Fixed an issue with multi-valued SCIM attributes not being formatted correctly when they only have a single value. 

- [VMR-737]: Fixed an issue with Synchronization, rules-based target attribute mappings getting overwritten across rules with the same name in different pipelines. 

- [VMR-738]: Fixed an issue in the Synchronization transformation process when the identity linkage attribute contains a special character. The automatic target DN generation was not escaping the special characters which was causing a failure in the apply process. 

- [VMR-739]: Fixed an issue with the statistics analyzer settings not saving in Main Control Panel > Settings -> Logs -> Statistics. 

- [VMR-754]: Fixed a problem with not being able to open large LDIF files in File Manager. 

- [VMR-767]: Fixed an issue of deteriorated performance when evaluating ACL’s that contain rules involving target filters. 

- [VMR-773]: Fixed the lookupAttribute function in Synchronization, rules-based topology, to handle the integer representation of scopes (0, 1, or 2) being passed in as Strings, which caused the function to return no results.  

- [VMR-774]: Fixed a problem with ACLs not properly returning requested attributes and paged search results correctly, when targetFilter is used in aci definition. 

- [VMR-775]: Fixed an issue related to read-only admin roles being able to modify settings when they should be allowed to. 

- [VMR-777]: Fixed an issue with the “modifytimestamp” attribute value getting reset every time the RadiantOne service is started. 

- [VMR-784]: Fixed an issue with synchronization that was causing the trigger capability for capturing changes in RadiantOne Directory stores to ignore modify and delete events because of a missing pre-operation entry. 

- [VMR-796]: Fixed an issue with the Server Control Panel > Usage & Activity tab > Network Latency, graph custom date/time picker that was preventing the configuration window from closing properly.
 
## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
