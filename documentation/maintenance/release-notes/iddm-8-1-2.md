---
title: RadiantOne Identity Data Management v8.1.2 Release Notes
description: RadiantOne Identity Data Management v8.1.2 Release Notes
---

# RadiantOne Identity Data Management v8.1.2 Release Notes

December 23, 2024

These release notes contain important information about new features and improvements for RadiantOne Identity Data Management v8.1.2.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bugs](#bugs)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements


- [API-1336]: Populated the section and description fields of the cache refresh connector properties in the Control Panel UX to assist with configuration. 
- [API-1763]: Improvement to ensure that the export LDIF operation performed from Directory Browser uses the logged in user as a proxy user to ensure that the correct permissions/access are used.
- [API-1954]: Added validation of LDIF files to ensure they are syntactically accurate prior to importing them into RadiantOne.
- [API-1955]: Added support for Snowflake for real-time persistent cache refreshes: Timestamp Connector type.
- [API-2042]: Added support for on-prem password sync (getting existing hash) for Active Directory over SDC connections.
- [API-2158]: Multiple improvements:
Added a new helper function to ScriptHelper for getting the Active Directory password hash. 
Updated behavior of license banner in Control Panel to display expiration date for license. 
Fixed loading of stats for Global Id Builder projects that are actively processing. 
Added ability to configure Global Sync rules independently for upload & realtime behavior.
- [API-2164]: The ClearAttributesOnly and Special Users groups are not designated as default delegate admin roles for Control Panel anymore.
- [API-2165]: File Manager access to the folder “/opt/radiantone/vds/certs” has been enabled.
- [API-2168]: Added sAMAccountName as a required attribute when creating a new 'group' type of entry.
- [API-2179]: Added an option to `vdsconfig` utility that allows to export data as a folder instead of exporting as zip package.
- [API-2183]: Added new permissions for exporting & importing configurations.     
- [API-2240]: Added a new "Scan Folder" property for Access Log management on self-managed instances.
- [API-2335, API-2246]: Added caching layer to schema files to improve read times for large schemas. This is feature-flagged to enable/disable.
- [API-2268]: Updated the Classic control panel to force any new view filenames to lowercase.
- [API-2285]: Added datasource schemas when exporting datasources using `vdsconfig resource-export`
- [API-2351]: Added ability to associate LDAP data source failovers with an SDC group.
- [SMD-54]: Added self-managed deployment support for Google Cloud.
- [SMD-55]: Added self-managed deployment support for Redhat OpenShift.

 
## Security Vulnerability Fixes

- [API-2222,2223, 2224, 2244 and 2245]: Upgraded to Spring Boot 3.3.5 to address CVE-2024-38819 and CVE-2024-38821.
- [API-2232]: Upgraded jetty server version from 9.4.53.v20231009 to 9.4.56.v20240826 to address CVE-2024-8184.
- [API-2243]: Upgraded Spring security libs updated from 5.7.12 to 5.7.13 to address CVE-2024-38821.
- [API-2290]: Upgraded the cross-spawn library to resolve vulnerability to address CVE-2024-21532.
- [API-2294]: Upgraded spring-security-web and spring-security-config to 6.3.5 to remediate potential vulnerability and encoded characters errors.
- [API-2302]: Upgraded to 0.6.0 of unplugin to address CVE-2024-43788.
- [API-2303]: Upgraded oidc-clint-ts to 3.1.0 to address CVE-2024-21536.



## Bugs

- [API-1692]: Fixed the download real-time cache DB Changelog connector scripts endpoint, so that the downloaded zip file is not corrupted. 
- [API-1938]: Fixed an issue where the Data Catalog > Data Sources was not allowing users to sort the data sources in the table by name or type. 
- [API-2127]: Fixed an issue where the directory browser service was having issues retrieving and returning very large entries.  The directory browser service is now able to return a successful response when a dn with a very large number of entries is requested.
- [API-2142]: Restored the ADAPLB data source type that existed in prior versions for accessing ADAP through load balancers. 
- [API-2169]: The Task Scheduler can now be started and stopped with no issues. All attributes can be configured without issues. Stopping the task scheduler will now be a synchronous action and the user will have to wait until the task scheduler has been stopped before performing other UI actions.
- [API-2278]: Fixed an issue for the NullPointerException in the get schema full object endpoint when a table is passed with a null primary keys list.
- [API-2297]: Fixed an issue where data sources with SSL enabled were occasionally not loading when previewing (browsing) the data source.
- [API-2300]: Fixed an issue where directory namespace > namespace design sometimes would redirect the user back to the dashboard when selecting a naming context.
- [API-2323]: Fixed an issue where the object builder was returning a null for the source of a mapped attribute that did not have a matching table name. 
- [API-2329]: Fixed an issue where the object builder was showing an empty list of attributes for a joined input source with an object class of *.
- [API-2331]: Fixed an issue that broke the rename schema functionality.
- [API-2333]: Fixed an issue with the check to see if a cache is initialized that was blocking cache calls when a cached naming context was unreachable.
- [API-2337]: Fixed an issue where customers migrating from 8.0.x were having login issues due to new permission attributes introduced in v8.1 not being added to out-of-the-box groups during migration. This fix added the new permission attributes to existing out-of-the-box during RadiantOne startup after migration.
- [API-2338]: Fixed an issue where data sources from the classic control panel in an older version of RadiantOne with SDC-mapped failovers were failing to parse in the newest version of RadiantOne.
- [API-2340]: Removed restriction on usage of certain special characters in data source names.
- [API-2342]: Fixed an issue where naming contexts with whitespaces would cause details panel to not properly appear.
- [API-2344]: Fixed an issue so that legacy custom data sources will now automatically migrate and continue functioning on upgrades to the latest 8.1.x.
- [API-2348]: Fixed an issue related to configurations where joins exist with duplicate target object classes and target base DNs.
- [API-2349]: Fixed an issue where the advanced search page would freeze due to improper use of tanstacks useReactTable hook.
- [API-2350]: Fixed an issue where LDAP data sources with failovers defined that leveraged SDC configurations were having the failovers duplicated when migrating from 8.0 to 8.1.
- [API-2401]: Fixed an issue for merged backends with a comma in the merge tree DN not loading.
Also, changed the merged backend page to display the Radiantone Namespace DN value. 


## Known Issues

- Loading/refreshing on Directory Namespace > Namespace Design > *selected naming context* > Object Builder is sometimes slow and the user is prompted to *SAVE* before exiting the tab even if they have recently saved.
- Loading/refreshing on Data Catalog > Data Sources > *selected data source* > Schema is sometimes slow.
- developer.radiantlogic.com site is in the process of having broken links and missing images fixed.
- Direct upgrades to v8.1.0 from earlier versions of RadiantOne aren't supported. Using a migration (configuration exported) from v7.4.10, 8.0.3, or v8.1.0 can be used to create new v8.1.1(+) environments.
- AWSKMS is not supported yet in Security > Attribute Encryption.
- Modification of encrypted attributes fails from the Directory Browser.
- Importing LDIFZ files is not supported yet.
- [API-2355]: The edit schema functionality has been disabled as there is a known issue where it will not update dependent view files with the new schema name, because we don't have the ability currently to update the view files.
- [API-2403]: LDAP filter assist mode in Namespace Design > `[naming context]` > Advanced Settings > LDAP Filter is disabled due to a bug that currently has no workaround.
- [API-2421]: The Classic Control Panel > Wizards > Identity Data Analysis wizard has been temporarily disabled due to a bug with running analysis that has no workaround.
- Joining related objects from the same source schema as the primary object isn't working properly in Object Builder.
- FIPS-compliance mode isn't supported. It is planned for Q1 2026.


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues


## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.



