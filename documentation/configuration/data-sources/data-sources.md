---
title: Introduction to Data Sources
description: Learn how to use the Data Catalog to connect to and extract identity source metadata. This is the first step to creating views.
---

## Overview

The first step in configuring RadiantOne Identity Data Management is defining connections to all identity data sources. This can be done from Control Panel > Setup > Data Catalog > Data Sources.

Each data source is associated with a template that defines how to connect and integrate the identity data source. Default templates are included for LDAP, Active Directory, Oracle, SQL Server, Maria DB, MySQL, Apache Derby and others.  Custom templates can be created for those that don't have a default template, as long as they offer a JDBC-driver and/or API that supports the needed operations (e.g authenticate, create, read, update, delete, and ideally a change detection mechanism).

After an identity data source is defined, a schema can be extracted. A schema represents the metadata for all identity objects contained in the data source. Schemas can be managed in the Data Catalog > Data Sources > Selected data source > SCHEMA tab. This metadata is used to define identity views that are then accessed by clients that query the RadiantOne service. Identity views can be managed from Control Panel > Setup > Directory Namespace > Namespace Design.

## Managing Data Sources

Data sources are managed from Control Panel > Setup > Data Catalog > Data Sources.

### Creating Data Sources

To create a data source:
1.  Navigate to Control Panel > Setup > Data Catalog > Data Sources.
1.  Click ![An image showing](Media/newsource.jpg).
1.  Select a template associated with the identity data source type from the list. Use the Search field to quickly find a template name, or click on LDAP, DATABASE or OTHER tabs to narrow down the template choices by type. JDBC-accessible source templaes are located on the DATABASE tab. LDAP-accessible data source templates are located on the LDAP tab. Custom data source templates are located on the OTHER tab.
1.  Enter the basic details about the identity data source.

   PROPERTY	| DESCRIPTION
   -|-
   Data Source Name	| Unique name representing the identity source backend. Do not use spaces, commas, brackets or parenthesis, colons, or the word “domain”.
   Data Source Type	| Auto-populated, non-editable. Based on the template.
   Secure Data Connector	|  The Secure Data Connector group used to establish a connection to an identity data source in a different network, like one running in an on-prem data center.
   Description	| Details about the identity source backend.
   Status | Toggled to either OFFLINE (indicates the identity source is not available and should not be accessed by the RadiantOne service) or ACTIVE (indicates the identity source is available and can be accessed by the RadiantOne service).

1.  Enter the Connection details. These properties vary depending on the type of identity source.
1.  Configure applicable properties in the Advanced section (only applicable for LDAP data sources).

PROPERTY	| DESCRIPTION
-|-
Disable Referral Chasing	| By default, RadiantOne does not attempt to chase referrals that have been configured in the underlying LDAP server. If you want RadiantOne to chase referrals when searching the underlying LDAP server, then you should uncheck the Disable Referral Chasing option. Chasing referrals can affect the overall performance of the RadiantOne service because if the referral server is unresponsive, RadiantOne could take a long time to respond to the client. For example, in the case of querying an underlying Active Directory (with a base DN starting at the root of Active Directory) you may get entries like the following returned: <Br>*ldaps://ForestDnsZones.na.radiantlogic.com:636* <br> *ldaps://DomainDnsZones.na.radiantlogic.com:636* <Br>If RadiantOne attempts to “chase” these referrals, there can be extreme degradation in response times. Therefore, it is recommended that you disable referral chasing if you need to connect to Active Directory starting at the root of the Active Directory tree, or connect to any other directory where you don’t care about following referrals.
Paged Results Control	| If you enable the paged results option, and indicate a page size, RadiantOne (as a client to other LDAP servers) will request the result of a query in chunks (to control the rate at which search results are returned). This option can be useful when RadiantOne (as a client to other LDAP servers) has limited resources and may not be able to process the entire result set from a given LDAP query, or if it is connecting to the backend LDAP server over a low-bandwidth connection. The backend LDAP directory must support the Paged Results Control.
Verify SSL Certificate Hostname	| This setting is only applicable if SSL is used to connect to the backend. If enabled, RadiantOne validates the CN/SAN of the certificate and only establishes a connection to the backend if the hostname matches. This setting is not enabled by default meaning that RadiantOne doesn’t validate the hostname to the CN/SAN of the certificate for SSL connections. RadiantOne does not perform a reverse lookup when the Host Name for the backend is defined as an IP address instead of a fully qualified server name.

1.  Configure Failover servers. For database backends, select the configured database data source that contains the failover server connection details. For LDAP backends, click **NEW** and enter the host, port and SSL option to connect to the failover server. For LDAP backends, you can configure as many LDAP failover servers as needed.

   For LDAP backends, RadiantOne attempts to connect to failover servers only if there is an error in connection to the primary server (it attempts to connect twice) or if the SSL certificate for the backend server is expired.

   >[!note] If your data source is Active Directory and you are using Host Discovery in your data source settings, there is no need to define failover server. RadiantOne automatically leverages the first five LDAP servers listed in the SRV record as primary/failover servers. 

1.  Click **TEST CONNECTION**.

   >[!note] Not all custom data sources support test connection, meaning this may return a connection error even if all   properties have been configured successfully.

1.  Click **CREATE**. The new data source appears in the list of configured sources and is briefly noted with a *new* tag next to it.
   


## Data Source Properties

### LDAP Data Sources and Active Directory

The following properties apply to LDAP data sources.

PROPERTY	| DESCRIPTION
-|-
Host	| Fully-qualified server name or IP address for the identity source. For Active Directory sources, if you want to use host discovery, you can enter the Active Directory domain here surrounded by [ ].
Port	| A numeric value indicating the port number the LDAP service is listening on.
SSL	|  Toggled ON if SSL/TLS should be used in the connection to the backend. Enter the SSL port in the Port property. Toggled OFF if SSL/TLS should not be used. Enter the non-SSL port in the Port property.
Bind DN	| Service account credentials that the RadiantOne service should use to connect to the backend. Enter a full user DN.
Bind Password	| Credentials associated with the account indicated in the Bind DN property.
Base DN	|  Enter the Remote Base DN or click the **folder** button, select a base DN and then click **OK**. Do not use special characters in the Base DN value.

**Host Discovery**
Automatic host discovery can be used when connecting to underlying Active Directory servers using DNS lookups.

>[!warning] if you plan to use persistent cache with real-time/connector-based refresh for your virtual view of Active Directory, do not use host discovery since the native Active Directory capture connector requires the FQDN of the primary and failover servers defined in the data source, in combination with the replication vector to perform failover. If you do not plan on caching your virtual view and/or you plan on using a periodic refresh strategy, then using host discovery is fine.

The LDAP services reached are the ones published in the DNS service record. If the LDAP service is not published, it cannot be reached (the service is defined by a host AND port in the SRV record). Some examples are shown below (0 means highest priority level)

_ldap._tcp.example.com. SRV 1 100 389 ldap.example.net
_ldap._tcp.example.com. SRV 0 100 636 ldap.example.net

DNS lookups leverage the domain specified in the host parameter. When the specific domain is set in the host parameter, the BaseDN value can be omitted. To use this functionality, the host option should specify the domain name you are interested in and optionally a port (if you are looking for a specific service on a specific port). If you do specify a port, then RadiantOne tries to get the first LDAP service it finds that is listening on that specific port (no matter what order of that particular service in the srv record). Additionally, if you enter a port and there is no LDAP service available on that port, RadiantOne uses the first LDAP service returned from the srv record.

>[!note] The number of LDAP servers RadiantOne treats as **“primary”** and **“failover”** is determined by the **Active Dir. SRV Record Limit** property, found in **Classic Control Panel > Settings > Server Backend > Connection Pooling/Other**. RadiantOne uses this list of servers to automatically handle failover if the primary LDAP server becomes unavailable. Do **not** manually configure failover servers in the data source.


Below are some examples of the syntax.

Example 1 - Host specified with port set to 0 (a value of zero means no port is indicated). This uses the novato.radiantlogic.com domain and returns the first server found as there is no specific port mentioned.

`host:[domain:novato.radiantlogic.com] 
port:0`

Example 2 - This example tries to get the 'global catalog' ldap service (the one listening on port 3268).

`host:[domain:radiantlogic.com]
port: 3268`

Example 3 - This example tries to get an SSL connection to the LDAP server (on port 636).

`host: [domain:na.radiantlogic.com] port: 636`

### SCIM Data Sources

The following properties apply to SCIM v2 data sources. 

| Property | Type | Description |
|---|---|---|
| URL | string | Base URL of the target SCIM service endpoint. |
| Username | string | Username used for HTTP Basic authentication against the SCIM service. |
| Password | password | Password paired with the username for HTTP Basic authentication. |
| Timeout | number | Request/read timeout (in milliseconds) applied to SCIM API calls. |
| ConnectionTimeout | number | Time to wait (in milliseconds) when establishing the underlying HTTP connection before failing. |
| OAuthURL | string | Token endpoint URL used to obtain an OAuth 2.0 access token using the OAuthClientID and OAuthClientSecret for the SCIM service. |
| OAuthClientID | string | OAuth 2.0 client ID used for token acquisition. |
| OAuthClientSecret | password | OAuth 2.0 client secret paired with the client ID. |
| OAuthToken | password | Pre-issued bearer token; provide this when the connector should skip the token-acquisition flow and use a static token. |
| LoadSchemaFromFirstEntry | boolean | When enabled, use the first returned SCIM entry to infer the schema instead of reading it from the /Schemas endpoint. Enable this only if the server doesn't expose a reliable /Schemas definition. |
| IsDirectValueModeForPatch | boolean | When enabled, send PATCH requests with raw attribute values instead of using a SCIM PATCH envelope. Enable this only if the SCIM server expects direct values rather than full PATCH operation objects. |
| ReplaceOnUpdate | boolean | RadiantOne chooses PATCH or PUT based on the SCIM server's capabilities. If the server supports both, set "replaceonupdate" to true for PUT or false for PATCH. If the server doesn't support PATCH, RadiantOne automatically uses PUT. |
| TEST_CONNECTION_URL | string | The URL to use for testing the connection instead of the Base URL; useful when the SCIM service exposes a dedicated health endpoint. |
| ACCEPT_TYPE | string | Optional. RadiantOne automatically sets an appropriate value that works for most SCIM data sources. Enter a value for this property only if you need to override the HTTP Accept header for SCIM requests. |
| Proxy | string | HTTP proxy address (host:port) used to reach the SCIM service when a proxy is required. |
| ProxySSL | string | HTTPS proxy address (host:port) used for SSL/TLS traffic to the SCIM service. |
| PageSize | number | Number of entries requested per page on paginated SCIM list operations (count parameter). |



### Kafka Data Sources

The following producer properties apply to Kafka data sources. 


| PROPERTY                | DESCRIPTION                                                                                                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                 |
| Bootstrap Servers       | Required. Comma-separated list of Kafka broker addresses (host:port) to connect to the cluster.                                                                                 |
| Is Anonymous Access     | Checkbox that allows you to enable or disable anonymous producer access.                                                                                                                                    |
| Security Protocol       |  Type of security protocol to be used (e.g., PLAINTEXT, SASL_PLAINTEXT, SSL).                                                                                                          |
| SASL Mechanism          | Authentication mechanism for SASL (e.g., PLAIN).                                                                                                         |
| SSL Truststore File     | Upload/select the truststore file (.jks or .p12 format) for TLS/SSL connections.                                                                                                 |
| SSL Truststore Password | Password to access the SSL truststore file.                                                                                                                                     |
| SASL JAAS Config        | SASL JAAS configuration string. Kafka uses the Java Authentication and Authorization Service (JAAS) for SASL configuration. You must provide JAAS configuration for all SASL authentication mechanisms. |

### Microsoft Entra ID Data Source

The following properties apply to Microsoft Entra ID data source. 

| Property | Description |
|-----------|-------------|
| URL | Microsoft Graph API URL to be called (e.g., "https://graph.microsoft.com/beta"). |
| Scope | Microsoft Graph API Scope typically `https://graph.microsoft.com/.default` so it uses the app’s assigned permissions. |
| OAuth URL | Microsoft Graph API OAuth URL. Example: `https://login.microsoftonline.com/[domain]/oauth2/v2.0/token` where you'll replace `[domain]` with your Entra ID tenant domain. |
| Auth_Type | Specify the OAuth authentication method; enter `access_token_with_certificate` to use certificate files or leave this field empty for standard flows. |
| OAuth_Cert_Public_Path | Provide the file path to the public certificate if you authenticate with certificates. |
| OAuth_Cert_Private_Path | Provide the file path to the private key that pairs with the public certificate for certificate-based client authentication. |
| ClientId | Application Client ID of the Entra ID app registration RadiantOne should use to obtain tokens. |
| Username | Same as Application Client ID. |
| Password | Application Client Secret of the Entra ID app. |
| JWT_Assertion_Generator_ClassName | Provide the generator class name if you use a custom Java class to generate JWT assertions for authentication. |
| Max_Retries_On_Error | Maximum number of retries per request. |
| Timeout | Timeout duration (in milliseconds). |
| ConnectionTimeout | Initial HTTP connection timeout duration (in milliseconds). |
| Proxy | Provide a value that points to the HTTP proxy server and port if your org requires a HTTP web proxy (e.g, `rli.vip.proxy.com:9090`) |
| ProxySSL | Set the value to `true` if your org requires a HTTPS web proxy and SSL is used. Set the value to `false` if your org uses HTTP.
| MFAEnabled | Enable this if your security policy enforces multifactor authentication on the account and you would like to fetch MFA data. |

In the Entra ID data source configuration page, you can also configure the [Microsoft Graph](https://learn.microsoft.com/en-us/graph/?view=graph-rest-1.0) object link properties to control what value (the Group DN as represented in the RadiantOne namespace, the Group display name, or the Group URL) is returned for "memberOf" and/or "member" attributes.

 ![](Media/graphobject-links.png "Image showing Graph Object Links properties")

The following sections describe these properties along with examples.

PROPERTY	| DESCRIPTION
-|-
LinkByDN | Returns the value of memberOf attribute as RadiantOne DNs.
LINKBYDISPLAYNAME | Returns the values of memberOf attribute as group display names.
LINKBYURL| Returns the value of memberOf attribute values as group URLs. 


**Example**

To return display names for the memberOf attribute, enter "memberOf" in the LINKBYDISPLAYNAME field. 

 ![](Media/linkbydisplayname.png "Image showing LinkByDisplayName property")


When performing an LDAP search, the memberOf attributes are returned, showing the group display names simlar to the following example:

```
dn: user=abcrandom@random.onmicrosoft.com,Category=user,dc=entraidview
displayName: abc
givenName: abc100
mailNickname: abc10000
objectclass: top
objectclass: azureaduser
accountEnabled: true
memberOf: Test Group
memberOf: Group from LDIF Import 01
memberOf: ABC Team
memberOf: Group from LDIF Import 02
memberOf: DnsAdmins
memberOf: All Company
......
```

If you leave these fields blank (LINKBYDN, LINKBYDISPLAYNAME, LINKBYURL), RadiantOne will return all three attributes (memberOfDisplayName, memberOfLink, memberOf) by default:

```
memberOfDisplayName: testgroup4
memberOfDisplayName: testgroup5
memberOfLink: /groups/76c1d5c8-13e9-4b98-b71d-591440bbdcdd
memberOfLink: /groups/35a758f5-69d4-47ae-9678-f0925bcc11a0
memberOf: group=ABCd31-7935-4717-bc03-e5dff81cfebe,Category=group,dc=entraidview
memberOf: group=ABCDcf66c9-e92e-4cf7-aa76-d3ccffb4a00e,Category=group,dc=entraidview
......
```

> The examples above show partial snippets for illustration and does not represent full response bodies. 

These fields can also accept multiple attribute names, separated by commas. For example, to return display names for both `member` and `memberOf` attributes, enter `member,memberOf` in the LINKBYDISPLAYNAME field. 

### Database Data Sources

The following properties apply to LDAP data sources.

PROPERTY	| DESCRIPTION
-|-
Driver Class Name	| Auto-populated, non-editable. Based on the template.
Driver URL	| Enter the URL to connect to the Database server.
User 	| Service account name that the RadiantOne service should use to connect to the backend.
Password	| Credentials associated with the account indicated in the User property.

### Custom Data Sources

If your data source is not supported by Identity Data Management by default, you can select a custom data source type and provide the required information. The properies supported are defined in the [template](#creating-templates).

### Updating Data Sources
To update a data source, navigate to Control Panel > Setup > Data Catalog > Data Sources. Click the data source name in the list of configured sources. The connection properties displays. Update the properties and click **SAVE**.

### Deleting Data Sources
To delete a data source, navigate to Control Panel > Setup > Data Catalog > Data Sources. Select the configured data source in the list, click the inline trash can icon and click **DELETE** to confirm. Otherwise, click **KEEP DATA SOURCE** to not delete.

![An image showing deleting data source](Media/delete-data-source.jpg)

>[!warn] When a data source is deleted, all associated schemas (default and added schemas) are also deleted.

### Cloning Data Sources
Cloning a data source allows you to make a copy of the connection information and provide a new name for the data source. To clone a data source, navigate to Control Panel > Setup > Data Catalog > Data Sources. Select the configured data source in the list and click the clone icon.

![Cloning a data source](Media/clone-data-source.jpg)

Enter a data source name and click the checkmark inline with the cloned data source to save it. Click **X* to delete the clone instead of saving it.

![Confirm a cloned data source name](Media/confirm-clone.jpg)

### Importing Data Sources
If you have existing data sources defined (exported from another RadiantOne configuration) and you would like to import those, navigate to the Control Panel > Setup > Data Catalog > Data Sources, click **...** and choose Import. 

![An image showing import data sources screen](Media/import-export-menu.jpg)

Either browse to the file containing the data source definitions that you have exported from another RadiantOne server or drag-and-drop the file into the window and click **CLOSE** after the import.

![An image showing import data sources screen](Media/import-data-source.jpg)

>[!note] 
>To override existing data sources containing the same names as ones from the import file, toggle the **OVERRIDE DUPLICATE DATA SOURCES** option on. 

### Exporting Data Sources
To export data sources, navigate to the Control Panel > Setup > Data Catalog > Data Sources, click **...** and choose Export.

![Export Data Sources Option](Media/export-data-source.jpg)

Select the data sources to include in the export and click **EXPORT**

![Exporting Data Sources](Media/selected-data-sources.jpg)

Your internet browser settings determine the download location. The download file is named fid-datasources-export.json.

## Managing Templates

Each identity data source is associated with a template. The template indicates all properties required to connect to the data source. RadiantOne includes some default templates and  you can also create new templates for JDBC-accessible databases and other data sources that can be queried through a web services API.

Only database templates that are associated with JDBC drivers installed with RadiantOne are shown by default. These drivers are included to help save configuration time, but are not owned, licensed or managed by Radiant Logic. If newer versions of the drivers are available from the database vendors, customers must update and replace the drivers used in RadiantOne. Some JDBC drivers, like IBM DB2 (UDB), require additional license files (e.g. `db2jcc_license_cisuz.jar`) to be included as well. Downloading and associating any updated drivers or additional license files with RadiantOne templates is the responsibility of the customer.

Templates can be managed from **Control Panel > Setup > Data Catalog > Template Management**.

### Creating Templates

Templates for JDBC-accessible databases and other data sources that can be queried through a web services API are managed from **Control Panel > Setup > Data Catalog > Template Management**.

Click the **+ CREATE TEMPLATE** drop-down and select either **Database source type** (for JDBC-accessible data sources) or **Custom source type** (for web service API-accessible services).

#### Database Source Types

##### Step 1 — JDBC Driver

1. Choose **Upload New** to add a new driver, or **Select From Existing** to reuse a driver library that already exists on the RadiantOne node. For **Upload New**, either drag-and-drop the library into the window or click **choose a file** to upload it.

![Driver Jar File UI](Media/jdbc-driver.png)

2. Click **NEXT** to advance to the Driver Dependencies step.

> **Warning**
> Some databases require additional libraries (extra `.jar` files) from the vendor to support features like licensing and TLS/SSL access. These additional `.jar` files must be registered with the template as Driver Dependencies (see Step 2). Consult your database vendor documentation for details on which driver files are needed.

##### Step 2 — Driver Dependencies (optional)

This step lets you register one or more dependency `.jar` files alongside the primary JDBC driver. The widget supports **multi-file uploads**, so customers with large dependency sets (50+ jars are supported) can register them all in a single step.

To register dependencies:

1. Drag-and-drop one or more `.jar` files into the upload area, or click **choose a file** to select files.
2. Each dependency you upload appears in the list. To remove a dependency before continuing, click the **Delete** action next to that row.
3. Repeat as needed until all required dependencies are registered.
4. Click **NEXT** to advance to the Setup step.

> **Note**
> This step is **optional**. If your driver does not require additional libraries, click **NEXT** without uploading anything to skip ahead to Setup. If a dependency `.jar` does not contain extractable metadata, RadiantOne automatically generates a unique identifier for it so the upload workflow does not stall.

##### Step 3 — Setup

1. Enter a unique **Template Name**. This name is displayed on the card that can be selected during data source creation.

   ![Setup UI](Media/setup-jdbc.png)

2. Enter or select the **Driver Class Name** associated with the library. This is typically auto-populated from the driver file selected in Step 1.
3. Enter the **Driver URL Pattern** indicating the values required by the driver to establish a connection to the database. This is a hint for the administrator that uses the template to create the data source.
4. Select a unique **Icon** to display on the card associated with the template.
5. Click **ADD**. A new card is available for defining "Database" type data sources.

#### Custom Source Types

1. Choose the option to either **Upload New** or **Select Existing** plugin file. Use the **Select Existing** option only if the plugin file already exists on the RadiantOne node. For **Upload New**, either drag-and-drop the plugin file into the window or click the link to choose a file.
2. Enter a unique template name. This name is displayed on the card that can be selected during data source creation.
3. Enter a plugin name associated with the file selected in step 1.
4. Select or enter the class name associated with the plugin file.
5. Select a unique icon to display on the card associated with the template.
6. Click **NEXT**.
7. Use **+ SECTION** to create categories for properties required to be passed when establishing connections to the custom API. Create as many sections as needed.
8. In each section created in the previous step, click **+** to add properties. Create as many properties as needed.
9. Click **ADD**. A new card is available for defining "Other" (type) data sources.

### Updating Templates

All user-defined templates can be updated from **Control Panel > Setup > Data Catalog > Template Management**. Default templates associated with JDBC-accessible types of data sources can also be updated from here to update JDBC drivers.

Select the template and use the drawer that appears on the right to update properties. Click **SAVE**.

#### Managing Dependencies

### Updating Templates

All user-defined templates can be updated from **Control Panel > Setup > Data Catalog > Template Management**. Default templates associated with JDBC-accessible types of data sources can also be updated from here to update JDBC drivers.

Select the template and use the drawer that appears on the right to update properties. Click **SAVE**.

#### Managing Dependencies

For existing JDBC templates, you can add, remove, or view registered dependency jars at any time without recreating the template. 

To manage dependencies on an existing template:

1. Click the template card from the list to open its details on the right.
2. Under **Driver URL Pattern**, click **MANAGE DEPENDENCY**.

   ![Managing Dependency](Media/manage-dependency-option.png)

3. In the modal that opens, upload new dependency jars or click the delete action next to a listed dependency to remove it.
4. Click **SAVE**.
5. Re-open the modal at any time to confirm the dependency list matches what was saved.

### Deleting Templates

Only user-defined templates can be deleted.

Templates can be deleted from Control Panel > Setup > Data Catalog > Template Management. Select the user-defined template and click **Delete**. Click **DELETE** to confirm.

![Deleting Templates](Media/delete-template.jpg)

### Exporting Templates

Only user-defined templates can be exported.

Templates can be exported from Control Panel > Setup > Data Catalog > Template Management. Select the user-defined template and click **EXPORT TEMPLATE**. The template is exported and automatically downloaded based on your web browser settings.

![Exporting Templates](Media/export-template.jpg)

### Importing Templates

Templates that have been exported from a RadiantOne v8.1.X deployment can be imported into other RadiantOne v8.1.X deployments. Templates can be imported from Control Panel > Setup > Data Catalog > Template Management. Click **IMPORT TEMPLATE**. Either drag-and-drop the template file into the window or click *Choose a File* to upload. The templates included in the file are shown. Select which templates to import and click **IMPORT**. Imported templates can be used to create data sources from Control Panel > Setup > Data Catalog > Data Sources.

![Importing Templates](Media/import-template.jpg)

## Managing Schemas
Each data source can be associated with one or more schema files. The first schema file extracted for a data source is considered the default one. For LDAP data sources, the default schema is automatically extracted when the data source is defined. For JDBC-accessible and SCIMv2 accessible data sources, you must manually extract the schema so you can selectively choose the objects that are required for creating identity views. For custom data sources, you must manually create the schema in RadiantOne.

For details, see [Managing Schemas](./schemas.md).










