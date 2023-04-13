---
keywords:
title: Types of Reports
description: Learn about Access Reports available in Environment Operations Center that can be used to monitor activities and the overall health of your environments.
---
# Types of Reports

This guide outlines the types of reports available in Environment Operations Center for you to monitor activities and the overall health of your environments. Only Access Log Reports are currently available in Env Ops Center. Additional report types will be added in future releases.

The reporting dashboards displayed in Environment Operation Center are a representation of the Kibana log monitoring user interface available. Every time any application or client accesses the server, that data is captured in log files available through Elastic Search. Logs can be searched or filtered in Env Ops Center for particular events or activities.

## Access reports

Data is pulled from the Access Logs to build access reports. Information provided by these logs includes client requests to RadiantOne and the responses. The report outlines how long operations run and provides a summary of associated error codes.

### Operation types

The types of operations included in Access Reports are:

- connections:
- bind: LDAP bind (authentication) requests received by RadiantOne.
- search: Search (base search, one level search, sub-tree search) requests received by RadiantOne.
- add: Add entry requests received by RadiantOne.
- modify: Update entry requests received by RadiantOne.
- compare: Compare requests received by RadiantOne.
- delete: Delete requests received by RadiantOne.

### Standard report details

The Access Report lists the following details for all operation types:

- response time interval: how long the operation took to complete (in milliseconds)
- response time threshold: any operation that exceeds a specified response time.
- error codes: specified error codes to track
- date: 
- session ID
- connection ID
- operation ID

### Unique report details

Details that are unique to each operation type include:

| Operation | Details |
| --------- | ------- |
| Bind | Bind DN (user the operation was issued by). |
| Base Search | Base DN (entry that was searched for) and the filter. |
| One Level Search | Base DN (entry where the one level search started from) and the filter. |
| Sub Tree Search | Base DN (entry where the sub tree search started from) and the filter. |
| Add | The Entry (DN) to be added. |
| Modify | The object (entry to be modified) and the modification details. |
| Delete | The Entry (DN) to be deleted. |
| Compare | Information about the compare operation. |

## Next steps

You should now have an understanding of the types of reports available in Environment Operations Center and the activity data they provide. For further information on accessing reports, see the [reporting overview](reporting-overview.md) guide.
