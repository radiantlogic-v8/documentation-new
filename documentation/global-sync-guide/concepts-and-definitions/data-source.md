---
title: Data source
description: Data source
---

# Data source

A data source represents the connection to a backend which plays the role of either a source or target endpoint for synchronization. LDAP data sources that have been defined are contained in `{RLI_HOME}/{INSTANCE_NAME}/datasources/ldap.xml`. Database data sources are contained in `{RLI_HOME}/{INSTANCE_NAME}/datasources/database.xml`. Connections to custom backends are contained in `{RLI_HOME}/{INSTANCE_NAME}/datasources/custom.xml`.

>[!note]
>When deploying RadiantOne in a cluster, the configured data sources are managed/stored in ZooKeeper and shared across all cluster nodes. In other words, RadiantOne data sources created on one cluster node are accessible and used by all other nodes.
