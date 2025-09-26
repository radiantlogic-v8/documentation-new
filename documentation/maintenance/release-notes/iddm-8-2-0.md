---
title: RadiantOne IDDM v8.2.0 Release Notes
description: RadiantOne IDDM v8.2.0 Release Notes
---

# RadiantOne Identity Data Management v8.2.0 Release Notes

September 26, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.2.0

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-2170]: Introduced a new Connector SDK to support integration with data sources that don't include an out-of-the-box template. 
- [API-3091]: Improvement so Radiant Logic license keys can be updated in self-managed deployments without needing to restart the service.
- [API-3123]: Updated templates for creating Entra ID data Sources. Old graphapi (deprecated) template was removed and the mgraph template was renamed to Microsoft Entra ID.
- [API-3153]: Updated the attribute creation validation to compare the new attribute names against existing ones case-insensitively. Example: sn and SN are treated as the same; if SN already exists, creating sn is not allowed.
- [API-3174]: Added a loading spinner that displays until the cloning of a data source completes in Data Catalog > Data Sources.
- [API-3209]: Removed the “stop/start” and “server control panel” buttons on the Classic Control Panel since those are not needed for SaaS and/or self-managed environments.
- [API-3210]: Multiple OIDC improvements. Renaming OIDC Config to a name that already exists now returns a 409 conflict response. The DN Mapping expressions are now required on the OIDC configuration. Updated wording on Control Panel login screen when both IDP and username+password options are available.
- [API-3232,SQ-631]:Improvement to Kafka data sources so that the truststore and password properties are optional.
- [API-3331,SQ-717]: Improvement to Classic Control Panel > Settings > Configuration > File Manager to allow LDAP Server Schema LDIF files to be added, deleted, and/or edited. 
- [API-3335,SQ-714]: Improvement to allow the following special characters in data source names: $, -, _, . Data sources with any other special characters (aside from the four listed above) in their name will be blocked from all data source operations except for viewing, cloning, and/or deleting. The data source name character restrictions will also apply to data source names that are used in all of the other resources (i.e. schemas, views, etc.). Only the four special chars listed above will be allowed. The data source name character restrictions will also apply to data sources being pulled in from previous versions. i.e., a data source in a previous version with a special character that is apart from the four listed above can only be viewed, cloned and deleted in v8.1.2.
- [API-3346,SQ-608]: Improvement to sort the “Required Attributes” and “Optional Attributes” lists by name (ascending) in Control Panel > Setup > Directory Namespace > Directory Schema > LDAP Schema -> Object Classes. Also sorted the ORX schema file names by name (ascending) in Directory Schema -> Extend from ORX -> ORX Schema File.
- [API-3374, SQ-777]: Improvement so that the page size setting is configurable for SCIM data sources.
- [API-3375,SQ-783]: Increased schema attribute limits for schema extraction to avoid issues when extracting large schemas of over 1,000 attributes.
- [API-3383,SQ-791]: Added support for "." in naming context names.
- [API-3411]: Added the client id property to the template for Microsoft Entra ID data sources.
- [API-3412,SQ-808]: Improvement to allow uploading of certificate files in Classic Control Panel > Settings > Configuration > File Manager.
- [API-3414,SQ-817]: Multiple Kafka improvements. When a user deletes a truststore file, we now update the respective producer properties with the removal of the ssl truststore file and password. When producing kafka messages, we now create a new KafkaProducerOp with new properties so we always take the latest properties.


## Security Vulnerability Fixes

- [API-3349]: Updated org.apache.commons:commons-lang3 to version 3.18.0 to address CVE-2025-48924.
- [API-3400]: Updated Spring Boot to 3.5.5 to address CVE-2025-48989.
- [API-3401]: Updated the Netty library to 4.1.125.Final to address CVE-2025-55163.

## Bug Fixes

- [API-3129]: Fixed an error where adding a content/container node to a child label node caused a 400 error response.
- [API-3178]: Fixed the design of the File Upload area in Directory Namespace > Directory Schema > Extend from LDIF tab so that it now stretches to fill the entire height of its container.
- [API-3237,SQ-633]: Fixed an issue with how we get the data source name for Kafka sources, so it won't potentially be null during test connection, and if it is, providing a sensible fallback. 
- [API-3242,SQ-396]: Fixed an issue where password policy was not working properly when performing an LDAP Modify operation via Proxy Authorization.
- [API-3268,SQ-629]: Fixed an issue with being unable to view the expected RootDN in the BaseDN selection dropdown when creating data sources from eDirectory backends, despite the bind account having administrative privileges.
- [API-3299]: Fixed an issue with duplication of the 'objectClass' attribute during new user creation resulting in the entry failing to be created in the backend directory.
- [API-3314]: Fixed an issue that caused the Classic Control Panel > Settings > Security > Password Policy settings page to not load properly.
- [API-3328]: Fixed an issue where the Manage Groups configuration in the Control Panel > Manage > Directory Browser did not handle values properly, therefore removing last member was not possible.
- [API-3330,SQ-711]: Fixed an issue of filtering of naming contexts on the Control Panel > Setup > Directory Namespace > Namespace Design.
- [API-3332]: Fixed an issue where deleting naming context nodes was deleting child content/container nodes from the view files.
- [API-3342,SQ-561]: Fixed an issue where deleting any naming context would reset the dynamic groups' membership attribute to "member" in views mounted in other naming contexts.
- [API-3345,SQ-716]: Fixed an issue in the text overlay on Scheduler Task Manager > Task List so the Name column text doesn't overlap into adjacent columns.
- [API-3357,SQ-761]: Fixed an issue where the first search name is deleted when a new search tab is opened in the directory browser. It now sends a request to save tabs when clicking the New Tab button, and allows users to create a new search tab from the root without specifying a DN.
- [API-3396,SQ-801]: Fixed an issue so that enabling the optimized linked attributes feature on a cache will now automatically add any linked attributes to the list of extension attributes on the UI.
- [API-3415,SQ-813]: Fixed an issue to properly mask values of sensitive properties for data sources.
- [API-3416]: Fixed an issue with what was defined as required properties for SCIM data sources.
- [API-3417]: Fixed an issue where the Oauth token property for SCIM data sources was being returned to UI in encrypted format.
- [API-3435]: Fixed an issue in the export template functionality that was returning the error: org.springframework.core.io.buffer.DataBufferLimitException: Exceeded limit on max bytes to buffer


## Known Issues

- After updating to v8.2.0, you may see the following harmless error in the vds_server.log and install logs: `ERROR org.apache.curator.framework.imps.CuratorFrameworkImpl:703 - Background exception was not retry-able or retry gave up java.lang.NullPointerException: null 	at org.apache.curator.framework.imps.EnsembleTracker.configToConnectionString(EnsembleTracker.java:185)`. You can safely ignore this error message.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com


If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com


