## ADAP External Token Validators

External token validators allow applications to use an access token to call an API on behalf of itself. The API then responds with the requested data. This section assumes that your OIDC provider is already set up.

>[!warning] The processes described in this section are not hardened against security risks. For more information on hardening RadiantOne, refer to the [RadiantOne Hardening Guide](/hardening-guide/00-preface). 

### Getting an Access Token

This section describes using the Postman REST client to obtain an access token. 

1. Start a new request. 
1. Click the Auth tab.
1. From the Type drop down menu, select OAuth 2.0. The Current Token section displays. 

![Type drop-down menu](Media/typemenu.jpg)

Figure 21: The Type drop-down menu
 
1. In the Configure New Token section, enter the Client ID and client secret.

    >[!note] These values were created during the OIDC provider configuration process. 

1. Provide the access token URL. 

    >[!note] This value can be found using the using the metadata URL from the Authorization Server. 

![Configuring an access token in Postman](Media/configuringtoken.jpg)

Figure 22: Configuring an access token in Postman

1. Click Get New Access Token. The new access token's details are displayed. 

![token details](Media/tokendetails.jpg)

Figure 23: The Token Details section in Postman
 
1. Copy this token and decode it for the values needed by the FID server. You can do this at https://jwt.io/.

1. Keep the decoded token. Several values contained within are required for mapping attributes. 

### RadiantOne Configuration

This section describes configuring proxy authorization, configuring an ADAP external token validator, and attribute mapping.

**Configuring Proxy Authorization**

The RadiantOne ADAP (or SCIM) service queries the RadiantOne LDAP service using proxy authorization.

To configure proxy authorization: 

1. In the Main Control Panel, navigate to Settings > Server Front End > Supported Controls.

1. Enable Proxy Authorization and click Save.

1. Navigate to Settings > Security > Access Control.

1. Enable the “Allow Directory Manager to impersonate other users” option and click Save.

**Configuring ADAP External Token Validator**

To add an external token validator:

1. In the Main Control Panel, navigate to Settings > Security > External Token Validators. 

1. Click **Add**. The New ADAP External Token Validator page displays.

![The New ADAP External Token Validator Page](Media/externaltokenvalidatorpage.jpg)

Figure 24: The New ADAP External Token Validator Page

1. Name the external token validator.

1. Toggle the Enable switch to On. 

1. Select an OIDC provider from the drop-down menu (if applicable, to assist with populating the Directory URL syntax). Otherwise, skip this step and enter your own Discovery URL. 

1. If the Discovery URL is not loaded automatically, paste the Metadata URI from your OIDC authorization server into the Discovery URL field. 

1. Click Discover. The JSON Web Key Set URI auto-populates. 

1. Use the Expected Audience from your OIDC client to populate the Expected Audience field. 

1. Other values can be obtained from the decoded access token. See the [Getting An Access Token](#getting-an-access-token) section for more information.  

![Configuring an ADAP External Token Validator](Media/configuringtokenvalidator.jpg)

Figure 25: Configuring an ADAP External Token Validator

1. Click Edit next to Claims to FID User Mapping. The OIDC to FID User Mappings page displays.

1. Click Add. 

1. Define either a search expression or a simple DN Expression. In this example, a search expression is defined as shown below. 

![Editing OIDC to FID User Mapping](Media/editingmapping.jpg)

Figure 26: Editing OIDC to FID User Mapping

1. Click OK. Click OK again to close the OIDC to FID User Mappings window.

1. Click Save. 

**Attribute Mapping**

Map a uniquely identifying attribute to a corresponding claim value in the token (refer to the [Getting An Access Token](#getting-an-access-token) section for more information). In the following image, the attribute **mail** is mapped to the claim value **email**.

>[!note] In some cases, creating a new attribute may be required.

![search expression builder](Media/searchexpressionbuilder.jpg)

Figure 27: The Search Expression Builder

### Completing the Request with Postman

To complete the request with Postman:

1. Request a new access token (see [Getting An Access Token](#getting-an-access-token)). 
1. Click Use Token. This inserts an Authorization header that inserts your bearer token. 

![Requesting a new access token](Media/requestnewaccesstoken.jpg)

Figure 28: Requesting a new access token

1. Send the bearer token to the FID ADAP. In this example, a basic ADAP search is performed. 

Field |	Value
-|-
URL Syntax	|http://`<ip:port>`/adap/<baseDN>
Example URL |http://54.219.166.170:8089/adap/o=companydirectory
Method	|Get

![Sending the bearer token to RadiantOne](Media/Image..jpg)

Figure 29: Sending the bearer token to RadiantOne

