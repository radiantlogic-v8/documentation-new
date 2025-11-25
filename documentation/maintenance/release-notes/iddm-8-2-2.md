---
title: v8.2.2 Release Notes
description: v8.2.2 Release Notes
---

# RadiantOne v8.2.2 Release Notes

November  19, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v8.2.2.

These release notes contain the following sections:

* [Security Vulnerability Fixes](#security-vulnerability-fixes)
* [Known Issues/Important Notes](#known-issuesimportant-notes)
* [How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

For specific hardware requirements of each, read the [system requirements](../system-requirements/v74-system-requirements/) guide. 

## Security Vulnerability Fixes
- [API-3743-3745, SQ-1043]: Addressed the following vulnerabilities. <br>
  - CVE-2020-11979, CVE-2022-41853, CVE-2024-47554, CVE-2025-41248, CVE-2025-41249, CVE-2025-48989
  - CVE-2025-55163, CVE-2025-55754, CVE-2025-58056, CVE-2025-58057, CVE-2025-58187, CVE-2025-58188
  - CVE-2025-59250, CVE-2025-61723, and CVE-2025-61725.

## Known Issues / Important Notes

**Important update regarding HSQLDB and Microsoft SQL Server Data Sources in v8.2.2**

In version **v8.2.1**, two important vulnerabilities were identified in  `hsqldb-1.8.0.10.jar` and `mssql-jdbc-7.2.2.jre8.jar`.

These two JAR files are JDBC drivers that provide connectivity to **HSQL databases** and **Microsoft SQL Server**.  
**As a precaution, these JAR files have been proactively removed from the product starting in v8.2.2.**

As a result, any data sources (newly created or existing) that use **HSQLDB** or **Microsoft SQL Server** will no longer be able to establish a connection out of the box.

To restore connectivity, you will need to manually upload newer versions of the affected JDBC drivers. You can find available JDBC drivers at the locations listed below or directly on the vendor’s website:

- **HSQLDB:** <https://mvnrepository.com/artifact/org.hsqldb/hsqldb>  
- **Microsoft SQL Server:** <https://mvnrepository.com/artifact/com.microsoft.sqlserver/mssql-jdbc>

> Ensure that the versions you select are compatible with **Java 8**.

#### How to Upload the JDBC Drivers

1. Log in to the new Control Panel.
2. Open the menu in the top-right corner and select **“Open classic control panel.”**
3. In the classic Control Panel, navigate to **Settings > Configuration >  File Manager**.
4. In File Manager, navigate to **RLI_HOME/lib/jdbc/custom**
5. Click **“Upload files”** and upload the updated JDBC driver JARs.
6. Once the upload is complete, return to the new Control Panel and use **“Test Connection”** on your data sources to verify that connectivity has been restored.


For known issues reported after the release, please see the Radiant Logic Knowledge Base: 
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.
