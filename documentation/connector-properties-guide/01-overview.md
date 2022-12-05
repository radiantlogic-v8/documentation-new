---
title: 01-overview
description: 01-overview
---
         
# Chapter 1: Overview

Connectors are used for synchronization in the RadiantOne Global Sync module and have three main functions: 1) Query data sources and collect changed entries, 2) Filter unneeded events, and 3) publish changed entries with the required information (requested attributes).

This chapter provides a brief introduction to the RadiantOne Global Sync module's architecture and some common topics applicable for all connectors like how to reset the cursor and message size. Other chapters in this guide focus on specific connectors per data source type.

## Introduction to Connectors

RadiantOne includes connectors for databases and directories. A connector is an adapter for one catalog/object per data source that can be configured to listen for changes. Some examples are:

- A SQL Server connector for database/catalog PUBS

- An Oracle connector for database owner SCOTT

- An LDAP connector for the inetOrgPerson object class in the schema

For databases, there are three capture connector types: Counter, Changelog (Triggers-based), or Timestamp.

For LDAP directories, there are two connector type options: LDAP (changelog), or Persistent Search.

For Active Directory, there are three connector type options: AD USNChanged, AD DirSync, and AD Hybrid.

Capture connectors publish change messages to queues. A sync engine receives notification when messages are in a queue, applies transformation to the message (based on attribute mappings and or scripting) and sends the transformed message to the destination.

A high-level architecture is shown below.

![An image showing a flow chart of high level architecture](media/image1.png)

Figure 1. 1: High Level Architecture

### Resetting Connector Cursor – Detect New Changes Only

Capture connectors use a cursor to maintain information about the last processed change. This allows the connectors to capture only changes that have happened since the last time they processed changes. When the capture connectors start, they automatically attempt to capture all changes that have happened since the last time they checked. If the synchronization process has been stopped for an extended period, you might not want them to capture all missed changes. In this case, you can reset the cursor for the connector. You can reset the cursor from command line or from the Main Control Panel -> Global Sync tab. Each option is described below.

#### Global Sync tab

On the Main Control Panel -> Global Sync tab, select the topology on the left. Click **Configure** next to the pipeline on the right. Select the **Capture** component and click **Reset Cursor** shown below the properties. An example is shown below.

![An image showing the Reset Cursor option in the Global Sync tab of the Main Control Panel](media/image2.png)

Figure 1. 2: Reset Cursor Option for Capture Connector

#### Command Line

To reset the cursor, run the following command to locate the Pipelines Identifier for your topology: `\<RLI_HOME\>/bin/vdsconfig list-topologies`

Once you have the Pipelines Identifier, run the following command to reset the cursor for the capture connector: `\<RLI_HOME\>/bin/vdsconfig reset-cursor -pipelineid \<pipelines identifier\>`

An example is shown below (log output was removed to simply the response):

```sh
C:\radiantone\vds\bin\>vdsconfig reset-cursor -pipelineid
o_activedirectory_sync_o\_companydirectory_pipeline_o\_activedirectory

{

 "success" : true,

 "data" : "The pipeline connector
\<o_activedirectory_sync_o\_companydirectory_pipeline_o\_activedirectory\>
has been successfully reset."

}
```

### Manually Updating Connector Cursor

Each connector stores a cursor to maintain information about the last processed change. In some cases, you may need to edit the cursor value to force the connector to pick up some missed changes (during a disaster recovery scenario where you will start synchronization in another data center), or skip some changes in cases like where [non-sequential change IDs](06-database-timestamp-connector.md#force-sequential-counters) were detected. Connector configuration is stored in a RadiantOne Universal Directory store mounted at the cn=registry naming context.

>[!note]
>Editing the cursor is supported for connectors that store a number or timestamp value. The AD DirSync and Hybrid connectors use a cookie for a cursor value that you wouldn't know how to set.

1.  Stop the capture connector by suspending the pipeline. You can do this from the Main Control Panel -> Global Sync tab, or using the vdsconfig command line utility, `change-pipeline-state` command.

2.  Connect to RadiantOne with an administrator that has permissions to modify entries in cn=registry and browse to the configuration for your capture connector: `cn=cursor,\<pipelineID\>,cn=registry`

3.  Edit the cursor attribute and enter the value to indicate the point from which the connector should capture changes from. An example for a database changelog connector is shown below.

![An image showing an example of Database Changelog Connector Cursor Settings](media/image3.png)

Figure 1. 3: Example of Database Changelog Connector Cursor Settings

4.  Resume the pipeline which redeploys/starts the connector. You can do this from the Main Control Panel -> Global Sync tab, or using the vdsconfig command line utility, `change-pipeline-state` command.

### Message Size

Each message published by the connector contains one changed entry. Multiple changed entries are not packaged into a single message. The [requested attributes](02-configuring-connector-types-and-properties.md#request-all-attributes) configured for the connector dictate the contents of the message and as a result, the message size.
