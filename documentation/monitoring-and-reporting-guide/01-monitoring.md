---
title: Monitoring
description: Monitoring Options in RadiantOne
---

## Monitoring Overview

Monitoring is one of the most important aspects of maintaining the health of RadiantOne. It is highly recommended that you monitor the RadiantOne components on a regular basis using the methods and utilities discussed in this guide.

The RadiantOne components can be monitored from both the Main and Server Control Panels and command line scripts, in addition to using third party tools.

The key services to monitor are RadiantOne and ZooKeeper. There are default monitoring and alerts for these services. For RadiantOne, see [RadiantOne Availability](monitoring-and-reporting-guide/alert-settings/#radiantone-service-availability). For ZooKeeper, see
[ZooKeeper Write Failure](monitoring-and-reporting-guide/alert-settings/#zookeeper-write-failure).

## Expert Mode

Some settings in the Main Control Panel are accessible only in Expert Mode. To switch to Expert Mode, click the Logged in as, (username) drop-down menu and select Expert Mode.

![An image showing expert mode](Media/Expert-Mode.jpg)

>[!note]
>The Main Control Panel saves the last mode (Expert or Standard) it was in when you log out and returns to this mode automatically when you log back in. The mode is saved on a per-role basis.

## Monitoring from the Main Control Panel

RadiantOne includes built-in monitoring capabilities and can also be monitored by external [third party monitoring tools](#external-monitoring-options-with-third-party-tools).

The Main Control Panel provides a view of RadiantOne nodes deployed. When RadiantOne is deployed in a cluster, the state of services running on all nodes is visible in the Overview section of the Dashboard tab. In the Intranode Health section you can see the connectivity across all nodes.

If RadiantOne is deployed in a classic active/active or active/passive architecture, the Intranode Health section is irrelevant and only one node is shown in the Overview section.

The Replication Monitoring tab is relevant if inter-cluster replication is deployed or if you have RadiantOne deployed in an active/active or active/passive architecture and are replicating RadiantOne Directory stores across them.

### Dashboard Tab

On the Dashboard Tab of the Main Control Panel, the Overview section displays information
about each cluster node. From here, you can see the status of all nodes. The cluster’s RadiantOne leader node is noted with a yellow-colored triangle beside the server name.

For each node, the Overview section displays the status of:

- Current CPU usage of the machine hosting RadiantOne.
- Current RadiantOne service memory usage.
- Current disk usage of the drive on the machine hosting RadiantOne.
- The RadiantOne service’s LDAP port
- The RadiantOne service’s LDAPS port
- The RadiantOne service’s HTTP port
- The RadiantOne service’s HTTPS port
- VRS (SQL) port
- VRS (SQL) SSL port
- ZooKeeper (ZK) on the node (in Node Component Status section). If ZooKeeper is running on a separate machine instead of on the same machine as the RadiantOne service, N/A is shown.
- Disk latency
- Up time – how long the RadiantOne service has been running on the node.
- Version of RadiantOne installed on the node

![An image showing monitoring two RadiantOne cluster nodes ](Media/Image1.1.jpg)

Figure 1.1 : Example Monitoring of a RadiantOne Cluster Containing Two Nodes

If RadiantOne is deployed in a cluster, you can also use <RLI_HOME>/bin/advanced/cluster.bat list (cluster.sh on Linux) to monitor the status (ON/OFF) of each cluster node and see which one is the current RadiantOne service leader and ZooKeeper (ZK) leader. Below is an example.

c:\radiantone\vds\bin\advanced>cluster.bat list
<br> +----------------+--------------------------------------+------------+--------------------+--------------+
<br> | SU-WINUD-E1N1* | cd96bcc3-40f9- 4286 - 810d-881f0aa10eb4 | ON | #1 | ON |
<br> | SU-WINUD-E1N2 | b40c196b- 5596 - 499d- 9855 - 1f8d3980fd1a | ON | #2** | ON |
<br> | SU-WINUD-E1N3 | 53df2 904 - 63b6-41f1-8de6-62c10369846a | ON | #3 | ON |
<br> +----------------+--------------------------------------+------------+--------------------+--------------+

*: RadiantOne service Leader

**: ZK Leader

The Internode Health section is applicable for cluster deployments only and displays a topology of all nodes in the cluster and information about the connectivity between the nodes. If you hover the mouse pointer over a node, the direction of connectivity is conditioned by this node and more details are shown. By default, this includes the availability of the LDAP and LDAPS ports for the RadiantOne service, and the ability to read and write to ZooKeeper on the target node. To toggle information about ZooKeeper or LDAP connectivity, check/uncheck the corresponding box in the upper-left corner of the Internode Health section.

![An image showing the internode health monitoring](Media/Image1.2.jpg)

Figure 1.2: Internode Health Monitoring

A green checkmark means connectivity on the RadiantOne LDAP and/or LDAPS ports is fine and ZooKeeper can be read from and written to.

A red X means there is no connectivity on the LDAP and/or LDAPS ports for RadiantOne and/or
ZooKeeper cannot be read from or written to.

### Replication Monitoring Tab

RadiantOne Directory stores across multiple sites/data centers support multi-master replication. This type of replication is referred to as inter-cluster replication. The state of inter-cluster replication can be monitored from the Replication Monitoring Tab.

**Central Journal Replication**

The default, recommended replication model for RadiantOne Universal Directory stores is based on a publish-and-subscribe methodology. When writes occur on a site, the leader node publishes the changes into a central journal. The leader nodes on all other sites pick up the changes from the central journal and update their local stores. These changes are then automatically replicated out to follower/follower-only nodes within the cluster. For more details on inter-cluster replication, please see the [RadiantOne Deployment and Tuning Guide](/deployment-and-tuning-guide/00-preface).

If inter-cluster replication is enabled, the clusters that are participating in replication can be viewed in the Central Journal Replication section. The topology depicts the connectivity between the clusters and the cluster housing the replication journal. If a red line is visible, this indicates a connection problem between a cluster and the replication journal.

An example is shown below.

![An image showing central journal replication ](Media/replication.jpg)

|Column Name | Definition |
|------------|------------|
| HDAP Store | The root naming context that stores the entries to be replicated across all clusters. |
| Cluster Name | The cluster name, as defined during the RadiantOne installation. | 
| Changes Subscribed (Applied) | The number of changes replicated to this cluster. | 
| Changes Subscribed (Pending) | The number of changes waiting to be replicated to this cluster. | 
| Changes Published | This value is a total of the number of applied and pending changes. | 

More than one store per cluster can be participating in inter-cluster replication. The table shown in the Central Journal Replication section details for each store the clusters involved in replication. Then, for each cluster, the table shows:

- The number of changes subscribed to, are broken down into changes that have been applied and changes that are pending.
- The number of changes published into the replication journal.

**Push Mode Replication**

To address a very small subset of use cases, namely where a global load balancer directs client traffic across data centers/sites, where the inter-cluster replication architecture might be too slow, you have the option to enable an additional, more real-time replication mode where changes can be pushed directly to intended targets. For example, an update made by a client to one data center might not be replicated to other data centers in time for the client to immediately read the change, if the read request it sent to a different data center than the update was. This is generally not an ideal load distribution policy when working with distributed systems. Load balancing is best deployed across multiple nodes within the same cluster on the same site/data center.

In any event, to address scenarios like this, a push replication mode can be used to send the changes directly to the intended targets. The targets must be other RadiantOne servers defined as LDAP data sources. For more details on Push Mode Replication, please see the [RadiantOne Deployment and Tuning Guide](/deployment-and-tuning-guide/00-preface).

If push mode replication is enabled, the clusters that are participating in replication can be viewed in the table in the Push Mode Replication section. The table lists, for each store, the clusters involved in replication. The source cluster, target cluster and connectivity status between them is shown.

### Global Sync Tab

From the Main Control Panel > Global Sync tab, you can select a topology and monitor the
activities of the capture, transform and apply processes associated with each pipeline.

![An image showing ](Media/Image1.35.jpg)

Figure 1. 35 : Global Sync Monitoring

All topologies are listed on the left. Select a topology to view the sync pipelines. For each
running pipeline, a list of entries processed by the Capture, Transform and Apply components
are shown. For the Transform component, you see a number queued (messages in the queue
waiting to be processed) and a number processed (entries transformed).

From the Global Sync tab, you can stop the synchronization flows with **Stop**. Clicking stop, pauses the synchronization for all pipelines associated with the topology. Click **Start** to start synchronization for all pipelines. To resume synchronization for a specific pipeline, click CONFIGURE next to the apply, select the Apply component and click Start.

![An image showing ](Media/Image1.36.jpg)

Figure 1. 36 : Resume Synchronization for a Specific Pipeline

Click **Configure** next to a pipeline to access the queue monitoring, alert settings, and logs
associated with the synchronization. In the Queue section, you can view the number of
messages processed, the current queue size, and some processing statistics (rate per sec and
peak processing times). You can also manage messages that failed to be applied by either
deleting them or manually resending them.

![An image showing ](Media/Image1.37.jpg)

Figure 1. 37 : Queue Monitoring – Resending Failed Messages

### Persistent Cache Refresh (PCache Monitoring tab)

From the Main Control Panel > PCache Monitoring tab, you can select a real-time persistent cache refresh configuration and monitor the activities of the capture and apply processes.

![An image showing ](Media/Image1.38.jpg)

Figure 1. 38 : Persistent Cache Refresh Monitoring



## Monitoring from the Server Control Panels

The items that can be monitored from the Server Control Panels are described in this section.

Server Control Panels can be launched from the Dashboard tab in the Main Control Panel.

Locate the node and click the ![An image showing the server control panel button](Media/server-control-panel.jpg) button to launch the Server Control Panel.

>[!warning] When deploying RadiantOne in a cluster, the Main Control Panel allows you to monitor certain aspects of all cluster nodes. Each node also has its own Server Control Panel for monitoring other server-specific activities.

### CPU, Memory, Disk Space, Disk Latency and Connection Usage

From the Server Control Panel > Dashboard Tab, you can monitor the CPU, disk space and
latency on the machine hosting RadiantOne, and the RadiantOne service memory and
connections.

>[!warning]
>To use this feature, enable the cluster monitor at Main Control Panel > Settings > Logs > Clustermonitor.

![An image showing monitoring resources from the server control panel ](Media/Image1.3.jpg)

Figure 1.3: Monitoring Resources from the Server Control Panel

Alerts can be configured for memory, connections, disk space and disk latency from the Main
Control Panel > Settings tab > Monitoring > Standard Alerts.

To manage alerts:

1. In the Main Control Panel go to Settings Tab > Monitoring section > Standard Alerts sub-section.
2. Define the memory threshold in the Memory section.
3. Define the connection threshold in the Connections section.
4. Define the disk space and disk latency thresholds in the Disk Alerts section.

    ![An image showing configuring standard alerts from the Main Control panel ](Media/Image1.4.jpg)

    Figure 1.4: Configuring Standard Alerts from the Main Control Panel

5. File alerts are enabled by default. If SMTP settings are configured in the Monitoring -> Email Alert Settings section you can also use the Email Alert output.
6. Click Save.

### Connections and Operations

The Server Control Panel > Usage & Activity Tab > Usage Summary section, displays the total number of connections made to the server (since startup), and the total number of operations (since startup). The average per minute for each is calculated and displayed.

From the Current Connections section, you can also view the number of open connections to
RadiantOne including:

- Client IP/port that opened the connection
- Time the connection was opened
- How many operations have been performed on the connection
- Which user authenticated on the connection

The Processing Activity Details section shows how many operations are waiting to be processed, how many operations are currently being executed in addition to the maximum working threads available and peak worker threads used. This allows you to see the load on the server in terms of working threads. If you are consistently seeing peak working threads close to the max working threads number, you should possibly increase the max working threads or number of processors (depending on the processing capabilities of the machine RadiantOne is deployed on). This may also indicate that you need to scale out and deploy a new machine (e.g. add a cluster node).

![An image showing monitoring connections and processing activity ](Media/Image1.7.jpg)

Figure 1. 7 : Monitoring Connections and Processing Activity from the Server Control Panel

### RadiantOne Directory Status

Store status (including number of entries, index size, revision, and search and write operations) can be monitored from the Server Control Panel > Usage & Activity tab > Universal Directory Status section.

To filter the stores displayed, click on gear icon and then click Select Filters. Select the stores to display and click OK. Click OK to exit the settings.

![An image showing the ](Media/Image1.8.jpg)

Figure 1.8: Monitoring RadiantOne Universal Directory Stores from the Server Control Panel

### Resetting Peak Operations

To reset the peak operations without restarting the RadiantOne service, you can use the following (assuming the service is listening on LDAP port 2389 and the super user password is “password”):

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" -b
"action=resethdapactivityinfos,cn=monitor" (objectclass=*)

### Configuring RadiantOne Directory Alerts

Alerts can be configured for RadiantOne Directory stores. To configure store alerts:

1. In the Main Control Panel go to Settings Tab > Monitoring section > Custom Alerts sub-section (requires [Expert Mode](#expert-mode)).
2. Click the Add button.
3. From the Template drop-down menu, select **Custom**.
4. From the Monitoring Source drop-down menu, select hdap-store. The page refreshes and displays the store information in the table at the bottom.
5. Configure other parameters as required.
6. Click **Save**.

![An image showing the ](Media/Image1.9.jpg)

Figure 1. 9 : Configuring a RadiantOne Universal Directory Store Alert from the Main Control Panel

### Data Source Status

The status of the RadiantOne service (data sources named vds and vdsha) and any backend can be monitored from the Server Control Panel > Usage & Activity Tab > Data Source Status section.

![An image showing the ](Media/Image1.10.jpg)

Figure 1. 10 : Monitoring Data Sources from the Server Control Panel

The status values are on, off, offline, and unavailable. The following table describes each status.


| Status | Description | 
|--------|---------------------------|
| On | RadiantOne can connect to the data source. | 
| Off | The connection test to the data source failed. | 
| Offline | The data source’s active property is set to false. | 
| Unavailable | No classname property is defined for the data source. | 

If a data source has failover servers configured, the URL in the message indicates which server the status applies to.

To configure alerts for data source availability:

1. In the Main Control Panel go to Settings Tab -> Monitoring section > Standard Alerts sub-section.
2. In the Data Sources section, there is the option to enable/disable alerts when a data source is disconnected (unreachable).

    ![An image showing configurating a data source](Media/Image1.11.jpg)

    Figure 1.11: Configuring a Data Source Alert from the Main Control Panel

3. Define the interval to check the data source availability. The default is 120 seconds.
4. File alerts are enabled by default. If SMTP settings are configured in the Monitoring > Email Alert Settings section you can also use the Email Alert output.
5. Click the field next to “Data sources to monitor:” and select a data source from the drop-down menu. The vds data source is selected by default and is used to monitor the RadiantOne service and alert when the service is stopped or started.

    ![An image showing selecting a data source to monitor ](Media/Image1.12.jpg)

    Figure 1. 12 : Selecting a Data Source to Monitor

6. Verify that the data source name is displayed in the “Data sources to monitor” field.
7. Click Save.

![An image showing a data source to monitor](Media/Image1.13.jpg)

Figure 1.13: Example of a Data Source to Monitor

>[!note]
>To disable alerts for a data source, click the X next to the data source name in the Data Source to monitor field, which removes it from the list.

### Network Latency

If deployed in a cluster, the latency between RadiantOne nodes can be monitored from the
Server Control Panel -> Usage & Activity tab -> Network Latency section.

![An image showing monitoring network latency](Media/Image1.14.jpg)

Figure 1.14: Monitoring Network Latency Between RadiantOne Nodes

## Monitoring and Alerts for the RadiantOne Service from the Command Line

A command-line script can monitor the status of the following items:

- The RadiantOne service’s [Memory](#radiantone-services-memory)
- [Connections](#connections-to-radiantone) to RadiantOne
- Status of the [RadiantOne LDAP service and LDAP Backend Data Sources](#status-of-radiantone-ldap-service-and-ldap-backend-data-sources)
- Status of [Database Backend Data Sources](#status-of-database-backend-data-sources)
- [Disk Space](#disk-space) on the machine where RadiantOne is installed
- Status of [Data sources (Backends)](#data-source-backends)

The script, monitoring.bat (monitoring.sh on Linux), is located in <RLI_HOME>/bin. This script must run on the same machine as RadiantOne. If triggers are configured, the alert is triggered when you first running the monitoring script (if a trigger condition is met) or when there is a change of state for the property you are monitoring. If there is no change of state for a monitored property, no alert is issued. To configure the alert to go to a file, edit the <RLI_HOME>/bin/monitoring.bat (monitoring.sh on Linux) to add the following (below is an
example for the Linux script)

```sh
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=file:/usr/local/apps/vds/config/logging/log4j2-default-file.json -Drli.app.key=myalert ${RLI_JOPTS_EXTRA} ${RLI_JOPTS_DEFAULT_VM_SIZE} -cp "${RLI_ALL_CP}" com.rli.monitoring.MonitoringCommand "$@"
```

usage: < script > [-n < instance name >] -d < data collector key > [-p < data property >]

[-t <trigger type>] [-g < key:value >] [-i <seconds>]

- n,--instance <instance name> Which instance to use (optional), vds_server is the default if nothing is specified.
- d,--data <data collector key> Which data to collect
- p,--data-param <data property> Which property of the data to collect
- t,--trigger <trigger type> Defines the type of the trigger to use
- g,--trigger-param < key:value > Trigger parameter (repeat the option for each parameter)
- i,--interval <seconds> Sets the monitoring polling interval

The possible data collector keys are described [here](monitoring-and-reporting-guide/data-collectors.md).

List of available triggers:

- above(threshold)
- below(threshold)
- equals(value)
- always()

### RadiantOne Service’s Memory

The following example command shows how to monitor the RadiantOne service’s memory every 15 minutes (900 seconds) and trigger an alert when the memory reaches above 90% of
the allocated amount:

<RLI_HOME>/bin/monitoring.bat -d node-monitor -p propertyId:memoryPercent -t above -g threshold:90 -i 900

### Connections to RadiantOne

The following example command shows how to monitor connections to RadiantOne every 15 minutes (900 seconds) and trigger an alert when the connections reaches above 90% of the allocated amount:

<RLI_HOME>/bin/monitoring.bat -d node-monitor -p propertyId:connectionPercent -t above -g
threshold:90 -i 900

### Status of RadiantOne LDAP Service and LDAP Backend Data Sources

The following example command shows how to monitor an LDAP backend every 15 minutes
(900 seconds) and trigger an alert when the status changes, using monitoring.bat:

<RLI_HOME>/bin/monitoring.bat -d datasource-status -p datasourceId:sundirectory -p
propertyId:status -t equals -g value:false -i 900

### Status of Database Backend Data Sources

The following example command shows how to monitor a database backend every 15 minutes (900 seconds) and trigger an alert when the status changes, using monitoring.bat:

<RLI_HOME>/bin/monitoring.bat -d datasource-status -p datasourceId:sqlserver -p
propertyId:status -t equals -g value:false -i 900

### Disk Space

The following example command shows how to monitor the available disk space every 15 minutes (900 seconds) on the machine where RadiantOne is installed and trigger an alert when the disk space usage reaches above 90% of the available amount (meaning only 10% of the available disk space is left):

<RLI_HOME>/bin/monitoring.bat -d node-monitor -p propertyId:diskPercent -t above -g
threshold:90 -i 900

### Data Source Backends

You can use the <RLI_HOME>/vds/advanced/checkDataSources.bat (.sh on Unix) script to check the status of all data sources (or only the ones listed in the command) and prints their status either to the console or a specified file. The status is either “OK” (indicating that nothing was found to be wrong with accessing the data source) or “FAILED [specific error]” (indicating that is something wrong with accessing the data source). Execute the command with? to find out more about the command. Below are the possible parameters:

- n Name of the RadiantOne instance. If this is not specified, the default instance is used.
- l List of data sources (comma separated) to be checked. If not specified, all data sources are checked.
- o Output file to store the status. If nothing is specified, the output is printed to the console.

The following example command checks the status of data sources named Sun ONE, AD, Oracle, and SQL_Server and writes the status of each data source in mystatus.log (which is
located in $RLI_HOME/bin since it is default path).

<RLI_HOME>/bin/advanced/checkdatasources.sh -l sunone, ad, oracle, sql_server -o mystatus.log

Example contents of the mystatus.log file:

- replicationjournal[LDAP]=OK
- log2db[JDBC]=OK
- remotevds[LDAP]=OK
- advworks[JDBC]=OK
- rli_client_db_datasource[JDBC]=OK


## Monitoring Real-time Persistent Cache Refresh and Global Sync Components from Command Line

You can use the <RLI_HOME>/bin/monitoring.bat (monitoring.sh on Unix) to monitor real-time persistent cache refresh and global synchronization components from command line. This script must run on the same machine as the services you want to monitor. If triggers are configured, the default alert is a file alert: <RLI_HOME>/logs/alerts.log. Alerts associated with the monitoring command are configured on the Main Control Panel -> ZooKeeper tab (requires [Expert Mode](#expert-mode)). Navigate to /radiantone/v1/cluster/config/logging/log4j2-monitoring-command.json and click EDIT MODE on the right.

The monitoring script offers a set of data collectors that retrieve information about specific components of RadiantOne. The “pipeline” data collector is used for persistent cache refresh and Global Sync components. The syntax and properties supported are shown below.

`pipeline(sourceDn=*,targetDn=*,pipelineId=*,pipelineType=*,componentType=*,propertyId=*)`

Run the monitoring script with the pipeline command to get a list of possible values for the
properties that can be passed in the command.

### Real-time Persistent Cache Refresh

A high-level real-time persistent cache refresh architecture is shown below.

![An image showing ](Media/Image1.39.jpg)

Figure 1.39 : Real-time Persistent Cache Refresh Architecture

Pipeline properties for real-time persistent cache refresh processes are described below.

- SourceDn and targetDn values are the same, and indicate the DN in the RadiantOne namespace that is configured for real-time persistent cache refresh.
- The pipelineId is the identifier associated with the real-time persistent cache refresh.
- The pipelineType value is: PCACHE
- The componentType has one of the following values: APPLY, CAPTURE, PIPELINE, PROCESSOR.
- The CAPTURE componentType, related to step 1 in Figure 1.30, has the following properties (propertyId): captureCounter, captureHostname, captureMetaDn, captureState, captureType.
<br> **captureCounter** - indicates the number of changed entries published by the connector.
<br> **captureHostname** - indicates the identifier of the machine where the agent process is running. The agent oversees managing the connector states.
<br> **captureMetaDn** - is an identifier for the virtual node that the connector listens for changes on.
<br> **captureState** - is the status of the capture connector. The captureState can have one of the following values: RUNNING, DEPLOYING, STOPPED, ERROR, WAITING_FOR_AGENT.
<br> **captureType** - indicates the method used to capture changes. The captureType can have one of the following values: CHANGELOG, AD_DIRSYNC, AD_USN, AD_HYBRID, DB_TIMESTAMP, DB_COUNTER, DB_TRIGGER, SCIM2, SCIM1, GRAPHAPI, MGRAPH, OKTA, KAFKA, KAFKA_GG, PERSISTENT_SEARCH.
- The APPLY componentType, related to step 4 in Figure 1.30, has the following property: appliedCounter. This indicates the number of changes processed to apply to the persistent cache.
- The PIPELINE componentType has the following property: pipelineState, which indicates if the persistent cache refresh process is started. PipelineState can have one of the following values: RUNNING, SUSPENDED, UPLOADING, ERROR, DEPLOYING, WAITING_FOR_AGENT
- The PROCESSOR componentType has the following properties: processorCounter, processorHostname, processorQueueSize. The processor component logic is built into the Sync Engine shown in Figure 1.30 and is responsible for processing events from the queues. ProcessorCounter is the number of events processed from the queue. ProcessorHostname is the machine name where this process is running. ProcessorQueueSize is the number of entries in the queue waiting to be processed.ProcessorQueueSize is a good candidate to configure custom alertsfor. If this number is growing, and the pipeline is fully  started, it is an indicator that events are being processed too slow. This could be due to errors while applying events, or just slow machine hardware or network.

### Global Synchronization

A high-level Global Synchronization architecture is shown below.

![An image showing ](Media/Image1.40.jpg)

Figure 1. 40 : Global Synchronization Architecture

Pipeline properties for global synchronization processes are described below.

- SourceDn is the DN in the RadiantOne namespace associated with the data source where changes are captured.
- TargetDn is the DN in the RadiantOne namespace associated with the destination data source where changes are to be applied.
- The pipelineId is the identifier associated with the synchronization pipeline.
- The pipelineType value is: SYNC
- The componentType has one of the following values: APPLY, CAPTURE, PIPELINE, PROCESSOR.
- The CAPTURE componentType, related to step 1 in Figure 1.31, has the following properties (propertyId): captureCounter, captureHostname, captureMetaDn, captureState, captureType.
<br> **captureCounter** - indicates the number of changed entries published by the connector.
<br> **captureHostname** - indicates the identifier of the machine where the agent process is running. The agent oversees managing the connector states.
<br> **captureMetaDn** - is an identifier for the virtual node that the connector listens for changes on.
<br> **captureState** - is the status of the capture connector. The captureState can have one of the following values: RUNNING, DEPLOYING, STOPPED, ERROR, WAITING_FOR_AGENT
<br> **captureType** - indicates the method used to capture changes. The captureType can have one of the following values: CHANGELOG, AD_DIRSYNC, AD_USN, AD_HYBRID, DB_TIMESTAMP, DB_COUNTER, DB_TRIGGER, SCIM2, SCIM1, GRAPHAPI, MGRAPH, OKTA, KAFKA, KAFKA_GG, PERSISTENT_SEARCH
- The APPLY componentType, related to step 4 in Figure 1.31, has the following property (propertyId): appliedCounter. This indicates the number of changes applied on the target.
- The PIPELINE componentType has the following property (propertyId): pipelineState, which indicates if the synchronization process is started. PipelineState can have one of the following values: RUNNING, SUSPENDED, UPLOADING, ERROR, DEPLOYING, WAITING_FOR_AGENT
- The PROCESSOR componentType, has the following properties (propertyId): processorCounter, processorHostname, processorQueueSize. The processor component logic is built into the Sync Engine shown in Figure 1.31 and is responsible for processing events from the queues. ProcessorCounter is the number of events processed from the queue. ProcessorHostname is the machine name where this process is running. ProcessorQueueSize is the number of entries in the queue waiting to be processed. ProcessorQueueSize is a good candidate to configure custom alerts for. If this number is growing, and the pipeline is fully started, it is an indicator that events are being processed too slow. This could be due to errors while applying events, or just slow machine hardware or network.

## External Monitoring Options with Third Party Tools

Even though RadiantOne does not log activities directly to any third party/external monitoring tool by default, there are various methods available for these tools to get information about what they want to monitor. These methods are described below.

### Configure a Log4J Appender

RadiantOne logging leverages log4j format. Log4j offers many different appenders that can be utilized in RadiantOne, such as sysLog, SNMP trap and socket, among others. A list of appenders supported for Log4J v2 can be found here:
https://logging.apache.org/log4j/2.x/manual/appenders.html

An example SNMP trap appender configuration can be found in the [Radiant Logic online knowledge base](https://support.radiantlogic.com).

The default log4j configurations are described in the table below:

| Service or Tool | Log4J Default Configuration |
|---------------|----------------------------------------|
| RadiantOne FID and Universal Directory |  In ZooKeeper at `/radiantone/<version>/<cluster_name>/config/logging/log4j2-vds.json` | 
| Task Scheduler | In ZooKeeper at `/radiantone/<version>/<cluster_name>/config/logging/log4j2- scheduler.json | 
| Control Panels | In ZooKeeper at `/radiantone/<version>/cluster_name>/config/logging/log4j2-control-panel.json` | 
| Monitoring Script | In ZooKeeper at `/radiantone/<version>/<cluster_name>/config/logging/log4j2-monitoring-command.json`
| Agents used to manage capture connectors for real-time persistent cache refresh and global sync. | In ZooKeeper at `/radiantone/<version>/<cluster_name>/config/logging/log4j2-cragents.json` | 

To configure your own log4j appender:

>[!warning] Extreme caution should be used when configuring your own log4j appender. If this is done incorrectly, you could negatively impact the service that you are customizing the logging for. It is highly recommended you consult with Radiant Logic (support@radiantlogic.com) prior to modifying the default log4j configuration.

1. Make a backup of the existing Log4J configuration by navigating to the Main Control Panel -> ZooKeeper tab (requires [Expert Mode](#expert-mode)).
2. Browse to `/radiantone/<version>/<clusterName>/config/logging`.
3. Click Export on the right.
4. The ZooKeeper parent node should be `/radiantone/<version>/<clusterName>/config/logging`.
5. Enter a path to a directory to save the default log4j configuration and a file name.
    >[!note] This file can be imported on the ZooKeeper tab if you want to revert back to the default log4j configuration.
6. Click OK.

    ![An image showing ](Media/Image1.41.jpg)

    Figure 1. 41 : Exporting Default Log4J Configuration as a Backup

7. On the Zookeeper tab, navigate to the log4j configuration you want to configure your appender for. The service/tool and corresponding log4j configuration are described in the table above.
8. Click Edit Mode on the right and configure your appender.
9. Click Save.

### Control Panels - Delegated Administration Activity

Any user that can bind to RadiantOne can potentially administrator the server (if they belong to
the proper group). A user can belong to multiple groups. The following administration groups are
defined for RadiantOne:

- Directory Administrator Role
- Read Only Role
- Namespace Administrator Role
- Operator Role
- Schema Administrator Role
- ACI Administrator Role
- ICS Administrator Role
- ICS Operator Role

For details on the operations allowed for each user, please see the [RadiantOne System Administration Guide](/sys-admin-guide/01-introduction).

When any user that is a member of one of the above delegated administration groups saves changes in the Main or Server Control Panel, this activity is logged into:
<RLI_HOME>/vds_server/logs/jetty/web_access.log. This is a CSV formatted log file with the delimiter being TAB. To configure the log output for the Control Panel, navigate to the Main Control Panel > Settings tab > Logs > Log Settings section.

Select Control Panel – Access from the Log Settings to Configure drop-down list. Define the log level, rollover size and number of files to keep archived.

In the Advanced section (requires [Expert Mode](#expert-mode)), you can indicate the log file location/name (default is <RLI_HOME>/logs/jetty/web_access.log) and the archive location/name.

![An image showing ](Media/Image1.42.jpg)

Figure 1.42 : Main Control Panel Access Log Settings

For more fine-grained log configuration you must edit the configuration in ZooKeeper. From the Main Control Panel -> ZooKeeper tab (requires [Expert Mode](#expert-mode)), navigate to: `radiantone/<version>/<cluster_name>/config/logging/log4j2-control-panel.json` <br> Click the Edit Mode button on the right to make changes. Generally, these advanced settings should only be changed if advised by Radiant Logic.

### Cluster State

You can use <RLI_HOME>/bin/advanced/cluster.bat (.sh on Linux) with the list option to return a table of information about the cluster nodes. This includes the hostname, cloudID, RadiantOne Service status (ON/OFF), RadiantOne node leader status (true for the leader node.

False indicates that the node is a follower), ZooKeeper server ID, ZooKeeper server status (ON/OFF), ZooKeeper Server leader status (true for the ZooKeeper leader node. False for all non-leader nodes). An example is shown below for a 3-node cluster.

![An image showing ](Media/ClusterState.jpg)

To return just the table info, and avoid other logged output, pass RLI_CLI_VERBOSE=false before the command, like shown below.


C:\radiantone\vds\bin\advanced>set RLI_CLI_VERBOSE=false
C:\radiantone\vds\bin\advanced>cluster.bat list

On Linux, the command is:
[admin@localhost advanced]$ RLI_CLI_VERBOSE=false ./cluster.sh list

To get the result in JSON format, use:

C:\radiantone\vds\bin\advanced>set RLI_CLI_FORMAT=JSON
C:\radiantone\vds\bin\advanced>cluster.bat list

`{

"success" : true,

"data" : [ {

"Hostname" : "DOC-E1WIN1",

"CloudID" : "fbcd9ce3- 1648 - 43a5-bad4-4673f065814e",

"FIDServerStatus" : "ON",

"FIDServerLeader" : true,

"ZKServerId" : 1,

"ZKServerStatus" : "ON",

"ZKServerLeader" : false

}, {

"Hostname" : "DOC-E1WIN2",

"CloudID" : "32d06d7e-217a-4b8b-ade5-82fd281d5179",

"FIDServerStatus" : "ON",

"FIDServerLeader" : false,

"ZKServerId" : 3,

"ZKServerStatus" : "ON",

"ZKServerLeader" : true

}, {

"Hostname" : "DOC-E1WIN3",

"CloudID" : "2bddf61f-3e30-4e03-a845-10ee610f87cc",

"FIDServerStatus" : "ON",

"FIDServerLeader" : false,

"ZKServerId" : 2,

"ZKServerStatus" : "ON",

"ZKServerLeader" : false

} ]

}`

###  RadiantOne Memory, Connections, Connection Pools, and Processing Queues with a Search Against CN=MONITOR

Certain information available for monitoring RadiantOne can be reached with an LDAP search request to the cn=monitor naming context. Searching this naming context provides live access
to some memory structures in RadiantOne.

>[!warning] When deploying RadiantOne in a cluster, you will have to query the cn=monitor branch at each node (as the stats are specific per node).

#### Memory and Connection Usage

If you perform a base search on the cn=monitor node, the following “live” server information is
available:

- connection: < conn-id >:< startTime >:< indUser >:< client-ip >:< client-port >@< server-ip>:< server-port>:< op-count>

    For example:
9:20140902225743.020Z:cn=Directory
Manager:10.11.0.236:53376@10.11.12.164:2389:23

The above could be parsed as:
Connection number: 9
<br>Time the connection was established: 20140902225743.020Z
<br>Bind User associated with the connection: cn=Directory Manager
<br>Client IP address: 10.11.0.236
<br>Client Port: 53376
<br>RadiantOne IP address: 10.11.12.164
<br>RadiantOne LDAP Port: 2389
<br>Operation Count: 23

- connectionCount - the total (cumulative) number of connections established to
RadiantOne since last startup.
- connectionIdleTimeout – the value of the Idle Timeout property configured for
RadiantOne.
- connectionMax - the maximum concurrent connections allowed to RadiantOne.
- connectionPeak - the peak number of concurrent connections to RadiantOne since last startup.
- currentConnections - the live number of concurrent connections to RadiantOne (will never be more than connectionMax). This number increases or decreases depending on new connections coming into RadiantOne or existing connections being closed.
- cpuPeak - highest percentage of system CPU utilized since server startup.
- cpuUsed – current amount of system CPU utilized.
- currentTime – the current time on the machine hosting RadiantOne.
- diskPeak - the peak amount of machine disk space used (in bytes) since startup.
- diskTotal – total amount of machine disk space (in bytes) on the machine storage device.
- diskUsed – current amount of machine disk-space used (in bytes).
- lookThroughLimit – the value of the Look Through Limit property configured for RadiantOne.
- memAllocated – the total amount of memory allocated for the RadiantOne node.
- memMax – maximum amount of memory (Java heap size) configured for the instance.
- memUsed – the total amount of memory currently used by RadiantOne. This number fluctuates (as the server is running) depending on how much memory it needs to serve client requests and how fast the Garbage Collector (GC) can recycle the discarded resources.
- memPeak - the peak memory usage of RadiantOne since last startup.
- opCount – the total number of operations RadiantOne has processed on the connection.
    >[!note] The opCount for certain connections, used for internal operations, returns a value that is higher than the combined total of opCountAdd, opCountAbandon, opCountBind, opCountModify, opCountModifyDn, opCountCompare, and opCountDelete.
- opPeak – the peak (the longest duration) operation info.

    For example:
2014 - 09 - 02 16:39:44,120 --> conn=45 op=5 SEARCH REQUEST Duration=1050

The above could be parsed as:
<br>Operation Time: 2 014 - 09 - 02 16:39:44,120
<br>Connection number: 45
<br>Operation number: 5
<br>Type of operation: SEARCH REQUEST
<br>Length of operation to complete=1050 ms
<br>More information about the connection can be seen by navigating to cn=connection-
45,cn=monitor like shown below.

![An image showing ](Media/Image1.43.jpg)

Figure 1. 43 : Sample of Querying cn=monitor Branch in RadiantOne

- readOPS – read (search, bind, or compare) rate (op/s) during the last 5 seconds.
- sizeLimit – the value of the Size Limit property configured for RadiantOne.
- startTime – the timestamp when the RadiantOne service started.
- timeLimit – the value of the Time Limit property configured for RadiantOne.
- version – the version of RadiantOne.
- writeOPS - write (add, delete, or modify) rate (op/s) during the last 5 seconds.

There is also a script that can be run that returns statistics about the memory usage and
connection usage for RadiantOne. This script is in the <RLI_HOME>/bin/advanced directory
and is named checkvds. When this script is run, the default RadiantOne instance is queried
(cn=monitor branch) and the following statistics are returned: memAllocated, memMax,
connectionMax, memUsed, currentConnections, memPeak, and connectionPeak.

**Connection, Operation and Client Details**

The sample in the screen shot below shows that there are currently eight connections made to RadiantOne. Each entry represents a connection. The details pertaining to a specific connection can be seen when selecting a specific entry (see the LDAP Browser client below).

![An image showing ](Media/Image1.44.jpg)

Figure 1.44 : Example of Active Connection Information by Querying cn=monitor Branch

The value of opCount attribute indicates how many total operations have been performed by this connection.

>[!note] The opCount for certain connections, used for internal operations, returns a value that is higher than the combined total of opCountAdd, opCountAbandon, opCountBind, opCountModify, opCountModifyDn, opCountCompare, and opCountDelete.

The values for the following attributes indicate how many of each type of operation the connection has performed:

- opAdd ---- Add operations
- opModify ---- Modify operations
- opAbandon ---- Abandon operations
- opDelete ---- Delete operations
- opSearch ---- Search operations
- opCompare ---- Compare operations
- opBind ---- Bind operations

Details about which client opened the connection are described in the following attributes:

- clientPort
- clientIP
- startTime ---- when the client opened the connection
- bindDn ---- who the client authenticated with
- connectionID ---- unique identification allocated for the connection

Details about the server that the client connected to are detailed in the following attributes:

- serverPort
- serverIP

**Processing Activity of RadiantOne**

The processing activity of RadiantOne can be retrieved below the cn=processor,cn=monitor
container. Here you can retrieve the properties associated with the processing queues (the ones
seen from the Server Control Panel -> Usage & Activity tab -> Connections & Operations
section).

![An image showing ](Media/Image1.45.jpg)

Figure 1. 45 : Example of Processing Activity by Querying cn=monitor Branch

- opWaiting – operations waiting in the queue (waiting to be processed by RadiantOne).
- opExecuting – operations currently being executed by RadiantOne.
- threadPoolMaxSize – the value of the Max Concurrent Working Threads property configured for RadiantOne.
- threadPoolPeakSize – peak number of threads used by RadiantOne to process requests.

**Naming Context Activity**

The amount of activity per naming context can be retrieved by selecting the naming context
below cn=namings,cn=monitor. An example is shown below.

![An image showing ](Media/Image1.46.jpg)

Figure 1. 46 : Example of Processing Activity for a given Naming Context

The values for the following attributes indicate how many of each type of operation the naming context has received.

- add ---- Add operations
- modify ---- Modify operations
- modrdn ---- Modify RDN operations
- delete ---- Delete operations
- search ---- Search operations
- compare ---- Compare operations
- bind ---- Bind operations
- total ---- Total number of operations

**Connection Pools**

Connection pool statistics related to connections between RadiantOne and the backend data
sources are logged into the cn=conn-pools,cn=monitor branch. You can retrieve these statistics
by querying this branch from any LDAP client.

>[!note] The values of the attributes for backend connection pooling are read
only.

Below the cn=conn-pools container, you will see information on the internal connection pool (INTL), JNDI, LDAP and JDBC connections. The example below shows this information from the RadiantOne LDAP Browser.

![An image showing ](Media/Image1.47.jpg)

Figure 1.47: Example of Connecting Pooling Activity from the cn=monitor Branch

Details regarding the attributes available for each pool type are shown below.

**Internal Connection Pool Attributes**

Internal connection pooling is leveraged in scenarios where RadiantOne makes calls to itself. This can happen during authorization enforcement (e.g. checking group membership) or certain lookup functions used in an interception script.

![An image showing ](Media/Image1.48.jpg)

Figure 1.48: Example of Internal Connection Pool Activity

*Max_Pool_Size*: The maximum number of connections. When the number of connections reaches this value, further connections are refused.

*Idle_Timeout*: The length of time that a connection may remain idle before being removed from
the pool. A value of 0 (zero) means that the idle time is unlimited, so connections are never
timed out.

*Current_Num_Of_Pools*: Number of connections in the pool that are currently connected.

**JNDI Connection Pool Attributes**

JNDI connection pooling is leveraged for model-driven virtual views and join definitions from
directory backends.

![An image showing ](Media/Image1.49.jpg)
Figure 1.49: Example of JNDI Connection Pool Activity

*Current pool size (anonymous)*: Number of connections in the pool that are currently
connected using authentication type “none”.

*Preferred pool size*: This is the optimal pool size. Idle connections are removed when the number of connections grows larger than this value. A value of zero means that there is no
preferred size, so the number of idle connections is unlimited.

*Authentication types*: Only these authentication types are allowed to connect to the directory server.

*Current pool size (digest)*: Number of JNDI connections in the pool that are currently
connected using authentication type “digest”

*Protocol types*: Only these protocol types are allowed to connect to the directory server.

*Initial pool size*: Number of JNDI connections created when initially connecting to the pool.

*Current pool size (simple)*: Number of JNDI connections in the pool that are currently
connected using authentication type “simple”.

*Idle time out*: The length of time that a JNDI connection may remain idle before being removed
from the pool. A value of 0 (zero) means that the idle time is unlimited, so connections will never
be timed out.

*Maximum pool size*: The maximum number of JNDI connections. When the number of connections reaches this value, further connections are refused. A value of 0 (zero) means that
the number of connections is unlimited.

**LDAP Connection Pool Attributes**

LDAP connection pooling is leveraged for proxy views of directory backends.

![An image showing ](Media/Image1.50.jpg)

Figure 1. 50 : Example of LDAP Connection Pool Activity

*Connect_Timeout*: Number of seconds a request for a LDAP connection waits when there are
no connections available in the free pool and no new connections can be created.

*Max_Pool_Size*: The maximum number of LDAP connections. When the number of
connections reaches this value, further connections are refused.

*Idle_Timeout*: The length of time that an LDAP connection may remain idle before being
removed from the pool. A value of 0 (zero) means that the idle time is unlimited, so connections
are never timed out.

*Current_Num_Of_Pools*: Number of LDAP connections in the pool that are currently connected.

**JDBC Connection Pool Attributes**

JDBC connection pooling is leveraged for views from database backends.

![An image showing ](Media/Image1.51.jpg)
Figure 1. 51 : Example of JDBC Connection Pool Activity

*Max_Pool_Size*: The maximum number of JDBC connections allowed. When the number of
connections reaches this value, further connections are refused.

*Idle_Timeout*: The length of time that a JDBC connection may remain idle before being removed from the pool. A value of 0 (zero) means that the idle time is unlimited, so connections
are never timed out.

*Current_Num_Of_Pools*: Number of JDBC connections in the pool that are currently connected.


### RadiantOne Service Status and Responsiveness – Heartbeat Check

To check if the RadiantOne service is up and responding, it is recommended to issue a periodic
LDAP search request against cn=config. In the request, bind with any user that has permissions
(stored locally in RadiantOne Universal Directory) to read cn=config. This indicates that
RadiantOne is listening on the LDAP port and is able to respond to requests. The default
RadiantOne ports are 2389/636 (LDAP/LDAPS) although you define the port you want during
the RadiantOne install.

>[!warning] When deploying RadiantOne in a cluster, issue the heartbeat check against each node.

When RadiantOne runs as a service on Windows platforms, you can also use System Center Operations Manager (SCOM) to monitor it. On LINUX platforms, Nagios (or some other daemon
service monitor) can be used.

### RadiantOne Logs and Error Messages to Monitor

The most important logs and error messages to monitor for RadiantOne are:

<RLI_HOME>/vds_server/logs/vds_server_access.log

- SearchResult {resultCode=53
- VDS_Server is shutting-down [Connection to ZooKeeper lost.]
- !!! Server Busy -- Maxmium TCP/IP connection limit(1000) reached

<RLI_HOME>/vds_server/logs/vds_server.log

The following errors indicate the server is shutting down or unable to accept more connections.

- Server is shutting down: VDS stop command invoked.
- Error in accepting an incoming connection: java.io.IOException: Too many open files

The following errors can indicate users are connecting to the server and attempting to perform
operations they are not authorized to.

- ??? Error in binding: Failed in passing security check point: IP address where the
ROOT_USER connected from is not listed.
- SearchResult {resultCode=50

The following errors indicate memory problems.

- java.lang.OutOfMemoryError: unable to create new native thread
- java.lang.OutOfMemoryError: GC overhead limit exceeded
- Root exception is java.net.SocketException: Too many open files

The following error indicates problems with ZooKeeper.

- Server is shutting down: VDS has been configured to stop if the connection to ZK is
not writable any more.
- VDS_Server is shutting-down [Connection to ZooKeeper lost.]
- ConnectionStateListener: ZK connection is not writable any more.
- ZooKeeper session has been lost. [vds_server]

RadiantOne logging is configured from the Main Control Panel -> ZooKeeper tab (requires [Expert Mode](#expert-mode)). Navigate to /radiantone/<version>/<cluster_name>/config/logging/log4j2-vds.json and click EDIT MODE on the right.

### Periodic Persistent Cache Refresh Threshold Failures

To monitor periodic persistent cache refresh failures due to thresholds being reached, monitor
the <RLI_HOME>\vds_server\logs\periodiccache.log for keywords: “Threshold reached”

For example, assume a 50% Add Threshold has been configured and during the next refresh
cycle, there are 85% more entries in the backend than there are in the persistent cache image.
This persistent cache refresh is aborted, and the following message can be found in the
periodiccache.log.

2021 - 04 - 20T11:44:59,487 ERROR - [Storage Periodic Refresh - o=sql] Refresh failed:
java.lang.Exception: Threshold reached with 85% difference for adds.

In the example above, a periodic persistent cache refresh is configured on the o=sql naming context.

### ZooKeeper Status – Heartbeat Check

To check if ZooKeeper is up, it is recommended to check that ports 2181 (this is the ZooKeeper
connection string defined during install and is the port for the cluster), 2888 (communication port
between ZooKeeper servers in the ensemble), and 3888 (ZooKeeper election port) are open.
Ports 2888 and 3888 are only applicable if you are deployed in a Cluster (of three nodes
running ZooKeeper in an ensemble). If more than a port check is desired, third-party tools that
support JMX can be used. Contact Radiant Logic Support (support@radiantlogic.com) to
discuss this option.

### ZooKeeper Logs and Error Messages to Monitor

The most important log to monitor for ZooKeeper is
<RLI_HOME>/logs/zookeeper/zookeeper.log. The following are critical error messages to monitor in this log:

- ERROR [ConnectionStateManager-0:ZooManager@?] - Connection lost. (local zookeeper node no longer able to contact peers in ensemble)
- Non-optimial configuration, consider an odd number of servers.
- Could not add appenderMBean for [null]
- Unexpected exception causing shutdown while sock still open

### RadiantOne Activity – Check/Parse Access Log (CSV Format) Output

CSV logging is enabled in the Main Control Panel > Settings tab > Log > Access Logs settings. On the right, check the CSV option in Output format and click Save.

![An image showing ](Media/Image1.52.jpg)

Figure 1.52: Enabling CSV Log

For details on the columns in the CSV file, please see the [RadiantOne Logging and Troubleshooting Guide](/logging-and-troubleshooting-guide/01-overview).

### RadiantOne Activity – Read Changes from a Database Table

The RadiantOne service logs all access to data in the vds_server_access.log by default as long as the server log level is set to a minimum of ACCESS. This includes who accessed the data, when (day and time) and what operations they performed. This information can also be logged into a database which allows for third-party reporting tools to easily create meaningful charts and graphs for compliance analysis. Logging to a database requires the [CSV log format output](#radiantone-activity--checkparse-access-log-csv-format-output)
enabled and running the Log2DB utility.

The database that houses the table which contains the log contents can be in any database server you choose. These settings are located on the Main Control Panel > Settings Tab > Reporting section > Log2DB Settings sub-section. The database associated with the “Database Datasource” configured here must be running and accessible. To check which database this data source points to, navigate to the Main Control Panel -> Settings Tab -> Server Backend > DB Data Sources.

>[!note] The default settings leverage a Derby database that is included with RadiantOne and can be started with <RLI_HOME>/bin/DerbyServer.exe.

Once RadiantOne is configured to log to CSV and the database hosting the log contents is
running, launch the Log2DB utility which is in charge of reading the CSV contents and writing into your database table (table name configured in the Log2db Settings).

>[!warning] If RadiantOne is deployed in a cluster, the Log2DB utility must be running on each node.

Details about configuring and starting the Log2DB utility and the database columns (describing the log contents) can be found in the [RadiantOne Logging and Troubleshooting Guide](/logging-and-troubleshooting-guide/01-overview).

### Check/Parse Alert File (CSV Format) Output or Emails Generated from Alerts enabled in Main Control Panel 

Output options and configuration are described in [Alerts](/alerts-settings/#alerts).

### Legacy Monitoring Scripts

[Monitoring.bat](#monitoring-and-alerts-from-the-command-line) (monitoring.sh on Unix), consolidates the monitoring abilities of the legacy scripts: memoryMonitoring, ldapBackendMonitoring, connectionMonitoring, dbBackendMonitoring, checkDataSources, and diskSpaceMonitoring.

The legacy monitoring scripts can still be used and are in the <RLI_HOME>/bin/advanced directory. However, the default target log output for these scripts has changed (if you use -v true and want the output to log to a file) because the rli.log has been deprecated. Refer to the description of the -v argument for details.

These scripts must run on the same machine as the RadiantOne service. Each is described in more details below.

>[!warning] When deploying RadiantOne in a cluster, the scripts must run on each cluster node that you want to monitor.

**Memory Monitor**

The memoryMonitoring script is used to monitor the RadiantOne service memory usage.
Execute the command with? to find out more about the command. Below are the possible
parameters:

- n Name of the RadiantOne instance.
- i Poll Interval. How frequently to fetch the server statistics. Default is 30 seconds.
- t Percentage of memory reached -- when to start sending the alerts. Default is 90%.
- v Verbose settings -- true/false. Default is false. If this is set to true, the destination of the output is console by default. If you want the output to go to a file, it can be defined in the script prior to running it. To use the default log4j file configuration (defined in <RLI_HOME>/config/logging.log4j2-default-file), edit the script and add the following:
- Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json
- Drli.app.key=<myScriptFileName if you don’t want it to go to the target associated with log4j2-default-file>

An example is shown below:

```
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json -Drli.app.key=memoryMonitoring -Xmx512m -Djava.awt.headless=true -cp "${RLI_ALL_CP}" com.rli.tools.vdsadmin.status.util.MemoryMonitoringUtility "$@"
```

The log level must be set to INFO or higher for this verbose option to work.

The following parameters are not required if you are using the instance name with -n because
the value is retrieved from the instance’s vds_server.conf file (which is stored in ZooKeeper). If not using the -n property, then you must specify the following parameters.

- h RadiantOne host name to be monitored.
- p RadiantOne port to be monitored.
- D Super user DN.
- w Password for super user.
- s Use SSL to make the connection -- true/false. If both the regular LDAP port and the SSL port have been enabled, the regular LDAP port is used by default. If you want the SSL port to be used, you should use -s true in the command. If only the SSL port has been enabled, then it is used by default.

SMTP settings (if the following parameters are not specified, the values configured in the Main
Control Panel -> Settings Tab -> Monitoring -> Email Alerts Settings are used):

- H host name of SMTP server.
- P SMTP port number. Default is 25.
- S Use SSL to make SMTP connection -- true/false.
- U SMTP user name (to connect to the SMTP server).
- W SMTP password (to connect to the SMTP server).
- T To email address...where alerts are sent.
- F From email address.

There is an example of using this script below. The default RadiantOne instance is named
“vds_server”. This example assumes that Email Alerts Settings have been configured in the
Main Control Panel, since the SMTP settings are not specified in the command.

<RLI_HOME>/bin/advanced/memoryMonitoring.sh -n vds_server -i 60 -t 75

This example command polls RadiantOne every 60 seconds and sends an email if the memory
usage goes over 75% of the JVM allocated memory and when the memory usage goes back to normal.

**Connection Monitor**

The connectionMonitoring script is used to monitor if the number of active connections to the RadiantOne exceeds the defined threshold. Execute the command with? to find out more about the command. Below are the possible parameters:

- n Name of the RadiantOne instance.
- i Poll interval. How frequently to fetch the server statistics. Default is 30 seconds.
- t Percentage of connections reached -- when to start sending the alerts. Default is 90%.
- v Verbose settings -- true/false. Default is false. If this is set to true, the destination of the output is console by default. If you want the output to go to a file, it can be defined in the script prior to running it. To use the default log4j file configuration (defined in <RLI_HOME>/config/logging.log4j2-default-file), edit the script and add the following:
- Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json
- Drli.app.key=<myScriptFileName if you don’t want it to go to the target associated with log4j2-default-file>

An example is shown below:

```
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json -Drli.app.key=connectionMonitoring -Xmx512m -Djava.awt.headless=true -cp
"${RLI_ALL_CP}" com.rli.tools.vdsadmin.status.util.ConnectionMonitoringUtility "$@"
```

The log level must be set to INFO or higher for this verbose option to work.

The following parameter are not required if you are using the instance name with -n because the
value is retrieved from the instance’s vds_server.conf file. If not using the -n property, then you must specify the following parameter.

- h RadiantOne FID host name to be monitored.
- p RadiantOne FID port to be monitored.
- D Super user DN.
- w Password for super user.
- s Use SSL to make the connection -- true/false. If both the regular LDAP port and the SSL
port have been enabled, the regular LDAP port is used by default. If you want the SSL port to be
used, you should use -s true in the command. If only the SSL port has been enabled, then it is
used by default.

SMTP settings (if the following parameters are not specified, the values configured in the Main
Control Panel > Settings Tab > Monitoring > Email Alerts Settings are used):

- H host name of SMTP server.
- P SMTP port number. Default is 25.
- S Use SSL to make SMTP connection -- true/false.
- U SMTP user name (to connect to the SMTP server).
- W SMTP password (to connect to the SMTP server).
- T To email address...where alerts are sent.
- F From email address.

There is an example of using this script below. By default the RadiantOne instance created is named “vds_server”. This example assumes that Email Alerts Settings have been configured in
the Main Control Panel, since the SMTP settings are not specified in the command.

<RLI_HOME>/bin/advanced/connectionMonitoring.sh -n vds_server -i 60 -t 75

This example command polls RadiantOne every 60 seconds and sends an email if the number of connections goes over 75% of the maximum number of connections allowed to the RadiantOne instance and when the number of connections goes back under the threshold.

**RadiantOne LDAP Service and LDAP Backend Data Source Monitor**

The ldapBackendMonitoring script monitors availability of the RadiantOne LDAP service, or one
of the configured LDAP backends. Execute the command with? to find out more about the
command. Below are the possible parameters:

- n Name of the RadiantOne instance.
- i How frequently to check the backend connection. Default is 30 seconds.
- b List of backend IDs. Comma separated. ID is vds_ldap.backend.x.storage_name property from the vds_server.conf file.
- d A comma separated list of data source names that you want to monitor.
- h Host Name of RadiantOne (or specific LDAP backend) to monitor.
- p the RadiantOne service (or specific LDAP backend) port to monitor.
- D Bind DN of the server to monitor.
- w Bind password.
- s Use SSL to make the connection -- true/false.
- v Verbose settings -- true/false. Default is false. If this is set to true, the destination of the output is console by default. If you want the output to go to a file, it can be defined in the script prior to running it. To use the default log4j file configuration (defined in <RLI_HOME>/config/logging.log4j2-default-file), edit the script and add the following:
- Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json
- Drli.app.key=<myScriptFileName if you don’t want it to go to the target associated with log4j2-default-file>

An example is shown below:

```
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default- file.json -Drli.app.key=ldapBackendMonitoring -Xmx512m -Djava.awt.headless=true -cp "${RLI_ALL_CP}" com.rli.tools.vdsadmin.status.util.LDAPBackendMonitoringUtility "$@"
```

The log level must be set to INFO or higher for this verbose option to work.

SMTP settings (if the following parameters are not specified, the values configured in the Main
Control Panel -> Settings Tab -> Monitoring -> Email Alerts Settings are used):

- H host name of SMTP server.
- P SMTP port number. Default is 25.
- S Use SSL to make SMTP connection -- true/false.
- U SMTP user name (to connect to the SMTP server).
- W SMTP password (to connect to the SMTP server).
- T To email address...where alerts are sent.
- F From email address.

There is an example of using this script below. By default the data source associated with the
RadiantOne service is named “vds”. If you wanted to monitor a backend, you would use the
data source name associated with that backend (in the -d parameter). This example assumes
that Email Alerts Settings have been configured in the Main Control Panel, since the SMTP
settings are not specified in the command.

<RLI_HOME>/bin/advanced/ldapBackendMonitoring.sh -d vds -i 60

This example command polls the RadiantOne service every 60 seconds and sends an email if it
is down.

**Backend Database Data Source Monitor**

The dbBackendMonitoring script is used to monitor if one of the configured database backends
are available or not. Execute the command with? to find out more about the command. Below
are the possible parameters:

- n Name of the RadiantOne instance.
- i How frequently (in seconds) to check the backend connection. Default is 30 seconds.
- d A comma separated list of data source names that you want to monitor.
- v Verbose settings -- true/false. Default is false. If this is set to true, the destination of the output is console by default. If you want the output to go to a file, it can be defined in the script prior to running it. To use the default log4j file configuration (defined in <RLI_HOME>/config/logging.log4j2-default-file), edit the script and add the following:
- Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json
- Drli.app.key=<myScriptFileName if you don’t want it to go to the target associated with log4j2-default-file>

An example is shown below:

```
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json -Drli.app.key=dbBackendMonitoring -Xmx512m -Djava.awt.headless=true -cp "${RLI_ALL_CP}" com.rli.tools.vdsadmin.status.util.DBBackendMonitoringUtility "$@"
```

The log level must be set to INFO or higher for this verbose option to work.

SMTP settings (if the following parameters are not specified, the values configured in the Main
Control Panel > Settings Tab > Monitoring > Email Alerts Settings are used):

- H host name of SMTP server.
- P SMTP port number. Default is 25.
- S Use SSL to make SMTP connection -- true/false.
- U SMTP user name (to connect to the SMTP server).
- W SMTP password (to connect to the SMTP server).
- T To email address...where alerts are sent.
- F From email address.

There is an example of using this script below. Enter the name of the database backend data
source(s) in the -d parameter (comma separated list of there is more than one). This example
assumes that there are two database data sources that you want to monitor (oracle and sql) and that Email Alerts Settings have been configured in the Main Control Panel, since the SMTP settings are not specified in the command. These data sources are polled every 60 seconds and an alert is emailed if either of them is unavailable.

<RLI_HOME>/bin/advanced/dbBackendMonitoring.sh -d oracle,sql -i 60

**Data Source (Backends) Status**

The checkDataSources script is used to check the status of all data sources (or only the ones
listed in the command) and prints their status either to the console or a specified file. The status
is either “OK” (indicating that nothing was found to be wrong with accessing the data source) or
“FAILED [specific error]” (indicating that is something wrong with accessing the data source).
Execute the command with? to find out more about the command. Below are the possible
parameters:

- n Name of the RadiantOne instance. If this is not specified, the default instance is used.
- l List of data sources (comma separated) to be checked. If not specified, all data sources are checked.
- o Output file to store the status. If nothing is specified, the output is printed to the console.

There is an example of using this script below. The following command checks the status of data sources named sunone, ad, oracle, and sql_server and writes the status of each data source in mystatus.log (which will located in <RLI_HOME>/bin since it is the default path).

<RLI_HOME>/bin/advanced/checkdatasources.sh -l sunone, ad, oracle, sql_server -o mystatus.log

**Disk Space Monitor**

The diskSpaceMonitoring script is used to monitor the disk space by checking the available disk
space at every poll interval for a specific threshold. Once the threshold is reached the process
will send an email alert. The threshold is specified in % of disk space available. Below are the
possible parameters:

- i Poll interval. How frequently (in seconds) to check the disk space available. Default is 30 seconds. For disk space checking, 30 seconds is probably too short. Generally every 15- 30 minutes (or even longer) is more realistic.
- t Percentage of disk space used -- when to start sending the alerts. Default is 90%.
- v Verbose settings -- true/false. Default is false. If this is set to true, the destination of the output is console by default. If you want the output to go to a file, it can be defined in the script prior to running it. To use the default log4j file configuration (defined in <RLI_HOME>/config/logging.log4j2-default-file), edit the script and add the following:
- Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json
- Drli.app.key=<myScriptFileName if you don’t want it to go to the target associated with log4j2-default-file>

An example is shown below:

```
"${RLI_JHOME}/bin/java" -Dlog4j.configurationFile=$RLI_HOME/config/logging/log4j2-default-file.json -Drli.app.key=diskspaceMonitoring -Xmx512m -Djava.awt.headless=true -cp "${RLI_ALL_CP}" com.rli.tools.vdsadmin.status.util.DiskSpaceMonitoringUtility "$@"
```

The log level must be set to INFO or higher for this verbose option to work.

SMTP settings (if the following parameters are not specified, the values configured in the Main
Control Panel -> Settings Tab -> Monitoring -> Email Alerts Settings are used):

- H host name of SMTP server.
- P SMTP port number. Default is 25.
- S Use SSL to make SMTP connection -- true/false.
- U SMTP user name (to connect to the SMTP server).
- W SMTP password (to connect to the SMTP server).
- T To email address...where alerts are sent.
- F From email address.

There is an example of using this script below. The following command monitors the disk space
every 10 minutes and checks if the disk space is 90% full. If this threshold is met, an alert is emailed. This example assumes that Email Alerts Settings have been configured in the Main Control Panel, since the SMTP settings are not specified in the command

<RLI_HOME>/bin/advanced/diskspaceMonitoring.bat -i 600 -t 90

One of the tuning aspects of RadiantOne can involve disk space, which is affected by things like the log archiving strategy (which frees up disk space). It is recommended to track the statistics of the disk space for the first week of deploying RadiantOne in production to see how quickly
disk space is growing to adjust the environment accordingly (e.g. redirect log output to a bigger
disk, archive more frequently...etc.). To keep track of the statistics, run the diskspaceMonitoring script and redirect the output (using >) to a file.
<RLI_HOME>/bin/advanced/diskspaceMonitoring.bat -i 600 -t 90 > diskspacestats.txt

Once disk space usage has been assessed, kill the diskspaceMonitoring script and relaunch again without redirecting output to a file. At this time, you can also increase the checking interval.

## Manually Resetting Connection and Memory Peak

RadiantOne supports special LDAP commands to reset the memory and connection peaks without requiring the server to be restarted.

To reset these values, any LDAP client can be used. The examples below use an ldapsearch command line tool.

To reset the connection peak you can use the following (assuming RadiantOne is listening on
LDAP port 2389 and the super user password is “password”):

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" –b "action=resetconnectionpeak" (objectclass=*)

To reset the memory peak, you can use the following (assuming RadiantOne is listening on LDAP port 2389 and the super user password is “password”):

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" –b "action=resetmempeak" (objectclass=*)

>[!warning] If you manually reset the connection peak, the Server Control Panel > Dashboard tab associated with the node you’ve reset does not reflect the current connection peak. This value on the Server Control Panel dashboard only refreshes every 24 hours.

## Manually Resetting Connection Operation Statistics

RadiantOne supports a special LDAP command to reset the operation statistics for connections without requiring the server to be restarted.

To reset the operations statistics for connections, any LDAP client can be used. The example below uses an ldapsearch command line tool.

To reset the number of operations (opAbandon, opAdd, opBind, opCompare, opCount, opDelete, opModify, opModifyDn, and opSearch) for all current connections (assuming RadiantOne is listening on LDAP port 2389 and the super user password is “password”):

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" -b
“action=resetconncounters" (objectclass=*)

## Manually Resetting Operation Statistics for a given Naming Context without Restarting the RadiantOne Service 

RadiantOne supports a special LDAP command to reset the operation statistics for a given naming context without requiring the server to be restarted.

To reset the operations statistics for a given naming context, any LDAP client can be used. The example below uses an ldapsearch command line tool.

To reset the number of operations (compare, bind, modify, modrdn, delete, add and search) for a naming context of o=ad203 (assuming RadiantOne is listening on LDAP port 2389 and the super user password is “password”):

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" -b
"action=resetnamingctxcounters,o=ad203,cn=namings,cn=monitor" (objectclass=*)

## Manually Resetting Connection Pools without Restarting the RadiantOne Service

RadiantOne supports a special LDAP command to reset the connection pools without requiring the server to be restarted.

To reset the connection pools, any LDAP client can be used. The example below uses an
ldapsearch command line tool to clear the LDAP connection pool.

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" -b
“action=clearldappool" (objectclass=*)

The example below uses an ldapsearch command line tool to clear the Database (JDBC)
connection pool.

#ldapsearch -h host -p 2389 -D "cn=directory manager" -w "password" -b
“action=clearjdbcpool" (objectclass=*)
