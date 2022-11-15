# Chapter 2: Client Access Limits and Regulation

## Access Limits

Access limits are related to how the server handles activity received from clients. Details about each of the parameters mentioned below can be found in the RadiantOne System Administration Guide. This document is only for pointing out these parameters as key to hardening the RadiantOne service against security risks.

><span style="color:red">**IMPORTANT NOTE – Changing any property mentioned in this section requires a restart of RadiantOne to take effect. If deployed in a cluster, restart on all nodes.**

### Size Limit

The maximum number of entries a search operation can return. This allows for limiting the
number of entries LDAP clients can receive from a query. This parameter is configured from the
Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

### Time Limit

The period during which a search operation is expected to finish. If a search operation does not
finish within this time parameter, the query is aborted. This parameter can be changed from the
Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

### Look Through Limit

The look through limit is the maximum number of entries you want the server to check in
response to a search request. You should use this value to limit the number of entries the server
looks through to find an entry. This limits the processing and time spent by the RadiantOne
service to respond to potentially bogus search requests (for example, if a client sends a search
filter based on an attribute that isn’t indexed). This parameter can be changed from the Main
Control Panel > Settings Tab > Limits section > Global Limits sub-section.

### Idle Connection Timeout

The length of time to keep a connection open without any activity from the client. This
parameter can be changed from the Main Control Panel > Settings Tab > Limits section > Global Limits sub-section.

### Custom Limits

Custom limits are more fine-grained and override any Global Limits that are defined. These are
defined on the Main Control Panel > Settings > Limits > Custom Limits.

### Access Regulation

After a client connects to RadiantOne, the amount of activity they can perform can be limited by
configuring access regulation. The activity checking can be performed based on the user that
connects to RadiantOne and/or what computer/client (IP address) they are connecting from.
Access regulation is defined from the Main Control Panel > Settings Tab > Limits section >
Per User and Per Computer sections. Enter applicable settings per user and/or per computer.


The “Restrictions Checking Interval” parameter indicated in the Per User or Per Computer
sections is the time frame in which the activity (max binds and max operations) is monitored.
Once the time interval is reached, the counts are reset. For example, if Special Users Group
checking is enabled, and the checking interval, max bind operations per checking interval and
max operations per checking interval are set to 300, 30 and 10 respectively, during a 5 minute
(300 secs) period, anyone who is a member of the special users group can bind no more than
30 times to the RadiantOne service and not perform more than 10 operations. This count resets
every 5 minutes. If a user attempts to perform more than the allowed number of operations, the
RadiantOne service refuses the operation, and the client must wait until the checking interval
resets.

For more details on configuring access regulation per user and/or per computer, please see the RadiantOne System Administration Guide.