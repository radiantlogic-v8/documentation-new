---
title: Hardening the RadiantOne Service
description: Hardening the RadiantOne Service Against Security Threats
---

## Overview
The document contains basic tips and general guidance on how to harden RadiantOne so that security risks are reduced as much as possible. This content is intended for administrators who are responsible for hardening RadiantOne against security threats and they must decide which items are applicable to their environment and corporate policies.

## Securing the RadiantOne Configuration and Administration

The following topics provide general guidance about how to secure RadiantOne configuration and administration.

### Protect and Monitor Access to the Directory Manager Account

The directory manager account (e.g. cn=Directory Manager by default, this is defined during RadiantOne installation) is a super user account that is managed locally by RadiantOne without password or lockout policies. To mitigate against online password cracking attacks against this account, use a strong password that is:

- At least 9 characters long
- Does not contain any dictionary words
- Contains a mixture of uppercase, lowercase, numbers and special characters

Provide this password only to trusted administrators with business need for super user access. Other accounts used by RadiantOne are managed by backend data sources and subject to lockout policies associated with those backend data sources.

### Limit Usage of Directory Manager Account

Knowledge and usage of the RadiantOne super user (e.g. cn=Directory Manager) credentials should be limited. It is highly recommended to use the delegated administrator accounts to manage RadiantOne configuration instead of the super user account. Add your users to the
appropriate delegated administrator groups to define the roles they should have for managing the RadiantOne configuration. For details on what activities the delegated administrators can perform, please see the RadiantOne System Admin Guide.

For details on updating the RadiantOne super user (e.g. cn=directory manager) credentials, see the RadiantOne System Administration Guide.


### Update Default Delegated Admin Account Passwords

There are eight groups used for delegated administration are Directory Administrator, Namespace Administrator, Operator, Schema Administrator, ACI Administrator, ICS Administrator, ICS Operator, and one role for Read Only access. Default administrative users are included as members of these groups. They are as follows:

uid=aciadmin,ou=globalusers,cn=config
Member of the ACI Administrator Group.

uid=icsadmin,ou=globalusers,cn=config
Member of the ICS Administrator Group.

uid=icsoperator,ou=globalusers,cn=config
Member of the ICS Operator Group.

uid=namespaceadmin,ou=globalusers,cn=config
Member of the Namespace Administrator Group.

uid=operator,ou=globalusers,cn=config
Member of the Operator Group.

uid=readonly,ou=globalusers,cn=config
Member of the Read Only Group.

uid=schemaadmin,ou=globalusers,cn=config
Member of the Schema Administrator Group.

uid=superadmin,ou=globalusers,cn=config
Member of the Directory Administrator Group.

You can use these default users for delegated administration of RadiantOne activities, or you can add your own users to the various admin roles as described in the Managing Delegation Administration Roles section in the RadiantOne System Administration Guide. To use the default users, you can log in to the Control Panel with any of the following (depending on the configuration you want to manage). For details on the privileges and associated activities these users can perform, please see the RadiantOne System Administration Guide.

user: aciadmin
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: icsadmin
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: icsoperator
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: namespaceadmin
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: operator
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: readonly
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: schemaadmin
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

user: superadmin
password: <set to the same password you defined for the super user (cn=directory manager)
during the installation>

By default, the password for the delegated admin accounts is set to the same password you defined for the super user (cn=directory manager) during the installation of RadiantOne. It is recommended that you change these passwords to match your company security policy and/or follow the same recommendations as detailed in [Protect and Monitor Access to the Directory Manager Account](#protect-and-monitor-access-to-the-directory-manager-account). You can also define strong [password policies](#configure-strong-password-policies) to ensure further protection of these accounts. Or you can delete the default users and assign your own.

To change the password:

1. Log in to the Main Control Panel as the directory manager and select the Directory Browser tab.
2. Navigate below cn=config > ou=globalusers.

3. Select the entry representing the user whose password you want to change. On the right side, select the userPassword attribute.
4. From the Modify Attribute drop-down menu, select Edit. An editable userpassword field displays above the attribute list.
5. Change the value here in the userpassword field. Click OK.

Below is an example of changing the aciadmin user’s password.

![An image showing changing the aciadmin user's password ](Media/Image2.1.jpg)

Figure 1.1 : Changing Passwords

### Configure Strong Password Policies

RadiantOne offers advanced password policy settings that can be a combination of the following:

- Allowing users to change their own passwords (require existing password to change).
  
- Password strength (minimum length, required uppercase characters, required special characters, required digits and required lowercase characters, required to pass a dictionary check).
  
- Password history (prevent password re-use).
  
- Forcing passwords changes after reset.
  
- Maximum password age.
  
- Allowing grace logins after password expires.
  
- Multiple password storage schemes are supported (e.g. Salted SHA-1, Salted SHA-256, Salted SHA-384, Salted SHA-512, BCrypt, SCrypt, and PBKDF2)
  
- Account lockout – if a user has not authentication successfully for longer than a specified period of time or if a user has reached the failed login threshold.
  
- Account expiration.

For details on password policy properties, see the RadiantOne System Administration Guide.

### Assign Appropriate Personnel to Delegated Administration Roles

There are eight default delegated administration groups/roles available for managing the RadiantOne configuration. Only members of these groups can login to the Main Control Panel.

The eight groups used for delegated administration are Directory Administrator, Namespace Administrator, Operator, Schema Administrator, ACI Administrator, ICS Administrator, ICS Operator, and one role for Read Only access. To add or remove members, log into the Main Control Panel as the super user and click on the Directory Browser tab. Navigate below ou=globalgroups,cn=config node to locate all of the groups. Select the group you want to manage and click the Manage Group button. From here you can remove users from groups and search for new users (located anywhere in the RadiantOne namespace) to add to groups. For complete configuration steps, see the RadiantOne System Administration Guide.

It is recommended that only users required to configure and administer RadiantOne get assigned to these groups.

### Leverage Corporate Identity Provider and Strong Authentication Practices to Login to the Control Panel

Log into the Control Panel using strong authentication methods like MFA and/or PIV Card/Certificate as an alternative to using username and password. For details on this configuration, please see the RadiantOne System Administration Guide.



## Client Access Limits and Regulation

The following topics provide general guidance about how to enforce client access limits and regulation.

### Global Access Limits

Access limits are related to how the server handles activity received from clients. Details about each of the parameters mentioned below can be found in the RadiantOne System Administration Guide. This document is only for pointing out these parameters as key to hardening the RadiantOne service against security risks.

>[!warning] 
>Changing any property mentioned in this section requires a restart of RadiantOne to take effect. If deployed in a cluster, restart on all nodes.

**Size Limit**

The maximum number of entries a search operation can return. This allows for limiting the
number of entries LDAP clients can receive from a query. This parameter is configured from the
Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

**Time Limit**

The period during which a search operation is expected to finish. If a search operation does not
finish within this time parameter, the query is aborted. This parameter can be changed from the
Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

**Look Through Limit**

The look through limit is the maximum number of entries you want the server to check in response to a search request. You should use this value to limit the number of entries the server looks through to find an entry. This limits the processing and time spent by the RadiantOne service to respond to potentially bogus search requests (for example, if a client sends a search filter based on an attribute that isn’t indexed). This parameter can be changed from the Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

**Idle Connection Timeout**

The length of time to keep a connection open without any activity from the client. This parameter can be changed from the Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

### Custom Limits

Custom limits are more fine-grained and override any Global Limits that are defined. These are defined on the Main Control Panel > Settings > Limits > Custom Limits.

### Access Regulation

After a client connects to RadiantOne, the amount of activity they can perform can be limited by configuring access regulation. The activity checking can be performed based on the user that connects to RadiantOne. Access regulation is defined from the Main Control Panel > Settings Tab > Limits section > Per User.

The “Restrictions Checking Interval” parameter indicate is the time frame in which the activity (max binds and max operations) is monitored. Once the time interval is reached, the counts are reset. For example, if Special Users Group checking is enabled, and the checking interval, max bind operations per checking interval and
max operations per checking interval are set to 300, 30 and 10 respectively, during a 5 minute (300 secs) period, anyone who is a member of the special users group can bind no more than 30 times to the RadiantOne service and not perform more than 10 operations. This count resets every 5 minutes. If a user attempts to perform more than the allowed number of operations, the RadiantOne service refuses the operation, and the client must wait until the checking interval resets.

For more details on configuring access regulation per user and/or per computer, please see the RadiantOne System Administration Guide.

## Recommendations for Securing Data at Rest

The following topics provide general guidance about how to secure data at rest in RadiantOne.

### Delete Global Read Access and Assign Finer-Grained Access Controls

When the RadiantOne service receives a request, it uses the user in the bind operation, and the
access control instructions (ACIs) defined to allow or deny access to directory information. The
service can allow or deny permissions such as read, write, search, or compare.

With ACI, you can control access to targets such as:

- the entire RadiantOne namespace
- a specific subtree
- specific entries in the RadiantOne namespace
- a specific set of entry attributes
- specific entry attribute values.

You can define access to the following subjects:

- a particular user
- all users who belong to a specific group
- all users in the directory

Access controls are set from the Main Control Panel > Settings Tab > Security section > Access Control sub-section.

By default, all users have read access to all naming contexts in RadiantOne for search, compare, and read operations. This includes read access to the RadiantOne directory RootDSE (accessible by requested an empty base DN).

This default access control can be removed from the Main Control Panel ->
Settings Tab > Security section > Access Control. Click root on the right and select the
configured access control described as “grant read access to anyone”. Then click **Delete**.

If you choose not to delete the grant access to anyone control, it is recommended for security reasons that you ensure that userpassword is not returned. You can do so as shown in the following example ACI. 

(targetattr != "aci || userPassword")(target = "ldap:///")(targetscope = "subtree")(version 3.0;acl "grant read access to anyone";allow (read,compare,search) (userdn = "ldap:///anyone");)

If you do not want to return the userPassword attribute for anyone other than self, you can do so as shown in the following example ACI. 

(targetattr = "userPassword")(target = "ldap:///")(targetscope = "subtree")(version 3.0;acl "Allow Access to userPassword to self";allow (all) (userdn = "ldap:///self");)

>[!warning] 
>If you delete the default read access, this does not delete read access to the RootDSE for RadiantOne. If you want to remove public access to the RootDSE, check the Enable RootDSE ACI option after you delete the default global read access. This denies access to the RootDSE to everyone except cn=directory manager. You can also add a new ACI that
dictates RootDSE access. Below is an example of allowing public access to the RootDSE:

>[!warning]
>(target="ldap:///")(targetscope="base")(targetattr="*")(version 3.0; acl
"RootDSE accessible to public"; allow (read,search,compare)
userdn="ldap:///anyone";)

Although there is not an absolute requirement, it is generally recommended to define all your
access controls at the root level so you can come back to this single level and see all configured
access controls across the entire RadiantOne namespace. When you define the actual ACI at
the root level, you can set the Target DN to only the applicable branch in the namespace you
want to protect.

For details on defining access controls, please see the RadiantOne System Administration
Guide.

### Turn on Bind Requires Password Setting

If the Bind Requires Password setting is enabled, and no password is specified in the bind request, the RadiantOne service tries to bind the specified user and returns an invalid credential error to the client.

If Bind Requires Password is not enabled, and a bind request comes in with a valid user DN and no password, it is considered an anonymous bind.

This setting can be enabled from Main Control Panel > Settings tab > Security section > Access Control. Check the Bind requires a password option.

### Use Multi-Factor Authentication

Configure your corporate OIDC provider from Main Control Panel > Settings > Security > OIDC Provider Configuration. The OIDC provider should be configured to support the desired MFA vendor.

### Use Least Privilege Accounts for Backend Connections

RadiantOne connects to backends using the credentials defined in the data sources. When defining data sources, use credentials associated with an account that has the needed permissions required by RadiantOne. For example, if the backend information exposed in the RadiantOne namespace is to be read-only, use credentials for a read-only account in the data source. If certain attributes exposed in the RadiantOne namespace must be updateable by clients, use an account with permissions to update this information in the backend when defining the data source. It is always recommended to use least privilege accounts in the RadiantOne data source configurations.

### Encrypt Attributes in RadiantOne Directory Stores

Attribute encryption protects sensitive data while it is stored in RadiantOne Directory stores. You can specify that certain attributes of an entry are stored in an encrypted format. This prevents data from being readable while stored in the RadiantOne Directory stores,
backup files, and exported LDIF files. Attribute values are encrypted before they are stored, and decrypted before being returned to the client, as long as the client is authorized to read the attribute (based on ACLs defined in RadiantOne), is connected to RadiantOne via SSL and not a member of the special group containing members not allowed to get these attributes (e.g. cn=ClearAttributesOnly,cn=globalgroups,cn=config). For details on this special group, please see the RadiantOne System Administration Guide.

You can use your own security key (Customer Master Key) for attribute encryption via AWS KMS. For details on using AWS KMS, see the RadiantOne System Administration Guide.


For details on configuring attribute encryption, see the RadiantOne Namespace Configuration Guide.

### Use Zipped and Encrypted LDIF Files

When exporting (or initializing) RadiantOne Directory stores or persistent cache stores, choose to use LDIFZ file types (which are zipped and encrypted) instead of classic LDIF files. LDIFZ files are encrypted using the security key defined in RadiantOne. For details on creating a security key, see the RadiantOne System Administration Guide.

You can use your own security key (Customer Master Key) for attribute encryption via AWS KMS. For details on using AWS KMS, see the RadiantOne System Administration Guide.

For details on exporting RadiantOne Directory stores using LDIFZ, see the RadiantOne Namespace Configuration Guide. For details on exporting persistent cache stores using LDIFZ, see the RadiantOne Deployment and Tuning Guide.

### Avoid Displaying Sensitive Attributes in Log Files

Configure sensitive attributes in the Main Control Panel > Settings > Server Front End > Attribute Handling -> Attributes Not Displayed in Logs setting. This property allows you to control which attribute values are not printed in clear in the RadiantOne logs. If you do not want certain attribute values printed in clear in the logs, you can indicate them here. Each attribute
name should be separated with a single space. Any attribute indicated here has a value of ***** printed in the logs instead of the value in clear.

>[!warning] 
>If Interception Scripting is used, remove or comment out the following line from each method to avoid cleartext passwords being written
to log files: prop.list(System.out)

### Avoid Displaying Sensitive Changelog Attributes

When entries change, the change log reports the attributes under its "changes" attribute. This may pose a security risk if sensitive attributes have been changed and the change log is searchable by outside applications such as sync connectors. To eliminate this risk, the Excluded Change Log Attributes option allows you to exclude selected attributes from members of the
“ChangelogAllowedAttributesOnly” group. Though these attributes are logged in the change log,
they are not returned for these group members when performing a search on the change log. For more information, refer to the RadiantOne System Administration Guide.

### Secure Access to the Global Sync Queues

For Global Sync deployments, the Agent and Sync Engine process read and/or write into the queues using the credentials configured in the RadiantOne data source named: vdsha
You can view this data source configuration from Main Control Panel > Settings > Server Backend > LDAP Data Sources.

For security reasons, the user account (Bind DN) you have configured in the vdsha data source should be the only one allowed to access the cn=queue and cn=dlqueue naming contexts.

Configure access controls for these root naming contexts from Main Control Panel > Settings > Security > Access Control. Access should only be allowed for the account configured in the vdsha data source. For details on configuring access controls, see the RadiantOne System Administration Guide.

### RadiantOne Directory (HDAP) Stores Attribute Encryption

Attribute encryption protects sensitive data while it is stored in RadiantOne. Attribute encryption allows you to specify that certain attributes of an entry are stored in an encrypted format. This prevents data from being readable while stored in RadiantOne Directory stores, persistent cache, backup files, and exported LDIF files.

There are two items to configure. One is the criteria for the key generation used to encrypt/decrypt the attributes. Two is the list of attributes you want to encrypt. For details, see: [Attribute Encryption](../configuration/security/attribute-encryption)


### LDIF File Encryption

Using the LDIFZ format when exporting RadiantOne Directory stores produces a zipped and encrypted LDIF file. This prevents data from being readable while stored in exported LDIF files.

For LDIF file encryption, configure the criteria for the key generation and then when you export data to ldif, select the ldifz file extension. For details, see: [Attribute Encryption](../configuration/security/attribute-encryption)


## Recommendations for Securing Data in Transit - SSL/TLS Settings

The following topics provide general guidance about how to secure data-in-transit in RadiantOne.

By default, only SSL-enabled endpoints are accessible to the RadiantOne Service.

### Configure SSL Protocols Allowed for RadiantOne

You can limit the SSL protocols supported in RadiantOne from the Main Control Panel > Settings Tab > Security section > SSL sub-section. Click **Change** next to Enabled SSL Protocols. Select the protocols to support and click OK. Restart the RadiantOne service on all nodes.

>[!note] 
>Only enable the SSL protocols that comply with your company’s security policy.**


### Use Strong Cipher Suites and Disable Weak Ones

1. Open the Main Control Panel.
2. On the Settings Tab > Security section > SSL sub-section, click on the CHANGE button next to Supported Ciphers Suites. Enable only the desired cipher suites.
3. Click SAVE.
4. Restart the RadiantOne service. If deployed in a cluster, restart it on all nodes.


### Advise Application Owners to use the Latest Java Patches

Java patches are currently released quarterly by OpenJDK:
https://wiki.openjdk.java.net/display/jdk8u/Main

Radiant Logic releases patches for RadiantOne approximately one week after OpenJDK releases to ensure support for the latest Java patch is included.

It is highly advised that all client applications connecting to RadiantOne via LDAPS or HTTPS have the latest Java patch in order to reduce the risk of security breaches. This is to ensure the latest bugs and security vulnerabilities have been addressed, and that clients don’t attempt to negotiate obsolete, unsafe or disabled ciphers.

Although you can configure the SSL ciphers and protocols enabled in RadiantOne, it is not advised to enable less secure settings solely to accommodate client applications running older
versions of Java.

### Configure SSL/TLS for Backend Connections

If RadiantOne is connecting to backends over a network connection that is considered unsecure, it is recommended that you configure the connection to use SSL/TLS.

If the backend server uses a certificate issued by a trusted Certificate Authority, then all you need to do is enter the SSL port and check the SSL checkbox when you define the data source.
For database backends, just enter the SSL port in the URL as there is no SSL checkbox.

If the server you are connecting to uses a self-signed certificate, or signed by a Certificate Authority not known by RadiantOne, then this certificate must be imported into the client truststore. Import client certificates into the RadiantOne truststore from the Main Control Panel > Settings Tab > Security section > Client Certificate Truststore. RadiantOne dynamically loads client certificates from here meaning certificates can be added at any time without requiring a restart.

For more information on SSL/TLS support, please see the RadiantOne System Administration Guide.
