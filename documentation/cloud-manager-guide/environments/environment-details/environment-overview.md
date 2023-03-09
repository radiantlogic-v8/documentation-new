---
keywords:
title: Environment Details
description: Components and navigation for an environment's detailed view
---

# Environment Details

Each environment has a detailed view where you can see further information about the environment, monitor its status, and perform various operations on the environment. This guide outlines the detailed view of an environment as seen in the environment *Overview* screen. For an overview of the *Environments* screen that lists all available environments, see the [environments overview guide](../environment-overview/environments-overview.md).

## Getting started

To navigate to the detailed view of an environment, select the environment name from the list of environments displayed on the *Environments* screen.

![image description](images/overview-select-env.png)

This brings you to the environment's *Overview* screen that displays a summary of the environment details and operation statuses. Further monitoring and updating tools for the environment are accessible from the navigation bar located at the top of the page.

![image description](images/overview-screen.png)

## Top navigation

A navigation bar is located at the top of the *Overview* screen and is visible from all tabs in the environment details view. The top navigation allows you to access several monitoring and updating tools through the following tabs:

- Overview
- Logs 
- Backups
- Configuration
- Activity Log

![image description](images/overview-topnav.png)

### Logs

The *Log* tab allows you to view an environment's log details, imported from Elastic.

For further details on reviewing environment logs, see the [Environment Logs](../logging/environment-logs.md) guide.

![image description](images/overview-log-tab.png)

### Backups

From the *Backups* tab, you can save a backup of the current environment configuration and view previous backups.

For information on managing your environment backups, refer to the [backup and restore documentation](../backup-and-restore/backup-restore-overview.md).

![image description](images/overview-backups-tab.png)

### Configuration

From the *Configuration* tab, you can view a chronological list of the configuration file import and export history for an environment. Configuration file import or export workflows can also be launched from this screen.

To learn how to import a configuration file, review the [import a configuration file](../environment-overview/import-configuration-file.md) guide. Or, for details on exporting a configuration file, review the [export a configuration file](export-configuration-file.md) guide.

![image description](images/overview-configuration-tab.png)

### Activity log

Under the *Activity Log*, you can view a list of all actions performed on an environment. Each action has a corresponding time and date stamp of when it was performed and the user who performed the action is also listed.

> **(RL QUESTION: Are the listed actions "clickable" or static? If they are "clickable", what is displayed when one is selected??)**

![image description](images/overvieew-activitylog-tab.png)

## Monitor environment

A **Monitor Environment** button is located near the top of the *Overview* screen. Select **Monitor Environment** to navigate to the monitoring section with the current environment selected.

For further details on monitoring environments, see the [monitoring](../../monitoring/monitoring-overview.md) guide.

![image description](images/overview-monitoring.png)

## Environment options

An expandable **Options** (**...**) menu is located next to the **Monitor Environment** button. Selecting the **Options** (**...**) dropdown menu displays the options to **Update** or **Delete** the environment.

To learn how to delete the environment, review the [delete environment](delete-environment.md) guide. For details on updating the environment, review the [update environment](update-environment.md) guide.

![image description](images/overview-options.png)

## Environment details

The *Environment Details* section outlines the environment name, scale, type, status and version number.

![image description](images/overview-env-details.png)

### Status

The environment status will change depending on the state of the environment. Statuses include:

- Operational: The environment is fully operational with 100% of services running.
- Warning: There are services down. This can range from 10%-90% of services.
- Outage: There are too many services down for the environment to operate. Less than 10% of services are running.

![image description](images/overview-envdetails-status.png)

### Version

If the environment version is out of date, an "Update Now" message appears next to the version number. 

For details on updating the environment, review the [update environment](update-environment.md) guide.

![image description](images/overview-updatenow.png)

You can view the environment's version history by selecting the **View Version History** button in the lower right corner of the *Environment Details* box. 

See the guide on [version history](version-history.md) for further details on reviewing and restoring an environment's previous versions.

![image description](images/overview-version-history.png)

## Endpoints

The *Application Endpoints* section lists all of the environment endpoints.

> **(RL Question: Are there further details that should be outlined in this section regarding Application Endpoints that would be helpful for a user to know?).**

![image description](images/overview-endpoints.png)

## Node monitoring

The lower section of the *Overview* page displays monitoring sections for the FID and Zookeeper nodes of an environment. For both FID and Zookeeper nodes, the status, CPU, memory, and disk space are provided for each node. The number of connections are listed for all FID nodes.

Node status will be listed as "Healthy", "Warning, or "Outage", indicating that the node is either operational, experiencing a partial outage, or experiencing a complete outage.

![image description](images/overview-node-monitoring.png)

CPU, memory, and disk are all displayed as color-coded percentages to indicate their health.

- Green: Indicates the component is operational.
- Yellow: Indicates the component has a partial outage.
- Red: Indicates a full outage.

![image description](images/overview-health-indicators.png)

An expandable **Options** (**...**) menu is available for each node. Selecting the **Options** dropdown menu displays the options to **View Details** or **View Logs** for the selected node. 

For further details on reviewing nodes details, see the [node details](node-details.md) guide.

![image description](images/overview-node-options.png)

## Alerts

Environment alerts display at the top of the Overview screen when warnings or outages occur. A maximum of three alerts display at a time in order of priority. If there are more than three alerts, each subsequent alert will display once a previous alert has been closed or resolved.

![image description](images/alerts.png)

You can hide an alert by selecting the "X" located in the alert message. If the issue has not been resolved, the alert notification will persist when you navigate back to the *Overview* screen.

![image description](images/alerts-close.png)

To view further details about the alert, select **View Alert Logs**. 

![image description](images/alerts-view-logs.png)

This brings you to the *Alerts* tab where you can review the alert details.

To learn more about managing environment alerts, see the [alert management guide](../../admin/alert-management/alert-management-overview.md).

![image description](images/alerts-tab.png)

## Next steps

After reading this guide you should be able to navigate the *Overview* screen of an environment and understand its main features including the top navigation, Environment Details, Application Endpoints, and Node Monitoring. For details on updating the environment, review the guide to [update an environment](update-environment.md).
