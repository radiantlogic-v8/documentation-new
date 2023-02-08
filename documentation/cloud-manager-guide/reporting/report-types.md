---
keywords:
title: Types of Reports
description: Report types
---
# Types of Reports

**This page is a WIP**

Several types of reports can be generated to help monitor the activities and operations in Environment Operations Center.

Every time any application or client accesses the server, that data is logged anc captured in Elastic Search.

The reporting dashboards displayed in Environment Operation Center are a representation of the log monitoring user interface available in Kibana.

Logs can be searched or filtered for particular events or activities.

## Access reports

Data is pulled from the Access Logs to build access reports. Information provided by these logs includes client requests to RadiantOne and the response.

Info includes:
how long operations run and a summary of associated error codes.

- Types of operations - listed below
- Response time intervals - how long operations are taking to finish
- Response time thresholds - list operations that exceed a specified response time; measured against the specified maximum amount of time that a response should not exceed.
- Error codes - specify error codes of concern to track.

Operation settings tracked:

- connections
- bind: LDAP bind (authentication) requests received by RadiantOne.
- search: Search (base search, one level search, sub-tree search) requests received by RadiantOne.
- add: Add entry requests received by RadiantOne.
- modify: Update entry requests received by RadiantOne.
- compare: Compare requests received by RadiantOne.
- delete: Delete requests received by RadiantOne.

The response time interval, response time threshold, and error codes are reported for each type of operation listed above.

## Audit reports

Lists operations performed by a user including the number of times the type of operation was performed.

> **Note:** "If RadiantOne is deployed in a cluster, the default behavior of the Audit Report generator is to create a report for each node."

Audit reports provide a summary of all operations performed by a user during a specific session.

Session information, user details, operations performed by the user, total number of times each type of operation was performed.

Monitor which users are accessing the RadiantOne service, when, and what operations they perform.

Displays the following operations (same definitions as Access report operations):

- Connections by Host
- Operations Count across the entire cluster
- Result Codes per server
- Connections made by different users
- Add Requests
- Search Requests
- Modify Requests
- Bind Requests
- Delete

## Group Audit report

Similar metrics provided as the Audit Report, except the Group Audit Report organizes user activity by groups.

This report lists all operations performed, grouped by user, for a specific session.

## Next steps


