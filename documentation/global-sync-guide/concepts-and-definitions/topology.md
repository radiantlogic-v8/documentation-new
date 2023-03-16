---
title: Topology
description: Topology
---

# Topology

The naming and graphical representation of a set of objects participating in a synchronization process is known as a topology. The synchronization flow(s) in a topology are grouped and depicted as pipelines. A topology can consist of one or more synchronization pipelines. Pipelines are auto-generated when the topology is created. You cannot manually create your own pipelines.

An example of a topology with a single auto-generated pipeline is shown below:

![An example of a topology with a single auto-generated pipeline](../media/image5.png)

An example of a topology with multiple auto-generated pipelines is shown below:

![An example of a topology with multiple auto-generated pipelines](../media/image6.png)

## Pipeline ID

The pipeline ID is required for a variety of scenarios. A few examples are shown below.

| Example | Description |
|---|---|
| `https://<rli_server_name>/adap/util?action=vdsconfig&commandname=dl-replay-sync-pipeline&pipelineid=<PIPELINE_ID>` | REST command for replaying messages from a dead letter queue. |
| `https://<rli_server_name>/adap/util?action=vdsconfig&commandname=init-sync-pipeline&pipelineid=<PIPELINE_ID>` | REST command for running an upload from command line. |
| `<PIPELINE_ID>/connector.log` | Locating connector logs associated with the pipeline. You can view and download the connector log from the Environment Operations Center. |

You can find the pipeline ID from the Main Control Panel > Global Sync tab.

Select the topology and hover over the name property of the pipeline. An example is shown below.

![A pipeline ID triggered by a hover](../media/image8.png)
