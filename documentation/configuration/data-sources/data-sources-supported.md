---
title: Data Sources Supported
description: Data Sources Supported
---

This document describes the supported backend data sources supported by RadiantOne.

## Supported Identity Data Sources

### LDAP Directory Servers	

- Microsoft Active Directory 2008 or higher
- Active Directory Lightweight Directory Service (AD-LDS)
- Active Directory Application Mode (ADAM)
- SunONE Directory Server 4.X – 7.X
- Sun Java System Directory v6.X
- IBM Directory Server v5 or higher
- Novell eDirectory v8 or higher
- IBM Domino (formerly Lotus Domino)
- Oracle Internet Directory v9 & v10, Oracle   Directory Server Enterprise Edition (ODSEE)
- CA Directory r12.X
- Any LDAP v3 Service

### Database Servers	

- Oracle 8i, 9i, 10g, 11g, 12c
- Microsoft SQL Server v2008 or higher
- IBM DB2 (UDB) v7 or higher
- Sybase v12 and 12.5
- MongoDB
- Snowflake
- Terradata
- Any JDBC-accessible database

The following JDBC drivers are installed with RadiantOne by default for convenience, but may be insufficient for your use cases: Oracle (thin), Oracle oci, Microsoft SQL Server, HSQL, MySQL (supports MariaDB too), IBM DB2, Sybase, and Derby. For all other databases, import your own JDBC driver in Control Panel > Setup > Data Catalog > Template Management.

You have the option to use one of the above drivers, however, it is recommended that you use the driver that was delivered with the database that you want to connect to. Also, some of the drivers provided in the install for convenience don't support SSL/TLS access to the database server. You might need other libraries (additional .jar files) from the vendor to support this. These additional files must also be associated with the database template. Consult your database vendor documentation for driver details.

### Cloud Directory Services

- Entra ID (formerly Azure AD)
- PingOne
- Okta Universal Directory

### Applications/Other**

- SAP
- Siebel v7.5+
- Oracle Financials v12+
- Salesforce
- Google Apps/Directory
- SharePoint 2010, 2013, 2016 (on-premises)
- Workday
- Concur
- Any SCIM-accessible Service
- Other
    - 	Web Services
    - 	RACF
    -	ACF2
    -	Top Secret
    -	Java API
    -  	Microsoft NT Domain

>[!warn] ** All of these require customization. Consult your Radiant Logic Account Representative for details.
