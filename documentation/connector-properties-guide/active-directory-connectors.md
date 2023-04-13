---
title: Active Directory connectors
description: Learn about the three different Active Diretory capture connector types: USNChanged, DirSync, and Hybrid that are included in the RadiantOne platform. These connectors can be used to detect changes in Active Directory for persistent cache refreshes and/or used for detecting changes in Active Directory as a source for a Global Synchronization pipeline. Defining connector properties like LDAP filter, Excluded Branches, Included Branches, Determine Move Operations, and how the connectors handle failover if the primary Active Directory is unavailable are also covered topics.
---

# Active Directory connectors

There are three types of Active Directory connectors: USNChanged, DirSync and Hybrid. These connector types are described in this document.

>[!note]
>The Active Directory USNChanged connector supports AD LDS.

The decision tree below can help guide you on the Active Directory connector type to use.

![A decision tree that can guide you on the Active Directory connector type to use](media/image13.png)

## Active Directory USNChanged connector

Active Directory keeps track of changes that happen to entries in the directory (by incrementing the `uSNChanged` attribute for the entry). Based on a polling interval configured, the connector connects with the user and password configured in the connection string/data source and checks the list of changes stored by Active Directory. The connector internally maintains the last processed change number (`uSNChanged` value) and this allows for the recovery of all changes that occur even if the connector is down (deliberately or due to failure).

>[!note]
>This is the connector type that must be used if the backend is an Active Directory Global Catalog. The Active Directory DirSync connector should not be used because it is unable to detect events in sub-domains.**
>Also, If you are pointing the Active Directory connector to the Global Catalog, when a deleted entry is detected, the connector receives only the DN of the deleted entry in the context of the `CN=Deleted Objects` container (e.g. `CN=u1\0ADEL:2ca20e8c-1748-4e7d-9044-45e64ab8105b,CN=Deleted Objects,DC=t1,DC=f6,DC=rli`). Transformation logic needs to address how to find the corresponding entry in the target(s) to remove or update them accordingly.**

If the sequence of events is critical, use the [DirSync connector](#active-directory-dirsync-connector) because it processes events in the order in which they occur instead of prioritizing and processing inserts and updates before deletes.

>[!warning]
>To detect delete events, the service account used by RadiantOne to connect to the backend Active Directory (configured in the connection string of the RadiantOne data source) must have permissions to search the tombstone objects. More specifically, the LIST CONTENTS and READ PROPERTY permissions to the` CN=Deleted Objects` branch are required. Generally, a member of the Administrators group is sufficient. However, some Active Directory servers may require a member of the Domain Admins group. Check with your Active Directory permissions to determine the appropriate credentials required.

## Active Directory DirSync connector

The Active Directory DirSync capture connector retrieves changes that occur to entries in a directory by passing a cookie that identifies the directory state at the time of the previous DirSync search. The first time the DirSync capture connector is started, it stores a cookie in a cursor file. At the next polling interval, the connector performs a DirSync search to detect changes by sending the current cookie. These changes include only the objects and attributes that have changed since the previous state identified by the current cookie. Because it retrieves only changed objects and attributes, the Active Directory DirSync capture connector avoids propagating irrelevant attributes, reducing message size and potentially reducing network congestion. After retrieving changes, a new cookie is obtained, and the cursor file is updated.

>[!warning]
> Do not use this connector type if your backend is an Active Directory Global Catalog because it is unable to detect events in sub-domains. Use the [Active Directory (USNChanged)](overview.md#manually-update-connector-cursor) connector instead.
>To detect delete events, the service account used by RadiantOne to connect to the backend Active Directory (configured in the connection string of the RadiantOne data source) must have permissions to search the tombstone objects. Generally, a member of the Administrators group is sufficient. However, some Active Directory servers may require a member of the Domain Admins group. Check with your Active Directory permissions to determine the appropriate credentials required.

The DirSync capture connector is recommended for environments where the sequence of events is critical. The DirSync capture connector processes events in the order in which they occur, unlike the [Active Directory USNChanged connector](overview.md#manually-update-connector-cursor) which prioritizes inserts and updates before deletes.

To use the DirSync control, the Bind DN connecting to the directory must have the DS-Replication-Get-Changes extended right, which can be enabled with the **Replicating Directory Changes** permission, on the root of the partition being monitored. By default, this right is assigned to the Administrator and LocalSystem accounts on domain controllers.

>[!warning]
>The DirSync capture connector does NOT capture changes to calculated attributes such as the `memberOf` attribute or moved entries (`modDN` or `modRDN` operations).

## Active Directory Hybrid connector

The Active Directory hybrid capture connector uses a combination of the uSNChanged and DirSync change detection mechanisms. The first time the connector starts, it gets a new cookie and the highest `uSNchanged` number. When the connector gets a new change (modify or delete), it makes an additional search using the DN of the entry and fetches the entry from AD. The fetched entry contains the `uSNChanged` attribute, so the connector updates the cursor values for both for the cookie and the last processed `uSNchanged` number.

>[!warning]
>If you are virtualizing and detecting changes from a Global Catalog, then you must use the Active Directory USNChanged changed connector because the Hybrid connector cannot detect change events on sub-domains.

When the connector restarts, uSNChanged detection catches the entries that have been modified or deleted while the connector was stopped. The LDAP search uses the last processed uSN to catch up. After the connector processes all entries, it requests a new cookie from AD (not from the cursor) and switches to DirSync change detection.

## Active Directory Connector Failover

All Active Directory connectors have the ability to failover to a replica if the primary server is unavailable and the number of failure exceptions exceeds either the [Maximum Retries on Error](configure-connector-types-and-properties.md#max-retries-on-error) or [Maximum Retries on Connection Error](configure-connector-types-and-properties.md#max-retries-on-connection-error) value. This mechanism leverages the Active Directory replication vectors `[replUpToDateVector]`, and the failover servers configured at the level of the RadiantOne data source associated with Active Directory, to determinate which server(s) the connector switches to in case of failure. Since the replication vector contains all domains, in addition to some possibly retired domains, the connector narrows down the list of possible failover candidates to only the ones listed as failover servers in the RadiantOne data source associated with the Active Directory backend. If there are no failover server defined for the data source, all domains in the replication vector are possible candidates for failover.

>[!warning]
>When defining the RadiantOne data source associated with Active Directory, do not use Host Discovery or Load Balancers. You must use the fully qualified machine names for the primary server and failover servers. Do not use IP addresses. Also, it is highly recommended that you list your desired failover servers at the level of the data source. Not only does this make the failover logic more efficient, but it also avoids delays in synchronization.

`[replUpToDateVector]` definition: The non-replicated attribute `replUpToDateVector` is an optional attribute on the naming context root of every naming context replica. If this vector is unavailable, the connector is suspended.

The ReplUpToDateVector type is a tuple with the following fields:

- `uuidDsa`: The invocation ID of the DC that assigned `usnHighPropUpdate`.
- `usnHighPropUpdate`: A USN at which an update was applied on the DC
  identified by `uuidDsa`.
- `timeLastSyncSuccess`: The time at which the last successful replication occurred from the DC identified by `uuidDsa`; for replication latency reporting only.

`[replUpToDateVector]` example:

```sh
01ca6e90-7d20-4f9c-ba7b-823a72fc459e @ USN 2210490 @ Time 2005-08-21
15:54:21

1d9bb4b6-054a-440c-aedf-7a3f28837e7f @ USN 26245013 @ Time 2007-02-27
10:17:33

24980c9d-39fa-44d7-a153-c0c5c27f0577 @ USN 4606302 @ Time 2006-08-20
23:33:09
```

For more information on Active Directory replication please read [how the Active Directory replication model works](http://technet.microsoft.com/en-us/library/cc772726(WS.10).aspx) and this [guide to Active Directory replication](http://technet.microsoft.com/en-us/magazine/2007.10.replication.aspx).

At run-time, the connector retrieves the entire list of servers defined in the replication vector and reduces the number of possible failover candidates based on failover servers defined in the RadiantOne data source (if any). The list of potential failover servers is stored at each polling interval. When the current server fails, and retries are exhausted, the connector decides to switch to the closest candidate by selecting the server with the maximum timestamp from the up-to-dateness vector. The capture connector's cursor is assigned the value from the up-to-dateness vector for the failover server. If the closest candidate fails as well, the connector tries with a second closest candidate and so on.

Important things to keep in mind about the different Active Directory connector types:

- Active Directory USNChanged connector - Due to the lack of Active Directory replication for the `USNChanged` attribute, some changes could be missed or replayed on failover.
- For AD LDS backends, a special user for the connector must exist under the `CN=Configuration`, `CN={...}` naming context. This account must be configured in the RadiantOne LDAP data source associated with the AD LDS backend. This user must have permissions to read everything under the Root DSE, (e.g. `CN=Configuration`, `CN={...}`), and the AD LDS branch that the connector is monitoring for changes. All AD LDS instances must run on different computers and must listen on the same ports.
- Active Directory DirSync connector – When the connector fails over to another DC replica, the connector may receive all objects and attributes instead of just the delta since the last request. Therefore, you may notice the number of entries published by the connector is more than you were expecting. This behavior is dictated by the Active Directory server and is out of the control of the connector. Keep this in mind when you define the Max Retries and Retry Intervals for the connector properties. The smaller the number of retries, the higher the chance the connector will failover and the greater potential of receiving all objects and attributes (a full sync) from the domain controller.
- Active Directory Hybrid connector – leverages a mix of both USNChanged and DirSync functionalities during failover. After the failover server is found, uSNChanged detection catches the entries that have been modified or deleted since the connector's failure. The LDAP search uses the last processed `uSNChanged` number to catch up. After the connector processes all entries, it requests a new cookie from Active Directory and switches to DirSync change detection.

## Configuration

Set the connector type in the pipeline configuration by choosing the **Capture** component. In the Core Properties section, select the type of Active Directory connector from the drop-down list.

![The drop-down list for available types of Active Directory connectors in the Core Properties section of Configure Pipeline](media/image14.png)

After the Active Directory connector type has been selected, configure the properties. For properties common to all connectors, see [Configure capture connector types and properties](configure-connector-types-and-properties.md#common-properties-for-all-connectors). Properties related to filtering of events are configured in the Event Filtering section. Properties related to the contents of the messages published by the connector are configured in the [Event Contents](configure-connector-types-and-properties.md#event-contents) section. All other properties are configured in the Advanced Properties section.

### Event filtering

When a connector collects changed entries, it can filter out the ones that are not needed. There are three properties used for filtering: LDAP Filter, Excluded Branches and Included Branches. These properties are described below.

#### LDAP Filter

To further condition the entries that are published, you can indicate the desired criteria in the LDAP Filter property. This is a post filter, used to qualify which entries are included in the message published by the connector. You must enter a valid LDAP filter in the property.

This property can be used to reduce the size of the message by only including desired entries (that match the filter). This can also help reduce the amount of transformation logic needed because you can easily avoid synchronizing certain entries without needing the logic to abort them in the transformation script.

If a captured entry matches the criteria indicated in the LDAP filter property, it is published in the message by the connector. If it does not, the entry is not published in the message. Information about the skipped entries is in the connector log (with log level 4).

If the captured change type is delete, and not enough information is known about the entry, the LDAP filter is not used and the entry is published in the message. For example, if the LDAP filter property contained a value of `(l=Novato)` and the captured entry did not contain an `l` attribute, the LDAP filter is not applied and the entry is published in the message.

If the captured change type is not delete (e.g. insert, update, move, etc.), and not enough information is known about the entry, the LDAP filter is still used and the entry is not published into the message. For example, if the LDAP filter property contained a value of `(l=Novato)` and the captured entry did not contain an `l` attribute, the LDAP filter is still applied and the entry is not published in the message.

>[!note]
>This property can be updated while the connector is running and takes effect without restarting the connector.

#### Excluded Branches

To further condition the entries that are published, you can indicate one or more branches to exclude. In the Excluded Branches property, enter one or more suffixes associated with entries that should not be published by the connector. Select **Enter** after each suffix. An example is shown below.

![Two suffixes entered in the Excluded Branches property](media/image9.png)

If the changed entry DN contains a suffix that matches the excluded branches value, or is a change in the exact entry that is listed (e.g. `ou=dept1,ou=com`), this entry is not published by the connector. Otherwise, the entry is published. This can avoid publishing unwanted information.

>[!note]
>If both included and excluded branches are used, an entry must satisfy the conditions defined in both settings to be included in the message. The included branches condition(s) is checked first.

If a change is made to this property while the connector is running, the new value is taken into account once the connector re-initializes which happens automatically every 20 seconds.

#### Included Branches

To further condition the entries that are published, you can indicate one or more branches to include. In the Included Branches property, enter one or more suffixes associated with entries that should be published by the connector. Select **Enter** after each suffix. An example is shown below.

![Two suffixes entered in the Included Branches property](media/image10.png)

If the changed entry DN contains a suffix that matches the included branches value, or is a change in the exact entry that is listed (e.g. `ou=dept1,ou=com`), this entry is published by the connector. Otherwise, the entry is not published. This can avoid publishing unwanted information.

>[!note]
>If both included and excluded branches are used, an entry must satisfy the conditions defined in both settings to be included in the message. The included branches condition(s) is checked first.

If a change is made to this property while the connector is running, the new value is taken into account once the connector re-initializes which happens automatically every 20 seconds.

### Advanced properties

#### Determine Move Operations

By default, the connector handles changes associated with LDAP modify DN and RDN operations, which change the distinguished name (DN)/relative distinguished name (RDN) of an entry, as an update operation. In the case of modify DN/RDN operations, Active Directory does not provide information about the old DN of the entry making it impossible for the connector to propagate a delete operation for the old DN/entry.

If you require DN/RDN changes to be processed by the connector as a `modDN/modRDN` operation (so the target data source(s) get the change as a `modDN/modRDN`), set the Determine Move Operations property to: `true`

>[!warning]
>The connector must be restarted for this property to take effect.

When the Determine Move Operations property is enabled, the connector maintains a cache mapping the objectGUID to DN for each Active Directory entry. This allows the connector to detect and propagate the event as a `modDN/modRDN` (move) operation. All entries from Active Directory must be read the first time when the connector starts/restarts to populate the cache. This increases the amount of time it takes for the connector to start and be able to capture changes.

>[!warning]
>When defining the data source for the backend Active Directory, check the Paged Results Control option to ensure that all entries can be retrieved from the backend. This is required for the connector to get all entries in the cache to map objectGUID to DN and support `modDN/modRDN` operations.
