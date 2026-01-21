---
title: RadiantOne IDDM v8.3.0 Release Notes
description: RadiantOne IDDM v8.3.0 Release Notes
---

# RadiantOne Identity Data Management v8.3.0 Release Notes

January 14, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.3.0

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-2004]: Added schema improvements to the Control Panel: Added an “Unlink Schema” option. Reworded the “Link Schema” menu label. Filtered ORX schema files to exclude already linked schemas and updated the linking modal title.
- [API-2042]: Added support for Active Directory password hash extraction over SDC connections.
- [API-3252]: Added input error validation for “BASE DN” when configuring access controls so the error notification does not trigger automatically when you pause typing, informing the user silently of the search not matching the value typed.
- [API-3278]: Migrated REST (ADAP) configuration from Classic Control Panel into the new Control Panel > Global Settings > Client Protocols > REST.
- [API-3279]: Migrated External Token Validators configuration from Classic Control Panel into the new Control Panel > Global Settings > Token Validators.
- [API-3280]: Migrated Limits configuration from Classic Control Panel into the new Control Panel > Global Settings > Tuning > Limits.
- [API-3281]: Migrated Global Attribute Handling configuration from Classic Control Panel into the new Control Panel > Global Settings > Tuning > Attributes Handling.
- [API-3282]: Migrated Changelog configuration from Classic Control Panel into the new Control Panel > Global Settings > Tuning > Changelog.
- [API-3283]: Migrated Log Settings from Classic Control Panel into the new Control Panel > Global Settings > Tuning > Log Settings.
- [API-3376, SQ-778]: Added the ability to Initialize a Persistent Cache by uploading a file from the local computer.
- [API-3377, SQ-779]: Added support for handling trailing whitespaces on attribute values from backends when generating an LDIF file for persistent cache initialization.
- [API-3397, SQ-469]: Added an option to vdsconfig that allows to export a single topology (with related contexts). Topology name should be specified in the format "source_context->target_context". Example command: `./vdsconfig.sh resource-export -name "ou=some,o=context->o=another_context."
- [API-3418, SQ-626]: Enabled sorting and filtering of custom alerts in Classic Control Panel.
- [API-3425, SQ-813]: Improved the handling of properties for default custom data sources to hide sensitive values in the Control Panel for some attributes. 
- [API-3561]: Added settings to manage audit logging from Control Panel > Admin section.
- [API-3450]: Added support for JSON formatting of audit logs and added the ability to log the before and after value for changes.
- [API-3452, SQ-412]: Added support for real-time persistent cache refreshes of contacts and devices for virtual views from Entra ID.
- [API-3509]: Added option in Control Panel to allow deleting tasks that are in unscheduled/finished/error/interrupted states.
- [API-3590]: Added a new Log4j2 appender that is responsible for writing to the JSON log files.
- [API-3602]: Added new Control Panel permissions for global limits, custom limits, change log, and global attributes.
- [API-3660]: Added an option in Control Panel > Manage > Security > Access Control > General support "ALLOW ANONYMOUS ACCESS LEGACY BEHAVIOR". By default the 'Allow Anonymous access legacy Behavior' is disabled. 
- [API-3692]: Added support for OpenJDK 8u472
- [API-3813]: Improvement for handling schema attribute names with invalid characters (., _, , /, *, @, $, or #). These are automatically remapped to sanitized versions with the special characters removed.
- [API-3820, SQ-1087]: Improved the search box under Final Object Output in the Object Builder, so it is no longer case sensitive.
- [API-3889]: Added configurable log settings for custom data sources/connectors in Control Panel > Global Settings > Tuning > Log Settings.  Note: these new log settings only apply to connectors built using the new Connector SDK. Older custom objects will still be logging into vds_server.log, and use the log settings for this.

## Security Vulnerability Fixes

- [API-3579]: Upgraded the spring boot version from 3.5.5 to 3.5.6 to address CVE-2025-41249 and CVE-2025-41248.
- [API-3931]: Upgraded to qs@6.14.1 to address CVE-2025-15284.


## Bug Fixes

- [API-3162]: Fixed an issue so that the migration tool import now removes old SDC configurations from data sources.
- [API-3347, SQ-718,SQ-582]: Fixed an issue where admins were unable to download log files from a specified server by adding a log download browser experience to the Classic Control Panel > Server Control Panel > Log Viewer. 
- [API-3353]:Fixed an issue where the add data source template button remained active while template is being added. The Loading state from the Import process is now used to dictate when the Loading Spinner on the “ADD” button should show up, informing the user of the current process ongoing.
- [API-3372]: Fixed an issue where the Directory Browser returned a 400 error code for entries that were not found because of an LDAP error code 32 (No Such Object). It will now return a 404 error.
- [API-3460]: Fixed an issue with related objects in the object builder breaking the entry RDN making it impossible to view the entries.
- [API-3491]: Fixed connector properties for LDAP backends to properly note them as required or optional.
- [API-3504]: Fixed an issue where Real-time cache refresh diagnostics now properly detects and creates required dependency cache locations when pointing to children nodes of proxy views.
- [API-3507]: Fixed an issue related to the migration utility during migration imports in case of resource key collisions.
- [API-3508]: Fixed an issue in the Task Manager where tasks failed when going from scheduled to unscheduled and saving.
- [API-3522,  SQ-911]: Fixed an issue where large (25+ MB) schemas could not be fetched.
- [API-3523]: Fixed the data source SDC mapping process to skip calls to the SDC API for data sources with no SDC group mapping.
- [API-3562, SQ-946]: Fixed an issue where schemas were not linked to the data sources when using the migration utility to import the configuration.
- [API-3559]: Fixed an issue with missing DB changelog script templates.
- [API-3588]: Fixed an issue so that the "Manage Drivers" page will no longer show built-in JDBC drivers as those are not editable by the user. It will only show JDBC drivers that have been manually uploaded by end users.
- [API-3594, SQ-515]: Fixed an issue where saving an LDAP data source could change its backend type if the search on the backend fails.
- [API-3597, SQ-947]: Fixed an issue in the object builder where computed attributes were adding a duplicate origin precedent attribute.
- [API-3601]: Fixed an issue where the Cache initialization page now properly displays the latest cache initialization task for the naming context.
- [API-3612]: Fixed an error that occurs when deleting a Microsoft Entra ID data source.
- [API-3624,3628 SQ-882 port]: Fixed an issue where the ADAP bulk operations endpoint did not always return a proper JSON structure even in the event of an unexpected exception.
- [API-3625, SQ-994]: Fixed an issue where objects restored back and deleted again from a backend Active Directory were not getting deleted from the persistent cache. 
- [API-3646]: Fixed an issue that could cause the Object Builder tab to crash when switching between different naming contexts.
- [API-3663, SQ-610, SQ-907]: Fixed an issue with adding attributes to a newly created custom object class in the RadiantOne Directory LDAP Schema.
- [API-3689]: Fixed an issue where deleting an entry in Control Panel > Directory Browser, would cause errors after loading more entries.
- [API-3691]: Fixed an issue where the Migration Export/Import Fails with "StatusLogger Unable to Access" Error.
- [API-3724]: Fixed an issue that caused legacy mgraph connector configurations to be erroneously determined as the wrong type.
- [API-3754]: Fixed an issue where the Control Panel > Directory Browser could throw a 431 error if the HTTP request contained a very large authorization header.
- [API-3777]: Fixed an issue where the LDIF export from the Control Panel > Directory Browser disabled the "file format" list.
- [API-3780]: Fixed an issue where the synchronization apply process was not detecting the SDC group ID for an Active Directory data source causing the sync process to fail.
- [API-3792, SQ-1057]: Fixed an issue where admins could not clear the invariant attribute field in the cache’s properties > Attributes Handling section.
- [API-3793, SQ-1066]: Fixed an issue that prevented admins from clearing the SQL Filter (Where Clause) field in a database virtual view’s Advanced Settings.
- [API-3882, SQ-1123]: Fixed OIDC login issues encountered when the token user is mapped to a user in a virtual view of an LDAP backend. Also fixed an issues when an admin user attempts to log into the Control Panel with a username and password that is in a virtual view of an LDAP backend.


## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

- The following error is sometimes seen in the vds_server.log after a migration import: <br>
  `ERROR org.apache.curator.framework.imps.CuratorFrameworkImpl:703 - Background exception was not retry-able or retry gave up
   java.lang.NullPointerException: null.` This error is harmless and can safely be ignored. 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com


If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com

