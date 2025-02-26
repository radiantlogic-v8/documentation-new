---
title: v7.4.13 Release Notes
description: v7.4.13 Release Notes
---

# RadiantOne v7.4.13 Release Notes

February 28, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerabilities](#security-vulnerabilities)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements

-	[VSTS40751]: Added support for TLSv1.3 when FIPS mode is enabled.
-	[VSTS46188]: Added a Move Entry action to rules-based topologies in synchronization.
-	[VSTS46316]: Added an Out of the Box Method to write logs into syncengine.log from within a Custom user-defined function in Rules-Based synchronization topologies.
-	[VSTS46318]: Added a default function for parsing and/or transforming dates in Rules-Based synchronization topologies.
-	[VSTS46319]: Added a default function to generate a string from delimited multi valued attributes in Rules-Based synchronization topologies. 
-	[VSTS46320]: Added an default function to display top 'n' values from a multi valued attribute in Rules-Based synchronization topologies. 
-	[VSTS46321]: Added an default function that gets current date and time in Rules-Based synchronization topologies. 
-	[VSTS46324]: Removed height constraints and added scroll bars when screen is resized for configurations performed from the Synchronization tab in Control Panel.
-	[VSTS46426]: Migration to v7.4.13 will automatically set max threads to the larger of 16 or the number of CPU cores. 
-	[VSTS46614]: Improvement so the RadiantOne LDAP Service properly rejects the anonymous binding based on the newer RFC 4513.
-	[VSTS46871]: Improved the generation performance for Access Log, Audit, and Group Audit reports.
-	[VSTS47011]: Added support for 'timeout' and 'connectiontimeout' data source properties (set in milliseconds) to be configurable for SCIMv2 backends. 
-	[VSTS47064]: Added additional logging into sync_engine.log for troubleshooting synchronization uploads. 
-	[VSTS47106]: Added a warning in the Control Panel UI for the mutual authentication setting to be displayed to restart the control panel and the RadiantOne service (FID) after changing. 
-	[VSTS47169]: Added an option in the Control Panel > Settings Tab > Logs > Access Logs > Advanced to ignore access log logging for queries to cn=queue.
-	[VSTS47181]: Improved the tcp packets optimizer by reducing its memory footprint which could become noticeable in highly concurrent environments with large entries in transit over the network.
-	[VSTS47191]: Removed the old Salesforce ORX and DVX files as they correspond to older attributes and do not function correctly with current Salesforce backends.  Salesforce JDBC data source connections should extract a new schema rather than using the old ones.
-	[VSTS47199]: Removed the SAML attribute service from control panel as a default disabled protocol. Customers can add it to the list of disabled protocols if needed. 
-	[VSTS47229]: Added more verbose logs during the scheduler start up process.
-	[VSTS47231]: Improved the "cluster-info" and "cluster-zk" data collector ZooKeeper write tests to now use the timeout, retry count, and retry interval from the cloud configuration to prevent false positives.
-	[VSTS47240]: Added support for OCSP CRL checking when FIPS-mode is enabled.
-	[VSTS47247]: Improved the SCIM server endpoints to now accept and return the content type application/scim+json, per the SCIM specification.
-	[VSTS47401]: Disabled the jar signing for the custom objects jar to prevent "error: Operations error : Class not found" issues seen after rebuilding the customobjects.jar when migrating configuration from v7.4.10 to v7.4.12.
-	[VSTS47418]: Updated JDK version to 8u442.



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

## Security Vulnerabilities

-	[VSTS47195]: Upgraded the Spring Framework libraries to 5.3.44 to address CVE-2024-38819 and CVE-2024-38820.	
-	[VSTS47208]: Upgraded the Spring Security version to 5.7.13.to address CVE-2024-38821.
-	[VSTS47234]: Upgraded the Derby libraries to 10.14.3.0 to address CVE-2022-46337.
-	[VSTS47235]: Upgraded the Derbynet dependency to 10.14.3.0 to address CVE-2022-46337.
-	[VSTS47288]: Upgraded Apache Kafka Clients library to 3.9.0 to address CVE-2024-56128.
-	[VSTS47318]: Upgraded Spring Security libs to 5.7.14 to remediate potential vulnerabilities.



## Bug Fixes

-	[VSTS46429]: Fixed an issue connecting to Google directory backends which was causing java.lang.NoClassDefFoundError messages.
-	[VSTS46695]: Fixed an issue where special characters used in functions and constants in synchronization rules were not escaped properly in the generated code.
-	[VSTS46865]: Fixed an issue where encrypted attributes passed to the synchronization transformation script were not decrypted properly.
-	[VSTS46997]: Fixed an issue where the Control Panel > Context Builder > Schema Manager was not saving the correct data source for schema. The unsaved changes popup now displays whenever the data source has been modified in the Schema Manager ensuring changes are saved.
-	[VSTS47062]: Fixed an issue where passwords and encrypted attributes in LDAP CompareRequest requests were incorrectly visible in the access logs. 
-	[VSTS47114]: Fixed an issue with the log level not saving properly when it is changed from Control Panel > Settings Tab > Logs > Log Settings.
-	[VSTS47130]: Fixed an issue where the write redirecting traffic from follower to leader was not functioning properly when 'Proxy Authorization' is enabled.
-	[VSTS47131]: Fixed an issue where duplicate naming contexts (e.g. cn=system-registry) were being created in 7.4.x when migrating from 7.2.x and 7.3.x.
-	[VSTS47142]: Fixed an issue where the threshold was not properly calculating the floating point values. The fix allows for better accuracy when calculating.
-	[VSTS47157]: Fixed an issue where the SCIM client incorrectly handled meta attributes that were needed for caching.
-	[VSTS47160]: Fixed an issue so that the synchronization transformation script editor compiles script upon opening to prevent users from saving invalid script contents.
-	[VSTS47176]: Fixed an issue where ldap search controls passed via interception scripts were not passed by the RadiantOne service to the ldap backend. ModifyRDN operations via interceptions scripts are currently not supported.
-	[VSTS47178]: Fixed an issue where regular joins with an existing view fails for dvx file names with uppercase letters. New views created in the Control Panel now ensure view names are lowercase. 
-	[VSTS47180]: Fixed an issue where one change (add/delete/modify) on password policy triggered multiple write operations, which could cause inconsistent state and confusing log information.
-	[VSTS47186]: Fixed an issue where the alias attribute entryUUID was not being returned when paging is used to search on persistent cache.
-	[VSTS47216]: Fixed an issue in rules-based synchronization topologies code generation that caused some advanced attribute mapping scenarios (granular changes like add values/delete values) to be incorrectly generated when the new globalsync.extract.mappings.enabled flag was enabled.
-	[VSTS47218]: Fixed an issue where the cluster.bat command did not save output for all commands. Added more verbose logging to the cluster.bat commands. 
-	[VSTS47230]: Fixed an issue where the Kafka consumer connector worked incorrectly when multiple clusters pointed at the same topic using the same configuration in RadiantOne.
-	[VSTS47233]: Fixed an issue that caused certain subattributes to be corrupted in SCIM response data.
-	[VSTS47239]: Fixed an issue related to the wildcard search including multiple special characters with an additional & or | character.
-	[VSTS47241]: Fixed an issue in the destination entry lookup that could cause an issue when the destination lookup attributes were set to empty lists. Also added a new logic for direct attribute mappings (A>B) so that when an entire source attribute is deleted, the corresponding target attribute is also deleted. 
-	[VSTS47244]: Fixed an issue where the task scheduler JVM settings filtered out characters in quoted strings.
-	[VSTS47246]: Fixed an issue where the search timelimit was not honored properly which can cause the monitoring threads to pile up and idle longer than necessary.
-	[VSTS47248]: Fixed an issue with deleting attributes/values from Okta backend data sources. The Control Panel would indicate that the deletion of the attribute/value from Okta was successful even if it wasn't.
-	[VSTS47337]: Fixed an issue where the email password was logged in clear text on send test email in the web.log.
-	[VSTS47362]: Fixed an issue with the PBE handshaking that could prevent a follower node to join a RadiantOne cluster at installation time.
-	[VSTS47364]: Fixed an issue that caused the task scheduler to be in a hung/deadlock state causing tasks to be stuck in a "running" state and the task scheduler being unable to be restarted. 
-	[VSTS47403]: Fixed an issue in the service display names when installing RadiantOne Windows services.



## Known Issues/Important Notes


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

