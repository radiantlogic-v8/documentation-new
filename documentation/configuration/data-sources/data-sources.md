---
title: Introduction to Data Sources
description: Learn how to use the Data Catalog to connect to and extract identity source metadata. This is the first step to creating views.
---

## Overview

The first step in configuring RadiantOne Identity Data Management is defining connections to all identity data sources. This can be done from Control Panel > SETUP > Data Catalog > Data Sources.

Each data source is associated with a template that defines how to connect and integrate the identity data source. Default templates are included for LDAP, Active Directory, Oracle, SQL Server, Maria DB, MySQL, Apache Derby and others.  Custom templates can be created for those that don't have a default template, as long as they offer a JDBC-driver and/or API that supports the needed operations (e.g authenticate, create, read, update, delete, and ideally a change detection mechanism).

After an identity data source is defined, a schema can be extracted. A schema represents the metadata for all identity objects contained in the data source. Schemas can be managed in the Data Catalog > Data Sources > Selected data source > SCHEMA section. This metadata is used to define identity views that are then accessed by clients that query the RadiantOne service. Identity views can be managed from Control Panel > SETUP > Directory Namespace > Namespace Design.

## Managing Data Sources
Data sources are managed from Control Panel > SETUP > Data Catalog > Data Sources.

### Creating Data Sources
To create a data source:
1.  Navigate to Control Panel > SETUP > Data Catalog > Data Sources.
1.  Click ![An image showing](../Media/newsource.jpg).
1.  Select a template associated with the identity data source type from the list. Use the Search field to quickly find a template name, or click on LDAP, DATABASE or OTHER tabs to narrow down the template choices by type. JDBC-accessible source templaes are located on the DATABASE tab. LDAP-accessible data source templates are located on the LDAP tab. Custom data source templates are located on the OTHER tab.
1.  Enter the basic details about the identity data source.

PROPERTY	| DESCRIPTION
-|-
Data Source Name	| Unique name representing the identity source backend. Do not use spaces, commas, brackets or parenthesis, colons, or the word “domain”.
Data Source Type	| Auto-populated, non-editable. Based on the template.
Secure Data Connector	|  The Secure Data Connector group used to establish a connection to an identity data source in a different network, like one running in an on-prem data center.
Description	| Details about the identity source backend.
Status	| Toggled to either OFFLINE (indicates the identity source is not available and should not be accessed by the RadiantOne service) or ACTIVE (indicates the identity source is available and can be accessed by the RadiantOne service).

1.  Enter the Connection details. These properties vary depending on the type of identity source.
For LDAP Data Sources:

PROPERTY	| DESCRIPTION
-|-
Host	| Fully-qualified server name or IP address for the identity source.
Port	| A numeric value indicating the port number the LDAP service is listening on.
SSL	|  Toggled ON if SSL/TLS should be used in the connection to the backend. Enter the SSL port in the Port property. Toggled OFF if SSL/TLS should not be used. Enter the non-SSL port in the Port property.
Bind DN	| Service account credentials that the RadiantOne service should use to connect to the backend. Enter a full user DN.
Bind Password	| Credentials associated with the account indicated in the Bind DN property.
Base DN	|  Enter the Remote Base DN or click the **folder** button, select a base DN and then click **OK**. Do not use special characters in the Base DN value.

For Database Data Sources:
PROPERTY	| DESCRIPTION
-|-
Host	| Unique name representing the identity source backend.
Port	| Auto-populated, non-editable. Based on the template.
SSL	|  The Secure Data Connector group used to establish a connection to an identity data source in a different network, like one running in an on-prem data center.
Bind DN	| Details about the identity source backend.
Bind Password	| Toggled to either OFFLINE (indicates the identity source is not available and should not be accessed by the RadiantOne service) or ACTIVE (indicates the identity source is availa

For Custom Data Sources:
PROPERTY	| DESCRIPTION
-|-
Host	| Unique name representing the identity source backend.
Port	| Auto-populated, non-editable. Based on the template.
SSL	|  The Secure Data Connector group used to establish a connection to an identity data source in a different network, like one running in an on-prem data center.
Bind DN	| Details about the identity source backend.
Bind Password	| Toggled to either OFFLINE (indicates the identity source is not available and should not be accessed by the RadiantOne service) or ACTIVE (indicates the identity source is availa

1.  Click **TEST CONNECTION**.

>[!note] Not all custom data sources support test connection, meaning this may return a connection error even if all properties have been configured successfully.

1.  Click **CREATE**.
   
### Updating Data Sources
### Deleting Data Sources
### Cloning Data Sources
### Importing Data Sources
### Exporting Data Sources

## Managing Templates

### Creating Templates
### Updating Templates
### Deleting Templates

## Managing Schemas
### Extracting Schemas
### Comparing Schemas
### Modifying Schemas
