---
title: ZooKeeper Install Guide
description: ZooKeeper Install Guide
---

## Testing a ZooKeeper Cluster

Once the Zookeeper ensemble and RadiantOne FID nodes are installed, you can test access to the ZooKeeper cluster.

To test a Zookeeper cluster:

1. On a machine that is running RadiantOne FID, open a Command Processor.
1. At the command line, navigate to <RLI_HOME>\bin\advanced. With a default RadiantOne FID installation, this location would be as follows (on Windows).

    `c:\radiantone\vds\bin\advanced`

3. Run the following command.

    `cluster.bat check`

If Zookeeper is functional on all nodes, “SUCCESS” messages similar to the following are displayed.

![An image showing ](Media/ZKImage4.1.jpg)

Figure 1: A Cluster Check with All Nodes Online

In the following image, one Zookeeper node has gone offline. In this example, RadiantOne nodes are unable to connect to the Zookeeper node at 10.11.10.39.

![An image showing ](Media/ZKImage4.2.jpg)

Figure 2: A Cluster Check with One Node Offline

In the following image, two Zookeeper nodes have gone offline. If the ZooKeeper ensemble only had three nodes to begin with, the loss of two nodes puts the service in a non-functional state since the quorum has been lost. The RadiantOne nodes are impacted at this point and will enter into a read-only mode where they cannot accept configuration changes nor client write operations.

>[!note] As an alternative to the default read-only mode, ZooKeeper can be configured for SHUTDOWN mode when the quorum is lost. In this case, the RadiantOne service on all cluster nodes shuts down. If this behavior is preferable, set "onZkWriteLossVdsServerBehavior" : "SHUTDOWN", for the /radiantone/v1/cluster/config/vds_server.conf node on the Main Control Panel > ZooKeeper tab. For more information, see the [RadiantOne Deployment and Tuning Guide](/deployment-and-tuning-guide/00-preface).

![An image showing ](Media/ZKImage4.3.jpg)

Figure 3: A Cluster Check with Two Nodes Offline
