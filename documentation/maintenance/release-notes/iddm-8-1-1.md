---
title: RadiantOne Identity Data Management v8.1.1 Release Notes
description: RadiantOne Identity Data Management v8.1.1 Release Notes
---

# RadiantOne Identity Data Management v8.1.1 Release Notes

September 30, 2024

These release notes contain important information about new features and improvements for RadiantOne Identity Data Management v8.1.1.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Bugs](#bugs)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [API-1594]: Improved the input validation error messages that the API returns to provide clearer, more useful messages when client request errors occur. 
- [API-1811]: Updated import data source behavior to provide more useful responses when failures occur. 
- [API-1834]: Addressed multiple issues encountered when installing v8.1 from a configuration exported from v7.4 when the exported configuration was missing ROOT ACI. 
- [API-1842]: Improvement to automate the creation the caches on secondary objects (from joins) and display warnings or “helper” text to guide user on additional steps like configuring cache refresh strategy. 
- [API-1849]: Added a version details attribute to the rootDSE alongside the product version. 
- [API-1867, API-2022, API-2100]: Added support for SSO into Control Panel leveraging OIDC. 
- [API-1902]: Added support for choosing LDIFZ when exporting files from Control Panel. 
- [API-1933]: Added support for Compare Schemas in Control Panel > Setup > Data Catalog > Data Sources > SCHEMAS tab (for selected data source). 
- [API-1947]: Added code signing to enforce security best practices. 
- [API-1953]: Improved default log viewer lines for tasks to be 250 and max to be 2000.
- [API-1957]: Improvement so when a dynamic group is created and then the “MANAGE GROUP” option is used, SUBTREE is now selected as the default scope (instead of BASE). 
- [API-1983]: Improvement so when a data source is deleted, all associated schemas (default and added schemas) will also be deleted. 
- [API-1985]: Added partial success toast notifications when importing data sources when not all of them were able to be imported.
- [API-1987]: Removed deprecated database templates from Control Panel > Setup > Data Catalog > Template Management. 
- [API-1989]: Improved efficiency of large LDIF file downloads to prevent out of memory errors. 
- [API-2005]: Added the ability to edit the base DN of identity views created from LDAP backends. 
- [API-2013]: Deprecated Directory tree wizard, Groups Builder wizard, and Groups Migration wizard. 
- [API-2025]: Added support to manage all LDIF files under  <RLI_HOME>/vds_server/conf from File Manager.  
- [API-2026]: Improvement to hide extra escape characters from data preview in Control Panel > Manage > Directory Browser. 
- [API-2031]: Support for assigning any user in the RadiantOne namespace to a delegated admin group allowing them to log into the Control Panel. 
- [API-2035]: Added support for managing access tokens from Control Panel > Admin > Access Tokens. 
- [API-2049]: Allow  configuration of standard and custom alerts from Classic Control Panel. 
- [API-2050]: Updated the built-in MySQL template to use the MariaDB JDBC driver. 
- [API-2061]: Set default max size limit to be 1000 for searches in the Control Panel > Manage > Directory Browser. Also, preconfigure the selected DN from directory browser when creating a new search. 
- [API-2067]: Improved the permissions to access the File Manager in the Classic Control Panel. Two new  vdPrivileges: `file-manager-read` and `file-manager-write` have been added. These permissions are assigned by default to the Directory Administrators group and a new group named File Manager Admin. 
- [API-2071]: Improved the product version date displayed in the Control Panel UI to have a locale-agnostic format. 
- [API-2093]: Deprecated`ldap.xml`, `database.xml`, and `custom.xml` files.  These configurations are now managed by ZooKeeper. 
- [API-2129]: Removed the default value configured for IMPERSONATE ROLE in the Classic Control Panel section in Control Panel > Admin > Roles and Permissions to avoid issues. 

 
## Security Vulnerability Fixes

- [API-1964]: Upgraded the Jackson jars to 2.17.2 to remediate potential vulnerabilities.  
- [API-1965]: Upgraded the Apache CXF jars to 3.5.9 to address CVE-2024-32007. 
- [API-2029]: Fixed vulnerabilities in @uiw/react-codemirror, @uiw/codemirror-extensions-basic-setup, @uiw/codemirror-themes. 
- [API-2113]: Upgraded the Spring libraries to 5.3.39 to address CVE-2024-38809. 
- [API-2116]: Upgraded to junit-4.13.1 to address CVE-2020-15250. 
- [API-2117]: Upgraded Apache Commons to 1.14 remediate potential vulnerabilities. 
- [API-2118]: Upgraded the commons-dbcp2 jar to 2.12.2 to remediate potential vulnerabilities. 

## Bugs

- [API-1617]: Fixed an issue with extracting large schemas resulting in the operation timing out. 
- [API-1711]: Fixed an issue where large schemas would cause the compare schemas functionality to fail. 
- [API-1835]: Fixed issues related to importing and/or downloading large LDIF files (e.g. backups of RadiantOne Directories) which were returning error code 500 due to timeouts. 
- [API-1847]: Fixed a problem with updating a node that links to an existing identity view. When you change the link node’s view, it now properly refreshes the tree and the URL. 
- [API-1875]: Fixed a problem with mounting container and content node types in identity views from database backends. 
- [API-1878]: Fixed an issue that logged many false alarm error messages when executing interception scripts. 
- [API-1879, API-1988, API-2024]: Fixed issues related to special characters in DNs in the directory browser. 
- [API-1901]: Fixed an issue so that adding/deleting primary objects from inaccessible or non-existent data sources returns more descriptive error responses. 
- [API-1907]: Fixed an issue when creating a new schema with the same name as a recently deleted one. 
- [API-1939]: Fixed an issue in the code that was decoding special character encoded DNs from URL paths. 
- [API-1945]: Fixed an issue that caused custom templates to not be saved during restarts on multi-node deployments. 
- [API-1946]: Fixed an issue when updating a data source and selecting None in the SDC connector list. 
- [API-1952]: Fixed an issue so that when deleting a naming context, the dialog box now says, “Delete Naming Context” instead of “Delete Node.” 
- [API-1961]: Fixed an issue with selecting/deselecting attributes with search filter in the object builder map and filter dialog. 
- [API-1962]: Fixed an issue with redirection after creating a new schema and deleting a schema. 
- [API-1963]: Improved the efficiency of the directory browser search tabs and resolved caching issues that prevented eager refreshing of the data.  
- [API-1967]: Fixed an issue with export/import data sources from other environments. 
- [API-2030]: Fixed an issue with testing user authentication from the directory browser UI. 
- [API-2037]: Allow multiple roles to be assigned when creating access tokens. 
- [API-2040]: Improved experience when migrating configurations between environments by including user created templates and drivers during import and export. This update also fixes the problem of imported data sources being labeled with the incorrect type (e.g., "Generic"). 
- [API-2041]: Fixed persistent cache logic to properly detect if a cache has been initialized or not so the proper status can be displayed in the UI. 
- [API-2044]: Fixed issue where users were created with empty attributes for fields that were not filled out whereas the LDAP attributes should not be created at all. 
- [API-2054]: Fixed an issue so that File Manager in Classic Control Panel supports downloading of .zip files.  
- [API-2060]: Fixed an issue when adding a primary object in the object builder. 
- [API-2072]: Fixed a frontend caching issue that prevented Optimize Linked Attributes button from changing its enabled/disabled state. 
- [API-2077]: Fixed an issue that caused importing of database data source templates with driver jars to fail. 
- [API-2081]: Fixed an issue with UI caching that prevented changes to naming contexts from being seen in other screens. 
- [API-2085]: Fixed an issue caused by over-optimizing some subject based ACIs evaluation. 
- [API-2086]: Fixed issues related to updating existing data sources. First issue was that data sources already existing in an SDC group could not be saved. The second issue was the browse base DN did not use updated properties when updating an LDAP data source. 
- [API-2090, API-2091]: Fixed a problem in Control Panel > Setup > Directory Namespace > Namespace Design > Object Builder when trying to add a related object onto the canvas due to invalid RDN name. 
- [API-2098]: Fixed issues related to proxy views to directory backends not working when creating environments with an export from v7.4. 
- [API-2099]: Fixed an issue that prevented custom data source templates from being synchronized across nodes. 
- [API-2101]: Fixed an issue with loading entries on Control Panel > Manage > Directory Browser when logged in as non-Directory Administrator users due to issues retaining the full user DN. 
- [API-2006, API-2108]: Fixed input validation for relationship hierarchy paths to allow identity views to be created (container/contents) from objects related in the schema. 
- [API-2111]: Fixed an issue where reconfiguring a real-time connector to a different connector type caused the connector config properties to not be saved. 
- [API-2120]: Fixed issues that prevented copying of sync topologies from one environment to another. 
- [API-2134]: Fixed issue with the frontend validation for CRON expression containing */2. 
- [API-2154]: Fixed an issue with extract schema link not working for database sources when no schemas are present

## Known Issues

- Loading/refreshing on Directory Namespace > Namespace Design > *selected naming context* > Object Builder is sometimes slow and the user is prompted to *SAVE* before exiting the tab even if they have recently saved.
- Loading/refreshing on Data Catalog > Data Sources > *selected data source* > Schema is sometimes slow.
- developer.radiantlogic.com site is in the process of having broken links and missing images fixed.
- Upgrades to v8.1 from earlier versions of RadiantOne aren't supported yet.
- AWSKMS is not supported yet in Security > Attribute Encryption.
- Modification of encrypted attributes fails from the Directory Browser.
- Importing LDIFZ files is not supported yet.


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues


## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
