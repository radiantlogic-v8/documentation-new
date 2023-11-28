---
title: Auditing and Reporting
description: Auditing and Reporting
---

## Auditing and Reporting Overview

Reports are a key tool for monitoring the health of the RadiantOne service and should be
generated frequently to understand the performance and load on the server and audit the activity (who is doing what and when). RadiantOne includes three default types of basic reports: Access, Audit and Group Audit. Details on these reports can be found in the 
[Environment Operations Center](/environment-operations-center-guide/reporting/reporting-overview/).

## Recommendations for Auditing and Reporting

There are three recommendations for auditing and reporting:

- To analyze/debug a problem
- To periodically monitor the health of the RadiantOne service
- To audit client activity of RadiantOne (who is connecting, doing what, and when)

The following sections describe each recommendation in more details.

### Analyzing Problems

If consumers of the RadiantOne service are experiencing problems (time-consuming logins, expected information not being returned...etc.), the access report can be helpful in pinpointing what is happening on the server and diagnosing the problem.

### Monitoring the Health of the RadiantOne Service

It is typically recommended to monitor the health of the RadiantOne service over a one week period at least once a month. Pay close attention to the configured access log rotation schedule to ensure no log content is missed (if applicable for your reports). The access log can be configured to roll over based on a configured size.

At the end of the reporting period, you can generate the Access Report from the [Environment Operations Center](/environment-operations-center-guide/reporting/reporting-overview/).


### Auditing RadiantOne Client Activity

It is typically recommended to audit RadiantOne client activity over a one-week period at least once a month.

Pay close attention to the configured access log rotation schedule to ensure no log content is missed (if applicable for your reports). The access log may be configured to roll over based on a configured size.

You can generate the Audit Report from the [Environment Operations Center](/environment-operations-center-guide/reporting/reporting-overview/).
