---
title: Data Sources Supported
description: Data Sources Supported
---

This document describes the supported backend data sources supported by RadiantOne.

## Supported Identity Data Sources

### LDAP Directory Servers	

- Microsoft Active Directory 2008, 2012, 2016, 2019, 2022
- Active Directory Lightweight Directory Service (AD-LDS)
- Active Directory Application Mode (ADAM)
- SunONE Directory Server 4.X – 7.X
- Sun Java System Directory v6.X
- IBM Directory Server v5(+)
- Novell eDirectory v8(+)
- IBM Domino (formerly Lotus Domino)
- Oracle Internet Directory v9 & v10, Oracle   Directory Server Enterprise Edition (ODSEE)
- CA Directory r12.X
- Any LDAP v3 Service

### Database Servers	

- Oracle 8i, 9i, 10g, 11g, 12c
- Microsoft SQL Server v2008, v2012, v2016, v2017
- IBM DB2 (UDB) v7(+)
- Sybase v12 and 12.5
- MongoDB
- Snowflake
- Terradata
- Any JDBC/ODBC-accessible database

The only JDBC drivers installed with RadiantOne are: JDBC-ODBC Bridge from Sun, Oracle (thin), Oracle oci, Microsoft SQL Server, HSQL, MySQL (supports MariaDB too), IBM DB2, Sybase, and Derby. For all other databases, import your own JDBC driver in Control Panel > Setup > Data Catalog > Template Management.

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