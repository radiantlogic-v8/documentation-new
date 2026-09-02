---
title: Data Sources Supported
description: Data Sources Supported
---

This document describes the identity data sources supported by RadiantOne.

## Supported Identity Data Sources

### LDAP Directory Servers	

To connect to the following directory services, follow the steps to: [Create Data Sources](./data-sources#ldap-data-sources-and-active-directory)

Templates for directory services are located on the LDAP tab.

- Microsoft Active Directory 2008 or higher. Use the Active Directory template.
- Active Directory Lightweight Directory Service (AD-LDS). Use the Generic LDAP template.
- Active Directory Application Mode (ADAM). Use the Generic LDAP template.
- SunONE Directory Server 4.X – 7.X. Use the Generic LDAP template.
- Sun Java System Directory v6.X. Use the Generic LDAP template.
- IBM Directory Server v5 or higher. Use the Generic LDAP template.
- Novell eDirectory v8 or higher. Use the Generic LDAP template.
- IBM Domino (formerly Lotus Domino). Use the Generic LDAP template.
- Oracle Internet Directory v9 & v10, Oracle Directory Server Enterprise Edition (ODSEE). Use the Generic LDAP template.
- CA Directory r12.X. Use the Generic LDAP template.
- Any LDAP v3 Service. Use the Generic LDAP template.

### Database Servers and Flat File Extracts

To connect to the following databases, follow the steps to: [Create Data Sources](./data-sources#database-data-sources)

Templates for databases are located on the DATABASE tab.

- .CSV-formatted flat file
- Oracle 8i, 9i, 10g, 11g, 12c
- Microsoft SQL Server v2008 or higher
- IBM DB2 (UDB) v7 or higher
- Sybase v12 and 12.5
- MongoDB
- Snowflake
- Terradata
- Any JDBC-accessible database. If you don't find an out-of-the-box template for your database vendor, define a new database data source template and upload your JDBC driver.

The following JDBC drivers are installed with RadiantOne by default for convenience, but may be insufficient for your use cases: Oracle (thin), Oracle oci, MySQL (supports MariaDB too), IBM DB2, Sybase, and Derby. For all other databases, import your own JDBC driver in Control Panel > Setup > Data Catalog > Template Management.

>[!note] You have the option to use one of the above drivers, however, it is recommended that you use the driver that was delivered with the database that you want to connect to. Also, some of the drivers provided in the install for convenience don't support SSL/TLS access to the database server. You might need other libraries (additional .jar files) from the vendor to support this. These additional files must also be associated with the database template. Consult your database vendor documentation for driver details.

### Applications and Distributed Event Streaming Platforms

- Sailpoint IdentityIQ. Use the template named SCIMv2.
- Apache Kafka (Oracle GoldenGate)

### Cloud Directories and Services

To connect to the following cloud services, follow the steps to: [Create Data Sources](./data-sources#managing-data-sources)

Templates for cloud services are located on the OTHER tab.

- Microsoft Entra ID (formerly Azure AD). Use the template named mgraph for Entra ID.
- PingOne. Use the template named SCIMv2.
- Okta Universal Directory. Use the template named Okta.
- Any SCIMv2 service. Use the template named SCIMv2.
- Salesforce. Use the template named SCIMv2.
- Zscaler. Use the template named SCIMv2.
- Saviynt. Use the template named SCIMv2.
- CyberArk Privileged Cloud. Create a new template based on the CyberArk connector you can download from the [Connector Marketplace](https://github.com/radiantlogicinc/connector-marketplace/tree/main/cyberark-privilege-cloud)


<br>

### NHI and AI Agent Repositories

To connect to the following sources, follow the steps to: [Create Data Sources](https://developer.radiantlogic.com/ido/v2/data-sync/datasource-examples/ai-agent-data-sources/)

- Amazon Bedrock
- Microsoft Azure Foundry
- Google Cloud Platform

  ![coming soon](Media/coming-soon.jpg)
- Sailpoint Identity Security Cloud 
- ServiceNow
- Worday
- Google Pub/Sub Queue
- AWS Identity and Access Management

>[!note] For any data source that doesn't have an out-of-the-box template, the Radiant Logic Connector SDK can be used. It provides the framework and methodology for configuring a connector. This is our standard process to make sure the connector is tailored to your exact use case: which systems you care about, which users, groups, and attributes...etc. you need, and how often changes should flow. This ensures we can precisely define what data is retrieved and how it behaves in your environment, so you get a connector that fits your exact requirements. Consult your Radiant Logic Account Representative for details.













