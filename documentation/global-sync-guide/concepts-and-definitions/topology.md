# Topology

The naming and graphical representation of a set of objects participating in a synchronization process is known as a topology. The synchronization flow(s) in a topology are grouped and depicted as pipelines. A topology can consist of one or more synchronization pipelines. Pipelines are auto-generated when the topology is created. You cannot manually create your own pipelines.

An example of a topology with a single auto-generated pipeline is shown below:

![An image showing an example of a topology with a single auto-generated pipeline](../media/image5.png)

Example Topology Containing a Single Pipeline

An example of a topology with multiple auto-generated pipelines is shown below:

![An image showing an example of a topology with multiple auto-generated pipelines](../media/image6.png)

Example Topology Containing Multiple Pipelines

## Pipeline ID

The pipeline ID is required for a variety of scenarios. A few examples are shown below.

- Replaying messages from a dead letter queue

`{RLI_HOME}/bin\>vdsconfig dl-replay-sync-pipeline -pipelineid {PIPELINE_ID}`

- Running an upload from command line:

`{RLI_HOME}/bin\>vdsconfig init-sync-pipeline -pipelineid {PIPELINE_ID}`

- Locating connector logs associated with the pipeline.

`{RLI_HOME}/logs/sync_agents/{PIPELINE_ID}/connector.log`

You can find the pipeline ID using the vdsconfig command line utility with the `list-topologies` command. The `"pipelinesIdentifiers"` property returns the pipeline ID. An example is shown below.

![An image showing a terminal application and the execution of the "vdsconfig list-topologies" command with the subsequent output](../media/image7.png)

Using Vdsconfig Utility to get a Pipeline ID

You can find the pipeline ID from the Main Control Panel -> Global Sync tab.

Select the topology and hover over the name property of the pipeline. An example is shown below.

![An image showing a pipeline ID triggered by a hover](../media/image8.png)

Using Main Control Panel -> Global Sync Tab to get a Pipeline ID
