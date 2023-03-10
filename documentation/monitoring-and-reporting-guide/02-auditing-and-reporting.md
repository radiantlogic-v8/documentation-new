---
title: Monitoring and Reporting Guide
description: Monitoring and Reporting Guide
---

# Chapter 2: Auditing and Reporting

Reports are a key tool for monitoring the health of the RadiantOne service and should be
generated frequently to understand the performance and load on the server and audit the activity (who is doing what and when). RadiantOne includes three default types of basic reports: Access, Audit and Group Audit. Details on these reports can be found in the Environment Operations Center Guide.

## Recommendations for Auditing and Reporting

There are four recommendations for auditing and reporting:

- To analyze/debug a problem
- To periodically monitor the health of the RadiantOne service
- To audit client activity of RadiantOne (who is connecting, doing what, and when)

### Analyzing Problems

If consumers of the RadiantOne service are experiencing problems (time-consuming logins, expected information not being returned...etc.), the access report can be helpful in pinpointing what is happening on the server and diagnosing the problem.

<!-->

The instructions in this section assume the following:

- The RadiantOne server log level has been set to a minimum of Info.
- The access log content is relevant (captures the period of time where consumers are seeing issues).
- All operations are configured to be included in the report.
- RadiantOne is configured to log to CSV (on the Settings Tab > Logs section > Server Logs, make sure the CSV Output format option is checked on the right side).

#### Starting the Log to Database Utility

The Log2DB settings can be managed from the Main Control Panel > Settings Tab > Reporting Section > Log2DB Settings sub-section.

After confirming the proper configuration, start the Log2DB Utility. On Windows platforms,
execute <RLI_HOME>/bin/runAccessLog2DB.bat <path to AccessLog2DBconfig.properties
file>. On UNIX platforms, execute runAccessLog2DB.sh <path to
AccessLog2DBconfig.properties file>. The AccessLog2DBconfig.properties file is in
<RLI_HOME>/config/log2db.

The Log2DB utility writes the access log information into a database. After, generate the Access Report from the Main Control Panel -> Settings Tab -> Reporting section -> Access Log Report sub-section. On the right side, click on the Generate Report button. The report can be found in the location indicated in the Output Location parameter which is <RLI_HOME>/reporting-birt/reports by default. If RadiantOne is deployed in a cluster, you can generate a single report that aggregates statistics from all nodes in the cluster. For more information on configuring and generating an Access Log report, see [Access Log Report Settings](#access-log-report-settings) and [Access Log Report](#access-log-report).

The summary section provides you with valuable information regarding how long operations are
taking and a summary of error codes found. In the detailed section of the report, you will find
specific entries from the log that match either a certain error code and/or exceed a response
time threshold. This information can be the starting point for further investigation and pinpoints
the location in the access log (by searching for the exact connection and operation numbers
associated with a specific operation) where the issue occurred. Sometimes, examining the
activity prior to an error can help in determining the cause of a problem.

-->

### Monitoring the Health of the RadiantOne Service

It is typically recommended to monitor the health of the RadiantOne service over a one week period at least once a month. Pay close attention to the configured access log rotation schedule to ensure no log content is missed (if applicable for your reports). The access log can be configured to roll over based on a configured size.

At the end of the reporting period, you can generate the Access Report from the Environment Operations Center.

### Auditing RadiantOne Configuration Changes

To log configuration changes made through command line, using the vdsconfig utility, enable
config logging with the following steps:


>[!warning] these steps require downtime since all services must be stopped. If RadiantOne is deployed in a cluster, perform the following steps on each node.

1. Stop all RadiantOne services including ZooKeeper.
2. Edit <RLI_HOME>\config\advanced\features.properties and set:
    vdsconfig.logging.enabled=true
3. Restart ZooKeeper.
4. Restart all needed RadiantOne services.

Configuration changes are logged in: <RLI_HOME>/logs/vdsconfig.log

### Auditing RadiantOne Client Activity

It is typically recommended to audit RadiantOne client activity over a one-week period at least once a month.

Pay close attention to the configured access log rotation schedule to ensure no log content is missed (if applicable for your reports). The access log may be configured to roll over based on a
configured size.

You can generate the Audit Report from the Environment Operations Center. 

>[!warning] you can also audit user activity and have the report sorted by groups. The [Group Audit Report](#group-audit-report) is similar in output to the Audit Report. The only difference being the report categorizes user activity based on groups.

