---
title: Understanding Default Configuration and Samples
description: Understanding Default Configuration and Samples
---

## Overview

This guide describes default naming contexts and default data sources.

>[!note] For more information on installing the samples described in this guide, refer to the guide on [creating environments](installation/create-environments.md)

## Default Naming Contexts

This section describes all the default root naming contexts included with RadiantOne. The naming contexts can be viewed/managed from the Main Control Panel > Directory Namespace tab and the data (run-time) can be seen from the Directory Browser tab. If a naming context is safe to delete, it is indicated in the description below.

The sample naming contexts are as follows.

- o=vds
<br> This naming context contains many sample virtual views mounted below it. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for the RadiantOne service) but should not be deleted.

- o=companydirectory
<br> This is a sample local RadiantOne Universal Directory store. The data is stored in this RadiantOne Universal Directory can be managed from the Directory Browser tab in the Main Control Panel. This naming context is used in the RadiantOne training materials. If you do not plan on using the RadiantOne Tutorials (for training) then this entire naming context may be deleted (de-activate it before removing the naming context).

- o=companyprofiles
<br> NOTE - NEEDS TO BE UPDATED This is a sample of an LDAP proxy. The backend LDAP in this example is the RadiantOne Universal Directory local store that matches the o=companydirectory setting mentioned above. A proxy can point to any LDAP server. This is not a critical naming context and it may be deleted if needed (de-activate it before removing the naming context). Deleting the naming context also deletes the underlying .dvx and .orx files o_companyprofiles.dvx and o_companyprofiles.orx.

- o=examples
<br> NOTE - NEEDS TO BE UPDATED This is a sample of a virtual view from a database backend. The database used here is Apache Derby and is included in the RadiantOne installation. This is not a critical naming context and it may be deleted if needed (de-activate it before removing the naming context. You need to deactivate and delete the child node prior to removing the root naming context). After deleting the naming context, you can also delete the underlying .dvx and .orx files: <RLI_HOME>/vds_server/dvx/o_examples.dvx,
NOTE - NEEDS TO BE UPDATED <RLI_HOME>/vds_server/dvx/ou_hr_o_examples.dvx, and
NOTE - NEEDS TO BE UPDATED <RLI_HOME>/vds_server/org/ou_hr_o_examples.orx.

>[!warning] Before you can view the data in the sample o=examples naming context, you must start the Derby database server.

>[!warning]On Windows → execute %RLI_HOME%\bin\DerbyServer.exe

>[!warning]On UNIX platforms → $RLI_HOME/bin/runDerbyServer.sh

- ou=AllProfiles
<br> This naming context is used by the legacy ID-Connect client web application and has three levels mounted below it. There are two nodes pointing to local RadiantOne Universal Directory stores (ou=ad_sample and ou=localvds) and one virtual view containing definitions to dynamically build groups (ou=VirtualGroups). If you do not plan on using the legacy ID-Connect application then this entire naming context may be deleted (de-activate each node first before removing the naming context).
NOTE - NEEDS TO BE UPDATED After deleting the naming context, you can also delete the underlying .dvx files:
NOTE - NEEDS TO BE UPDATED <br> <RLI_HOME>/vds_server/dvx/o_allprofiles.dvx
NOTE - NEEDS TO BE UPDATED <br> <RLI_HOME>/vds_server/dvx/virtualgroups.dvx.

>[!note] Although the ou=AllProfiles naming context is associated with the default.orx, this schema file should not be deleted if you delete the ou=AllProfiles naming context as it is used by other RadiantOne internal components.

- cn=replicationjournal
<br> This naming context is used for inter-cluster replication. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

-  cn=extendedxjoin
<br> This naming context is used when the default store setting is configured for an extended join. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

- cn=config
<br> This naming context stores certain global configuration information for RadiantOne. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

- cn=changelog
<br> This naming context stores a list of changes made to RadiantOne. Clients can leverage this for detecting changes that happen in the RadiantOne namespace. This naming context should not be deleted.

- cn=cacherefreshlog
<br> This naming context stores a list of changes made during persistent cache refresh. This naming context should not be deleted.

- cn=registry
<br> This naming context is used internally by RadiantOne to store configuration information for the Global Sync Module and the Global Identity Builder. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

- cn=system-registry
<br> This naming context is used internally by RadiantOne to store ADAP session tokens. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

- dv=globalprofiles
<br> This naming context is created and used by the Global Identity Builder and Global Identity Viewer applications. This naming context may be hidden (by specifying it as a hidden context in the rootdse.ldif file for RadiantOne) but should not be deleted.

NOTE - NEEDS TO BE UPDATED All files related to the naming contexts detailed above are located in <RLI_HOME>/vds_server/dvx. Schema files associated with these naming contexts are located in <RLI_HOME>/vds_server/org and <RLI_HOME>/vds_server/lod.

## Default Data Sources

### LDAP

An LDAP data source named vdsha is included by default. This data source contains connections to all RadiantOne nodes in a given cluster. One node is defined as the primary server and all others as failover servers. This data source is used internally by many operations including persistent cache refreshes and should not be deleted or have its status changed to “offline”.

An LDAP data source named replicationjournal is included by default. This data source plays a role in inter-cluster replication and should not be deleted or have its status changed to “offline”.

>[!warning] If you change the super user/directory administrator password after installing RadiantOne, you must manually edit both the vdsha and replicationjournal LDAP data sources to update the password here as well. Changes to the data sources are performed from the Main Control Panel > Settings Tab > Server Backend section > LDAP Data Sources.

### Database

There are nine default database data sources defined for the Derby databases installed with RadiantOne (advworks, derbyorders, derbysales, examples, log2db, multistore, northwind, rx500 and vdapdb). These databases support the [sample virtual views](#default-naming-contexts) mounted below o=examples and o=vds.

The default radiantsalesforce database data source supports a sample virtual view of Salesforce mounted at dv=salesforce,o=cloudservices,o=vds. This data source can be modified to point to any Salesforce instance to quickly test bringing in Salesforce identities into the virtual namespace. For steps on editing the radiantsalesforce data source, see the RadiantOne Namespace Configuration Guide.

### Custom

NOTE - NEEDS TO BE UPDATED Custom data sources are accessible via a Java API, or web service including REST or SCIM. Each custom data source is associated with a Java script that includes the needed API calls. There are twenty custom data sources included in RadiantOne. Some of the installed custom data sources are associated with code that is externalized and can be viewed. These are noted below. All others are associated with code that is packaged and maintained by Radiant Logic (in <RLI_HOME>/lib/custom-objects-1.0-SNAPSHOT.jar) and not editable externally.

>[!warning] To use a custom data source, edit and update the connection properties (credentials, URL...etc.) and set the active property to true. Restart the RadiantOne service for changes to custom data sources to take effect.

>[!warning] Some of these data sources require further customization by the Radiant Logic Professional Services team. Contact your Radiant Logic Account Representative for further details.

- acsclient – to virtualize information and authenticate users against Cisco TACACS and RADIUS. This data source requires customization by Radiant Logic to use.
- adap – to virtualize RadiantOne using the REST API.
- components - beta for being able to virtualize file systems. This data source requires customization by Radiant Logic to use.
NOTE - NEEDS TO BE UPDATED - concur - for creating virtual views from Concur. Script can be viewed at /src/com/rli/scripts/customobjects/concur.java. This data source requires customization by Radiant Logic to use.
NOTE - NEEDS TO BE UPDATED - gdatacontacts - for creating virtual views from Google contacts. Script can be viewed at /src/com/rli/scripts/customobjects/gdatacontacts.java
NOTE - NEEDS TO BE UPDATED - googledirectory – for creating virtual views from Google Directory. Scripts can be viewed at <RLI_HOME>/vds_server/custom/src/com/rli/scripts/customobjects/googledirectory/
- graphapi – for creating virtual views from Azure AD. This uses the Azure Active Directory Graph API.
- graphapib2c – for creating virtual views from Azure AD B2C. This uses the Azure Active Directory Graph API.

- mgraph - for creating virtual views from Azure AD. This uses the Microsoft Graph API.
- epic – for creating virtual views from Epic data (Employees, Patients and Providers). This calls the Epic API and database. LDAP authenticate, move and modrdn operations are not supported for virtual views created from this data source. The Provider information is retrieved from the database directly as there is no API available. This information is read-only. This data source requires customization by Radiant Logic to use.
 
  
   The Patient information does not support add or delete operations. Modify operations are only supported for address, name, email and phone attributes.

   The Employee object supports add, delete and modify operations. Newly added or updated employees do not show up immediately in queries to the database (takes approximately 24-48 hours for the new entry to be accessible in database queries). When querying employees through the REST API, there are many attributes returned, most of which are typically not needed for RadiantOne clients.
   
   Periodic cache refresh is the only option for cached virtual views of Epic backends.

- epic2 - for creating virtual views from Epic data(Employees, Patients and Providers). This calls the Epic database. Views created from this data source are read-only and LDAP authentication is not supported. However, the attributes returned from the database are cleaner and typically match what is expected for an “identity” (profile and/or authorization attributes) for RadiantOne clients better than using the “epic” data source. **This data source requires customization by Radiant Logic to use.**

    Periodic cache refresh is the only option for cached virtual views of Epic backends.

- hdfs – beta for being able to virtualize HDFS. This data source requires customization by Radiant Logic to use.

- oktaclient – for creating virtual views and being able to authenticate users in Okta Universal Directory.

NOTE - NEEDS TO BE UPDATED - remotefiles - beta for being able to virtualize file systems. Script can be viewed at <RLI_HOME>/vds_server/custom/src/com/rli/scripts/customobjects/FileSystem.java. **This data source requires customization by Radiant Logic to use.**

- scimclient – for creating virtual views from SCIM v1 accessible data sources. See RadiantOne Context Builder Guide for details on virtualizing SCIMv1 backends.

- scimclient2 – for creating virtual views from SCIM v2 accessible data sources. See RadiantOne Context Builder Guide for details on virtualizing SCIMv2 backends.

NOTE - NEEDS TO BE UPDATED - sharepoint – for creating virtual views from SharePoint on-premise user profile database. Script can be viewed at <RLI_HOME>/vds_server/custom/src/com/rli/scripts/customobjects/sharepoint.java

NOTE - NEEDS TO BE UPDATED - sharepointonline – for creating virtual views from SharePoint Online (Office 365) user profile database. Script can be viewed at <RLI_HOME>/vds_server/custom/src/com/rli/scripts/customobjects/sharepointonline.java. **This data source requires customization by Radiant Logic to use.**
NOTE - NEEDS TO BE UPDATED - workdayhr – for creating virtual views from Workday. Scripts can be viewed at <RLI_HOME>/vds_server/custom/src/com/rli/scripts/customobjects/workday30. This data source is associated with <RLI_HOME>\vds_server\dvx\workdayhr.dvx and <RLI_HOME>\vds_server\org\workdayhr.orx. **This data source requires customization by Radiant Logic in order to use.**
NOTE - NEEDS TO BE UPDATED - awscognito – for creating read-only virtual views of AWS Cognito user accounts. This data source is associated with <RLI_HOME>\vds_server\dvx\awscognito.dvx and <RLI_HOME>\vds_server\org\awscognito.orx. **This data source requires customization by Radiant Logic in order to use.**

### JDBC Drivers

The following JDBC drivers are installed with RadiantOne: JDBC-ODBC Bridge from Sun, Oracle (thin), Oracle oci, Microsoft SQL Server, HSQL, MariaDB, IBM DB2, Sybase, RadiantOne Salesforce, and Derby.

>[!warning] The MariaDB JDBC driver supports connecting to both MySQL and MariaDB databases.

JDBC drivers are used during the creation of database data sources (the connection to the database backend). A list of drivers appears in the drop-down list box when you are defining a data source. Only the drivers that are listed above were actually installed with RadiantOne. The other driver names/syntaxes that appear in the drop-down list have been provided to save time. If you would like to use one of these drivers or to include a new JDBC driver, install the driver files in the <RLI_HOME>/lib/jdbc directory. Restart the RadiantOne service and any open tools. During the creation of the database data source, if your driver type is listed in the drop-down list, select it and the syntax for the driver class name and URL will be populated for you. Update the URL with the connection details for your database. If the drop-down list does not include your database driver type, you can leave this blank and manually type in the data source name, driver class name, driver URL, user and password.

>[!warning] Updating to a different DB2 driver may require more than just replacing the existing driver files in the <RLI_HOME>/lib/jdbc directory if the name or license has changed. Please consult the Radiant Logic knowledge base for additional details.
