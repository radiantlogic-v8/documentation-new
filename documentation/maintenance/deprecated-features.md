---
title: Deprecated and Removed Features
description: Learn which RadiantOne Identity Data Management features are deprecated or removed, and what to do before you upgrade.
---

## Overview

This page lists the RadiantOne Identity Data Management features that are deprecated or have been removed. Review it when you plan an upgrade.

- Deprecated features still work in the current release, but they are no longer recommended and will be removed in a future release. Plan to stop using them.
- Removed features are no longer available.

For the changes made in a specific release, see the [v9 Release Notes](release-notes/release-notes).

## Deprecated Features

| Feature | Deprecated in | Details |
| :--- | :--- | :--- |
| Cluster monitor store (`cn=clustermonitor`) and the Server Control Panel Dashboard graphs that use its data | v9.1.0 | See [Cluster Monitor Store](#cluster-monitor-store). |


### Cluster Monitor Store

The cluster monitor store (`cn=clustermonitor`) collects the data used by the Server Control Panel Dashboard history graphs. While it is enabled, the leader node polls the admin port of every node in the cluster every few seconds, which has caused stability issues in production clusters. Disable it unless you need the Server Control Panel history graphs.

The following are deprecated:

- The cluster monitor store and the **Clustermonitor** setting in the Classic Control Panel.
- The Server Control Panel Dashboard graphs that use the cluster monitor data.
- The `/cluster_monitor` REST endpoints. 

**If the cluster monitor store is enabled in your environment:**

The **Clustermonitor** setting is still shown under Classic Control Panel > **Settings** > **Logs**, with a deprecation warning, so that you can turn the store off without configuring it from the command line. At startup, RadiantOne also logs a deprecation warning in `vds_server.log`.

To turn off the cluster monitor store:

1. In the Classic Control Panel, go to **Settings** > **Logs** > **Clustermonitor**.
2. Select **Disabled**.
3. Click **Save**.

>[!warning] After you turn off the cluster monitor store, the **Clustermonitor** setting is no longer shown, and you can't turn the store back on from the Control Panel.

**If the cluster monitor store is not enabled:**

The **Clustermonitor** setting is not shown in the Classic Control Panel, and the Server Control Panel opens on **Usage & Activity** instead of the Dashboard. No action is needed.

