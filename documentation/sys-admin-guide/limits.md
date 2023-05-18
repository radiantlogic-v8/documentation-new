---
title: System Administration Guide
description: System Administration Guide
---

# Limits

The settings found in the Main Control Panel -> Settings Tab -> Limits section are related to enforcing search size limits and activity quotas. These settings prevent against Denial of Service (DoS) attacks towards RadiantOne. Remember to save any changes you make to limits.

>[!warning]
>Changing any property in the Limits section requires a restart of the RadiantOne service to take effect. If RadiantOne is deployed in a cluster, restart the service on all nodes.

## Global Limits

The following parameters are configured from the Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

![An image showing ](Media/Image3.117.jpg)

Figure 1: Global Limits Section
 
### Maximum Connections

The maximum number of client connections the server can accept concurrently (connecting at the exact same time).

#### Manually Closing a Client Connection

A connection can be manually closed by issuing an LDAP search to RadiantOne with the connection ID. The connection ID can be viewed from the Server Control Panel > Usage & Activity tab > Connections & Operations. The connection ID can also be retrieved with a one level search to RadiantOne below cn=monitor. The cn=connection-`<ID>` entries are associated with the current connections. A base search on one of these entries, returns an attribute named connectionID. This attribute contains the identifier for the connection and is what should be used to manually close the connection.

![An image showing ](Media/Image3.118.jpg)

Figure 2: Retrieving Connection ID from cn=Monitor

With the connection ID, connect to RadiantOne as the super user (e.g. cn=directory manager) and perform a search request with a base DN of, action=closeconnection,ID=<connectionID>. An example is shown below using the ldapsearch utility. This example closes the connection associated with ID 148300.

```
C:\SunKit>ldapsearch -h 10.11.10.40 -p 2389 -D "cn=directory manager" -w password -b action=closeconnection,ID=148300 (objectlcass=*)
```

### Size Limit

The maximum number of entries a search operation can return. This allows for limiting the number of entries LDAP clients can receive from a query. By default this value is set to 0 which means there is no restriction on the size. 

>[!warning]
>This parameter is a global parameter for RadiantOne. If you want more granular, specific size limits set, then you should set them in the Custom Limits sections.

### Time Limit

The time (in seconds) during which a search operation is expected to finish. If a search operation does not finish within this time parameter, the query is aborted. By default, this value is set to 0 which means there is no restriction on time. 

### Look Through Limit

The look through limit is the maximum number of entries you want the server to check in response to a search request. You should use this value to limit the number of entries the server will look through to find an entry. This limits the processing and time spent by the server to respond to potentially bogus search requests (for example, if a client sends a search filter based on an attribute that is not indexed). By default, this is set to 0, which means that there is no limit set for the number of entries that the server will look through.

>[!warning]
>This property is not used by RadiantOne Universal Directory (HDAP) stores.

### Idle Timeout

The length of time (in seconds) to keep a connection open without any activity from the client. The default is 900, which means the idle connection is kept open for 900 seconds and then closed by the server. 

## Custom Limits

Custom limits are more fine-grained than global limits and can be defined in the Main Control Panel > Settings > Limits > Custom Limits section. Custom limits can be configured for the pre-defined users: “Anonymous Users”, and “Authenticated Users”. They can also be more granular and associated with users belonging to any group or located below any branch/naming context (subtree) in RadiantOne.

>[!note]
>Multiple custom limits are not allowed for anonymous users and authenticated users.

Custom limits override any Global Limits defined in the Main Control Panel > Settings tab > Limits section > Global Limits sub-section. The order of precedence (highest to lowest) for global and custom limits containing the same subject is: Group, Sub-tree, Authenticated Users, Anonymous Users, Global. For custom limits defined within the same root naming context, the limit defined for the deepest entry in the tree will take precedence. For example, if a custom size limit of 3 is defined for a subject location of ou=Novato,ou=California,dc=USA and a size limit of 5 is defined for a subject location of ou=California,dc=USA, if a user of uid=Svc1,ou=Novato,ou=California,dc=USA connects to RadiantOne, the custom size limit of 3 will be enforced.

>[!note]
>This section is accessible only in [Expert Mode](introduction#expert-mode).

### Granular Limits

To define custom limits:
1.	Click **ADD** in the Custom Limits section.

2.	Select a subject from the drop-down list. The possible subjects are described below.
    -	Sub-tree - the location (base DN) in the RadiantOne namespace containing the users that are affected by the custom limits.
    -	Group – a group entry in the virtual namespace. All members of this group are affected by the custom limits.
    -	Anonymous users – any authenticated users or anonymous users.
    -	Authenticated Users – any authenticated users.

3.	Click **CHOOSE** to browse and select a subject location – if sub-tree is selected, the subject location is the base DN containing the users that are affected by the custom limits. If group is selected, the subject location is the DN of the group entry. All members of this group are affected by the custom limits. If authenticated users or anonymous users are selected, subject location is irrelevant.

4.	Enter a value for maximum connections. This is the maximum number of concurrent connections the subject can create. By default, this value is set to 0 which means there is no restriction on maximum connections.

5.	Enter a value for size limit. This is the maximum number of entries a search operation can return. This allows for limiting the number of entries LDAP clients can receive from a query. By default, this value is set to 0 which means there is no restriction on the size. 

6.	Enter a value for idle timeout. This is the length of time (in seconds) to keep a connection open without any activity from the client. By default, this value is set to 0 which means there is no restriction on idle time.

7.	Click **OK**.

8.	Click **Save**. The RadiantOne service needs to be restarted.

### Number of Processing Queues

If you are running RadiantOne on a multi-processor machine, performance and efficiency of the server might improve by increasing the value for the Number of Processing Queues parameter. The default value is 2 and is sufficient for most deployments. As a general guideline, this value should never exceed 3.

>[!warning]
>This parameter does not affect the actual number of processors that get used. However, it does improve the utilization of the available processors.

A better indicator for performance is the number of threads allocated for each processing queue. For each processing queue, the maximum number of concurrent worker threads is 80 by default. This value can be seen/changed in the Max Concurrent Working Threads parameter. For more details, see the next section.

After making changes, click **Save**. RadiantOne must be restarted for the changes to take effect. If deployed in a cluster, restart the service on all nodes.

### Maximum Concurrent Working Threads

This is the number of threads the virtual directory server uses for handling client requests. In other words, this defines the number of concurrent LDAP requests RadiantOne can handle. If there are backends involved (e.g. proxy views without persistent cache), then you must also consider how the backend handles the level of concurrency you define here as well because requests made to RadiantOne may directly result in concurrent requests sent to the backend(s).

The default value is 16, which means 16 worker threads allocated per processing queue defined in the Number of Processing Queues property. This amount is sufficient for most deployments and generally should not be modified unless recommended by Radiant Logic. You might be able to increase this number if:

-	You are using a multiprocessor system - Multiprocessor systems can support larger thread pools than single processor systems. See the Number of Processors parameter above.

-	Clients connecting to RadiantOne perform many time-consuming operations simultaneously (like complex searches or updates).

-	RadiantOne needs to support many simultaneous client connections.

It is difficult to provide an exact formula for determining the optimal number of maximum concurrent working threads to set because it depends on the machine and environment where RadiantOne is running. Generally, the value for concurrent working threads should not be modified unless recommended by Radiant Logic. If it is modified, you must verify the value you set with testing. Incrementally change the value and retest. In the test results, you should start to see performance peak and then a decrease. The peak in the curve should represent the optimal setting.

### Max Pending Connection Requests

The max pending connection property represents a queue of server socket connections associated with requests from clients. This is not managed by the RadiantOne process. As soon as a TCP connection is established to RadiantOne, the connection is removed from the pending queue. A maximum number of pending client requests can be set in the Max Pending Connection Requests parameter. This parameter should not be changed unless advised by a Radiant Logic Support Engineer. 

## Access Regulation

After a client connects to the RadiantOne service, the amount of activity they perform can be limited by configuring access regulation. The activity checking can be performed based on the user that connects to RadiantOne and/or what computer/client (IP address) they are connecting from.

The “Restrictions Checking Interval” parameter indicated in the Per User or Per Computer sections is the time frame in which the activity (max binds and max operations) is monitored. Once the time interval is reached, the counts are reset. For example, if Special Users Group checking is enabled, and the checking interval, max bind operations per checking interval and max operations per checking interval are set to 300, 30 and 10 respectively, during a 5 minute (300 secs) period, anyone who is a member of the special users group can bind no more than 30 times to the RadiantOne service and not perform more than 10 operations. This count resets every 5 minutes. If a user attempts to perform more than the allowed number of operations, the RadiantOne service refuses the operation and the client must wait until the checking interval resets.

### Per User

The following groups of users found on the Main Control Panel > Settings tab > Limits section > Per User sub-section allow you to configure fine-grained activity control:

>[!note]
>Members of the Administrators group specified on the Main Control Panel > Settings Tab > Server Front End > Administration section do not have any access limitations in terms of max connections or max operations per second.

### Anonymous

An anonymous user is a client who connects anonymously (no username or password) to the RadiantOne service. To enable checking for this category of user, check the Enable Access Checking option in the Anonymous section of the Per User Category sub-section. Enter a number for the maximum bind operations that anonymous users are allowed to perform. Also enter a number for the maximum number of operations per checking interval they are allowed to issue. Any parameters that are set to 0 have no limits applied. The restrictions checking interval dictates the number of seconds the server should wait before determining if these thresholds are reached.

### Authenticated Users

An authenticated user encompasses any client who successfully authenticates no matter which group they are a member of. To enable checking for this category of users, check the Enable Access Checking option in the Authenticated Users section of the Per User Category sub-section. Enter a number for the maximum bind operations that authenticated users are allowed to perform. Also enter a number for the maximum number of operations per checking interval they are allowed to issue. Any parameters that are set to 0 have no limits applied. The restrictions checking interval dictates the number of seconds the server should wait before determining if these thresholds are reached.

### Special Users Group

Special Users are anyone who successfully binds and is a member of the special user group defined on the Main Control Panel > Server Front End > Administration section. To enable checking for this category of users, check the Enable Access Checking option in the Special Users Group section in the Per User Category sub-section. Enter a number for the maximum bind operations that users in the Special Users Group are allowed to perform. Also enter a number for the maximum number of operations per checking interval they are allowed to issue. Any parameters that are set to 0 have no limits applied. The restrictions checking interval dictates the number of seconds the server should wait before determining if these thresholds are reached.

### Per Computer/Client

Computers/client applications are identified by their IP address. IP configurations are located on the Main Control Panel > Settings Tab > Limits Section > Per Computer sub-section. These settings allow you to configure fine-grained activity control per computer/client machines.

### IP address

All client machines fall into this category. To enable checking for this category of computer, check the Enable Access Checking option in the IP Address section of the Per Computer sub-section. Enter a number for the maximum amount of connections all computers are allowed to create. Also enter a number for the maximum number of operations per checking interval they are allowed to issue. Any parameters that are set to 0 have no limits applied. The restrictions checking interval dictates the number of seconds the server should wait before determining if these thresholds are reached.

### Special IP Address 

Any client who connects from one of the IP addresses listed in the Special IP Addresses parameter. 

Both IPv4 and IPv6 addresses are supported, and you can indicate a range of IP addresses using “/”. A mix of IPv4 and IPv6 can also be used. 

Example set for a range of IPv4 addresses: 

```
10.11.12.0/24    which represents the given IPv4 address and its associated routing prefix 10.11.12.0, or equivalently, its subnet mask 255.255.255.0, which has 24 leading 1-bits. This covers the range between 10.11.12.0 to 10.11.12.255.	
```

Example set for a range of IPv6 addresses:

```
2001:db8::/32    which covers the range between 2001:db8:0:0:0:0:0:0 to 2001:db8:ffff:ffff:ffff:ffff:ffff:ffff
```

To enable checking for this category of computer/client, check the Enable Access Checking option in the Special IP Address section on the Per Computer sub-section. Enter a number for the maximum amount of connections all computers are allowed to create. Also enter a number for the maximum number of operations per checking interval they are allowed to issue. Any parameters that are set to 0 have no limits applied. The restrictions checking interval dictates the number of seconds the server should wait before determining if these thresholds are reached.

>[!warning]
>If you have enabled activity checking for both users (special users, authenticated and/or anonymous) and computers (IP address and Special IP), the activity per computer takes precedence over the user activity. The order of precedence is special IP addresses, IP addresses, special users, authenticated users, and then anonymous users. For example, let’s say that special user access checking, IP address access checking, and special IP address access checking have been enabled, and the max connections are set to 50, 30, and 40 respectively. Any user who connects that is a member of the special users group from a computer that is not a member of the special IP address group, is only allowed to make a maximum of 30 connections during the checking interval.
