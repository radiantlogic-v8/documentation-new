---
title: Selecting a Custom Task Template
description: Learn how to select the right custom task template. 
---

## Multi-Node Behavior

When running Identity Data Management in a clustered environment (multiple nodes), it is important to understand how custom tasks behave across the cluster. The behavior depends on which base class your custom task extends:


### Run on all nodes (PerNodeCustomTask)

If your custom task extends `PerNodeCustomTask`, the task will execute independently on every node in the cluster. Each node runs its own instance of the task. This is useful for operations that need to happen locally on each node, such as clearing a local cache or writing to a node-specific log file.


### Run on one node (PerClusterCustomTask)

If your custom task extends `PerClusterCustomTask`, the task will execute on only one node in the cluster - the current leader node. All other nodes will skip the task. This is useful for operations that should only happen once across the entire cluster, such as updating shared data or triggering an external API call.


> **Note:** In both cases, the task is scheduled on every node. The difference is whether the task's logic actually executes on each node or only on the leader. You do not need to configure this behavior in the UI - it is determined by the base class you chose when writing the Java class.


## Selecting a Template

| Use Case | Template | Runs On |
|---|---|---|
| Node-local operation (eg: clearing a local file, restarting a local process) | PerNodeCustomTaskTemplate | All nodes |
| Shared operation that should only happen once (eg: syncing data, refreshing a cache) | PerClusterCustomTaskTemplate | Leader node only |


If you are running a single-node deployment, both options behave the same way - the task runs on the single node.