---
keywords:
title: Environment Logs
description: Reviewing environment logs
---
# Environment Logs

This guide outlines the steps to review logs for a specific environment. Log files let you monitor activities and troubleshoot errors in your environments. They outline the event description, a date and time stamp of when the event occurred, and the email of the user who triggered the event. The information contained in these logs is helpful if you require assistance from Radiant Logic Support to troubleshoot problems if they arise.

Environment Operations Center is connected to Elastic and displays the Elastic monitoring user interface directly within the Env Ops Center logging tab. This allows you to review environment logs directly in Env Ops Center without having to navigate away from the application.

[!note] For further details on specific log types and the data they provide, see the RadiantOne logging and troubleshooting guide (**link to the guide when it is available**).

## Getting started

To navigate to the *Logs* screen for a specific environment, select **Logs** from the top navigation in the environment's detailed view.

![image description](images/select-logs.png)

There are two dropdown menus located at the top of the *Logs* screen. The first is the **Log File** dropdown and the second is the **Date Range** dropdown.

[!note] A warning message will display on the *Logs* screen notifying you that a log file must be selected before any log data can be displayed.

![image description](images/logs-home.png)

## Review environment logs

To view a specific log for the environment, select the log file you would like to review from the **Log File** dropdown list.

![image description](images/logfile-dropdown.png)

This displays the log details that have been pulled in from Elastic for the selected log file.

![image description](images/log-details.png)

You can refine the logs to only display log details for a period of time. To refine logs for a selected period of time, select a date range from the **Date Range** dropdown menu.

![image description](images/daterange-dropdown.png)

## Next steps

After reviewing this guide you should have an understanding of the steps required to review the log files of a specific environment. To learn more about backing up an environment, see the environment [backup and restore](../backup-and-restore/backup-restore-overview.md) documentation.
