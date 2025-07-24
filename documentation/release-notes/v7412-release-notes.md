---
title: v7.4.12 Release Notes
description: v7.4.12 Release Notes
---

# RadiantOne v7.4.12 Release Notes

November 5, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Deprecated Features](#deprecated-features)

[Security Vulnerabilities](#security-vulnerabilities)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS40945]: Improvement to the Mgraph custom datasources so user can now access attributes that require $select queries.
-	[VSTS44535]: Added a reload schema button to the View Designer.
-	[VSTS45636]: Added number of CPU cores per node to the Control Panel > Dashboard tab.
-	[VSTS45783]: Updated the default mgraph custom data source to use v1.0 API instead of beta.
-	[VSTS45951]: Added move node up and move node down buttons to the View Designer.
-	[VSTS46232]: Added support for multiple expressions to computed attributes. 
-	[VSTS46233]: Improved persistent cache init task logs so that when a persistent cache initialization failure occurs, there is more context about the error in the cache init task log.
-	[VSTS46373]: Added a warning message that appears when navigating away from the SCIM tab in Control Panel when there are unsaved changes. 
-	[VSTS46486]: Allow custom time limits to be configurable.
-	[VSTS46587]: Added a new flag, isFromUpload, to all events in sync pipelines so that rules can be written to perform different operations based on if the pipeline is an upload or not.
-	[VSTS46680]: Added samAccountName as a required field for objectclass group.
-	[VSTS46740]: Added support for SHA-3 for password protection when RadiantOne is running in FIPS mode.
-	[VSTS46744]: Improved memory configuration in windows service install scripts to better match behavior of previous versions. 
-	[VSTS46904]: Improved the Computed Attributes configuration in the Context Builder so that they can now be reordered.
-	[VSTS46926]: Added support for Snowflake as a Database for realtime persistent cache refresh.
-	[VSTS46929]: Added the ability to decrypt exported LDIFz files using the ldiz-to-ldif command in vdsconfig.
-	[VSTS46932]: Added FID_SERVER_JOPTS to runVDSServer.sh and CP_SERVER_JOPTS to runWebAppServer.sh
-	[VSTS46938]: Added support for MFA enabled users to create service accounts using Azure AD Initialization tool and provided an option to enter data source name for the custom data source created in RadiantOne.
-	[VSTS46941]: Improved sensitive information masking in logs.
-	[VSTS46952]: Improvement to not allow the root account CN=Directory Manager to be deleted. 
-	[VSTS46957]: Removed DSML/SPML Service from the new naming context popup since these are deprecated.  Removed SPML targets section from Settings -> Server Front End -> Other Protocols.
-	[VSTS46968]: Fixed a type conversion bug with SCIMPost that could cause boolean values for attributes like primary to throw an exception. Also added a new mode (isDirectValueModeForPatch) to control whether SCIM Patch operations are generated with or without the path parameter. This is necessary to get around a Condeco SCIM limitation.
-	[VSTS46980]: Added support for "certificateUserIds" in mgraph custom data source during create and update of users.
-	[VSTS46990]: Added a confirmation dialog popup message when deactivating naming contexts and/or caches to protect against accidently deactivation. 
-	[VSTS47057]: Added a license expiration message in the Control Panel so admins receive a visual notification.
-	[VSTS47085]: Added method to ScriptHelper to extract the password hash from the AD domain.
-	[VSTS47129]: Ensured runVDSServer.sh and runWebAppServer.sh scripts are executable after updating to 7.4.12.
-	[VSTS47132]: Added support for OpenJDK 8u432.
-	[VSTS47143]: Removed DES3 cipher option from the list of available ciphers for attribute encryption/LDIFZ attribute encryption keys.


## Deprecated Features
- SAML Attribute Service.

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

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide.

## Security Vulnerabilities

-	[VSTS46984]: Updated the following Apache CXF dependencies from 3.4.10 to 3.5.9: cxf-rt-rs-json-basic, cxf-rt-rs-security-jose, cxf-core, cxf-rt-security to address the following CVE-2024-28752, CVE-2024-29736 and CVE-2024-32007.
-	[VSTS47014]: Upgraded Spring dependencies from 5.3.36 to 5.3.39 to address CVE-2024-38809.
-	[VSTS47015]: Upgraded com.fasterxml.jackson dependencies from 2.13.5 to 2.17.2 to address to remediate potential vulnerabilities. 

## Bug Fixes

-	[VSTS46558]: Fixed an issue that caused a global sync toplogy to not be migrated if its source or destination points to a starting point that is not a root naming context but is instead a child within a naming context.
-	[VSTS46819]: Updated profile-password for mgraph Azure AD users to reflect that it is required for creation.
-	[VSTS46826]: Fixed an issue that caused an UnsupportedOperationException during ZooKeeper config export on Windows.
-	[VSTS46827]: Fixed an issue where the modifiersName attribute is missing if the change operation is through proxied authorization by "cn=Directory Manager".
-	[VSTS46868]: Fixed an issue for the "Export for replication" option in the Directory Browser -> Export LDIF window to take effect.
-	[VSTS46920]: Fixed an issue that prevented deleting subtrees in external LDAP data sources. Caused by mistakenly sending multiple tree delete controls in the LDAP delete request.  
-	[VSTS46942]: Fixed an issue where Global Identity Builder stats would timeout while upload was ongoing.
-	[VSTS46956]: Fixed an issue that caused exceptions during persistent cache initialization for Okta backends when certain attribute values were null.
-	[VSTS46965]: Fixed an issue so that after enabling vds_access logs, logging starts immediately without requiring a restart of the RadiantOne service.
-	[VSTS46967]: Fixed an issue where the connection to failover nodes within a RadiantOne cluster was not functioning in resync-utils.bat tool, which results in inconsistent state when the leadership changes.
-	[VSTS46975]: Fixed an issue where the password strength rule was not properly saved on the Password Policy page.
-	[VSTS46977]: Fixed an issue where ADAP token validators JSON Web Token Validation Clock Offset was not getting saved.
-	[VSTS46979]: Fixed an issue that prevented copying of a sync topology from one environment to another. Vdsconfig resource traverse is now considering parent resources as dependencies (along with child resources).
-	[VSTS46982]: Fixed an issue in update-custom-datasource where the active property wasn't being updated correctly. Updated DataSourceStatusUtility (used by checkdatasources.sh) so that it automatically fails on data sources that are marked as "offline" or disabled.
-	[VSTS46986]: Fixed an issue where the Password policy CLI and UI were not consistent with each other.
-	[VSTS46989]: Fixed an issue that was caused by over-optimizing some subject based ACIs evaluation. 
-	[VSTS46996]: Removed the default public read-access ACIs to cn=config and cn=changelog and also their corresponding legacy ACI structure.
-	[VSTS47000]: Fixed an issue that causeed the ldif-utils command to hang when sending LDIF changes to a cluster that is configured with ZooKeeper in SSL/TLS mode.
-	[VSTS47001]: Fixed an issue that caused the vdsconfig add-aci CLI command to create new ACI LDAP entries without their expected object class values.
-	[VSTS47016]: Fixed an issue for the Directory Namespace tab label nodes not saving virtual attributes.
-	[VSTS47028]: Fixed an issue so that now failure when sending a monitoring alert email is now reported in the monitoring task's scheduler log to help improve troubleshooting.
-	[VSTS47029]: Fixed an issue where there was no ability to change the access.log.file.archive.scan.folder property from the UI. 
-	[VSTS47152]: Fixed an issue with Synchronization transformation scripts hitting a Java limitation of 65k bytes and the code being unable to compile. After applying the patch, the "$RLI_HOME/config/advanced/features.properties" file needs to be updated to add the following line, before the RadiantOne services is started on the cluster nodes: globalsync.extract.mappings.enabled=true <br> Lastly, the transformation script needs to be saved after the RadiantOne service is started for the first time after patching and updating the features.properties file.

-	[VSTS47153]: Fixed an issue that was preventing sync topologies that were migrated between patch versions (e.g., 7.x.y to 7.x.z where y <= x) from starting properly because of missing transformation mappings.
-	[VSTS47158]: Fixed an issue causing NullPointerException to be reported in web.log when capturing mappings transformations.

## Known Issues/Important Notes

-	Data sources exported using the "Export" button (in the Control Panel UI) in versions 7.4.8 and 7.4.9, 7.4.10 cannot be imported into other environments. If you need to migrate configurations, use the vdsconfig utility commands (resource-export, resource-import, export-datasource, import-datasource ). Starting in v7.4.11, data sources exported using the Control Panel can be imported into other environments. In v7.4.11 the vdsconfig command also supports an optional cross-environment flag for flexibility to differ between local backup of data sources and diff environment migration. 

-	Related to item 46438, you need to manually update files in: <RLI_HOME>/bin/ad_pwd. These files are located in your Radiant Logic support portal account in the same location as the v7.4.11 updater files. Also, the .NET framework 4.8 and VC++ distributable v14.38+ must be installed on the RadiantOne machine.   

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

