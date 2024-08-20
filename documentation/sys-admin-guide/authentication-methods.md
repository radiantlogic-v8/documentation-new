---
title: Authentication Methods
description: Details about the authentication methods supported in RadiantOne.
---

## Authentication Methods

>[!note] This section is accessible only in [Expert Mode](01-introduction#expert-mode).

To access the RadiantOne service via LDAP, the LDAP client must authenticate itself. This process is called a “bind” operation and means, the client must tell the LDAP server who is going to be accessing the data so that the server can decide what the client is allowed to see and do (authorization). After the client successfully authenticates, RadiantOne checks whether the client is allowed to perform subsequent requests. This process is called authorization and is enforced via [access controls](#access-control-terms--definitions).

RadiantOne supports three types of authentication: anonymous, simple and SASL.

**Anonymous:**

Clients that send an LDAP request without doing a "bind" are treated as anonymous. Clients who bind to RadiantOne without a password value are also considered anonymous. 

**Simple:**

Simple authentication consists of sending the LDAP server the fully qualified DN of the client (user) and the client's clear-text password. To avoid exposing the password in clear over the network, you can use SSL (an encrypted channel). For details on configuring SSL, please see the [SSL Settings](#ssl-settings) section.

**SASL:**

Clients that send an authentication request to RadiantOne using Kerberos (GSS-SPNEGO), MD5 (DIGEST-MD5) or Certificate (EXTERNAL) are leveraging one of the supported SASL mechanisms. The SASL EXTERNAL mechanism is supported by default, but you must configure the [Client Certificate to DN Mapping](/sys-admin-guide/06-security/#client-certificate-dn-mapping) so the RadiantOne service knows how to identify the user in the certificate to a user in the RadiantOne namespace. 


## Kerberos

RadiantOne supports Kerberos v5, and can act as both a [Kerberos client](#kerberos), and a Kerberized service. As a Kerberos client, RadiantOne can request tickets from a KDC to use to connect to kerberized services. As a Kerberized service, RadiantOne can accept tickets from clients as a form of authentication. These configurations have been certified with Windows 2000, 2003 and 2008 in addition to MIT Kerberos on Linux CENTOS. This section describes RadiantOne support as a Kerberized server. For details on RadiantOne support as a Kerberos client, please see the section on defining [LDAP data sources](04-backend-settings#ldap-data-sources). The following diagram provides the high-level architecture and process flow for RadiantOne acting as a Kerberized service.

![RadiantOne as a Kerberized Service](Media/Image3.87.jpg)
 
Figure 7: RadiantOne as a Kerberized Service

Kerberos can be used for authentication to RadiantOne (acting as a Kerberized Service) as long as the client resides within the same domain or trusted domain forest as the RadiantOne service (and the RadiantOne machine must be in the same Kerberos realm/domain, or at least within the same forest as Active Directory). To continue with configuring Kerberos for access to RadiantOne in Microsoft domains, follow the steps below. For details on MIT Kerberos support, see [Support for MIT Kerberos](#support-for-mit-kerberos).

>[!note] All machines (client, domain controller…etc.) must be in sync in terms of clock (time/date settings). Also, if you have deployed RadiantOne in a cluster, the service account created in the KDC can use the server name of the load balancer that is configured in front of the RadiantOne cluster nodes. <br> To use a generic or common account for multiple RadiantOne cluster nodes, you need to set the SPN on the account matching the FQDN of the host that requests the kerberos ticket. There is no need to create individual accounts for each RadiantOne node/host. Refer to the account using the UPN in the RadiantOne configuration. The account can have multiple SPNs. An example is shown below.<br>
sAMAccountName: svc-vdsadmin
<br>UPN: ldap/vds.example.net@example.net
<br>SPN: ldap/host1.example.net
<br>ldap/vds.example.net
<br>ldap/host2.example.net
<br>ldap/host3.example.net

### Configuring RadiantOne as a Kerberized Service

>[!warning] RadiantOne MUST be running on port 389. The default port for RadiantOne is 2389. To change the port, you must stop the RadiantOne service, and then edit the port from the Main Control Panel > Settings Tab > Administration section. After changing the port and saving your changes, restart the RadiantOne service. If RadiantOne is deployed in a cluster, all the service on all nodes.

1. Create a Kerberos identification for the RadiantOne service by creating a user account in the Active Directory domain controller (KDC) for the host computer on which RadiantOne runs. When creating the account, you can use the name of the computer. For example, if the host is named AMAZONA-EQ3PKP4.cloudcfs.radiant.com, create a user in Active Directory with a user logon name of AMAZONA-EQ3PKP4.cloudcfs.radiant.com.

    >[!note] If you have deployed RadiantOne in a cluster behind a load balancer (the clients access the load balancer), the KDC service account in Active Directory should use the server name of the load balancer. The UPN of the account should represent the load balancer machine and the SPN attribute should list the FQDN of each RadiantOne node in the cluster (as separate values of the SPN attribute). There is no need to create individual accounts for each RadiantOne host because the KDC account can have multiple SPNs. Each SPN will be associated with a RadiantOne node (and local traffic manager(s) if multiple layers of traffic managers are used). An example of a KDC account is described below.<br>
sAMAccountName: svc-vdsadmin
<br>UPN: ldap/vds.example.net@example.net
<br>SPN: ldap/vds.example.net@example.net
<br>ldap/host1.example.net
<br>ldap/vds.example.net
<br>ldap/host2.example.net
<br>ldap/host3.example.net

    ![Sample Active Directory Account for RadiantOne on the KDC](Media/Image3.88.jpg)

    Figure 8: Sample Active Directory Account for RadiantOne on the KDC

2. Create a User Mapping and Keytab file using KTPASS. 

    If you do not have the ktpass utility (part of the Windows Resource Kit Tools), you can download it from Microsoft’s website.

    Below is a sample command to be run on the KDC machine:

    `ktpass –princ ldap/AMAZONA-EQ3PKP4.cloudcfs.radiant.com@CLOUDCFS.RADIANT.COM -pass` 
    <br> `password -mapuser “vds server” -out c:\temp\amazona-eq3pkp4.LDAP.keytab `

    <br> `------result of executing the command------`
    <br> `Targeting domain controller: AMAZONA-CMF8EDC.cloudcfs.radiant.com`
    <br> `Successfully mapped AMAZONA-EQ3PKP4.cloudcfs.radiant.com to AMAZONA-EQ3PKP4.`
    <br> `Password successfully set!`
    <br> `WARNING: pType and account type do not match. This might cause problems.`
    <br> `Key created.`
    <br> `Output keytab to c:\temp\amazona-eq3pkp4.LDAP.keytab:`
    <br> `Keytab version: 0x502`
    <br> `keysize 97 ldap/amazona-eq3pkp4.radiant.com@CLOUDCFS.RADIANT.COM ptype 0` 
    <br> `(KRB5_NT_UNKNOWN) vno 3 etype 0x17 (RC4-HMAC) keylength 16` 
    <br> `(0xf70be0d13c22ee9e2bc249af6874019e)`

    -	Amazona-eq3pkp4.cloudcfs.radiant.com is the fully qualified domain name for the machine running RadiantOne.
    -	CLOUDCFS.RADIANT.COM is the realm and must be in upper case in the ktpass command.
    -	password is the password for the user account created in Step 1. 
    -	The keytab file will be in c:/temp and be named amazon-eq3pkp4.LDAP.keytab.

    After executing the ktpass command, if you go into the Active Directory account created in [Step 1](#configuring-radiantone-as-a-kerberized-service), you will see that the user login name value has been changed to ldap/amazona-eq3pkp4.cloudcfs.radiant.com.

    ![Example User Account on the KDC after using the ktpass Utility](Media/Image3.89.jpg)

    Figure 9: Example User Account on the KDC after using the ktpass Utility

3.	Go to the Main Control Panel > Settings Tab > Security section > Authentication Methods sub-section and check the box to enable Kerberos Authentication. Click **Save**.

4.	The userPrincipalName and password associated with the service account created in Active Directory (KDC) in the [first step](#configuring-radiantone-as-a-kerberized-service) can be entered in the Main Control Panel > Settings Tab > Security section > Authentication Methods sub-section > Kerberos Authentication section. RadiantOne uses this information to authenticate to the KDC when it starts if there is no keytab file present. If there is a keytab file present (and RadiantOne is configured to use it), and the keytab file contains the “principal” keyword with a value of the user principal name for the RadiantOne service account in the KDC, it is used to get the secret key/password to use for authenticating to the KDC instead of the settings configured in the Control Panel. If the keytab file does not contain the “principal” defined in it, you must set the user principal name in the Kerberos Authentication section, but you do not need to configure the password.

5. Copy the keytab file created when running the ktpass utility to the RadiantOne machine (anywhere on the machine is fine) and configure the needed parameters described below. This step is optional. If there is no keytab file present, RadiantOne uses the service principal and password that are defined on the Main Control Panel > Settings Tab > Security Section > Authentication Methods sub-section > Kerberos Authentication to authenticate to the KDC. 

    If you choose to copy the keytab file to the RadiantOne machine, edit the <RLI_HOME>/<instance_name>/conf/krb5/vds_krb5login.conf file. To enable RadiantOne to participate in SSO with clients via Kerberos tokens, a JAAS login file is needed to tell where and how the RadiantOne service is authenticated. The JAAS login file (vds_ krb5login.conf) is provided with RadiantOne. The default content of this file is as follows:

    `vds_server {`
    <br> `com.sun.security.auth.module.Krb5LoginModule required`
    <br> `storeKey=true;`
    <br> `};`

    If RadiantOne should use the keytab file, add the following parameters to the vds_krb5login.conf file:

    `useKeyTab=true`
    <br> `keyTab= "c:/radiantone/amazona-eq3pkp4.LDAP.keytab”`

    **useKeyTab** – set this to true if you want the server to get the principal’s key from the keytab. The default value (if this parameter is not set in the file) is False. As mentioned above, if there is no keytab specified, RadiantOne uses the service name and password defined on the Main Control Panel > Settings Tab > Security Section > Authentication Methods sub-section > Kerberos Authentication section on the right side, to authenticate to the KDC when the RadiantOne service first starts.

    **principal** – set this to the user principal name of the account in the KDC associated with the RadiantOne service. If this property is not defined in the keytab file, it must be set in the Main Control Panel > Settings Tab > Security section > Authentication Methods sub-section > Kerberos Authentication section.

    **keyTab** – set this to the full path and file name of the keytab to get the principal’s secret key. Surround the value with double quotes and the word keyTab is case-sensitive (it should appear in the vds_krb5login.conf file in this exact case).

    For information on other optional configuration parameters, please refer to the Krb5LoginModule class in the Java Authentication and Authorization Service (JAAS) documentation.

6. Edit the RadiantOne Kerberos configuration file to include the realm and KDC. The Kerberos configuration file is named vds_server_krb5.conf and is in <RLI_HOME>/vds_server/conf/krb5.

    Edit this file and set the appropriate values in the [libdefaults] and [realms] sections. Below is an example that matches the use case we have been using in this section.

    `[libdefaults]`
    <br> `default_realm = CLOUDCFS.RADIANT.COM`
    <br> `[realms]`
    <br> `CLOUDCFS.RADIANT.COM = {`
    <br> `kdc = 10.11.12.205:88`
    <br> `default_domain = CLOUDCFS.RADIANT.COM`
    <br> `}`

7.	Verify the RadiantOne rootdse responds with the appropriate Supported SASL Mechanisms by using a client (e.g. LDAP Browser) to query RadiantOne with a “blank/empty” base DN. The following should be returned.

    `supportedSASLMechanisms: GSSAPI`
    <br> `supportedSASLMechanisms: GSS-SPNEGO`

8. Configure Client Principal Name Mapping. This step is optional and can be used to define a mapping between the user who authenticates with a Kerberos ticket and a user DN in the virtual namespace. The DN is required for the RadiantOne service to enforce access permissions (authorization). If no client principal name mappings are configured, RadiantOne creates an account in a local Universal Directory store that is linked to the person who authenticated using a Kerberos ticket.

    There are three different ways to determine the DN from the user ID in the Kerberos ticket received in the LDAP bind (using regular expression syntax). Each is described below.

-	Setting a specific User ID to DN. In this example, if lcallahan were received in the authentication request, RadiantOne would base the authorization on the DN: cn=laura Callahan,cn=users,dc=mycompany,dc=com

`lcallahan (the user ID) 🡪 (maps to) cn= laura Callahan,cn=users,dc=mycompany,dc=com`

-	Specify a DN Suffix, replacing the $1 value with the User ID.

`(.+) -> uid=$1,ou=people,ou=ssl,dc=com`

`(.+) represents the value coming in to RadiantOne from the Kerberos ticket. If RadiantOne received a User ID of lcallahan, then the DN used for authorization is: uid=lcallahan,ou=people,ou=ssl,dc=com.`

-	Specify a Base DN, scope of the search, and a search filter to search for the user based on the User ID received in the bind request.

`(.+) -> dc=domain1,dc=com??sub?(sAMAccountName=$1)`

If RadiantOne received a User ID of lcallahan from the Kerberos ticket, it would issue a search like:

`dc=domain1,dc=com??sub?(sAMAccountName=lcallahan)`

The user DN returned from the search is used by RadiantOne to identify the user entry in the virtual namespace and to base authorization decisions on.

For the second and third options described above, multiple variables can be used (not just 1 as described in the examples). Let’s look at an example mapping that uses multiple variables:

`(.+)@(.+).(.+).com -> ou=$2,dc=$3,dc=com??sub?(&(uid=$1)(dc=$3))`

If RadiantOne received a user ID like laura_callahan@ny.radiant.com, the search that would be issued would look like:

`ou=ny,dc=radiant,dc=com??sub?(&(uid=laura_callahan)(dc=radiant))`

For more details, please see [Processing Multiple Mapping Rules](03-front-end-settings#processing-multiple-mapping-rules).

The user DN returned from the search is used by RadiantOne to identify the user entry in the RadiantOne namespace and to base authorization decisions on. For more information, please see [Authorization of Kerberos Users](#authorization-of-kerberos-users).

Changing any Kerberos-related parameters requires a restart of the RadiantOne service. Save your changes prior to restarting the service. 

### Accessing RadiantOne as a Kerberized Service from a Kerberos Client

The Kerberos client (user or machine) must also have an account on the KDC machine.

>[!warning]
>RadiantOne must be running on a different machine than the client that is connecting to it, otherwise the Microsoft libraries for LDAP use the local security and not a Kerberos ticket. This is only relevant for LDAP clients that use the Microsoft libraries (LDP and Softerra LDAP Administrator v3.3 for example).

The following example configurations describe:

-	Using JXplorer as the LDAP client connecting to RadiantOne as a Kerberized service.

-	Using LDP as the LDAP client connecting to RadiantOne as a Kerberized service.

-	Using Softerra LDAP Administrator v3.3 connecting to RadiantOne as a Kerberized service.

**Example 1 – Using JXplorer Client**

The Kerberos client user account logs into their machine and they must first make sure that JXplorer is configured to use Kerberos.

Edit the jxplorer.bat file (to pass a Java parameter specifying where to find the Kerberos configuration file) and then start JXplorer using this bat file. Below is an example of the file content. The Kerberos filename in this example is Kerberos.conf:

`--------------------------------jxplorer.bat---------------------------------------------`
<br> `rem # Use this version if limited by 256 character max batch file length (earlier windows versions)`
<br> `rem # java -Djava.ext.dirs=jars;dsml/jars com.ca.directory.jxplorer.JXplorer`

<br> `rem # This version is slightly preferable, as it doesn't override the standard java extensions directory`
<br> `rem # (note that 'classes' is only used if you are compiling the code yourself; otherwise jars/jxplorer.jar is used.)`
<br> `java -
Djava.security.krb5.conf=kerberos.conf -classpath .;jars/jxplorer.jar;jars/help.jar;jars/jhall.jar;jars/junit.jar;jars/ldapsec.jar;jars/log4j.jar;jars/dsml/activation.jar;jars/dsml/commons-logging.jar;jars/dsml/dom4j.jar;jars/dsml/dsmlv2.jar;jars/dsml/mail.jar;jars/dsml/saaf-api.jar;jars/dsml/saaj-ri.jar com.ca.directory.jxplorer.JXplorer`
<br> `--------------------------------------------------------------------------------------------------------`


Below is an example of the Kerberos configuration file that JXplorer references:

`--------------------------------kerberos.conf-----------------------------------------------------`
<br> `[libdefaults]`
<br> `  default_realm = CLOUDCFS.RADIANT.COM   `

<br> `[realms]`
<br> `	CLOUDCFS.RADIANT.COM = {`
<br> `		kdc = 10.11.12.205:88`
<br> `		default_domain = CLOUDCFS.RADIANT.COM`
<br> `	}`
<br> `------------------------------------------------------------------------------------------------------`

After you run JXplorer, click on connect and enter the parameters to connect to RadiantOne. In the Security section, choose the GSSAPI option.

![JXplorer Authenticating to RadiantOne using Kerberos](Media/Image3.90.jpg)

Figure 10: JXplorer Authenticating to RadiantOne using Kerberos

After the Kerberos client user successfully authenticates via Kerberos, authorization will be determined based on the access rights configured in RadiantOne. For more information, please see the section titled, [Authorization of Kerberos Users](#authorization-of-kerberos-users).

Example 2 – Using LDP Client
<br>Run ldp and create a new connection. Enter the values for RadiantOne and click **OK**.

![Connection to RadiantOne from LDP Client](Media/Image3.91.jpg)

Figure 11: Connection to RadiantOne from LDP Client

Click **Advanced**, you should have the NEGOTIATE (or in older LDP versions, use the SSPI method) selected. See Figure below.

![LDP Bind Options](Media/Image3.92.jpg)

Figure 12: LDP Bind Options

You do not need to enter a user password. Just click OK. See below as an example.

![LDP after Authenticating to RadiantOne via Kerberos](Media/Image3.93.jpg)

Figure 13: LDP after Authenticating to RadiantOne via Kerberos

After the Kerberos client user successfully authenticates via Kerberos, authorization is determined based on the access rights configured in RadiantOne. For more information, please see the section titled, [Authorization of Kerberos Users](#authorization-of-kerberos-users).

**Example 3 – Using Softerra LDAP Administrator Client**

The following describes the connection parameters from Softerra LDAP Administrator v2012.2.

1. Create a new profile specifying the RadiantOne connection criteria. Be sure to use the fully qualified name for RadiantOne machine.

    ![Sample Connection to RadiantOne from Softerra](Media/Image3.94.jpg)

    Figure 14: Sample Connection to RadiantOne from Softerra

2. Click **Next**.

3. You can choose the option currently logged on user (for Active Directory only) or select the GSS Negotiate mechanism and specify the username you want to use to connect and click Finish. See the screen shots below as an example.

    ![Use User Currently Logged into the Machine Option](Media/Image3.95.jpg)

    Figure 15: Use User Currently Logged into the Machine Option

    ![Specifying Alternate Credentials](Media/Image3.96.jpg)

    Figure 16: Specifying Alternate Credentials

4. Click **Finish**. At the bottom of the LDAP Administrator console you will be able to see whom you are connected as (johnny_appleseed@setree1.com is the example shown below). 

![An image showing ](Media/Image3.97.jpg)

Figure 15: Softerra LDAP Administrator Interface

After the Kerberos client user successfully authenticates via Kerberos, authorization will be determined based on the access rights configured in RadiantOne. For more information, please see the section titled, [Authorization of Kerberos Users](06-security#authorization-of-kerberos-users).
 
### Support for MIT Kerberos

The following steps were certified on Linux CENTOS to configure RadiantOne as a Kerberized service.

1. To manage the Kerberos database locally, launch

    `kadmin.local`

2. Add the RadiantOne service to Kerberos database with the following:

    `add_principal ldap/vds.novato.radiantlogic.com@EXAMPLE.COM`

3. Ensure FQDN of service can be resolved via DNS using ping or other methods.

4. Ensure unlimited Java cipher suites are installed. This is to be compatible with certain clients using stronger cyphers. Note that Kerberos can be enabled in RadiantOne without installing the extra ciphers, but most clients using kerberos require these ciphers that RadiantOne does not bundle out of the box. For details on installing unlimited cipher suites, see the [RadiantOne Hardening Guide](/hardening-guide/00-preface).

5. From the Main Control Panel > Settings Tab > Security section > Authentication Methods enable Kerberos Authentication and enter the user principal name and service password associated with the RadiantOne service account that was created in the KDC.

6. Click **CHANGE** next to Client Principal Name Mapping and define the mapping to be used for authorization.

7. Restart the RadiantOne service.

![Enabling RadiantOne as a Kerberized Service](Media/Image3.98.jpg)

Figure 16: Enabling RadiantOne as a Kerberized Service

### Authorization of Kerberos Users

After a client successfully authenticates with a Kerberos ticket, RadiantOne tries to link the user to a DN based on any Client Principal Name Mappings that you have set up. If no Client Principal Name Mappings are defined or if no mapping results are found for a particular user, RadiantOne translates the user principal name and realm into a DN and stores that user in the local LDAP store below a suffix of ou=krbusers,cn=config. The user DN consists of the principal name and the realm (from which they came from). An example would be:

`uid=lcallahan,cn=NOVATO.RADIANTLOGIC.COM,ou=krbusers,cn=config`

In the example above, all users who authenticate from the NOVATO.RADIANTLOGIC.COM realm are located here. Each realm has its own location in the local LDAP store. Below is an example from a different realm:

`uid=sbuchanan,cn=NA.RADIANTLOGIC.COM,ou=krbusers,cn=config`

Once the user is stored locally (or linked to an existing DN), they can be added to groups and included in access control lists. This allows users who authenticate using Kerberos access to protected information in the RadiantOne namespace. See below for the location in the directory tree for the authenticated users (This location is for users that could not be linked using Client Principal Name Mappings).

![An image showing ](Media/Image3.99.jpg)

Figure 17: Location of Users who Successfully Authenticate using Kerberos

## MD5

If desired, an LDAP client can send RadiantOne a hashed password using Digest MD5 for authentication. RadiantOne must have access to the password in clear. When the password is received, RadiantOne uses the Digest MD5 hashing algorithm to encrypt it and compare to the value received from the client. If the compare succeeds, the bind was successful. Otherwise, the bind fails.

To enable MD5 authentication, check the MD5 Authentication box from the Main Control Panel > Settings Tab > Security section > Authentication Methods sub-section.

Changing any MD5-related settings requires a restart of the RadiantOne service after saving the new settings.

**Server Fully Qualified Name**

Enter the Server fully qualified name for the machine running RadiantOne (<machine_name>.<domain_name>).

**Client User Name Mapping**

After authentication via MD5, authorization (access permissions) must be determined. Client User Name Mapping can be used to set up a mapping between the user who authenticates using MD5 and a user DN in the virtual namespace. The DN is required to set access permissions and for RadiantOne to enforce authorization. If no client user name mappings are configured (or the ones configured fail to link the user name to a valid DN in the virtual tree), then RadiantOne allows [anonymous access](access-control#allow-anonymous-access) (you must make sure anonymous access is allowed). To configure the mapping, click **Change** next to the Client User Name Mapping parameter.

There are three different ways to determine the DN from the user ID received in the LDAP bind (using regular expression syntax). Each is described below.

- Setting a specific User ID to DN. In this example, if lcallahan were received in the authentication request, RadiantOne would base the authorization on the DN: cn=laura Callahan,cn=users,dc=mycompany,dc=com

`lcallahan (the user ID) -> (maps to) cn= laura Callahan,cn=users,dc=mycompany,dc=com`

-	Specify a DN Suffix, replacing the $1 value with the User ID.

`(.+) -> uid=$1,ou=people,ou=ssl,dc=com`

`(.+) represents the value coming into RadiantOne from the bind operation. If it received a User ID of lcallahan, then the DN RadiantOne bases authorization on is: uid=lcallahan,ou=people,ou=ssl,dc=com.`

-	Specify a Base DN, scope of the search, and a search filter to search for the user based on the User ID received in the bind request.

`(.+) -> dc=domain1,dc=com??sub?(sAMAccountName=$1)`

If RadiantOne received a User ID of lcallahan from the bind request, it would issue a search like:

`dc=domain1,dc=com??sub?(sAMAccountName=lcallahan)`

The user DN returned from the search is used by RadiantOne to identify the user entry in the RadiantOne namespace and to base authorization decisions on.

For options 2 and 3 described above, multiple variables can be used (not just 1 as described in the examples). Let’s look at an example mapping that uses multiple variables:

`(.+)@(.+).(.+).com -> ou=$2,dc=$3,dc=com??sub?(&(uid=$1)(dc=$3))`

If RadiantOne received a user ID like laura_callahan@ny.radiant.com, the search that would be issued would look like:

`ou=ny,dc=radiant,dc=com??sub?(&(uid=laura_callahan)(dc=radiant))`

The user DN returned from the search is used by RadiantOne to identify the user entry in the virtual namespace and to base authorization decisions on.

For more details, please see [Processing Multiple Mapping Rules](interception#processing-multiple-mapping-rules).

## Global Authentication Strength

The Global Authentication Strength parameter is used to specify that a client must bind to RadiantOne by using a specific authentication method. The parameter is configured on the Main Control Panel > Settings Tab > Security section > Authentication Methods. The values are as follows:

**None**
<br>There are no restrictions on what authentication method a client uses. This is the default.

**Simple**
<br>The bind rule is evaluated to be true if the client is accessing the directory using a username and password.

**SSL**
<br>The client must bind to the directory over an SSL/TLS or STARTTLS connection. The bind rule is evaluated to be true if the client authenticates to the directory by using simple authentication (bind DN and password) or with a certificate over LDAPS.

**SASL**
<br>The bind rule is evaluated to be true if the client authenticates to the directory by using one of the following SASL mechanisms: DIGEST-MD5, GSSAPI, EXTERNAL or GSS-SPNEGO.

**Simple LDAP Bind**
<br>For accounts stored in Universal Directory (HDAP) stores, the following table lists the potential LDAP response codes returned during bind operations.

Condition | Bind Response Error Code and Message
-|-
User Name and Password are Correct. Bind is successful.	 | Error code 0
Valid User Name with Incorrect Password. Bind is unsuccessful. | Error code 49, Reason 52e - invalid credentials
Invalid User Name/DN. Bind is unsuccessful. | Error code 49, Reason 525 – User not found
Valid User Name with Expired Password. Bind is unsuccessful.| Error code 49, Reason 532 – Password expired. Password has expired. <br>Password Expired Response Control: 2.16.840.1.113730.3.4.4
User Name and Password are Correct. Account is locked due to nsAccountLock attribute set to true. Bind is unsuccessful. |Error code 53, Reason 533 - Account disabled: Account inactivated. Contact system administrator to activate this account.
Valid User Name with Incorrect Password. Account locked due to too many bind attempts with invalid password. Bind is unsuccessful. | Error code 19, Reason 775 – Account Locked: The password failure limit has been reached and the account is locked. Please retry later or contact the system administrator to reset the password.
Valid User Name with no password. Bind might succeed; it depends on the “Bind Requires Password” setting. | If “Bind Requires Password” is enabled, error code 49, invalid credentials, is returned. If “Bind Requires Password” is not enabled, the user is authenticated as Anonymous.
User Name and Password are Corrrect. Account is locked due to inactivity. Bind is unsuccessful.	| Error Code 50, Reason 775 – Account Locked. This account has been locked due to inactivity. Please contact the system administrator to reset the password.
No User Name with no password. Bind is successful. | Error code 0. User is authenticated as Anonymous. <br>Even if “Bind Requires Password” is enabled, error code 0 is returned. User is authenticated as Anonymous.
[Bind Requires SSL or StartTLS](#bind-requires-ssl-or-starttls) is enabled and a user attempts to bind over a non-SSL connection. | Error code 13. Confidentiality Required.

