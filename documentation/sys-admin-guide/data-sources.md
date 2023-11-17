---
title: Data Sources
description: Details about where to configure data sources.
---

# Data Sources

A data source in RadiantOne represents the connection to a backend. Data sources can be managed from the Main Control Panel > Settings Tab > Server Backend section. Configuring connections to all backends from a central location simplifies the management task when changes to the backend are required. For more details on data sources, please see [Concepts](concepts).

>[!note] Data sources can also be managed from the command line using the RadiantOne command line config utility. Details on this utility can be found in the [Radiantone Command Line Configuration Guide](/command-line-configuration-guide/01-introduction).

## Status

Each data source has a status associated with it. The status is either Active or Offline and can be changed as needed. If a backend server is known to be down/unavailable, setting the status to Offline can prevent undesirable performance impact to views associated with this backend. When a data source status is set to Offline, all views associated with this data source are not accessed to avoid the performance problems resulting from RadiantOne having to wait for a response from the backend before being able to process the client’s query. To change the status for a data source, navigate to the Main Control Panel -> Settings Tab -> Server Back End section. Select the section associated with the type of data source that is known to be unavailable (e.g. LDAP Data Sources, Database Data Sources or Custom Data Sources). On the right side, select the data source representing the backend that is down and click Edit. Locate the status drop-down list and choose Offline. Save the change.

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


>[!note] When a data source is set as Offline, RadiantOne does not try to access the primary backend nor any failover servers configured in the data source.
