---
title: Logging and Troubleshooting Guide
description: Logging and Troubleshooting Guide
---

# Chapter 5: Task Scheduler and Tasks

The Task Scheduler schedules tasks. Activities that are processed as tasks are: 

-	Exporting to LDIF

-	Importing from LDIF

-	Login analysis (initiated from the Global Identity Builder)

-	Initializing a persistent cache or RadiantOne Universal Directory (HDAP) store

-	Re-indexing a persistent cache or RadiantOne Universal Directory (HDAP) store

-	Default monitoring
There are two aspects of logging described in this section: 

-	The task scheduler itself 

-	The tasks themselves

## Scheduler Server

The task scheduler logging is configured from the Main Control Panel > Settings tab > Logs > Logs Settings section. Select the Scheduler – Scheduler Server option from the Log Settings to Configure drop-down menu.

![An image showing ](Media/Image6.1.jpg)

Figure 6. 1: Main Control Panel, Task Scheduler Log Settings

### Log Level

Select a log level from the drop-down list in the Log Settings section. For details on available log levels, see [Chapter 1](01-overview).

### Rollover Size

By default, the task scheduler log file rolls over once it reaches 100MB in size. Change this value if needed.

### Log Location

The task scheduler log file is server.log and can be viewed and downloaded from Server Control Panel > Log Viewer. 

### Log Archiving

By default, 10 files are kept in the archive. Change this value in the How Many Files to Keep in Archive setting. The archived files are named `server-<number>.log` and can be viewed and downloaded from the Server Control Panel > Log Viewer.

## Scheduled Tasks

Logging for scheduled tasks is configured from the Main Control Panel > Settings tab > Logs > Logs Settings section. Select the Scheduler – Scheduler Tasks option from the Log Settings to Configure drop-down menu.

![An image showing ](Media/Image6.2.jpg)

Figure 6.2: Main Control Panel, Scheduled Tasks Log Settings

### Log Level

Select a log level from the drop-down list in the Log Settings section. For details on available log levels, see [Chapter 1](01-overview).

### Rollover Size

By default, the task log file rolls over once it reaches 100MB in size. Change this value if needed.

### Log Location

The task log file is `task.<taskID>.log` and can be viewed and downloaded from the Server Control Panel > Log Viewer.

### Log Archiving

By default, 10 files are kept in the archive. Change this value in the How Many Files to Keep in Archive setting. The archived files are named `task.<taskID-<number>>.log` and can be viewed and downloaded from the Server Control Panel > Log Viewer. 

### Email Alert Task

Email Alert settings are configured from the Main Control Panel (associated with the leader node if deployed in a cluster) > Settings Tab > Monitoring section > Email Alerts Settings. These properties are saved in Zookeeper at `/radiantone/<version>/<cluster_name>/config/monitoring`.properties.

These settings can be reused in log4j logging configurations by using the following properties:

${rli:alert.email.recipients}
${rli:alert.email.from}
${rli:alert.email.protocol}
${rli:alert.email.smtp.host}
${rli:alert.email.smtp.port}
${rli:alert.email.smtp.user}
${rli:alert.email.smtp.password}
An example of using these properties in a log4j configuration is shown below for the log configuration of the scheduler.

![An image showing ](Media/Image6.4.jpg)
 
Figure 6.4: Example of Leveraging Email Alert Settings in Log4J Configurations
