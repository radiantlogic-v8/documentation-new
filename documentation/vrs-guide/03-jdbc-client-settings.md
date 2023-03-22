---
title: VRS Guide
description: VRS Guide
---

# JDBC Client Settings

The JDBC driver is rli-vrs-driver-1.0-SNAPSHOT.jar. This file can be retrieved from <RLI_HOME>/lib and should be copied into the proper location to be loaded by the desired JDBC client application.

Following are the classname and URL to use the driver to connect to VRS:

```
Classname: com.rli.vrs.driver.JDBCDriver
URL Syntax: jdbc:vrs://<hostname>:<port>/<context>[client options]
```

>[!note] 
>For URL syntax when connecting VRS with a client certificate, see the [Client Options](#client-options) section.

## Context

The context used in the URL can be any valid DN (starting point) in the RadiantOne namespace. This can also be left blank (if you want to query any DN in the RadiantOne namespace by specifying it in the SQL command directly). 

Some examples of different contexts are:

```
jdbc:vrs://127.0.0.1:2388/o=vds
jdbc:vrs://127.0.0.1:2388/o=companydirectory
jdbc:vrs://127.0.0.1:2388/ou=Accounting,o=companyprofiles
jdbc:vrs://127.0.0.1:2388/
```

## Client Options

### Mode

There are two modes supported by the JDBC driver: ldap and context.

-	LDAP - Tells VRS to access the RadiantOne service in the LDAP mode. In this mode, the primary key of the table is the dn of the entry (dn as defined in RFC 1485 format). To indicate this type of mode, append  &id=dn to the context (see example below).

-	Context – This is the default mode. If &id=dn is NOT appended at the end of the context, VRS accesses the RadiantOne service in Context mode. In this mode, the primary key of the table is an attribute named contextid. The value of contextid is the “path” to the entry which is essentially the entry DN reversed. For example, if an entry’s DN is something like uid=sbuchanan,ou=accounting,o=vds, the contextid for this entry would be o=vds/ou=accounting/uid=sbuchanan. The foreign key of the table is an attribute named parentcontext. The value of parentcontext is the “path” to the to the parent entry. Using the previous example, the parentcontext would be o=vds/ou=accounting.

### SSL

Use of SSL between the JDBC driver and VRS. If you want the JDBC driver to connect to VRS over SSL, use the syntax shown in the following URL.

```
jdbc:vrs://<hostname>:<ssl_port>/<context>&ssl=true[&user=<user_dn>&password=<password>] 
```

>[!warning] 
>The user and password properties are optional. If [mutual authentication](#certificate-basedmutual-authentication) is used, and the client certificate to DN mapping fails to identify a user to base authorization on, the user DN in the connection string can be used by RadiantOne to enforce authorization for the connection. If the mapping fails and no user is specified in the JDBC connection string, RadiantOne enforces anonymous access.



#### Certificate-based/Mutual Authentication 

There is a self-signed certificate included with RadiantOne<!-- and this certificate can be viewed from the Server Control Panel > Settings Tab. Click the View button next to View Server Certificates-->. For more details on the RadiantOne server certificate, please see the RadiantOne System Administration Guide. 

For normal SSL communications, where the only requirement is that the client trusts the server, no additional configuration is necessary (as long as both entities trust each other). For mutual authentication, where there is a reciprocal trust relationship between the client and the server, the client must generate a certificate containing his identity and private key in his keystore. The client must also make a version of the certificate containing his identity and public key, which the RadiantOne service must store in its truststore. In turn, the client needs to trust the server; this is accomplished by importing the server's CA certificate into the client truststore.

>[!note] 
>Certificate-based authentication (mutual authentication) requires the use of SSL or StartTLS for the communication between the client and RadiantOne.**

![An image showing ](Media/Image3.1.jpg)

Figure 1: Mutual Authentication

There are three options for mutual authentication and this can be set from the Main Control Panel > Settings Tab > Security section > SSL > Mutual Auth. Client Certificate drop-down menu: Required, Requested and None (default value). 

If mutual authentication is required, choose the Required option. If this option is selected, it forces a mutual authentication. If the client fails to provide a valid certificate which can be trusted by RadiantOne, authentication fails, and the TCP/IP connection is dropped. 

If mutual authentication is not required, but you would like RadiantOne to request a certificate from the client, choose the Requested option. In this scenario, if the client provides a valid/trusted certificate, a mutual authentication connection is established. If the certificate presented is invalid, the authentication fails. If no certificate is presented, the connection continues (using a simple LDAP bind) but is not mutual authentication. 

If you do not want RadiantOne to request a client certificate at all, check the None option.

If the client certificate is not signed by a known certificate authority, it must be added in the RadiantOne client truststore.

For more details on these options, refer to the RadiantOne System Administration Guide.   

##### Client Certificate DN Mapping

To authorize a user who authenticates using a certificate, you must set a client certificate DN mapping. This maps the user DN (Subject or Subject Alternate Name from the certificate) to a specific DN in the RadiantOne namespace. After, the DN in the virtual namespace determines authorization (access controls). For more details on client certificate DN mapping, refer to the RadiantOne System Administration Guide. 

If the mapping fails, anonymous access is granted (if anonymous access is allowed). As an alternative to anonymous access, if a user DN is passed in the JDBC connection URL, it is used to identify the user for authorization.

### JDBC Driver Logs 

To enable logging for the JDBC Driver, append &tracelevel= 0, 1, 2, or 3 to the end of the context.
<br>0 –errors
<br>1 –warnings
<br>2 –info
<br>3 –debug

To specify a log file for the JDBC Driver append &tracefile= `<Filename with full path where the trace messages are logged>` to the end of the context. The default location is the console if no file is specified. 

Some examples of different client options are:

Access RadiantOne in LDAP mode:

```
jdbc:vrs://127.0.0.1:2388/o=vds&id=dn
```

Access RadiantOne in LDAP mode and use SSL between the driver and VRS:

```
jdbc:vrs://127.0.0.1:2388/o=mycompany&id=dn&ssl=true 
```

Access RadiantOne in context mode, use SSL between the driver and VRS, set the driver debug level to 3 and log to a file named VRS_JDBC_Client.log.

```
jdbc:vrs://127.0.0.1:2388/ou=Accounting,o=enterprisedirectory&ssl=true&tracelevel=3&tracefile=C:\\VRS_JDBC_Client.log
```

>[!note] 
>There is no order to respect between options.**
 
## Certified JDBC Clients

The following table indicates JDBC clients that have been tested and any notes related to the specific client.

Tool | Notes
-|- 
Squirrel | Bug on squirrel 2.6.5a : squirrel is not designed to display more than one catalog : all sets of schema are mixed and distributed visually into each catalog (reproduced with SQLServer JDBC driver)
Excel | With odbc-jdbc bridge from  http://www.openlinksw.com/
Crystal Reports 2013  | 	
