---
keywords:
title: Monitoring 
description: Monitoring
---
# Monitoring

From the *Monitoring* screen, you can review the status and health of various RadiantOne components for each server. This guide provides an overview of the *Monitoring* section in Environment Operations Center and its features.

[!warning] Monitoring is a crucial step in maintaining the health of RadiantOne and it is recommended that you monitor these components on a regular basis.

## Getting started

To navigate to the *Monitoring* screen, select **Monitoring** (![image description](images/monitoring-icon.png)) from the left navigation.

![image description](images/overview-select-monitoring.png)

## Monitor an environment

To generate monitoring metrics, an environment and at least one node must be selected.

To set the environment, select an environment from the **Environment** dropdown.

![image description](images/overview-select-env.png)

Select at least one node from the **Node** dropdown. 

![image description](images/overview-select-node.png)

If you would like to monitor more than one node, continue selecting all required nodes and then collapse the **Node** dropdown. The monitoring dashboard will update to display the component metrics for all nodes selected.

![image description](images/overview-multiple-nodes.png)

To remove a node, select the "X" associated with the node name.

![image description](images/overview-remove-node.png)

### Filter data by time range

You can filter monitoring data by time range, allowing you to narrow down the targeted data to a specific time frame.

To filter by time, select a range from the **Time Range** dropdown.

![image description](images/overview-time-range.png)

## Monitoring components

The monitoring dashboard displays several node component metrics, allowing you to monitor the health of RadiantOne servers.

Component metrics displayed include (**these have been pulled from existing guides, discussions with RL, and wire frames - need to be reviewed/confirmed by RL team**):

| Component | Definition |
|--------|------------|
| CPU Used | Current CPU usage of the machine hosting RadiantOne. |
| RAM Usage | Current RadiantOne service memory usage. |
| Disk Used | Current disk usage of the drive on the machine hosting RadiantOne. |
| Version | Current version of RadiantOne installed on the node. |
| Server Current | Details about the server you connected to. |
| FID Pool | The number of connections in a pool organized by anonymous, digest, and simple. |
| Up Time | How long the RadiantOne service has been running on the node. |
| Operations Count | How many operations have ben performed on the connection. |
| Live Connections | How many connections are currently live. |
| Ops | The type and number of operations performed. |
| Peak Stats | Peak statistics for various components, such as CPU, Connections, Memory, and Disk. |
| CPU Usage | A line graph that charts CPU usage over time. |
| RAM Usage | A line graph that charts RAM usage over time. |

## Next steps

After reading this guide you should have an understanding of how to generate metrics to monitor environment nodes. For details on reviewing RadiantOne operation and activity reports, see the [reporting](../reporting/reporting-overview.md) guide.
