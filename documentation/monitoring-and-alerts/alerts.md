---
title: Standard Alerts
description: Configuring Standard Alerts in RadiantOne Identity Data Management Control Panel
---

## Alerts Overview

Standard (default) alerts associated with monitored activities are configured from the Classic Control Panel > Settings > Monitoring section and are tied to the Task Scheduler which must be running. 

Standard alerts cover the recommended minimum monitoring for the RadiantOne components and are pre-configured by default (except for the ones related to data source status).

For standard alerts, the default alert output is a file, but you can easily add email alerts to the configuration. When these alerts are activated, they are also displayed on the Classic Control Panel’s Dashboard tab.

### File Alert Settings

File output is used for all pre-configured standard alerts. The alerts are logged in a CSV formatted file named alerts.log. This log can be viewed and downloaded from Classic Control Panel > Server Control Panel > Log Viewer.

![Alert Log](Media/alert-log.jpg)

## RadiantOne Service Memory Usage

A [file alert](#file-alert-settings), when the RadiantOne service’s memory usage reaches 90%, is enabled by default.

These settings can be changed from the Classic Control Panel > Settings tab > Monitoring section > Standard Alerts. To change the memory threshold, slide the bar in the Memory section to the needed amount. Define the interval to check the memory (default is 120 seconds).

The default alert output is File Alert, but if SMTP settings are configured in the Monitoring > Email Alert Settings section you can also use the Email Alert output. Click the Save button when you are finished making changes.

## Connections to RadiantOne

A [file alert](#file-alert-settings), when the number of connections to RadiantOne reaches 800 is enabled by default.

These settings can be changed from the Classic Control Panel -> Settings tab -> Monitoring section -> Standard Alerts. To change the connection threshold, slide the bar in the Connections section to the needed amount. Define the interval to check the connections (default is 120 seconds). The default alert output is File Alert, but if SMTP settings are configured in the Monitoring > Email Alert Settings section you can also use the Email Alert output. Click Save when you are finished making changes.

## Data Source Availability

An alert can be triggered when the availability of a backend data source changes. If the data source has failover servers configured, the alert would only be triggered if all servers were unavailable (alert would be in a triggered state), or in a scenario where all servers were unavailable and then one or more of the servers comes back online (an alert would be issued indicating the availability is back to normal). The setting can be changed from the Classic Control Panel > Settings tab > Monitoring section > Standard Alerts. Define the interval to check the data source availability (default is 120 seconds). The default alert output is File Alert, but if SMTP settings are configured in the Monitoring > Email Alert Settings section you can also use the Email Alert output. To enable alerts for data source availability, check the “Alert when a data source is disconnected” option and select the Data Sources to Monitor from the drop-down list. Click Save when you are finished.

## Disk Usage

A file alert, when the disk usage on the RadiantOne machine reaches 90% of max capacity, is enabled by default. These settings can be changed from the Classic Control Panel > Settings tab > Monitoring section > Standard Alerts. To change the disk usage, enter a threshold. Define the interval to check the data usage (default is 120 seconds). The default alert output is File Alert, but if SMTP settings are configured in the Monitoring > Email Alert Settings section you can also use the Email Alert output. Click the Save button when you are finished.

>[!warning] Closely monitoring disk space usage is extremely critical. If disk space is full, the RadiantOne service shuts down automatically.

## Disk Latency

A file alert, when the disk latency on the RadiantOne machine reaches 100ms, is enabled by default. These settings can be changed from the Classic Control Panel > Settings tab > Monitoring section > Standard Alerts. To change the disk latency, enter a threshold (in milliseconds). Define the interval to check the disk latency (default is 120 seconds). The default alert output is File Alert, but if SMTP settings are configured in the Monitoring > Email Alert Settings section you can also check the Email Alert output. Click the Save button when you are finished making changes.

## Processing Load on RadiantOne

Alerts based on RadiantOne processing load are pre-configured, but not enabled by default. If you would like to receive an alert when the RadiantOne processing queues reach a certain threshold, from the Classic Control Panel > Settings tab > Monitoring section > Standard Alerts, slide the bars for processing queues and internal queues to the threshold amount. Check the “Enable processing queues alerts” option. Click Save when you are finished.

