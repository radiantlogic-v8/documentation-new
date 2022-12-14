---
title: ZooKeeper Install Guide
description: ZooKeeper Install Guide
---

# Chapter 4: Testing a ZooKeeper Cluster

Once the Zookeeper ensemble and RadiantOne FID nodes are installed, you can test access to the ZooKeeper cluster.

To test a Zookeeper cluster:

1. On a machine that is running RadiantOne FID, open a Command Processor.
2. At the command line, navigate to <RLI_HOME>\bin\advanced. With a default RadiantOne FID installation, this location would be as follows (on Windows).

```
    c:\radiantone\vds\bin\advanced
```

3. Run the following command.

```
    cluster.bat check
```

If Zookeeper is functional on all nodes, “SUCCESS” messages similar to the following are displayed.

![An image showing ](Media/Image4.1.jpg)

Figure 4. 1 : A Cluster Check with All Nodes Online

In the following image, one Zookeeper node has gone offline. In this example, RadiantOne nodes are unable to connect to the Zookeeper node at 10.11.10.39.

![An image showing ](Media/Image4.2.jpg)

Figure 4. 2 : A Cluster Check with One Node Offline

In the following image, two Zookeeper nodes have gone offline. If the ZooKeeper ensemble only had three nodes to begin with, the loss of two nodes puts the service in a non-functional state since the quorum has been lost. The RadiantOne nodes are impacted at this point and will enter
into a read-only mode where they cannot accept configuration changes nor client write operations.

>**Note - As an alternative to the default read-only mode, ZooKeeper can be configured for SHUTDOWN mode when the quorum is lost. In this case, the RadiantOne service on all cluster nodes shuts down. If this behavior is preferable, set "onZkWriteLossVdsServerBehavior" : "SHUTDOWN", for the
/radiantone/v1/cluster/config/vds_server.conf node on the Main Control Panel > ZooKeeper tab. For more information, see the RadiantOne Deployment and Tuning Guide.**

![An image showing ](Media/Image4.3.jpg)

Figure 4. 3 : A Cluster Check with Two Nodes Offline

### Configuring ZooKeeper to Startup as a Service

Use the native operating system utilities (Task Scheduler or Linux Daemons) to configure the
ZooKeeper service on each node in the ensemble so that it starts up automatically after reboot.
The script to start ZooKeeper is <ZooKeeper_HOME>\bin\start_zookeeper.bat/.sh.

Scripts to install ZooKeeper as a service can be found here:

https://dl.radiantlogic.com/Global/Installers/<RadiantOne_Version>/ScriptsToInstallZKService.zi
p

If you need credentials for accessing the download site, contact support@radiantlogic.com.


