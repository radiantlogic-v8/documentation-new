---
title: Data Sources
description: Details about where to configure data sources.
---

# Data Sources

A data source in RadiantOne represents the connection to a backend. Data sources can be managed from the Main Control Panel > Settings Tab > Server Backend section. Configuring connections to all backends from a central location simplifies the management task when changes to the backend are required. For more details on data sources, please see [Concepts](concepts).

>[!note] Data sources can also be managed from the command line using the RadiantOne command line config utility. Details on this utility can be found in the [Radiantone Command Line Configuration Guide](/command-line-configuration-guide/01-introduction).

## Status

Each data source has a status associated with it. The status is either Active or Offline and can be changed as needed. If a backend server is known to be down/unavailable, setting the status to Offline can prevent undesirable performance impact to views associated with this backend. When a data source status is set to Offline, all views associated with this data source are not accessed to avoid the performance problems resulting from RadiantOne having to wait for a response from the backend before being able to process the client’s query. To change the status for a data source, navigate to the Main Control Panel -> Settings Tab -> Server Back End section. Select the section associated with the type of data source that is known to be unavailable (e.g. LDAP Data Sources, Database Data Sources or Custom Data Sources). On the right side, select the data source representing the backend that is down and click Edit. Locate the status drop-down list and choose Offline. Save the change.

>[!note] When a data source is set as Offline, RadiantOne does not try to access the primary backend nor any failover servers configured in the data source.

## Database Data Sources

A database data source represents a connection to a SQL/JDBC-accessible backend.

The following JDBC drivers are installed with RadiantOne: JDBC-ODBC Bridge from Sun, Oracle (thin), Oracle oci, Microsoft SQL Server, HSQL, MariaDB (used for MySQL as well), IBM DB2, Sybase, and Derby.

You have the option to use one of the above drivers, however, it is recommended that you use the driver that was delivered with the database that you want to connect to. To add a JDBC driver, you must make sure that the driver libraries are added in the <RLI_HOME>/lib/jdbc directory.

>[!warning] Updating to a different DB2 driver may require more than just replacing the existing driver files in the <RLI_HOME>/lib/jdbc directory if the name or license has changed. Please consult the Radiant Logic knowledge base for additional details.

![Database Data Sources](Media/Image3.72.jpg)

Figure 12: Database Data Sources

### Add a Database Data Source

1.	In the Main Control Panel, go to > Settings Tab > Server Backend section > DB Data Sources sub-section.

2.	Click **Add**.

3.	Enter a unique data source name (do not use spaces in the name) along with the connection information to reach your backend server. You can select a Data Source Type from the drop-down list and the driver class name and URL syntax is populated for you. You can then just modify the needed parameters in the URL and enter the required user/password. 

    >[!note] A secure connection can be made to the database if the JDBC driver supports it. If the server you are connecting to uses a certificate issued by a trusted Certificate Authority, then all you need to do during the creation of the data source is enter the SSL port in the appropriate location of the URL. If the server you are connecting to uses a self-signed certificate, then this certificate must be imported into the [RadiantOne client trust store](06-security#client-certificates-default-java-truststore).

4.	Click **Test Connection**.

5.	Click **Save**.

### Edit a Database Data Source

To update the connection information associated with a data source, select the configured data source and click **Edit**. After editing the information, click **Test Connection** and then save the updated information.

### Delete a Database Data Source

To delete a data source, select the configured data source and click **Delete**. After deleting any data source, save your changes.

### Adding a New Database Driver

A list of drivers appears in the drop-down list box when you are defining a database data source. Only the drivers that are shown in green were installed with RadiantOne. The other driver names/syntaxes that appear in the drop-down list have been provided to save time. If you would like to use one of these drivers or to include a new JDBC driver, install the driver files in the <RLI_HOME>/lib/jdbc directory. Restart the RadiantOne service and any open tools. During the creation of the database data source, if your driver type is listed in the drop-down list, select it and the syntax for the driver class name and URL is populated for you. Update the URL with the connection details for your database. If the drop-down list does not include your database driver type, you can leave this blank and manually type in the data source name, driver class name, driver URL, user and password.

This information is saved in a file so you do not have to re-enter the same connection parameters every time you extract a schema from the same type of database. The name of the file is jdbcxml.xml, and it can be found in the directory <RLI_HOME>\<instance_name>.

### Configure Failover Servers

If the primary backend is not available, RadiantOne attempts to connect to a failover server that is configured for the data source.

>[!warning] If you have not defined data sources for your failover servers, you must do so before performing the following steps.

1.	In the Main Control Panel, go to > Settings Tab > Server Backend section.

2.	Select the DB Data Sources section and on the right side, select the data source you want to configure a failover server for and click **Edit**.

3.	In the Failover section, select the data source that represents the failover database from the drop-down list.

4.	Save the configuration when you are finished.

## Custom Data Sources

A custom data source is defined as something that cannot be accessed directly using JDBC/ODBC or LDAP. To access these types of data sources, you need to configure what is known as a custom object. RadiantOne includes a few default custom objects representing data sources you can virtualize. These data sources are for the following applications: Google Apps, Azure AD, Okta Universal Directory, any SCIM v1 source, any SCIM v2 source, Workday, Concur, Epic, SharePoint Users and Profile, and SharePoint Online Profile. To use these objects in virtual views, you just need to update the connection properties to point to your own application instances. For more details on leveraging these custom data sources in virtual views, please see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

To edit a custom data source, from the Main Control Panel > Settings Tab > Server Backend section > Custom Data Sources sub-section, select the custom data source from the list and click **Edit**. Select a custom property and click **EDIT**. Save your changes when finished.

![Sample Custom Data Source](Media/Image3.73.jpg)

Figure 13: Sample Custom Data Source

>[!warning]
>Most default custom data sources do not support authentication operations. They are primarily to allow for provisioning/de-provisioning identity information to these apps through RadiantOne and/or retrieving identity profile information from these apps for RadiantOne to present a complete user profile (to join views of these backends to identities from other data sources). However, Azure AD (graphapi and mgraph data sources) and Okta Universal Directory (oktaclient data source) do support authentication operations. For details on creating virtual views from the default custom data sources, see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

### DSML/SPML Sources

For DSML/SPML accessible services, you can define the data source backend from the Main Control Panel.

1.	In the Main Control Panel, go to > Settings Tab > Server Backend section > Custom Data Sources sub-section.

2.	Click the drop-down arrow next to Add Custom and choose the DSML/SPML option.

3.	If you want to manually enter your own property names, click **Advaned Edit**. Otherwise, populate the properties described below.

4.	Enter a unique data source name (do not use spaces in the name).

5.	Enter the host, port (check the SSL box if it is a secured port), and select DSML or SPML from the drop-down list.

6.	Enter the credentials (e.g. username and password) to connect to the service.

7.	Enter the path (prefix) to reach the service.

![Sample Custom DSML/SPML Data Source](Media/Image3.74.jpg)

Figure 14: Sample Custom DSML/SPML Data Source

### SCIM v2 Sources

This section provides general details about virtualizing SCIM data sources. Details about virtualizing some common SCIM-specific data sources like SailPoint can be found in the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction). For SCIM v2 accessible services, you can define the data source backend from the Main Control Panel.

>[!warning] If you want to use SSL for this connection, you must import the RadiantOne public certificate into the backend server's truststore. The default RadiantOne public key is rli.cer, located in <RLI_HOME>/vds_server/conf.

To virtualize a SCIM backend: 

1.	In the Main Control Panel, go to the Settings Tab -> Server Backend section -> Custom Data Sources sub-section.

2.	Click the drop-down arrow next to Add Custom and choose the SCIMv2 option.

3.	Enter a unique data source name (do not use spaces in the name).

4.	Enter the SCIM URL path to reach the service. When testing the connection for this data source, RadiantOne attempts to get data from the /ServiceProviderConfig endpoint. You can validate the connection to an alternate URL using the “test_connection_url” property.

>[!note] If a RadiantOne service is the backend you are connecting to, the syntax of the URL is: `http://<fid_server>:8089/scim2/v2`

5.	Enter the credentials (e.g. username and password) to connect to the service.

    ![Sample Custom SCIM v2 Data Source](Media/Image3.75.jpg)
 
    Figure 15: Sample Custom SCIM v2 Data Source

6.	Click **Test Connection**.

7.	To customize or add new property names, click **Advanced Edit**. See [Custom Properties](#custom-properties) for details.

8.	Click **Save**.

>[!note] If you plan on virtualizing a RadiantOne Universal Directory backend, and are going to use the SCIM connector for detecting changes (for sync or persistent cache refreshes), the modifyTimestamp attribute must be removed from the Non-indexed Attributes property, and added to the Indexed Attributes and Sorted Attributes properties for the store. Rebuild the index for the store after modifying these properties. Also, the VLV/Sort control must be enabled on the RadiantOne service. This can be enabled from the Main Control Panel (associated with the RadiantOne backend) > Settings > Server Front End > Supported Controls.

### SCIM Custom Properties

Custom properties are optional. To add new properties, in the Advanced Edit window, click **Add**. To delete a property, select the property and click Delete. To edit a property, select the property and click **Edit**. Click **Save** after making any changes. 

>[!warning] Certain SCIM-accessible backends can require more properties than others. If you are unsure about the properties required for your SCIM service, contact support@radiantlogic.com for guidance.

The Namespace Configuration Guide describes the properties necessary for common SCIM services offered by SailPoint and PingOne Directory. 

#### Replace On Update

For update operations, some SCIM servers support both PATCH and PUT operations, and some only support PUT. If the SCIM server backend supports both operations, the value of the “replaceonupdate” property determines which operation RadiantOne sends. Set the “replaceonupdate” property to true, for RadiantOne to issue a PUT to the SCIM server. Otherwise set the “replaceonupdate” to false, and RadiantOne issues a PATCH to the SCIM server. You do not need to set this property for SCIM servers that do not support PATCH operations. In this scenario, RadiantOne detects that the server doesn’t support PATCH operations and sends the updates as PUT operations.

>[!note] For SCIM servers that do not support PATCH operations: When clients send update requests to RadiantOne, values for all attributes (even which were not changed) must be set because it sends a PUT request to the SCIM Server, which replaces the entry.

#### Pass Through Authorization

(Optional) RadiantOne (as a SCIM client) leverages the username and password defined in the data source to connect to the backend SCIM service. This is dictated by the passthru property which is set to a default value of false. If you set this property to true, if the user that binds (authenticates) to RadiantOne is defined in the SCIM backend, these credentials can be used to access the SCIM backend as opposed to the username and password defined in the data source. 

#### Oauth Authentication

If the backend SCIM service requires an OAuth2 token for authentication instead of a username and password (e.g. Slack), and you already have the token, add a property named “oauthtoken” and enter the token for the value. This is supported for accessing SCIMv1 and SCIMv2 services. 

If you do not already have the token, add a property named “oauthclientid” and enter the value associated with the client that is registered in the Oauth Provider. Add a property named “oauthclientsecret” and enter the value of the secret associated with the oauthclientid. Add a property named “oauthurl” and enter the URL for the token validator endpoint. These properties are used to get the token when the connection is made to the backend SCIM service.

To indicate the Oauth scope of the request to the backend SCIM server, you can add a property named “oauth_scope” that contains the value of the access token scope. An example for accessing Ping Federate’s Directory SCIM service via Oauth is: urn:pingidentity:directory-scim

#### Page Size

RadiantOne (as a SCIM client) uses paging when communicating with the SCIM service (backend). To customize the page size:

1.	Select the SCIM data source and click **Edit**.

2.	Click **Advanced Edit**. 

3.	In the Custom Properties section click **Add**. 

4.	Name the property “pagesize”.

5.	Indicate the page size value RadiantOne should use when it queries your SCIM service and click **OK**. If no value is set, a default value of 500 is used.

>[!warning]
>The pagesize value set here should be less than or equal to the SCIM backend’s page size value.

#### Sorting

RadiantOne allows you to indicate the order in which SCIM resources are returned in a query. This is done by specifying the sortBy parameter in the SCIM data source. To change the value of the sortBy property:

1.	Select the SCIM data source and click **Edit**.

2.	Click **Advanced Edit**.

3.	In the Custom Properties section click **Add**. 

4.	Name the property “sortby”. 

5.	In the value field, specify the endpoint, sort attribute, and sort order as follows. 

`<endpointName>:<sortAttributeName>-<sortOrder>`

6.	Click **OK**.

For each endpoint, the sortAttributeName indicates the attribute that determines the order of the returned responses. The sortOrder determines the order in which the sortBy parameter is applied to the query results. Acceptable values for the sortOrder are ascending and descending. 

In the following example, when the SCIM query (GET or POST) is made to the /Users endpoint, the results are returned in descending order, using the sort attribute "id".

`Users:id-descending`

Multiple endpoints with the associated sort attribute and sort order can be defined by creating a comma-separated list, as follows.

`<endpointName1>:<sortAttributeName1>-<sortOrder1>,`
<br> `<endpointName2>:<sortAttributeName2>-<sortOrder2>, `

In the following example, when the SCIM query (GET or POST) is made to the /Users endpoint, the results are returned in ascending order, using the sort attribute "userName". When the query is made to the /Groups endpoint, the results are returned in descending order, using the sort attribute "displayName"

`Users:userName-ascending,Groups:displayName-descending`

#### Test Connection URL

The “test_connection_url” property indicates a URL that can be used for testing the connection. This is an alternative to using the one in the “url” property. This might be useful if, for example, the endpoint indicated in the “url” property does not perform authorization.

To add a test connection URL: 

1.	Select the SCIM data source and click **Edit**. 

2.	In the Custom Properties section, click **Add**. 

3.	Name the property “test_connection_url”. 

4.	Indicate the URL to be tested.

5.	Click **OK**. 

    ![The Test Connection URL Property](Media/Image3.76.jpg)

    Figure 16: The Test Connection URL Property

6.	Click **Save**.

#### Web Proxy Server

If your company requires API calls to be made through a Web Proxy Server, add a property named “proxy” with a value that points to the proxy server and port (e.g. rli.vip.proxy.com:9090) to the scim custom data source.

#### Proxy SSL

If SSL is required, add a property named “proxyssl” with a value of true.

## SCIM Backend Exception Parameters

When RadiantOne sends a SCIM request, the SCIM service (backend) might generate an exception message. RadiantOne searches for keywords in the exception message, waits a specified amount of time, and then attempts to resend the SCIM request. This section describes how to customize this behavior, including how to disable it. 

### Error Keywords

If a keyword is detected in the exception message from the SCIM service (backend), RadiantOne can attempt to process the query again. If the exception message does not contain any of the keywords listed in this property, the exception is logged, and the query is discarded. The error keywords are defined by the “error_key_words” property in the SCIM data source. If this property is missing from the data source, the default keyword values are “throttled” and “too many changes”. To change the value of the “error_key_words” property:

1.	Select the SCIM data source and click **Edit**. 

2.	In the Custom Properties section, click **Add**. 

3.	Name the property “error_key_words”. 

4.	In the value field, separate keywords (or phrases) with the # character. 

5.	Click **OK**.

### Retry Interval On Error

In the event of an error, RadiantOne can wait before it attempts to resend a request to the SCIM service (backend). The waiting time is defined by the “retry_interval_on_error” property in the SCIM data source. If this property is missing from the data source, the default value is 5 seconds. To change the value of the “retry_interval_on_error” property:

1.	Select the SCIM data source and click **Edit**. 

2.	In the Custom Properties section, click Add. 

3.	Name the property “retry_interval_on_error”. 

4.	Indicate the length of time (in seconds) RadiantOne should wait before retrying when it queries the SCIM service. 

5.	Click **OK**. 

### Retries On Error

You can specify how many times RadiantOne should try to resend a request to the SCIM service (backend). The number of retries on error is defined by the “retries_on_error” property in the SCIM data source. If this property is missing from the data source, the default value of this property is 60. To change the value of the “retries_on_error” property:

1.	Select the SCIM data source and click **Edit**. 

2.	In the Custom Properties section, click **Add**. 

3.	Name the property “retries_on_error”. 

4.	Indicate the number of times RadiantOne should attempt to reconnect to the SCIM service. This includes connection errors. 

5.	Click **OK**. 

    ![SCIM Properties](Media/Image3.77.jpg)

    Figure 17: SCIM Properties

To disable attempting retries on error:

1.	Select the SCIM data source.

2.	Select retries_on_error in the Custom Properties of the Connection Information. 

3.	Click **Edit**. 

4.	In the Property Value field, enter a negative value. 

    ![Disabling SCIM Backend Exception Parameters](Media/Image3.78.jpg)

    Figure 18: Disabling SCIM Backend Exception Parameters

    >[!note] With this setting, when an exception is thrown, it is logged and changes are discarded.

5.	Click **OK**.

## Updating Username and/or Password for Data Sources via LDAP

The username (Bind DN property for LDAP data sources, User property for Database data sources) and/or password properties of a data source can be updated via an LDAP modify command. This modifies the configuration in the RadiantOne data source and does not modify any credentials in the backend. Updating data sources via LDAP requires the RadiantOne super user (cn=directory manager) credentials. The DN in the modify should be in the form of: id=<data_source_name>,cn=metads

>[!note]
>To update the RadiantOne credentials associated with the KDC account that is defined on Main Control Panel > Settings > Security > Authentication Methods > Kerberos Authentication, modify the username (user principal name) and/or password (service password) with a DN of “id=KDCconnect,cn=metads”. These special credentials are stored in ZooKeeper and updating the credentials via LDAP updates the kerberosUserPrincipalName and kerberosServicePassword properties in /radiantone/v1/cluster/config/vds_server.conf in ZooKeeper.

The LDAP attribute names to issue in the modify request for the Bind DN and password are: username and password respectively.

Two examples are shown below and leverage the ldapmodify command line utility. The syntax can be used to update LDAP data sources, database data sources and custom data sources (that have properties named username and password).

Example 1: A configured LDAP data source named sun102 has the following username (BindDN) and password configured:

`username: uid=sbuchanan,ou=People,dc=sun,dc=com`
<br> `password: Radiant1`

The following LDIF formatted file (named ldapmodify_update_datasource_sun.ldif) is created to update the password:

`dn: id=sun102,cn=metads`
<br> `changetype: modify`
<br> `replace: password`
<br> `password: radiantlogic`

The following is the ldapmodify command that is run to update the password in the sun102 data source:

`ldapmodify -h localhost -p 2389 -D "cn=directory manager" -w password -f` 
<br> `ldapmodify_update_datasource_sun.ldif` 
<br> `modifying entry id=sun102,cn=metads`

To verify the password update, go to the Main Control Panel > Settings tab > Server Backend > LDAP Data Sources and edit the data source (e.g. sun102). Click **Test Connection** to confirm it succeeds. Also validate that virtual views associated with this data source still work fine. This can be checked from the Directory Browser tab in the Main Control Panel.

Example 2: A configured LDAP data source named ad203 has the following username (BindDN) and password configured:

`username: CN=Shelly Wilson,OU=Users,OU=Europe,DC=na,DC=radiantlogic,DC=com`
<br> `password: Secret2`

The following LDIF formatted file (named ldapmodify_update_datasource_username.ldif) is created to update the username and password:

`dn: id=ad203,cn=metads`
<br> `changetype: modify`
<br> `replace: username`
<br> `username: CN=Logan Oliver,OU=Users,OU=Europe,DC=na,DC=radiantlogic,DC=com`

<br> replace: password
<br> password: Radiant1

The following is the ldapmodify command that is run to update the username and password in the ad203 data source:

ldapmodify -h localhost -p 2389 -D "cn=directory manager" -w password -f '
<br> ldapmodify_update_datasource_username.ldif
<br> modifying entry id=ad203,cn=metads

To verify the username and password update, go to the Main Control Panel > Settings tab > Server Backend > LDAP Data Sources and edit the data source (e.g. ad203). Click **Test Connection** to confirm it succeeds. Also validate that virtual views associated with this data source still work fine. This can be checked from the Directory Browser tab in the Main Control Panel.
