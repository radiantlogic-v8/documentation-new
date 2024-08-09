---
title: v7.4.11 Release Notes
description: v7.4.11 Release Notes
---

# RadiantOne v7.4.11 Release Notes

August 2, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerabilities](#security-vulnerabilities)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS43919, 45818]: Improved using Kafka as a source/target in sync pipelines. 
-	[VSTS45720]: Improvement to temporarily deactivate the save button for one second after it's clicked to prevent the user from spamming the save button in a short time interval. 
-	[VSTS46301]: Added code signing to enforce security best practices. 
-	[VSTS46437]: Improved ACL configuration to load more child nodes/branches on the main screen to select where to define access controls at. 
-	[VSTS46713, 46438]: Updated the graphapi custom data source to support adding and updating extension attributes. Also fixed issues with synchronizing on-prem user passwords into Entra ID. **NOTE** - you need to manually update files in: <RLI_HOME>/bin/ad_pwd. These files are located in Sharefile in the same location as the v7.4.11 updater files. Also, the .NET framework 4.8 and VC++ distributable v14.38+ must be installed on the RadiantOne machine.   
-	[VSTS46480]: Improvements to the Control Panel > Settings > Server Front End > Advanced section so that the “Windows Settings” section is hidden for non-windows deployments and removed the deprecated ODBC Path property. For Windows deployments, the Run as a Service checkbox is replaced with an option to only disable the service (if the Windows service is uninstalled and you want to stop/start/restart the service from the Control Panel again) 
-	[VSTS46725]: Improved Okta custom data source to handle rate limiting. Page size is configurable by adding a "pagesize" integer property on the Okta data source configuration.  Page size applies directly to users and applications, but page size for groups is automatically limited to avoid excessive timeouts.  Page size for group list requests will be either the configured page size or 30% of the rate limit, whichever is less. The rate limit of 50 requests/minute is assumed. This can be overridden by adding a "ratelimit" property to the Okta data source (integer number of requests/minute). 
-	[VSTS46747]: Added "ocspResponderURL" in Control Panel > Settings > Security > SSL > Certificate Revocation List to be used in case the certificate doesn't include the URI. 
-	[VSTS46845]:  Added support for OpenJDK 8u422. 
-	[VSTS46909]: Improvement to have vdsconfig get-ctx-prop and set-ctx-prop support the “inchangelog” property, which allows a user to enable/disable changelog on specific naming contexts. 

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

-	[VSTS46788]: Updated org.springframework version to address: CVE-2024-22259, CVE-2024-22243, and CVE-2024-22262.  

## Bug Fixes

-	[VSTS45668]: Fixed an issue where the user password was not hashed properly in the persistent cache during the cache initialization phase. 
-	[VSTS46514]: Fixed an issue with nested groups not working for enforcing access controls. 
-	[VSTS46332]: Fixed Global Sync Rules, attribute mapping so that the target ObjectClass lists all object classes properly when the destination view has mapped backend proxy views. 
-	[VSTS46529]: Fixed an issue with export/import data sources with v7.4.8, 7.4.9 and v7.4.10. 
-	[VSTS46679]: Fixed possible duplicate binds being sent to backends upon bind failure. 
-	[VSTS46696]: Fixed an issue with ACI's target filtering processes that could fail due to a race condition. 
-	[VSTS46710]: Fix to remove vddn attributes from entries that are converted from a persistent cache into a RadiantOne Directory store to avoid objectclass violations when schema checking is enabled. 
-	[VSTS46712]: Fix to add built-in functions to Global Sync to encode/decode base64 attributes without the {base64binary} prefix. 
-	[VSTS46752]: Fixed an issue with Control Panel > Settings > Log > Log Settings > Advanced Properties section so that the values are properly escaped so the section loads properly. 
-	[VSTS46780]: Fixed an issue where Server Control Panel > Log Viewer was not displaying logs for users associated with the ReadOnly role (member of the cn=readonly group). 
-	[VSTS46801]: Fixed an issue when adding merge links below an existing merge link. 
-	[VSTS46913]: Fixed issues with the Entra ID websocket service not stopping gracefully when all RadiantOne services are stopped. Also addressed issues where more than one websocket service could be running at the same time. 
-	[VSTS46933]: Fixed an issue where TLS/SSL connections to backend data sources were failing when RadiantOne was running in FIPS-mode due to the change in JDK behavior where TLS 1.3 was configured to be used by default in the handshake negotiation, and the library used in FIPS-mode doesn’t support this TLS version yet. 

## Known Issues/Important Notes

-	Related to item 46529, data sources exported using the "Export" button (in the Control Panel UI) in versions 7.4.8 and 7.4.9, 7.4.10 cannot be imported into other environments. If you need to migrate configurations, use the vdsconfig utility commands (resource-export, resource-import, export-datasource, import-datasource). Starting in v7.4.11, data sources exported using the Control Panel can be imported into other environments. In v7.4.11 the vdsconfig command also supports an optional cross-environment flag for flexibility to differentiate between local backups of data sources and migrating to different environments: use the cross-environments flag to migrate data sources to other environments/clusters. 

-	Related to item 46438, you need to manually update files in: <RLI_HOME>/bin/ad_pwd. These files are located in Sharefile in the same location as the v7.4.11 updater files in a folder named ActiveDirectoryPasswordCapture. Also, the .NET framework v4.8 and VC++ distributable v14.38+ must be installed on the RadiantOne machine.   

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

