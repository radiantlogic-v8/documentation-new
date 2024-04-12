---
title: RadiantOne IDDM v8.0.1 Release Notes
description: RadiantOne IDDM v8.0.1 Release Notes
---

# RadiantOne Identity Data Management v8.0.1 Release Notes

February 8, 2024

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.0.1.

These release notes contain the following sections:

[Improvements](#improvements)

[Security Vulnerabilty Fixes](#security-vulnerability-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

- [VMR-303]: Improvement to sync changes to JDBC drivers (added/updated/deleted) across all RadiantOne Identity Data Management nodes. 

- [VMR-313,413,157]: Added the ability to generate an Entry Statistics Report from Main Control Panel > Settings > Configuration. 

- [VMR-317]: DoS filtering configuration is hidden in the interface. This kind of filtering should be configured at the level of the load balancer if it is needed. 

- [VMR-418]: Added an SDC group selector to individual LDAP data source failover settings. 

- [VMR-600]: Start and stop buttons are removed in control panel. To start or stop, user must now use the options in Environment Operations Center. 

- [VMR-657]: Importing data sources with an invalid Secure Data Connector group configured displays a warning and allows the user to import without the Secure Data Connector configuration. 

- [VMR-658]: Saving an LDAP, DB, and custom data sources with Secure Data Connector configs works when data sources have been deleted from the Secure Data Connector and also when the data source already exists in the Secure Data Connector. 

- [VMR-655]: Added support for cluster names containing underscores in the installation. 

- [VMR-666]: LDAP data sources with failovers configured for the Secure Data Connector are now deleted when the parent data source is deleted. 

- [VMR-667]: Improvement to prevent multiple failovers with the same host, port and Secure Data Connector group. 

- [VMR-719]: Added support to automatically sync directory store backup files across RadiantOne cluster nodes. 

## Security Vulnerability Fixes

- [VMR-558]: Upgraded Jetty libraries to 94.4.53 and included new transitive dependency (util-ajax) for vulnerability remediation. 

- [VMR-559]: Updated aws java-sdk libraries from version 1.11.38 to version 1.12.261 for vulnerability remediation. 

- [VMR-562]: Updated guava library version from 20.0 to 24.11-jre and added missing guava dependency (failureaccess:1.0.1) for guava:32.0.0-jre for vulnerability remediation. 

- [VMR-568]: Updaated not-yet-commons-ssl package from 0.3.9 to 0.3.17 to address vulnerability CVE-2014-3604. 

- [VMR-591 & VMR-592]: Updated the Apache commons-httpclient library for vulnerability remediation detailed in CVE-2012-5783 and Improper Certificate Validation. 

- [VMR-593]: Updated opensaml version to 2.6.6 for vulnerability remediation. 

## Bug Fixes

- [VMR-305]: Fixed an issue where the control panel became unavailable when viewing large log files in the log viewer. 

- [VMR-314]: Fixed an issue where all members of the directory administrators role (except for superadmin) were unable to view the SCIMv2 schemas and resource types.  

- [VMR-320]: Fixed an issue where the vdsconfig create-ldap-datasource command did not properly detect the backend is type Active Directory. 

- [VMR-374]: Fixed an issue with the file name of the exported file when trying to download from the Export Data Sources page. 

- [VMR-409]: Fixed an issue where the custom classes created for interception scripts were not removed after the deletion of the source file and the rebuild of the intercept.jar was completed.  

- [VMR-412]: Fixed an issue where the build change event jars option did not update the “changeEventConvertors.jar” with the compiled class file even though it was updated in the classes folder.  

- [VMR-419]: Fixed an issue where the test connection hangs when the SDC client disconnects or goes down. 

- [VMR-422]: Fixed an issue where when a file is deleted from the following folder : “vds/vds_server/ldif/” on one of the nodes (fid-1), it did not get deleted in the other node (fid-0). 

- [VMR-424]: Fixed an issue where the file manager was not uploading files that were larger than 50MB. 

- [VMR-476]: Fixed an issue where files were not properly synchronized across nodes and fsync*.tmp files were not deleted from the/tmp.folder. 

- [VMR-507]: Fixed a timeout issue in Global sync when trying to save the transformation scripts.  

- [VMR-532]: Fixed bugs with export/import of data sources that use SDC (Secure Data Connector) groups.  

- [VMR-645]: Fixed an issue where if the hostname in the URL of a database data source does not match the case in the on-prem host field, it would not be replaced properly with the mapped hostname.  

- [VMR-668]: Fixed an issue where Control Panel > Settings > OIDC Provider Configuration was using the wrong discovery URL. 

- [VMR-670]: Fixed an issue with importing data sources that were exported in a different PBE environment.

- [VMR-717]: Fixed an issue where LDIF files managed through File Manager were not being properly synchronized across RadiantOne cluster nodes.  

- [VMR-742]: Fixed an issue with delete requests in the Control Panel causing delete schema operations to not work on follower nodes. 

## Known Issues

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com