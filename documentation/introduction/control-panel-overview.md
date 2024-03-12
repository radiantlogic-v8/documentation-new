---
title: Introduction to the Control Panel
description: Learn how to navigate the Control Panel.
---

## Overview
The Control Panel is a web-based interface that administrators use to configure and manage the RadiantOne Identity Data Management product.
RadiantOne also offers a configuration API that can be called programmatically with an [Access Token](/documentation/configuration/security/access-tokens).

## Accessing the Control Panels
The Control Panels utilize a web server that is installed with RadiantOne. The endpoint to access the Control Panel is defined when you create an environment in the Environment Operations Center. For details on creating environments and locating the Control Panel endpoint, see [Create Environments](/documentation/installation/create-environments).

![The Control Panel Login Page](Media/login-page.jpg)


### Classic Control Panel
To switch to Classic Control Panel, use the menu options for the logged in user in the upper right.

![Classic Control Panel](Media/classic-cp.jpg)

The currently logged in user must have permissions to [access the Classic Control Panel](#permissions).

For more details, see [Configuration Required in Classic Control Panel](#switch-to-classic-control-panel)

## Authentication 

### Username and Password 
Log in using the directory administrator (cn=directory manager) as the user with the password you set during the install of RadiantOne. Once logged in, the Directory Administrator should navigate in the Control Panel to the ADMIN section and define other users needed to administer RadiantOne. A user can either use their full DN (if known), or their user ID. However, to login with just a user ID, you must configure a [user ID to DN Mapping](/documentation/configuration/global-settings/client-protocols).

The Control Panel displays a message when authentication fails. The table below lists the possible error messages. 

Message	 | Cause | Solution
-|-|-
“Authentication failed. Reason: Access is denied.” | Incorrect login ID or incorrect password. | Verify the login ID and password and try again.
"Authentication failed. Reason [LDAP: error code 49 - Password has expired.]" | The user's password has expired. | If the client application supports password reset capabilities, the user can reset their password. <br>The Classic Control Panel supports resetting expired passwords. The user can click the *Reset Password* link in the message displayed on the Classic Control Panel to set a new password. If the [password policy](documentation/configuration/security/password-policies) associated with the user requires the current password to set a new password, the user is prompted to enter their current password along with the new password. 
“Authentication failed. Reason: [LDAP: error code 19 - The password failure limit has been reached and the account is locked. Please retry later or contact the system administrator to reset the password.]” | The account is locked. | Retry later or contact the system administrator to reset the password.

### Last Login Time
The time the user last logged into the Control Panel is displayed above the "Logged in as..." information shown in the top right.

![Last Login Time](Media/lastlogin.jpg)

### MFA 
Support for MFA logins, you must integrate with an OIDC provider that offers MFA. The MFA checking is handled by the OIDC provider. See the OIDC token configuraton below.

### OIDC Token 
The RadiantOne Control Panel supports SSO with your corporate Identity Provider using OpenID Connect (OIDC) token-based authentication. This option provides the security of sending user login credentials to the authentication server (the Identity Provider), not the application (Control Panel, the Relying Party). OpenID Connect token authentication allows you to send your username and password just once, to the Identity Provider (IDP), have MFA validated (if enabled and supported by the Identity Provider), and then pass the token in the request to the Control Panel. When OIDC is configured in RadiantOne, the Control Panel login screen displays:

![Login with Open ID Connect](Media/login-corp-sso.jpg)

The administrator must click the "Log in with Corporate SSO" option to login with an OpenID Connect token.

The high-level flow is shown below.

![An image showing ](Media/Image3.23.jpg)


Detailed steps:

1.	The RadiantOne Admin navigates his browser to the RadiantOne Control Panel and clicks “Login with Corporate SSO”.

2.	The browser redirects the user to the OIDC Provider’s authorization endpoint with the necessary parameters (ClientID, redirect URI, scope).

3.	The RadiantOne Admin authenticates to the OIDC server (if not already authenticated) and the OIDC server prompts the user for authorization: Control Panel wants to access info (scopes) about you. Do you Authorize this?

4.	Admin user gives consent.

5.	OIDC server gives Control Panel an Authorization code.

6.	The Control Panel sends the OIDC server the authorization code and requests an ID token.

7.	OIDC Server sends the ID token to Control Panel.

8.	Control Panel uses the information in the token along with the *Claims to User DN Mapping rules* to locate the user in the RadiantOne namespace to enforce permissions based on what delegated admin role the user is a member of – which dictates what the admin is allowed to do within the Control Panel.

To enable support for OIDC authentication:

1.	Have your client ID and secret associated with the Control Panel application configured in your OIDC server ready. The Redirect URL configured for the web application should point to the URL associated with the Control Panel. Example: https://cp.federated-identity.com/main/j_spring_openid_security_check

2.	Log into the Control Panel.

3.	Navigate to Admin > Control Panel Configuration tab.

4.	Select an OIDC Provider from the drop-down list. If you are using your own provider, select the Custom option.

5.	Click "Discover Endpoint URLs". The Authorization Endpoint URL and Token Endpoint URL should auto-populate. If you configure a custom provider, you can enter the needed Authorization Endpoint URL and Token Endpoint URL. In OpenID Connect the authorization endpoint handles authentication and authorization of a user. In the OpenID Connect Authorization Code Flow, the token endpoint is used by a client to obtain an ID token, access token, and refresh token.

6.	Enter the Client ID associated with the Control Panel application configured in the OIDC provider.

7.	Enter the Client Secret associated with the Control Panel configured in the OIDC provider.

8.	Select the Client Authentication Method corresponding to how the Control Panel client has been configured in the OIDC Server. There are two options available: CLIENT_SECRET_POST and CLIENT_SECRET_BASIC.

9.	Select a value for Requested Scopes to display a list of possible choices: openid, email, profile..etc. Openid is required. You can add more if needed as long as they match the configuration of the client in the OIDC server. Click **ADD SCOPE** to add the selected scope to the configuration.

10.	Click **ADD MAPPING** next to *DN Mapping Expression*. This configuration determines the logic to link the user that logs into the Control Panel with an Open ID Connect token with an identity in the RadiantOne namespace. This process determines which identity is used to enforce authorization within the Control Panel. The user mappings must result in a single user. If no user is found or if more than one user is found, the login fails. The RadiantOne user that is linked to the authentication token must be a member of a RadiantOne default or custom [Delegated Administrative group](#default-delegated-admin-roles). 

11.	In the OIDC to FID User Mappings window, click `Add`.

12.	There are two options for identifying the RadiantOne admin user. If the RadiantOne user can be identified by using values/claims from the token to comprise the DN, use the Simple DN Mapping. If the RadiantOne user can be identified by performing a lookup in RadiantOne based on values from the token, use the Advanced DN Mapping.

13.	Click **SAVE**.

Examples of configuring the Simple DN Mapping and an Advanced DN Mapping are shown below.

In the Simple DN Mapping example shown below, the RadiantOne user is identified by using the given_name and family_name claims from the token to compute the DN.

![DN Expression Builder](Media/simple-dn-mapping.jpg)

In the Advanced DN Mapping example shown below, the values of the family_name, given_name, and email claims from the token are used to condition a sub-tree search in RadiantOne, starting at the dc=mydomain naming context to locate the identity.

![Search Expression Builder](Media/adv-dn-mapping.jpg)

To disable support for OIDC authentication:

1. Log into the Control Panel. 

1. Navigate to Admin > Control Panel Configuration tab.

1. Click the Enabled toggle from on to off for the OpenID Connect Provider. 

	![OIDC Provider Toggle](Media/oidc-toggle.jpg)

1. Click **SAVE**.

   
## Authorization 
Roles-based access controls are used to enforce privileges for Control Panel. Any user that can authenticate to RadiantOne can administrator the service if they belong to the proper group that is associated with one of the delegated administrator roles. RadiantOne includes default delegated admin roles that users can be assigned to. Custom delegated admin roles can also be defined. 
Roles & permissions are managed from Control Panel > Admin > Roles & Permissions.

Assigning roles to users is done from Control Panel > Admin > User Management tab.

### Default Delegated Admin Roles
The default delegated admin roles can be viewed from Control Panel > Admin > Roles & Permissions. The default roles cannot be edited. However, you can use the default role definition as a basis for defining a new custom role by choosing the default role from the list when prompted to *Clone Permissions* during new role creation.

**Directory Administrator:**  Members assigned this role can perform all operations (all operations that the other default roles can perform) in addition to being able to update username and password properties for data sources via an LDAP modify command.

Control Panel Config	| Permissions
-|-
SETUP > Data Catalog > Data Sources | View & Edit
SETUP > Data Catalog > Template Management | View & Edit
SETUP > Directory Namespace > Namespace Design | View & Edit
SETUP > Directory Namespace > Directory Schema | View & Edit
MANAGE > Directory Browser | View & Edit
MANAGE > Tasks | View & Edit
MANAGE > Security > Attribute Encryption | View & Edit
MANAGE > Security > Access Control | View & Edit
GLOBAL SETTINGS | View & Edit
ADMIN > User Management | View & Edit
ADMIN > Roles & Permissions | View & Edit
ADMIN > Directory Manager Settings | View & Edit
ADMIN > Control Panel Config | View & Edit
ADMIN > Access Tokens | View & Edit
ADMIN > Entry Statistics | View & Edit
ACCESS CLASSIC CONTROL PANEL | Impersonate Role defined for cn=directory administrators,ou=globalgroups,cn=config

**Namespace Administrator:**  Members assigned this role are responsible for managing the RadiantOne namespace. The namespace is managed from Control Panel > Setup > Directory Namespace > Namespace Design.
The responsibilities include:
-  Creating new naming contexts and mounting backends
-  Configuring and managing identity views
-  Configuring and managing persistent cache
-  Creating and managing RadiantOne directory stores
-  Creating and managing synchronization pipelines 

Control Panel Config	| Permissions
-|-
SETUP > Data Catalog > Data Sources | View & Edit
SETUP > Data Catalog > Template Management | View & Edit
SETUP > Directory Namespace > Namespace Design | View & Edit
SETUP > Directory Namespace > Directory Schema | View & Edit
MANAGE > Directory Browser | View & Edit
MANAGE > Tasks | View & Edit
MANAGE > Security > Attribute Encryption | View Only
MANAGE > Security > Access Control | View Only
GLOBAL SETTINGS | View Only
ADMIN > User Management | View Only
ADMIN > Roles & Permissions | View Only
ADMIN > Directory Manager Settings | View Only
ADMIN > Control Panel Config | View Only
ADMIN > Access Tokens | View Only
ADMIN > Entry Statistics | View Only
ACCESS CLASSIC CONTROL PANEL | Impersonate Role defined for cn=namespaceadmin,ou=globalgroups,cn=config

**Schema Administrator:**  Members assigned this role are responsible for managing the RadiantOne LDAP schema. The schema is managed from Control Panel > Setup > Directory Namespace > Directory Schema.
The responsibilities include:
- Creating new LDAP object classes and attributes
- Extending the RadiantOne LDAP schema with objects and attributes from data source (backend) schemas.
- Importing new LDIF formatted files to extend the RadiantOne LDAP schema.

Control Panel Config	| Permissions
-|-
SETUP > Data Catalog > Data Sources | View & Edit
SETUP > Data Catalog > Template Management | View & Edit
SETUP > Directory Namespace > Namespace Design | View & Edit
SETUP > Directory Namespace > Directory Schema | View & Edit
MANAGE > Directory Browser | View Only
MANAGE > Tasks | View Only
MANAGE > Security > Attribute Encryption | View Only
MANAGE > Security > Access Control | View Only
GLOBAL SETTINGS | View Only
ADMIN > User Management | View Only
ADMIN > Roles & Permissions | View Only
ADMIN > Directory Manager Settings | View Only
ADMIN > Control Panel Config | View Only
ADMIN > Access Tokens | View Only
ADMIN > Entry Statistics | View Only
ACCESS CLASSIC CONTROL PANEL | Impersonate Role defined for cn=schemaadmin,ou=globalgroups,cn=config

**Security Administrator:**  Members assigned this role are responsible for managing access controls, password policies, and attribute encryption. 
Access controls are managed from Control Panel > Manage > Security > Access Controls.
The responsibilities include:
- Creating and managing access controls
- Creating and managing password policies
- Managing attribute and LDIF file encryption
- Manage access tokens

Control Panel Config	| Permissions
-|-
SETUP > Data Catalog > Data Sources | View Only
SETUP > Data Catalog > Template Management | View Only
SETUP > Directory Namespace > Namespace Design | View Only
SETUP > Directory Namespace > Directory Schema | View Only
MANAGE > Directory Browser | View Only
MANAGE > Tasks | View Only
MANAGE > Security > Attribute Encryption | View & Edit
MANAGE > Security > Access Control | View & Edit
GLOBAL SETTINGS | View Only
ADMIN > User Management | View Only
ADMIN > Roles & Permissions | View Only
ADMIN > Directory Manager Settings | View Only
ADMIN > Control Panel Config | View Only
ADMIN > Access Tokens | View & Edit
ADMIN > Entry Statistics | View Only
ACCESS CLASSIC CONTROL PANEL | Impersonate Role defined for cn=aciadmin,ou=globalgroups,cn=config

**Read Only:**  Members assigned this role can only view configurations. They are not allowed to edit anything.

Control Panel Config	| Permissions
-|-
SETUP > Data Catalog > Data Sources | View Only
SETUP > Data Catalog > Template Management | View  Only
SETUP > Directory Namespace > Namespace Design | View  Only
SETUP > Directory Namespace > Directory Schema | View  Only
MANAGE > Directory Browser | View Only
MANAGE > Tasks | View Only
MANAGE > Security > Attribute Encryption | View Only
MANAGE > Security > Access Control | View Only
GLOBAL SETTINGS | View Only
ADMIN > User Management | View Only
ADMIN > Roles & Permissions | View Only
ADMIN > Directory Manager Settings | View Only
ADMIN > Control Panel Config | View Only
ADMIN > Access Tokens | View Only
ADMIN > Entry Statistics | View Only
ACCESS CLASSIC CONTROL PANEL | Impersonate Role defined for cn=readonly,ou=globalgroups,cn=config

### Creating Roles 
Custom roles can be created from Control Panel > Admin > Roles & Permissions tab. 
1. Click **ADD ROLE**.
2. Enter the role name.
3. (Optional) select an existing role to quickly clone/assign similar permissions to the new role.
4. Click **OK**.
5. Go through each set of permissions and assign the proper privilege: None, View Only, or View & Edit.
6. Click **SAVE**.

### Permissions
The permissions available for creating custom roles in the new Control Panel are not applicable to the Classic Control Panel. However, custom roles can be associated with a Classic Control Panel role to allow administrators the needed access to both the new and Classic Control Panels.

**Classic Control Panel**

Classic Control Panel has the following admins and groups by default:

Default administrative user | Group membership 
-|-
uid=aciadmin,ou=globalusers,cn=config | Member of the ACI Administrator Group.
uid=namespaceadmin,ou=globalusers,cn=config | Member of the Namespace Administrator Group.
uid=operator,ou=globalusers,cn=config | Member of the Operator Group.
uid=schemaadmin,ou=globalusers,cn=config | Member of the Schema Administrator Group.
uid=superadmin,ou=globalusers,cn=config | Member of the Directory Administrator Group.
uid=icsadmin,ou=globalusers,cn=config | Member of the ICS Administrator Group.
uid=icsoperator,ou=globalusers,cn=config | Member of the ICS Operator Group.
uid=readonly,ou=globalusers,cn=config | Member of the Read Only Group.

The roles and corresponding required permissions are described in the table below.

Role	| Required Permissions (Value of vdPrivilege)
-|-
<span style="color:lightblue">Directory Administrator</span> <br> Members of this group can perform all operations (all operations that the other groups defined below can perform) in addition to:<br>Change privileges for the delegated roles<br>Access the Synchronization Tab <br>Update username and password properties for data sources via LDAP modify command | <span style="color:lightblue">config-read <br>config-write <br>services-restart <br> services-shutdown <br>update-schema <br>instance-read <br>instance-write <br>acl-read <br>acl-write <br>naming-context-read <br>naming-context-write <br>data-source-read <br>data-source-write <br>data-store-read <br>data-store-write <br>ics-admin <br>tasks-admin <br>globalidviewer-read <br>globalidviewer-write </span>
<span style="color:lightblue">Read Only</span> <br> Members of this group can read the RadiantOne configuration, read settings for any configured instances, read naming context configurations, read configured data sources, and view synchronization topologies on the Synchronization Tab. | <span style="color:lightblue">config-read <br>instance-read <br>naming-context-read <br>data-source-read <br>globalidviewer-read </span>
<span style="color:lightblue">Namespace Administrator</span> <br> Members of this group can perform the following operations:<br> Read RadiantOne configuration<br> Access Wizards tab in Main Control Panel<br> Restart the RadiantOne service from Main Control Panel<br> Create, update, or delete naming contexts<br> Create, update, or delete backend mappings<br> Create, update, and manage persistent cache <br> Create, update, or delete data sources<br> Create, update, or delete RadiantOne Directory stores<br> Update RadiantOne LDAP schema<br> Launch tasks	| <span style="color:lightblue">config-readconfig-write <br>services-restart<br>update-schema <br>naming-context-read<br>naming-context-write <br>data-source-read <br> data-store-read <br> data-store-write <br> tasks-admin <br> ics-admin
<span style="color:lightblue">Operator</span> <br> Members of this group can perform the following operations: <br> Read RadiantOne configuration <br> Create, update, or delete RadiantOne Directory (HDAP) Stores <br> Restart the RadiantOne service from the Main Control Panel <br> Stop the RadiantOne service from the Main Control Panel <br> Launch Tasks | <span style="color:lightblue">config-read <br> config-write <br> services-restart <br> services-shutdown <br> data-store-read <br> data-store-write <br> tasks-admin <br> naming-context-read</span>
<span style="color:lightblue">Schema Administrator </span> <br> Members of this group can perform the following operations: <br> Read RadiantOne configuration <br> Create, update or delete schema objects (objectclasses or attributes <br> Extend RadiantOne LDAP schema with objects and attributes from orx files <br> Create, update or delete data sources | <span style="color:lightblue">config-read <br> update-schema <br> data-source-read <br> data-source-write </span>
<span style="color:lightblue">ACI Administrator</span> <br> Members of this group can perform the following operations: <br> Read RadiantOne configuration <br> Create, update and delete access controls | <span style="color:lightblue">config-read <br> acl-read <br> acl-write <br> naming-context-read </span>
<span style="color:lightblue">ICS Administrator</span> <br> Members of this group can perform the following operations: <br> Read RadiantOne configuration <br> Access Wizards tab in Main Control Panel <br> Perform all operations from the Synchronization Tab <br> | <span style="color:lightblue">config-read <br> config-write <br> naming-context-read <br> data-source-read <br> ics-admin <br> ics-workflow-approve <br> tasks-admin <br> globalidviewer-read <br> globalidviewer-write <br> globalidviewer-designer</span>
<span style="color:lightblue">ICS Operator</span> <br> Members of this group can perform the following operations: <br> Read RadiantOne configuration <br> Access the Synchronization tab and read topologies <br>  | <span style="color:lightblue">config-read <br> ics-operator

**New Control Panel**

For the new Control Panel, each class of permissions matches a section in the left navigation menu.

![Roles and Permissions](Media/roles-and-perms1.jpg)
![Roles and Permissions](Media/roles-and-perms2.jpg)

- **DATA CATALOG**: Assign permissions to configure and manage data sources with the ability to set specific permission overrides for specific data sources. For example, you can assign a set of users permissions to manage and use a specific set of data sources.  The data sources must be defined prior to assigning permisssions.
- **DIRECTORY NAMESPACE**: Assign permissions to namespace design (where identity views are created from) and directory schema (where the LDAP directory schema is managed).
- **DIRECTORY BROWSER**: Assign permissions to the Directory Brower where entries in the RadiantOne namespace can be managed.
- **SECURITY**: Assign permissions to configure attribute encryption and access controls.
- **TASKS**: Various actions (e.g. initializing a RadiantOne directory) are launched as tasks. Use this to assign permissions for admins that can manage tasks (e.g. change JVM settings, modify task schedules, delete tasks...etc.).
- **GLOBAL SETTINGS**: Assign permissions to configuration for LDAP access (supported directory controls and user to DN mapping), and the client certificate truststore (to manage client certificates for SSL/TLS communications.
- **ADMINISTRATION**: Assign access to user management, roles & permissions, directory manager settings, control panel configuration, access tokens and entry statistics.
- **CLASSIC CONTROL PANEL**: enable or disable access to the Classic Control Panel and indicate what role (identified by group membership) should be enforced in the Classic Control Panel. This is to allow administrators the needed access to both the new and Classic Control Panels.

### Assigning Users to Roles
Admin users can be assigned to roles from Control Panel > Admin > User Management tab.
Either search for a user to manage their roles, or click **CREATE USER** to create a new user and assign their roles during the creation.

**Creating Users**
1. From Control Panel > Admin > User Management tab, click **CREATE USER**.
2. Enter a username.
3. Enter a passwod.
4. Confirm the password.
5. Enter a first name.
6. Enter a last name.
7. Enter an email address.
8. Toggle the status to either active or inactive. Inactive users are not allowed to log into Control Panel.
9. To assign roles, select a role from the drop-down list and click **+ASSIGN ROLE**. Repeat this step until all roles are selected.
10. Click **CREATE**.

**Assigning Roles to Existing Users**
1. From Control Panel > Admin > User Management tab, search for a user and click on the username to select it.
2. Locate the *Assign Roles* section.
3. Select a role from the drop-down list and click **+ASSIGN ROLE**. Repeat this step until all roles are selected.
4. Click **SAVE**
    
 
## Customizing the Classic Control Panel 
The following settings are currently only applicable to the **Classic Control Panel**.

To switch to Classic Control Panel, use the menu options for the logged in user in the upper right.

![Classic Control Panel](Media/classic-cp.jpg)

### Color theme 
The Classic Control Panel can have a custom color theme.

### Message of the Day 
The Classic Control Panel login page contains a basic username and password text box. To add a custom message on the login page, follow the steps below.

1.	Switch to the Classic Control Panel as a member of the Directory Administrators role.
1.	Go to the Settings tab > Server Front End > Administration.
1.	In the *Message of the Day Configuration*, enter the message contents.
1.	Enter a message title (will display if a popup window is used).
1.	(Optional) check the box to enable a "Warning" icon if you want the message to be prefixed with a "Warning".
1.	(Optional) check the box to enable a "Popup" message that displays the message title and contents that the user must explicitly acknowledge and close. 
1.	Click **Save**.
1.	Log out of the Classic Control Panel to be returned to the login screen to view the custom message.

An example of a custom message on the login page is shown below.

![Custom Message on Login Page](Media/Image3.26.jpg)

An example of a custom message using the "Warning" icon on the login page is shown below.

![Custom Message on Login Page with Warning Label and Bold Font](Media/Image3.27.jpg)

An example of a custom message using the "Popup" on the login page is shown below.

![Custom Message Popup Window](Media/Image3.28.jpg)


### Banner 
A custom message can be added to the banner of RadiantOne User Interface pages. This includes the Classic Control Panel, the Server Control Panel, the login page, and the logout landing page.

To add a custom message:

1. Log into the Classic Control Panel as a member of the Directory Administrators role. 

2. Navigate to Settings > Administration > Internal Banner Configuration section. 

3. Enter the message to appear in the banner in the Banner Text field. 

4. Specify a color in the Banner Background Color field. You can indicate the color by name or by hex color code.

    >[!note] If you enter a hex color code, include the "#" character here. If the color specified is not recognized, it defaults to gray. 

5. Specify the banner's text color. You can indicate the color by name or by hex color code.

    >[!note] If you enter a hex color code, include the "#" character here. If the color specified is not recognized, it defaults to gray. 

    ![internal banner configuration](Media/internal-banner-config.jpg)

6. Click **Save**. The next time the Classic Control Panel is opened (or the browser tab is refreshed), the custom banner message is displayed. 

![banner message](Media/banner-message.jpg)

## Navigating the Control Panel 

### Dashboard 

### Setup

**Data Catalog**

*Data Sources (managing data sources)*

*Schemas (managing schemas)*

*Drivers and Templates (managing templates)*

**Directory Namespace**

The RadiantOne namespace can be comprised of many different root naming contexts. Each one can represent a different type of backend configuration. This might be a RadiantOne Directory store, or an identity view created from a data source (LDAP, database, or custom).  The configuration of the namespace is managed in the Namespace Design section.  The LDAP schema for RadiantOne is configured in the Directory Schema section.

*Namespace Design*

The RadiantOne namespace is managed from here. Create and manage RadiantOne Directory stores, identity views, and persistent cache from here. For details, see: [Managing Directory Stores](/documentation/configuration/directory-stores/managing-directory-stores) and [Managing Identity Views](/documentation/configuration/identity-views/intro-view-design).

*Directory Schema*

The RadiantOne LDAP directory schema is managed from here. For details, see: [Managing Directory Schema](/documentation/configuration/directory-stores/managing-directory-schema).

*Global Identity Builder*

The [Global Identity Builder](/documentation/configuration/global-identity-builder/concepts) is only access in the Classic Control Panel.
To switch to Classic Control Panel, use the menu options for the logged in user in the upper right.

![Classic Control Panel](Media/classic-cp.jpg)

The currently logged in user must have permissions to [access the Classic Control Panel](#permissions).

### Manage 

**Directory Browser**

Entries can be managed from the [Directory Browser](/documentation/directory-stores/managing-directory-stores#managing-radiantone-directory-entries).

**Tasks**

[Manage Tasks](/documentation/configuration/global-settings/tasks) from here.

**Security**  

*Attribute Encryption*

[Manage Attribute Encryption](/documentation/configuration/security/attribute-encryption) from here.

*Password Policies* 

[Manage Password Policies](/documentation/configuration/security/password-policies) from Classic Control Panel.

*Access Controls* 

[Manage Access Controls](/documentation/configuration/security/access-controls) from here.

### Global settings

*Client Protocols*  

Manage supported LDAP controls and user-to-DN mapping from the Control Panel > Global Settings > Client Protocols > [LDAP](/documentation/configuration/global-settings/client-protocols).

[Manage the SCIM interface](../web-services-api-guide/rest) from Classic Control Panel.

[Manage the REST interface](../web-services-api-guide/rest) from Classic Control Panel.

*Client Certificates*

Manage client certificates from the Control Panel > Global Settings > [Client Certificates](/documentation/configuration/global-settings/client-certificates).

*Token Validators* 

*Tuning* 

*Attributes Handling*

Manage attributes handling from Classic Control Panel > Settings > Server Front End > Attributes Handling
![Attributes Handling Section](Media/Image3.45.jpg)
 
<ins>Hide Operational Attributes</ins>
Check the Hide Operational Attributes option on the Classic Control Panel > Settings tab > Server Front End > Attributes Handling section if you do not want LDAP clients to have access to operational attributes (stored in a RadiantOne Directory store) such as: createTimestamp, modifiersName, modifyTimestamp, creatorsName…etc. If you choose to hide operational attributes, LDAP clients must specifically request the operational attribute they want during the search request, otherwise it is not returned.

>[!note] 
>Operational attributes are not hidden from the root user (e.g. cn=Directory Manager) or members of the cn=Directory Administrators group.

Uncheck the Hide Operational Attributes option if LDAP clients are allowed to view the attributes.

<ins>Operational Attributes Excluded from Being Hidden</ins>
If checked, the Hide Operational Attributes option hides all operational attributes from non-root users and users that are not a member of the cn=Directory Administrators group. To accommodate third-party integrations that rely on certain operational attributes, without requiring the service account to have Directory Administrator privileges, you can indicate a list of operational attributes that should not be hidden. Indicate them in the Exclude Operational Attributes From Being Hidden field. Separate attribute names with a single space. 

<ins>Attributes Not Displayed in Logs</ins>

This property allows you to control which attribute values are not printed in clear in the RadiantOne logs. If you do not want certain attribute values printed in clear in the logs, you can indicate them here. Each attribute name should be separated with a single space. Any attribute indicated here has a value of ***** printed in the logs instead of the value in clear.

<ins>Binary Attributes</ins>

Sometimes, LDAP directory schema definitions do not define certain attributes as binary even though the value of these attributes is binary. An example of this is the objectGUID attribute in Microsoft Active Directory. If the LDAP backend schema definition does not properly define the attribute type as binary, RadiantOne does not translate the value properly when returning it to an LDAP client. To ensure RadiantOne translates the value as binary, you must list the attribute name in the Binary Attributes parameter (space separated list). This parameter is global and applies to any backend LDAP that RadiantOne is accessing. The binary attributes can be defined from the Main Control Panel > Settings tab > Server Front End > Attributes Handling section. As long as the attribute name is listed, RadiantOne returns the value to a client as binary even if the backend LDAP server doesn’t define it as such.

>[!note] 
>If a binary attribute should be searchable, define the attribute in the RadiantOne LDAP schema with a friendly name indicating it as binary. Below is an example for the certificateRevocationList attribute: attributeTypes: ( 2.5.4.39 NAME ( 'certificateRevocationList;binary' 'certificateRevocationList' ) DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.5 X-ORIGIN 'RFC 2256’ )

<ins>Excluded Attributes from Active Directory</ins>

This parameter is for Active Directory backends and is used for excluding specific attributes from being returned from the backend. Certain “system” attributes (e.g. dscorepropagationdata) returned from Active Directory (even for non-admin users) can cause problems for building persistent cache because the data type is not handled properly, and these attributes need to be added to the RadiantOne LDAP schema for the local storage to handle them in the cache. Also, these attributes cause problems for the change capture connector needed for real-time persistent cache refresh to work properly. Attributes that are not required by RadiantOne client applications, should be added to this list to ensure they are not returned in the view from Active Directory. By default, the AD attributes that are excluded are ds*, acs*, ms* and frs* (* is a wildcard meaning that any attributes with those prefixes are excluded). Any attributes that you do not want returned from the backend Active Directory can be added to the Excluded Attributes property. This value is defined from the Main Control Panel > Settings tab > Server Front End > Attributes Handling section. Make sure a space separates the attributes listed. Click **Save** when finished.

<ins>Multi-Valued Database Attributes</ins>

The Multi-Valued Database Attributes setting can be managed from the Main Control Panel > Settings tab > Server Front End > Attributes Handling section. This parameter allows for special processing of a database attribute that contains a multi-value. The database attribute must contain values separated by a space then the pound sign (#), then a space before the next value. For example, assume the following table existed inside a database:

Database Table Sample:

Name | Mail | 	Title
-|-|-
Harold Carter | hcarter@rli.com # harold@yahoo.com | HR Admin # HR # HR MGR

RadiantOne can return the database record with multi-valued attributes for Mail and Title.

Entry returned by RadiantOne with Multi-Valued Attributes Set:

```
cn=Harold Carter
mail = hcarter@rli.com
mail = harold@yahoo.com
title = HR Admin
title = HR
title = HR MGR
```

For RadiantOne to return database attributes as multi-valued, the attribute names must be listed in the Multi-valued DB Attributes parameter. The value of this parameter should be the database attribute name (or Mapped Attribute Name if one is being used). If there is more than one attribute, separate them with a comma.

If the Multi-valued DB Attributes parameter is not set, then RadiantOne would return the following:

Entry returned by RadiantOne if NO Multi-Valued Attributes Set:

```
cn=Harold Carter
mail = hcarter@rli.com # harold@yahoo.com
title = HR Admin # HR # HR MGR
```

*Duplicates Handling*
Manage duplicates handling from Classic Control Panel > Settings > Server Front End > Duplicates Handling.

<ins>Duplicate DN Removal</ins>

During the identification phase (finding the person in the directory tree) of the authentication process, it is important that a search for a specific, unique user account only returns one entry.

When aggregating model-driven virtual views (created in Context Builder) from multiple sources, there is the potential to have duplicate DN’s (because the same person exists in more than one source or the same identifier belongs to different people). Returning multiple users with the same DN is a violation of an LDAP directory. Therefore, if your virtual namespace encounters this configuration issue, you can enable the Duplicate DN Removal option to have RadiantOne return only the first entry. This is fine if the duplicate DN’s result in the same person. If they are not the same person, then you have a different problem which is identity correlation (correlating and reconciling the same person in multiple data sources) that needs to be addressed. To assist with your identity correlation problem, please see [Global Identity Builder Guide](/documentation/configuration/global-identity-builder/introduction).

Let’s look at an example of duplicate DN’s being returned for the same person. A person named Laura Callahan has an Active Directory account and a Sun Directory account. If both sources are virtualized and then merge-linked into a common virtual tree, a search on the tree would yield two results (because the RDN configured in the virtual views is exactly the same). Below is a screen shot of the virtual tree where both virtual views are linked, and a search from the Control Panel > Manage > Directory Browser, that returns two results.

![Virtual View Aggregating Two Data Sources](Media/Image3.47.jpg)
 
Figure 10: Virtual View Aggregating Two Data Sources

![Same user ID Exists in Multiple Data Sources that have been Aggregated by RadiantOne](Media/Image3.48.jpg)
 
Figure 11: Same user ID Exists in Multiple Data Sources that have been Aggregated by RadiantOne

If Laura Callahan in Active Directory is in fact the same Laura Callahan as in Sun, you can enable Duplicate DN Removal to consolidate the two accounts. The screen shots below show the Duplicate DN Removal option enabled and the new result for the search.

![Duplicate DN Removal Setting](Media/Image3.49.jpg)
 
Figure 12: Duplicate DN Removal Setting

![Search Result after Enabling Duplicate DN Removal](Media/Image3.50.jpg)
 
Figure 13: Search Result after Enabling Duplicate DN Removal

The one entry returned with attributes from the first source the user was found in (Active Directory in this example).

![Result of Duplicate DN Removal](Media/Image3.51.jpg)
 
Figure 14: Result of Duplicate DN Removal

<ins>Duplicate Identity Removal Rules</ins>

>[!note] 
>In general, it is usually recommended that you use the [Global Identity Builder](/documentation/configuration/global-identity-builder/introduction) to build your view if you know you have overlapping entries that require correlation/disambiguation.

In cases where RadiantOne is aggregating common user identities from multiple data sources, you have the option to configure it to remove any duplicate users (from search responses) if it finds there is a common attribute/identifier (across the data sources you have aggregated). It can also be used as a way for RadiantOne to eliminate ambiguity by returning only one unique entry. Let’s take two sources as an example. Source 1 is Active Directory and source 2 is a Sun directory. Both sources have been aggregated into the virtual namespace below a naming context of dc=demo and as the two following screens show, Laura Callahan exists in both.

![Virtual Entry from Active Directory Backend](Media/Image3.52.jpg)
 
Figure 15: Virtual Entry from Active Directory Backend

![Virtual Entry from Sun Directory Backend](Media/Image3.53.jpg)
 
Figure 16: Virtual Entry from Sun Directory Backend

The unique Identifier between the examples above is employeeID (employeeNumber in Sun has been mapped to employeeID to provide a common attribute between Sun and Active Directory). Therefore, a subtree search for employeeID=8 below dc=demo would return two people in this example.

![Two Entries are Returned based on Filter of EmployeeID=8](Media/Image3.54.jpg)
 
Figure 17: Two Entries are Returned based on Filter of EmployeeID=8

Now, if Duplicate Identity Removal rules are configured, RadiantOne returns only the first entry that it finds (in this case, the one from Active Directory). Multiple duplicate identity rules can be configured (each branch in the RadiantOne namespace may have a duplicate identity removal rule). In addition, multiple attributes may be used to determine a duplicate identity. For example, you can set uid,employeeid and this means if an entry has the same uid and employeeid then it is the same person. Make sure to list the attributes you want to use to determine a duplicate identity with a comma separating each attribute name. Remember to save your settings after defining the rules.

![Duplicate Identity Removal Settings](Media/Image3.55.jpg)

Figure 18: Duplicate Identity Removal Settings

>[!warning] 
>The identity attribute selected, must satisfy the following requirements: 
<br>Single-valued <br>Represent an identity (sAMAccountName, employeeID, etc...) <br>If the attribute is not present in an entry, the entry is returned. <br>If no suffix is specified, this identity attribute applies to the whole server search response.<br>The RadiantOne service must be restarted after changing these parameters. <br>Any search response returned by RadiantOne (below the specified starting suffix) checks if another entry with the same attribute/value has already been returned. If an entry with the same identity attribute value has been returned, then others are not returned.

![One Entry for Laura is Returned with Duplicate Identity Removal Rules Enabled](Media/Image3.56.jpg)

Figure 19: One Entry for Laura is Returned with Duplicate Identity Removal Rules Enabled

This is ideal for handling authentication requests (to ensure only one entry is returned to base authentication on). However, for authorization purposes, if a user exists in more than one source, only attributes from the first source are returned. If you need a complete profile of attributes coming from all the user’s accounts, then you need to configure joins to all branches in the virtual tree where the user may have an account. This join condition can be based on the identity attribute (or any other attribute that can be used to uniquely identify the person in the other branch). As a result, searches for the user still return only one entry. Without a join configured across these virtual views, only attributes from the first source the user was found in would be returned. For details on joining, please see [Joins](02-concepts#joins) in the Concepts section.

>[!warning] 
>If your use case requires identity correlation to address user overlap, and a complete identity profile is needed for authorization, you should review the capabilities of the [Global Identity Builder](/documentation/configuration/global-identity-builder/introduction) as opposed to trying to use Duplicate Identity Removal.

*Changelog*

*Log Settings* 

### Admin  

**Directory Admin Settings** 

*Directory Manager Account*
The directory manager (cn=directory manager by default) is the super user for the directory and this account is defined during the RadiantOne install. For details on defining this account, see the Environment Operations Center Guide.

The super user is the only user that can log into the Control Panel while RadiantOne is not running. When you log into the Control Panel with this user, you can perform any of the operations described in [Delegated Administration](#default-delegated-admin-roles). Also, access permissions and password policies do not apply for this user. This safety measure prevents someone from accidentally denying the rights needed to access and manage the server. Access to this super user account should be limited. If you require many directory managers, add these as members to the [Directory Administrator Role](#default-delegated-admin-roles) instead of having them all use the single super user account.

The RadiantOne super user account is associated with an LDAP entry in the RadiantOne namespace located at: cn=Directory Manager,ou=RootUsers,cn=config. Cn=Directory Manager,ou=RootUsers,cn=config is authorized the same as cn=Directory Manager. 

To configure the Directory Manager username:

1.	From Control Panel > Admin > Directory Manager Settings tab, locate the Directory Manager Account settings.
1.	Enter the value in the USERNAME property.
	>[!warning] The new value of the parameter should be in the same syntax: `cn=<new user value>`.

1.	Click **SAVE**.

1.	Restart the RadiantOne service.

1.	Re-open the Control Panel.

1.	Log in as the new username.

If you update the Directory Manager username, the LDAP entry in the RadiantOne namespace is located at: cn=Directory Manager,ou=RootUsers,cn=config is updated with a seeAlso attribute that contains the value of the new username. This allows the new username to be used to log into the Control Panel.

*Directory Manager Password*

The directory administrator (e.g. cn=directory manager) password is set during the install of RadiantOne and can be updated in Control Panel. You must know the current password to update the password. To change this password, from the Control Panel > Admin > Directory Manager Settings tab, locate the Directory Manager Account settings. Click ![Pencil](Media/pencil.jpg) an enter the old (current) password and the new value. Confirm the new value and click **SAVE PASSWORD**.

>[!warning] 
>If you change the password and you are currently logged into the Control Panel as the directory administrator, you must close the Control Panel and re-open it logging in with the new password.

You can also change the directory administrator’s password via LDAP. The DN representing the directory administrator is: cn=Directory Manager,ou=RootUsers,cn=config. The example below is using an LDIF file and the ldapmodify command to modify the password:

`dn: cn=Directory Manager,ou=RootUsers,cn=config`
<br>`changetype: modify`
<br>`replace: userPassword`
<br>`userPassword: newpassword`

An example of the syntax used in the command is shown below, assuming the LDIF file described above is named ChangePassword.ldif. You must bind as the cn=directory manager with the current password in order to update the password with this LDAP command.

`ldapmodify.exe -D "cn=Directory Manager,ou=RootUsers,cn=config" -w currentpassword -h localhost -p 2389 -f c:\radiantone\ChangePassword.ldif`

>[!note] 
>The RadiantOne service may be running when this command is executed.

You can also change the directory administrator's password via REST (ADAP API). The following commands can be issued from a Linux client that is able to connect to the RadiantOne service's REST endpoint.
Set the following on the Linux client:
```
REST_ENDPOINT="https://localhost:9101"
BIND_DN="cn=Directory Manager"
BIND_USER_DN="cn=Directory Manager,ou=rootusers,cn=config"
CURRENT_PASSWORD="MySuperSecretPassw0rd2"
NEW_PASSWORD="MySuperSecretPassw0rd3"
BASE64_USERNAME_PASSWORD=$(echo -n $BIND_DN:$CURRENT_PASSWORD | base64)
```

Run the following curl command on the Linux client:
```
curl -k --location --request PATCH "$REST_ENDPOINT/adap/$BIND_USER_DN" \
--header "Content-Type: application/json" \
--header "Authorization: Basic $BASE64_USERNAME_PASSWORD" \
--data '{
   "params": {
      "mods": [
       {
         "attribute": "userPassword",
         "type": "REPLACE",
          "values": [
           "'$NEW_PASSWORD'"
           ]            
          }
       ]
   }
}'
```

<br>
If the command is successful, an HTTP status of 200 is returned: 
{"httpStatus":200}

An example of using Postman as a REST client to update the cn=directory manager password is shown below.
1. Add an Authorization header that contains Basic with the base 64 encoded value for cn=directory manager:currentpassword. Use cn=directory manager in the authorization header value, not cn=Directory Manager,ou=RootUsers,cn=config. E.g. <br>Basic Y249RGlyZWN0b3J5IE1hbmFnZXI6bmV3cGFzc3dvcmQxMjM=
![Authorization Header Example](Media/restheaderexample.jpg)
2. Issue a PATCH operation with `http://RESTENDPOINT:8089/adap/cn=Directory Manager,ou=RootUsers,cn=config` with the following body:

```
{
    "params": {
        "mods": [
            {
                "attribute": "userPassword",
                "type": "REPLACE",
                "values": ["newpassword"]
            }
        ]
    }
}
```
![REST PATCH Example](Media/restbodyexample.jpg)


*Administrators Group DN*

This parameter can be set to the DN of the Administrators group defined in the virtual namespace. The administrators group is checked for authorization purposes as members of this group do not have limits or password policy enforced for them. To manage this value, from the Control Panel > Admin > Directory Manager Settings Tab > Special Group section. Enter the value of a valid group DN located in the RadiantOne namespace.

![Directory Administrator Group DN](Media/special-group-dn.jpg)

**User Management**

[Manage delegated admin users](#assigning-users-to-roles) from here.

**Roles & Permissions** 

[Manage default and custom roles](#default-delegated-admin-roles) from here.

**Control Panel Configuration**  

[Manage the OIDC Provider Configuration to support SSO into Control Panel](#oidc=token) from here.

**Access Tokens** 

[Manage Access Tokens](/documentation/configuration/security/access-tokens) from here.

**Entry Statistics**

[Run Entry Statistics Reports](/documentation/reporting/reporting#entry-statistics-report) from here.

### File Manager

File Manager is only accessible in the Classic Control Panel.

RadiantOne does not allow access to its files via operating system user interfaces. The File Manager option allows you to view, upload, and download files that reside under the RLI_HOME directory. It also allows you to build jar files. To access the File Manager, in the Classic Control Panel, go to Settings > Configuration > File Manager. The default location displayed is RLI_HOME.

>[!note] Files at the RLI_HOME level cannot be modified with File Manager. 

![File Manager Navigation](Media/file-manager-navigation.png)

To navigate within File Manager, click a folder in the main File Manager pane, or click a link the navigation bar at the top of the File Manager. To go up one folder, click the up-arrow button. 

Some files types are hidden from view in File Manager. These file types include the following.

- .cer
- .keystore
- .truststore

**Uploading Files**

Uploads can be made anywhere within the <RLI_HOME>, except within <RLI_HOME> itself.

To upload a file, click **Upload Files**. In the File Upload window, navigate to the file to be uploaded, select the file, and click **Open**.

**Actions Drop-down Menu**

The Actions drop-down menu allows perform the following functions. 

- Download files
- Delete files
- Open a selection
- Clear a selection

**Downloading Files**

To download a file in File Manager, navigate in File Manager to the file's location. From the Actions drop-down menu, select Download Files.

**Deleting Files**

The Delete Files option allows you to delete one file at a time. To delete a file in File Manager, navigate to the file's location. From the Actions drop-down menu, selct Delete Files. The file is downloaded to the location indicated by your web browser. 

**Open Selection**

Some files, such as text, LDIF, XML, and jar files are viewable in File Manager. To view a file in File Manager, navigate to the file's location. From the Actions drop-down menu, select Open Selection. 

>[!note] Files such as .class files are not openable in File Manager. 

**Building Jar Files**

The File Manager allows you to build jar files. 

To build jar files:

1. In the Classic Control Panel, click Settings > Configuration > File Manager. 

1. In File Manager, browse to RLI_HOME/vds_server/custom or any folder within. In the menu bar beneath the navigation bar, the Build drop-down menu displays. 

    ![Build Drop-down Menu](Media/file-manager-build.png)

1. From the Build drop-down menu, select an option.

![File Manager Options](Media/build-jar.png)

### Switch to Classic Control Panel 
Some settings must be managed using the RadiantOne Classic Control Panel.
To switch to Classic Control Panel, use the menu options for the logged in user in the upper right.

![Classic Control Panel](Media/classic-cp.jpg)

The following settings must be managed from the RadiantOne Classic Control Panel:
-	Synchronization: Classic Control Panel > Synchronization tab <br> See [Synchronization](/documentation/configuration/synchronization/synchronization-concepts) for details. 
-	Password Policies​: Classic Control Panel > Settings > Security > Password Policies <br> See [Password Policies](/documentation/configuration/security/password-policies) for details. 
-	SCIM config (frontend): ​Classic Control Panel > Settings > Server Front End  > SCIM <br> See [SCIM](../web-services-api-guide/scim) for details. 
-	REST config (frontend)​: Classic Control Panel > Settings > Server Front End > Other Protocols <br> See [REST](../web-services-api-guide/rest) for details. 
-	External Token Validators​: Classic Control Panel > Settings > Security > External Token Validators
-	Limits​: Classic Control Panel > Settings > Limits <br> See [Limits](../tuning/tuning-limits) for details. 
-	Attribute Handling​: Classic Control Panel > Settings > Server Front End > Attributes Handling
-	Duplicates Handling​: Classic Control Panel > Settings > Server Front End > Duplicates Handling
-	Changelog Settings​: Classic Control Panel > Settings > Logs > Changelog 
-	Log Settings​: Classic Control Panel > Settings > Logs > Log Settings <br> See [Log Settings](../troubleshooting/troubleshooting) for details. 
-	Control Panel customizations (lock, color theme, session timeout, max users, banner, custom message on login screen)​: ​Classic Control Panel > Settings > Server Front End > Administration
-	PCache Refresh Monitoring: Classic Control Panel > PCache Monitoring tab
-	Intercluster Replication Monitoring: Classic Control Panel > Replication Monitoring tab
-	File Manager: Classic Control Panel > Settings > Configuration > File Manager <br> See [File Manager](#file-manager) for details.
-	Zookeeper: Classic Control Panel > ZooKeeper tab
