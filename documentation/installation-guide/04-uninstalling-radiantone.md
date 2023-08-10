---
title: Installation Guide
description: Installation Guide
---

# Uninstalling RadiantOne

To remove RadiantOne, please follow the instructions below.

## Classic Architectures

For classic, non-clustered installs, to remove RadiantOne, open a command-line interface,
navigate to <RLI_HOME>/bin, and execute instancemanager.exe -X. After uninstalling and
restarting, you can manually remove any remaining folders in <RLI_HOME> (e.g. c:/radiantone).

## Cluster Architectures

For cluster architectures, unregister the node from the cluster prior to running the uninstaller. Steps to unregister nodes are shown below.

1. On the node that is to be uninstalled, stop all RadiantOne Services (except for ZooKeeper) and any running tools and execute the following command (using cluster.bat on Windows, cluster.sh on Linux):

    `<RLI_HOME>/bin/advanced/cluster.bat detach`

2. Open a command-line interface and navigate to <RLI_HOME>/bin.

3. Execute instancemanager.exe -X. After uninstalling and restarting, you can manually remove any remaining folders in <RLI_HOME> (e.g. c:/radiantone).

4. Edit the <RLI_HOME>/vds_server/conf/cloud.properties file on each remaining cluster node and verify that the zk.servers value correctly lists the cluster nodes and ZooKeeper client port. If the zk.servers value is incorrect, run the following command (using cluster.bat on Windows, cluster.sh on Linux):

    `<RLI_HOME>/bin/advanced/cluster.bat update-zk-client-conf`

5. Edit the <RLI_HOME>/apps/zookeeper/conf/zoo.cfg file on each remaining cluster node take note of the value for the dynamicConfigFile. An example showing the syntax of the value is shown below.

    `dynamicConfigFile=C:/radiantone/vds/apps/zookeeper/conf/zoo.cfg.dynamic.3000013b8`

6. Edit the dynamicConfigFile noted in the previous step to verify all ZooKeeper nodes remaining in the cluster are listed. An example of 2 remaining nodes in a cluster is shown below.

    `server.2=DOC-E1WIN2:2888:3888:participant;0.0.0.0:2181`
    <br> `server.3=DOC-E1WIN3:2888:3888:participant;0.0.0.0:2181`

7. To update the vdsha and replicationjournal data sources (that still reference the RadiantOne uninstalled node), on one of the remaining cluster nodes, run the following command (using cluster.bat on Windows, cluster.sh on Linux):

    `<RLI_HOME>/bin/advanced/cluster.bat reset-cluster-datasource`

8. To update a specific data source, like vdsha, use the following command instead of the one mentioned in the previous step (vds_server is the instance name and vdsha is the data source name in this example):

    `<RLI_HOME>/bin/advanced/cluster.bat reset-cluster-datasource vds_server vdsha`

From the Main Control Panel > Settings > Server Backend > LDAP Data Sources, you can verify that both vdsha and replicationjournal data sources have a host name referencing an accessible cluster node and the Failover LDAP Servers reference nodes accessible in the cluster.