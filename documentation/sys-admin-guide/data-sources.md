---
title: Data Sources
description: Details about where to configure data sources.
---

# Data Sources

A data source in RadiantOne represents the connection to a backend. Data sources can be managed from the Main Control Panel > Settings Tab > Server Backend section. Configuring connections to all backends from a central location simplifies the management task when changes to the backend are required. For more details on data sources, please see [Concepts](concepts).

>[!note] Data sources can also be managed from the command line using the RadiantOne command line config utility. Details on this utility can be found in the [Radiantone Command Line Configuration Guide](/command-line-configuration-guide/01-introduction).

## Status

Each data source has a status associated with it. The status is either Active or Offline and can be changed as needed. If a backend server is known to be down/unavailable, setting the status to Offline can prevent undesirable performance impact to views associated with this backend. When a data source status is set to Offline, all views associated with this data source are not accessed to avoid the performance problems resulting from RadiantOne having to wait for a response from the backend before being able to process the client’s query. To change the status for a data source, navigate to the Main Control Panel -> Settings Tab -> Server Back End section. Select the section associated with the type of data source that is known to be unavailable (e.g. LDAP Data Sources, Database Data Sources or Custom Data Sources). On the right side, select the data source representing the backend that is down and click Edit. Locate the status drop-down list and choose Offline. Save the change.

>[!note] When a data source is set as Offline, RadiantOne does not try to access the primary backend nor any failover servers configured in the data source.
