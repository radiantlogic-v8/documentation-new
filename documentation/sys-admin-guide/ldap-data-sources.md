# LDAP Data Sources

An LDAP data source represents a connection to an LDAP/JNDI-accessible backend.

>[!warning] When configuring data sources for Active Directory backends, always enable the Paged Results Control option.

To add an LDAP data source:
1.	From the Main Control Panel > Settings Tab > Server Backend section > LDAP Data Sources sub-section, click **Add**.

![Adding a New LDAP Data Source](Media/Image3.63.jpg)

Figure 3: Adding a New LDAP Data Source

2.	Enter a unique data source name along with the connection information to reach your backend server. Also select the type of LDAP Data Source (VDS/OpenDJ/SunOne/Active Directory/Novell/Other LDAP).

>[!warning] Do not use spaces, commas, brackets or parenthesis, colons, or the word “domain” in the data source name and do not use special characters in the Base DN value.

3.	Click **Test Connection** to validate the values entered above.

4.	Click **Save** to apply the changes to the server.

## LDAP Data Source Advanced Settings

For LDAP backends there are five additional settings that are optional: SSL/TLS, STARTTLS, Mutual Authentication, Kerberos, Chasing Referrals and the Paged Results Control. These options are described below.

### SSL/TLS

If the backend LDAP server you are connecting to uses a certificate issued by a trusted Certificate Authority, then all you need to do is enter the SSL port and check the SSL checkbox when you define the data source. If the server you are connecting to uses a self-signed certificate, then this certificate must be imported into the [RadiantOne client truststore](06-security#client-certificates-default-java-truststore).

### Verify SSL Certificate Hostname

This setting is only applicable if SSL is used to connect to the backend. If enabled, RadiantOne validates the CN/SAN of the certificate and only establishes a connection to the backend if the hostname matches. This setting is not enabled by default meaning that RadiantOne doesn’t validate the hostname to the CN/SAN of the certificate for SSL connections.

>[!note] RadiantOne does not perform a reverse lookup when the Host Name for the backend is defined as an IP address instead of a fully qualified server name.

### STARTTLS

If the backend LDAP server supports STARTTLS, you can configure the connection to be upgraded to use LDAPS on bind by prefixing your Bind DN parameter in the data source with tls: like shown in the following screen.

Some important tips for using STARTTLS are:

-	There is no extra space between the colon and the username.

-	Do NOT check the SSL checkbox. A secure connection is used for the bind and other connections flow over a non-SSL connection/port.

-	If the underlying LDAP server’s certificate has been signed by a trusted CA, then you do not need to import it into the RadiantOne client truststore. However, if the certificate has not been signed by a trusted CA, then you must import the certificate into the RadiantOne client truststore before attempting to connect via STARTTLS.

    Below is an example of the setting:

![Configuration for RadiantOne to Connect to the Underlying LDAP Server via STARTTLS](Media/Image3.64.jpg)

Figure 4: Configuration for RadiantOne to Connect to the Underlying LDAP Server via STARTTLS

>[!warning]
>When using STARTTLS, be aware that you cannot use the IP of the server in the Host Name parameter, you need the exact name of the server (which should match what is in the certificate), or you will get the following error: <br> ...JNDI connect Error : javax.net.ssl.SSLPeerUnverifiedException: hostname of the server '10.11.12.203' does not match the hostname in the server's certificate.

### Mutual Authentication

If you want to use mutual authentication between RadiantOne and the backend LDAP directory, in the data source configuration, Bind DN parameter specify cert:<client certificate file> instead of an actual user DN. In this case, RadiantOne is the client when accessing the underlying LDAP server. Also the suffix of the certificate file must indicate the store type. For example, PFX assumes pkcs12. If no suffix is specified, or the suffix is unknown, JKS type is assumed.

Below are the valid values for the suffix:

-	jks
-	pfx 
-	pkcs12
-	pkcs11

The Bind Password for the data source configuration should be the one defined in the certificate itself, and the same as the keystore password.

`Example:`
<br> `Host: ADServer1.na.radiantlogic.com` 
<br> `Port: 389`
<br> `Bind DN: cert:mycert.pfx`
<br> `Bind Password: mypassword`

![Enabling Mutual Authentication Between RadiantOne and the Underlying LDAP Server](Media/Image3.65.jpg)

Figure 5: Enabling Mutual Authentication Between RadiantOne and the Underlying LDAP Server

Some important tips are: 

-	Do not use an extra space between the colon and the certificate file name. 

-	All client certificate files need to be stored under: <RLI_HOME>/certs

-	There should be one file per certificate, and the certificate password and keystore password must be the same.

-	When storing a private certificate in a java keystore, the store password and the certificate password must match. This is why you should put only one certificate per store.

-	RadiantOne uses StartTLS when connecting to the backend directory. Therefore, the SSL checkbox should be UNchecked and the normal (non-SSL) port should be listed in the port parameter of the data source.

### Kerberos

RadiantOne can play the role of a Kerberos client and issue a bind request with a Kerberos ticket to a backend LDAP server leveraging the SASL GSSAPI mechanism. This allows RadiantOne to connect to and virtualize data from any LDAP-accessible kerberos service (typically Active Directory, but could be any Kerberized LDAP service) in the same domain/realm as the RadiantOne server or any trusted domain/realm using Windows Integrated Authentication (WIA). 

![RadiantOne Acting as a Kerberos Client](Media/Image3.66.jpg)

Figure 6: RadiantOne Acting as a Kerberos Client – Note the client accessing RadiantOne is NOT portrayed in this Diagram

To use this option, you first need to define a Kerberos profile.

>[!note] All machines (client, domain controller…etc.) must be in sync in terms of clock (time/date settings).

### Kerberos Profile

A Kerberos profile file defines the realm, domain and KDC information. All Kerberos profiles are stored in <RLI_HOME>/<instance_name>/conf/krb5. 

>[!note] Kerberos profile files are automatically shared across all RadiantOne cluster nodes.

There is a default file named vds_krb5.conf included with RadiantOne. Each data source backend (associated with a KDC) that you want RadiantOne to connect to via Kerberos requires its own “…krb5.conf” file. It is recommended that the name of the conf file indicate the relevant realm, since each KDC realm requires its own krb5.conf file. For example, the sample below uses NA.RADIANTLOGIC.COM as the default realm, so a good name for the krb5.conf file may be na_krb5.conf.

`[libdefaults]`
<br> `default_realm = NA.RADIANTLOGIC.COM`
<br> `[realms]`
<br> `NA.RADIANTLOGIC.COM = {`
<br> `kdc = 192.128.12.203:88`
<br> `default_domain = NA.RADIANTLOGIC.COM`
<br> `}`

As another example, assume two separate Active Directory domains (LINKEDIN.BIZ and MICROSOFT.COM) which have a two-way trust between them. Assume a user account in LINKEDIN.BIZ is the service account configured in the RadiantOne LDAP data source and the server/host is another trusted domain; MICROSOFT.COM (make sure you use the FQDN for the host name). The krb5.conf file associated with the RadiantOne LDAP data source would contain the following.

`[libdefaults]`
<br> `	default_realm = LINKEDIN.BIZ`
	
`[realms]`
<br> `	LINKEDIN.BIZ = {`
<br> `		kdc = 192.128.12.208:88`
<br> `		default_domain = linkedin.biz`
<br> `        }`

<br> `	MICROSOFT.COM = {`
<br> `		kdc = 192.120.12.211:88`
<br> `		default_domain = microsoft.com`
<br> `        }`

<br> `[domain_realm]`
<br> `        microsoft.com = MICROSOFT.COM<br> `
<br> `       .microsoft.com = MICROSOFT.COM`
<br> `        linkedin.biz = LINKEDIN.BIZ`
<br> `       .linkedin.biz = LINKEDIN.BIZ`


The [libdefaults] section specifies where to find the Kerberos user account. The [realms] specifies all the domains involved in the cross-domain access.

Kerberos profile files are managed from the Main Control Panel > Settings Tab > Server Backend section > Kerberos Profiles sub-section. You can add, edit and delete Kerberos profiles here.

![Kerberos Profile Settings](Media/Image3.67.jpg)

Figure 7: Kerberos Profile Settings

Click **Add** the right side, and enter the details about the realm, domain and KDC that RadiantOne needs to connect and click **OK**. Then click **Save**. This information is saved into a Kerberos profile file and must be referenced in the LDAP data source.

After the Kerberos Profile has been defined:

1.	Create the LDAP data source from the Server Backend section > LDAP Data Sources sub-section. 

2.	Use the fully qualified server name in the Host Name parameter. 

3.	For the Bind DN setting in the Data Source, do not use a full DN. You need to indicate the sAMAccountName for the service account user in the KDC.

4.	Enter the service account user’s password.

5.	Check the “Use Kerberos profile” checkbox and select the appropriate Kerberos profile from the drop-down list. 

6.	Check Disable Referral Chasing. 

7.	Check Paged Results Control and enter a page size of at least 500.

    ![An image showing ](Media/Image3.68.jpg)

    Figure 8: Sample LDAP Data Source Using Kerberos

8.	Click **Save**.

9.	Restart the RadiantOne service.

When a client binds to RadiantOne using a simple bind (DN+password) and their DN “suffix” matches a virtual view where Kerberos is enabled for the backend data source, RadiantOne uses the value set in the Bind DN of the data source to determine how to perform the Kerberos authentication to the backend directory. RadiantOne searches in the KDC where sAMAccountName matches the value used in the Bind DN and then requests a ticket from the KDC on behalf of this user to connect to the backend directory (Kerberized service). The details in the krb5.conf (Kerberos profile) file dictate which realm and KDC RadiantOne uses.

>[!note] The user is authenticated by the KDC and RadiantOne passes this Kerberos ticket in the SASL GSSAPI LDAP bind to connect to the backend Active Directory. All subsequent requests after the bind request flow over the standard LDAP port. If you need to secure/encrypt subsequent requests, configure SSL/TLS in the data source in addition to the Kerberos configuration described in this section.

### Chasing Referrals

By default, RadiantOne does not attempt to chase referrals that have been configured in the underlying LDAP server. If you want RadiantOne to chase referrals when searching the underlying LDAP server, then you should uncheck the Disable Referral Chasing option. Click **Save** to apply the changes to the server.

Chasing referrals can affect the overall performance of the RadiantOne service because if the referral server is unresponsive, RadiantOne could take a long time to respond to the client. For example, in the case of querying an underlying Active Directory (with a base DN starting at the root of Active Directory) you may get entries like the following returned:

`ldaps://ForestDnsZones.na.radiantlogic.com:636…`
<br> `ldaps://DomainDnsZones.na.radiantlogic.com:636…`

If RadiantOne attempts to “chase” these referrals, there can be extreme degradation in response times. Therefore, it is recommended that you disable referral chasing if you need to connect to Active Directory starting at the root of the Active Directory tree, or connect to any other directory where you don’t care about following referrals.

### Paged Results Control

The paged results option is only relevant for LDAP directories that support the paged results control (such as Active Directory and the RadiantOne service).

>[!note] Sun Java Directory Server does NOT support the paged results control (at least as of v5.2).

If you enable the paged results option, RadiantOne (as a client to other LDAP servers) will request the result of a query in chunks (to control the rate at which search results are returned). After enabling the paged results control option, specify the page size (number of entries per chunk). Click **Save** to apply the changes to the server.

This option can be useful when RadiantOne (as a client to other LDAP servers) has limited resources and may not be able to process the entire result set from a given LDAP query, or if it is connecting to the backend LDAP server over a low-bandwidth connection.

### Proxy Impersonation Rules

For LDAP data sources, you can define advanced impersonation rules for determining which set of credentials are used when connecting to the backend. 

To define advanced impersonation rules:

1.	In the Main Control Panel, go to > Settings tab > Server Backend > LDAP Data Sources sub-section.

2.	Select the LDAP data source and click **Edit**.

3.	Expand the Advanced section at the bottom. The mappings defined here dictate which credentials to use when connecting to the backend data source. Members of the selected group are impersonated by the configured user. 

4.	Click **Add**.

5.	Click **Choose** to locate a group in the virtual namespace that contains members to be impersonated.

6.	Enter a user DN and password to be used when connecting to the backend data source.

![An image showing ](Media/Image3.69.jpg)
 
Figure 9: Impersonation Rules

When you define a virtual view based on this data source, there is an option that can be enabled for Role Mapped Access. If this option is enabled, the impersonation rules defined for the data source take effect and dictate which credentials are used when connecting to the backend data source. This means that if a user binds to RadiantOne and accesses a virtual view from a backend data source where Role Mapped Access has been enabled, and this user is a member of a group that has been configured for impersonation rules, the credentials defined for the group are used for accessing the backend. Below is an example of a virtual view where Role Mapped Access has been enabled.

![Virtual View with Role Mapped Access Enabled](Media/Image3.70.jpg)
 
Figure 10: Virtual View with Role Mapped Access Enabled

**Default Credentials**

If proxy impersonation rules are defined, you can also define a default user. If Role Mapped access is enabled for the proxy view and the user that binds to RadiantOne is not a member of any groups defined for proxy impersonation, the default user account is used. If the connected user is not a member of any groups defined in the proxy impersonation section and there is no default user account defined, then the BindDN set in the data source is used to connect to the backend.

![Indicating a Default User Account](Media/Image3.70.jpg)

Figure 11: Indicating a Default User Account

## Edit an LDAP Data Source

To update the connection information associated with a data source, select the configured data source and click **Edit**. After editing the information, click **Test Connection** and then save the updated information.

## Delete an LDAP Data Source

To delete a data source, select the configured data source and click **Delete**. After deleting any data source, save your changes.

## Configure LDAP Failover Servers

If the primary backend is not available or the SSL certificate is expired (resulting in a connection error), RadiantOne attempts to connect to failover servers that are configured for the data source.

>[!note] If your data source is Active Directory and you are using Host Discovery in your data source settings, there is no need to define failover server. RadiantOne automatically leverages the first five LDAP servers listed in the SRV record as primary/failover servers. For more information on Host Discovery, see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

1.	Go to the Main Control Panel > Settings Tab > Server Backend section.

2.	Select the LDAP Data Sources and on the right side, select the data source you want to configure a failover server for and click **Edit**.

3.	Click **Add** in the Failover LDAP Servers section and enter a host and port. The servers added here must be exact replicas of the primary server. In other words, the user/password configured for the primary server must be able to connect to these replica servers.

4.	Save the configuration when you are finished.

>[!note] RadiantOne attempts to connect to failover servers only if there is an error in connection to the primary server (it attempts to connect twice) or if the SSL certificate for the backend server is expired.

