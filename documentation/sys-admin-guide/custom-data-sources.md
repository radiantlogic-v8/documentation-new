---
title: Custom Data Sources
description: Details about how to configure custom data sources.
---

# Custom Data Sources

A custom data source is defined as something that cannot be accessed directly using JDBC/ODBC or LDAP. To access these types of data sources, you need to configure what is known as a custom object. RadiantOne includes a few default custom objects representing data sources you can virtualize. These data sources are for the following applications: Google Apps, Azure AD, Okta Universal Directory, any SCIM v1 source, any SCIM v2 source, Workday, Concur, Epic, SharePoint Users and Profile, and SharePoint Online Profile. To use these objects in virtual views, you just need to update the connection properties to point to your own application instances. For more details on leveraging these custom data sources in virtual views, please see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

To edit a custom data source, from the Main Control Panel > Settings Tab > Server Backend section > Custom Data Sources sub-section, select the custom data source from the list and click **Edit**. Select a custom property and click **EDIT**. Save your changes when finished.

![Sample Custom Data Source](Media/Image3.73.jpg)

Figure 13: Sample Custom Data Source

>[!warning]
>Most default custom data sources do not support authentication operations. They are primarily to allow for provisioning/de-provisioning identity information to these apps through RadiantOne and/or retrieving identity profile information from these apps for RadiantOne to present a complete user profile (to join views of these backends to identities from other data sources). However, Azure AD (graphapi and mgraph data sources) and Okta Universal Directory (oktaclient data source) do support authentication operations. For details on creating virtual views from the default custom data sources, see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

## DSML/SPML Sources

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

## SCIM v2 Sources

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


