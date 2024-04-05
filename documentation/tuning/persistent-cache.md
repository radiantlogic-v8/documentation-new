---
title: Persistent Cache
description: Learn how to configure and manage persistent cache.
---

## Overview

This is the overview.

## Configuring Real-time Refresh

## Configuring Persistent Cache with Real-Time Refresh

If you plan on automatically refreshing the persistent cache as changes happen on the backend data sources, this would be the recommended cache configuration option. This type of caching option leverages the RadiantOne Universal Directory storage for the cache image. 

If you choose a real-time refresh strategy, there are two terms you need to become familiar with:

- Cache Dependency – cache dependencies are all objects/views related to the view that is configured for persistent cache. A cache dependency is used by the cache refresh process to understand all the different objects/views that need to be updated based on changes to the backend sources.

- Cache Refresh Topology – a cache refresh topology is a graphical representation of the flow of data needed to refresh the cache. The topology includes an object/icon that represents the source (the backend object where changes are detected from), the queue (the temporary storage of the message), and the cache destination. Cache refresh topologies can be seen from the Main Control Panel > PCache Monitoring tab.

Cache dependencies and the refresh topology are generated automatically during the cache configuration process.

If you have deployed multiple nodes in a cluster, to configure and initialize the persistent cache, you must be on the current RadiantOne leader node. To find out the leader status of the nodes, go to the Dashboard tab > Overview section in the Main Control Panel and locate the node with a yellow triangle icon. 

To configure persistent cache with real-time refresh:

1.	Go to the Directory Namespace Tab of the Main Control Panel associated with the current RadiantOne leader node.

2.	Click the Cache node.

3.	On the right side, browse to the branch in the RadiantOne namespace that you would like to store in persistent cache and click **OK**.

>[!warning] 
>For proxy views of LDAP backends, you must select the root level to start the cache from. Caching only a sub-container of a proxy view is not supported.

4. Click Create Persistent Cache. The configuration process begins. Once it completes, click OK to exit the window.

5. On the Refresh Settings tab, select the Real-time refresh option.

>[!warning] 
>If your virtual view is joined with other virtual views you must cache the secondary views first. Otherwise, you are unable to configure the real-time refresh and will see the following message. A Diagnostic button is also shown and provides more details about which virtual views require caching.

![An image showing ](Media/Image2.8.jpg)
 	 
Figure 2.8: Caching secondary views message

6. Configure any needed connectors. Please see the section titled [Configuring Source Connectors](#configuring-source-connectors) for steps.

7. Click **Save**.

8. On the Refresh Settings tab, click Initialize to initialize the persistent cache.

There are two options for initializing a persistent cache. Each is described below.

*Create an LDIF File*

If this is the first time you’ve initialized the persistent cache, choose this option. An LDIF formatted file is generated from the virtual view and then imported into the cache.

*Using an Existing LDIF*

If you’ve initialized the persistent cache before and the LDIF file was created successfully from the backend source(s) (and the data from the backend(s) has not changed since the generation of the LDIF file), then you can choose this option to use that existing file. The persisting of the cache occurs in two phases. The first phase generates an LDIF file with the data returned from the queries to the underlying data source(s). The second phase imports the LDIF file into the local RadiantOne Universal Directory store. If there is a failure during the second phase, and you must re-initialize the persistent cache, you have the option to choose the LDIF file (that was already built during the first phase) instead of having to re-generate it (as long as the LDIF file generated successfully). You can click browse and navigate to the location of the LDIF. The LDIF files generated are in `<RLI_HOME>\<vds_server>\ldif\import`.

If you have a large data set and generated multiple LDIF files for the purpose of initializing the persistent cache (each containing a subset of what you want to cache), name the files with a suffix of “_2”, “_3”…etc. For example, let’s say the initial LDIF file (containing the first subset of data you want to import) is named cacheinit.ldif. After this file has been imported, the process attempts to find cacheinit_2.ldif, then cacheinit_3.ldif…etc. Make sure all files are located in the same place so the initialization process can find them.

9. Click **OK**. The cache initialization process begins. The cache initialization is performed as a task and can be viewed and managed from the Tasks Tab in the Server Control Panel associated with the RadiantOne leader node. Therefore, you do not need to wait for the initialization to finish before exiting the initialization window.

10. The view(s) is now in the persistent cache. Queries are handled locally by RadiantOne and are no longer sent to the backend data source(s). Real-time cache refresh has been configured. For information about properties associated with persistent cache, please see [Persistent Cache Properties](#persistent-cache-properties).


## Configuring Periodic Refresh

Review the section on [periodically refreshing the cache](#periodic-refresh) to ensure the persistent cache is updated to match your needs. If you plan on refreshing the cache image periodically on a defined schedule, this would be the appropriate cache configuration option. This type of caching option leverages the internal RadiantOne Universal Directory storage for the cache image.

To configure persistent cache with Periodic refresh
1.	On the Directory Namespace tab of the Main Control Panel, click the Cache node.

2.	On the right side, browse to the branch in the RadiantOne namespace that you would like to store in persistent cache and click **OK**.

3.	Click **Create Persistent Cache**. The configuration process begins. Once it completes, click **OK** to exit the window.

4.	Click the **Refresh Settings** tab.

5.	Select the Periodic Refresh option.

6.	Enter the [CRON expression](#periodic-refresh-cron-expression) to define the refresh interval.

7.	(Optional) Define a [Delete Validation Threshold](#delete-validation-threshold).

8.	(Optional) Define an [Add Validation Threshold](#add-validation-threshold).

9.	Click **Save**.

10.	Click **Initialize** to start the initialization process.

There are two options for initializing the persistent cache: Creating a new LDIF file or initializing from an existing LDIF file. Each is described below.

*Create an LDIF from a Snapshot*

If this is the first time you’ve initialized the persistent cache, then you should choose this option. An LDIF formatted file is generated from the virtual view and then imported into the local RadiantOne Universal Directory store.

*Initialize from an Existing LDIF File*

If you’ve initialized the persistent cache before and the LDIF file was created successfully from the backend source(s) (and the data from the backend(s) has not changed since the generation of the LDIF file), then you can choose to use that existing file. The persisting of the cache occurs in two phases. The first phase generates an LDIF file with the data returned from the queries to the underlying data source(s). The second phase imports the LDIF file into the local RadiantOne Universal Directory store. If there is a failure during the second phase, and you must re-initialize the persistent cache, you have the option to choose the LDIF file (that was already built during the first phase) instead of having to re-generate it (as long as the LDIF file generated successfully). You can click browse and navigate to the location of the LDIF. The LDIF files generated are in <RLI_HOME>\<instance_name>\ldif\import.

If you have a large data set and generated multiple LDIF files for the purpose of initializing the persistent cache (each containing a subset of what you want to cache), name the files with a suffix of “_2”, “_3”…etc. For example, let’s say the initial LDIF file (containing the first subset of data you want to import) is named cacheinit.ldif. After this file has been imported, the process attempts to find cacheinit_2.ldif, then cacheinit_3.ldif…etc. Make sure all files are located in the same place so the initialization process can find them.

After you choose to either generate or re-use an LDIF file, click Finish and cache initialization begins. Cache initialization is launched as a task and can be viewed and managed from the Tasks Tab in the Server Control Panel associated with the RadiantOne leader node. Therefore, you do not need to wait for the initialization to finish before exiting the initialization window.

After the persistent cache is initialized, queries are handled locally by the RadiantOne service and no longer be sent to the backend data source(s). For information about properties associated with persistent cache, please see [Persistent Cache Properties](#persistent-cache-properties).

### Periodic Refresh CRON Expression

If periodic refresh is enabled, you must define the refresh interval in this property. For example, if you want the persistent cache refreshed every day at 12:00 PM, the CRON expression is: 
0 0 12 1/1 * ? *
Click **Assist** if you need help defining the CRON expression.

![An image showing ](Media/Image2.7.jpg)
 
Figure 2.7: CRON Expression Editor

### Delete Validation Threshold

For details on how the periodic persistent cache refresh process works, see [Periodic Refresh](#periodic-refresh).

You can define a threshold to validate the generated LDIF file/image prior to RadiantOne executing the cache refresh process. The threshold is a percentage of the total entries.

To define a granular threshold for delete operations, indicate the percentage in the Delete Validation Threshold. For example, if Delete Validation Threshold contains a value of 50, it means if the generated LDIF image contains at least 50% fewer entries than the current cache image, the periodic persistent cache refresh is aborted for the current refresh cycle.

If a validation threshold is configured, the threshold is checked.

### Add Validation Threshold

For details on how the periodic persistent cache refresh process works, see [Periodic Refresh](#periodic-refresh).

You can define a threshold to validate the generated LDIF file/image prior to RadiantOne executing the cache refresh process. The threshold is a percentage of the total entries.

To define a granular threshold for add operations, indicate the percentage in the Add Validation Threshold. For example, if Add Validation Threshold contains a value of 50, it means if the generated LDIF image contains 50% more entries than the current cache image, the periodic persistent cache refresh is aborted for the current refresh cycle.

## Managing Cache

### Enable/Disable
Active

### Delete Cache

### Rebuild Index

### Export

## Managing Cache Properties
### Full-text Search
### Authentication

**Use Cache for Authentication**

**Local Bind Only**

**Delegate on Failure**

**Enable Password Policy Enforcement**

**Password Writeback**

### Optimize Linked Attributes

**Enable Changelog**

**Async Indexing**

### Non-indexed Attributes
### Sorted Attributes
### Encrypted Attributes
### Extension Attributes
### Invariant Attribute

### Inter-cluster Replication

**Replication Excluded Attributes**

**Accept Changes from Replicas**



