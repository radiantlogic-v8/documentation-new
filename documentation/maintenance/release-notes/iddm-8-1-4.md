---
title: RadiantOne IDDM v8.1.4 Release Notes
description: RadiantOne IDDM v8.1.4 Release Notes
---

# RadiantOne Identity Data Management v8.1.4 Release Notes

July 28, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.1.4

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-326]: Added support for importing data sources that have been exported in v7.4.
- [API-2218] Added support for multiple SSO providers for logging into Identity Data Management. 
- [API-2124]: Enhanced mgraph custom data sources to fetch user MFA status details from Entra ID view. These attributes have been added to the mgraph default schema (.orx file).
- [API-2269]: Added cn=queue to Classic Control Panel > Settings > Logs > Access Logs > Advanced to allow exclusion of logging related to queries for certain naming contexts.
- [API-2279]: Added support for configuration promotion pipelines for automating configuration migration across environments. This serves as an alternative to manual resource-export/resource-import. For self-managed deployments, configure via Control Panel > Global Settings > Configuration Promotion (after manual Git setup). SaaS users can configure source/target environments and the pipeline via the Environment Operations Center.
- [API-2288,SQ-197]: Added date and time to archived access log file names to make it easier to identify access logs for specific dates.
- [API-2535]: Added support for Content-Type=application/scim+json headers to Radiant Logic's frontend SCIM API.
- [API-2784, SQ-342]: Added a "Successfully logged out" message upon logout from the Control Panel.
- [API-2785, SQ-341]: Added support for a configurable "message of the day" display in the new control panel.
- [API-2845, SQ-343]: Added support for an internal banner configuration in the new control panel. The settings to control this behavior are in the classic control panel. The banner text will appear in the navbar at the top of the page when logged in. If no colors are set, it will seamlessly work with the existing theme. If colors are set, then a colored section will appear in the navbar. The banner text is also displayed at the top of the right-hand section on the login page.
- [API-2846, SQ-349]: Added cluster name in the subject and body of test email alerts.
- [API-2868]: Made Mutual Authentication settings visible and configurable in the classic control panel for self-managed deployments.
- [API-2888]: Improved UI error messages in Control Panel > Directory Browser to clarify why an LDAP operation is being rejected.
- [API-2890]: Added support for creating Kafka data sources (for synchronization) via the control panel.
- [API-2932]: Added all supported custom data source properties to the Data sources UI.  
- [API-3001]: Added validation for data source names to allow only alphanumeric characters and ., $, and _.
- [API-3103]: Made improvement to Control Panel > Directory Browser for adding entries and editing attribute values.
- [API-3180]: Added a warning popup when modifying member attributes values in dynamic groups.
- [API-3175]: Improved error messages that are displayed when using the "Test Connection" feature on MySQL datasources after upgrading from v8.0.4 to v8.1.4. The enhanced logging now provides clearer detail related to missing or invalid meta types error. 


## Security Vulnerability Fixes

- [API-2541]: Updated SSO endpoint to resolve potential CSRF vulnerability.
- [API-2748]: Upgraded the Spring libraries to address CVE-2025-22228.
- [API-2831,2935]: Upgraded Apache Tomcat to version 10.1.40 to address CVE-2025-24813.
- [API-2938]: Upgraded to Axios 1.9.0 to address CVE-2025-27152.
- [API-2939, 3154]: Upgraded babel/runtime to 7.27.6 to address CVE-2025-27789.
- [API-3004,3054 and 3155]: Upgraded to Spring Boot 3.5.3 to address CVE-2025-46701.
- [API-3155]: Upgraded the Jetty version from 9.4.56.v20240826 to 9.4.57.v20241219 to address CVE-2024-13009.

## Bug Fixes

- [API-1392]: Fixed an issue where the 'Settings > Other Protocols' page in the classic control panel was not saving changes.
- [API-1936]: Fixed an issue where the data source page save failed because it did not send the correct payload for SDC Group on Save/Test connection.
- [API-2429]: Fixed an issue with the suffix branch exclusion/inclusion lookup modal, so that when selecting the Suffix Branch Exclusion/Inclusion> Advanced Settings> Select Base DN, the list of branches is now displayed. 
- [API-2456]: Fixed an issue that caused attribute deletions in Okta data sources to fail.
- [API-2468, SQ-284]: Fixed various Control Panel defects with the naming context stored procedure wizard.
- [API-2514, SQ-222]: Fixed an issue where the Control Panel > Browser did not display the Dynamics Groups tab to manage members when the group was a dynamic group.
- [API-2567, SQ-235]: Fixed an issue where Single Sign-On (SSO) from the new control panel (CP) to the classic control panel failed in self-managed environments.
- [API-2568, SQ-243]: Fixed an issue with object builder to block changes on views that are cached and added a message in Control Panel to inform the user when a view is cached and is read-only.
- [API-2571]: Fixed an issue for adding related objects in the Control Panel > Directory Namespace > Namespace Design > object builder.
- [API-2599]: Fixed an issue where switching to expert mode in the Classic Control Panel would log the user out.
- [API-2600,SQ-245]: Fixed an issue where the latest status and logs were not updated whenever auto refresh was enabled when navigating to the cache initialization screen.
- [API-2659,SQ-259]: Fixed an issue where nested RadiantOne Directory backends within a Proxy backend couldn't have special attributes assigned.
- [API-2711]: Fixed an issue where the entry's distinguished name was exposable when the search expected attribute was set as '1.1' or 'dn' which could by-pass ACI rules.
- [API-2734]: Fixed an issue where the task Scheduler was going into a hung state.
- [API-2837]: Fixed an issue with related objects attribute mappings in the object builder.
- [API-2874]: Fixed an issue with the SCIM server URL generation in the Classic Control Panel. 
- [API-2880]: Fixed an issue where SCIM endpoints now return a 401-Unauthorized instead of a 500 when invalid credentials are used. 
- [API-2944]: Fixed an issue where the Control Panel > Directory Browser entries with special characters in the DN would cause an error if the user logged out and then immediately back in.
- [API-2949, SQ-375]: Fixed an issue where the download log file endpoint when redirecting to leader was not properly handling zip archive files.
- [API-2956]: Fixed an issue where when trying to start the task scheduler it would require multiple attempts to start.
- [API-2967]: Fixed an issue to properly display LDIFZ files in File Manager, and ensure automatic file sync across RadiantOne nodes includes encrypted LDIFZ files.
- [API-2991]: Fixed an issue where only the first 50 root naming contexts would appear in the Control Panel > Directory Namespace > Namespace Design.
- [API-2997]: Fixed an issue where the Kafka data sources broke when updating from v8.0.4 to v8.1.3. Introduced a migration to handle converting legacy Kafka data sources into the new format.
- [API-3021]: Fixed an issue where schema objects were not properly validated. A new object modal in schema manager was redesigned so that either a new object class can be created or an existing object class can be used. 
- [API-3036]: Fixed an issue where the object builder API blocked saving.
- [API-3037]: Fixed an issue where the default search timeout was too slow in the Directory Browser. Improvement made to the timeout to be a minimum of 30 seconds.
- [API-3046]: Fixed an issue where the Classic Control Panel would not open.
- [API-3056]: Fixed an issue where the real-time cache connector properties that contain passwords did not mask their values in the Control Panel where they configured from.
- [API-3057]: Fixed an issue where in updating from a v8.0.x env to a v8.1.x env resulted in a ClassNotFoundException when attempting to create resources (such as data sources, schemas, etc).
- [API-3062]: Fixed an issue where the cache configuration failed when saving the refresh type as periodic.
- [API-3095]: Fixed an issue with the automatic JDBC file sync configuration.
- [API-3105]: Fixed an issue where the object builder would get stuck in the staging branch and view files were missing. Any detected missing view files are recreated.
- [API-3107]: Fixed an issue on the new/edit custom data source page where the "Test Connection" button was not calling the correct API for custom data sources, resulting in connection test failures.
- [API-3120]: Fixed an issue in the Control Panel > Directory Browser where placing a single value in a multi-valued attribute failed.
- [API-3122]: Improvement made to the exception logging if a naming context's compound object is null which was resulting in nullPointerException errors when mounting an LDAP backend (pointing to a RadiantOne Directory) at a Root Naming Context.
- [API-3126]: Fixed an issue where the Boolean properties on the edit data sources screen blocked continuing when marked was required.
- [API-3127]: Fixed an issue with importing Kafka data sources from v7.4. 
- [API-3135, SQ-525]: Fixed an issue where special attributes referential integrity rules validation did not allow referential integrity rules that point to RadiantOne Directory store when mounted in subtrees or cache subtrees.
- [API-3137]: Fixed an issue where mapped object class is no longer required in the LDAP Proxy Advanced Settings.
- [API-3158]: Fixed broken icon links on the Control Panel dashboard.


## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
