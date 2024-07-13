---
title: RadiantOne IDDM v8.1.0 Release Notes
description: RadiantOne IDDM v8.1.0 Release Notes
---

# RadiantOne Identity Data Management v8.1.0 Release Notes

July 1, 2024

These release notes contain important information about new features and improvements for RadiantOne Identity Data Management v8.1.0.

These release notes contain the following sections:

[New Features](#new-features)

[Improvements](#improvements)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## New Features
- [API-327]: Added support for automatic schema extraction for LDAP data sources. When an LDAP/Active Directory data source is created, the schema is automatically extracted.
- [RO-654]: Added support for the creation of new templates to connect to JDBC-accessible source and custom data sources.
- [API-1758]: Published new, refactored APIs to the developer.radiantlogic.com documentation site.
- [RO-971]: Added the ability to manage access tokens (for accessing RadiantOne SCIM, REST and Configuration API endpoints) from the Control Panel.
- [UX-2]: Added a dedicated section in the Control Panel for managing RadiantOne Admin accounts.
- [API-1237]: Added the ability to create new delegated admin roles for RadiantOne in the Control Panel.

## Improvements

- [RO]: Refactored Control Panel to provide an easier, more streamlined configuration and identity view building experience.
- [DOC]: Published user guides for RadiantOne Identity Data Management v8.1 to developer.radiantlogic.com. Select the v8.1 version from the drop-down list after clicking SEE ADMIN DOCUMENTATION on the main page.

 
## Known Issues

- Loading/refreshing on Directory Namespace > Namespace Design > *selected naming context* > Object Builder is sometimes slow and the user is prompted to *SAVE* before exiting the tab even if they have recently saved.
- Loading/refreshing on Data Catalog > Data Sources > *selected data source* > Schema is sometimes slow.
- OIDC support for SSO into the Control Panel isn't supported yet.
- Comparing differences between an extracted schema file and the current backend data source schemas in the Data Catalog isn't supported yet.
- developer.radiantlogic.com site is in the process of having broken links and missing images fixed.
- Admin section > Access Tokens to call the RadiantOne API has been temporarily hidden in the UI due to an issue that will be addressed in an upcoming patch.
- Upgrades to v8.1 from earlier versions of RadiantOne aren't supported yet.
- Self-managed deployments of v8.1 using Helm charts is expected mid-July 2024.
- AWSKMS is not supported yet in Security > Attribute Encryption.
- Identity views that have joins must have the secondary views cached manually before caching the main view.
- When mounting database backends, you are unable to add content nodes based on objects from the same schema.
- Modification of encrypted attributes fails from the Directory Browser.
- Importing LDIFZ files is not supported yet.
- Extracting a large schema, occasionally results in timeouts in Data Catalog > Data Sources.
- Issues exporting RadiantOne Directory stores from Directory Browser.

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
