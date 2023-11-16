---
title: Connection Pooling
description: Details about connection pooling settings.
---

# Connection Pooling/Other

>[!note] This section is accessible only in [Expert Mode](01-introduction#expert-mode).

![Connection Pooling Settings](Media/Image3.61.jpg)

Figure 1: Connection Pooling Settings

Connection pooling for database and LDAP sources is enabled by default. The settings can be modified in the Main Control Panel > Settings Tab > Server Backend section, Connection Pooling sub-section. Connection pooling improves performance for virtual views because a connection to the underlying source does not need to be created every time data needs to be retrieved.

When RadiantOne receives a search for information (that is not stored locally, either in cache or a local Universal Directory store), a connection to the underlying system is established. Since opening and closing a connection every time information must be retrieved from an underlying source can be time consuming, RadiantOne can pool the open connections and re-use them (thus saving the overhead involved in having to open/close a connection every time a backend needs to be accessed).

The first time RadiantOne queries an underlying source, a connection is opened. When the operation is done, the open connection remains in the connection pool (for the specified timeout parameter that has been set). The next time RadiantOne receives a query for the same underlying source, an open connection is retrieved from the pool (instead of opening a new connection). If no connections are available in the pool, a new connection is opened. This process continues until the connection-poolsize parameter has been reached (the maximum number of open connections to keep in the pool). Once this happens (the max number of open connections has been reached and they are all in use), the client must wait until one of the used connections is finished before their query can be processed.

## LDAP Backends

Connection pooling for LDAP backends is configured with the following settings:

### Pool size

This is the maximum number of concurrent connections by RadiantOne to each LDAP source. For example, if you have four LDAP sources and your maximum connections value is set to 200, then you could have up to a total of 800 LDAP connections maintained by RadiantOne.

### Timeout

The default is 7. This is the maximum number of seconds RadiantOne waits while trying to establish a connection to the backend LDAP server. There are two attempts to create a connection (each tries to create a connection for 7 seconds).

### Operation Timeout

The default is 0 (no timeout). This is the maximum number of seconds RadiantOne waits to receive a response from the backend LDAP server. After this time, RadiantOne drops the request and attempts to send the request again. After two failed attempts to get a response back, RadiantOne returns an error to the client.

### Write Operation Timeout

The default is 0 (no timeout). This is the maximum number of seconds RadiantOne waits to receive a response from the backend LDAP server for write operations and bind operations. After this time, RadiantOne drops the request and attempts to send the request again. After two failed attempts to get a response back, RadiantOne returns an error to the client.

### Idle Timeout

The default is 5 minutes. This is the maximum amount of time to keep an idle connection in the pool.

## Database Backends

Connection pooling for database backends is configured with the following settings:

#### Pool Size

The default is set to 20, this means 20 open connections are held in the pool for each JDBC data source. A connection pool is managed per each data source.

### Idle Timeout

The default is 15. This is the number of minutes a connection stays in the connection pool once it is idle. Setting this to “0” (zero) results in opened connections to stay in the pool forever.

### Prepared Statement Cache

The default is 50. RadiantOne uses parameterized SQL statements and maintains a cache of the most used SQL prepared statements. This improves performance by reducing the number of times the database SQL engine parses and prepares SQL. 

This setting is per database connection. Use caution when changing this default value as not all databases have the same limits on the number of 'active' prepared statements allowed.

## Manually Clearing the Connection Pool

RadiantOne supports special LDAP commands to reset connections in the pools. If you issue these commands to RadiantOne, all the connections that are currently not being used in the pool are closed.

To reset the connection pools from the command line, you can use the ldapsearch utility.

The following command clears the LDAP connection pool (assuming RadiantOne is listening on LDAP port 2389 and the super user password is “password”):

`ldapsearch -h host -p 2389 -D"cn=directory manager" -w "password" -b "action=clearldappool" (objectclass=*)`

The following command clears the database connection pool (assuming RadiantOne is listening on LDAP port 2389 and the super user password is “password”):

`ldapsearch -h host -p 2389 -D"cn=directory manager" -w "password" -b "action=clearjdbcpool" (objectclass=*)`

The connection pools can also be cleared using the LDAP Browser client that is included with RadiantOne. Enter the relevant connection criteria to RadiantOne (server, port, User ID, and Password) and in the Base DN field, enter action=clearldappool to clear the LDAP connection pool and click **Connect**. Use action=clearjdbcpool and the Base DN and click **Connect** to clear the database connection pool.

![An image showing ](Media/Image3.62.jpg)

Figure 2: LDAP Browser Client used to Clear the Connection Pool

## Other

This section contains the Active Directory SRV Record Limit setting. 

### Active Directory SRV Record Limit

If there are multiple Active Directory domains available in the SRV record, by default RadiantOne uses five as “main/primary” and “failover” servers. RadiantOne uses these to automatically failover if the primary server is down. The Active Directory SRV Record Limit can be adjusted from the Main Control Panel. 

To change the Active Directory SRV record limit:

1. In the Main Control Panel, navigate to Settings > Server Backend > Connection Pooling > Other. 

1. Set the Active Directory SRV Record Limit value. The default value is 5. 

1. Click Save. 
