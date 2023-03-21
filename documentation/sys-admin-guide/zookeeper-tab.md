---
title: System Administration Guide
description: System Administration Guide
---

# Zookeeper Tab

The Zookeeper tab is used for browsing and editing ZooKeeper contents. The configurations that are managed for all cluster nodes can be viewed from here. RadiantOne specific configuration is shown when expanding the RadiantOne node. ZooKeeper specific configuration is shown when expanding the zookeeper node.

>[!note] This tab is accessible only in [Expert Mode](introduction#expert-mode).

One of the key configuration nodes is vds_server.conf located at `/radiantone/<version>/<clusterName>/config`. This node contains most configuration information that was previously contained in the vds_server.conf file used in previous RadiantOne versions.

![zookeeper tab](Media/Image3.161.jpg)
 
Figure 1: ZooKeeper Tab

Certain nodes contain editable information. To modify settings for a specific node, click **EDIT MODE**. Click **SAVE** when you are finished.

You can also export the ZooKeeper configuration (to make backup copies) by clicking **EXPORT**. Indicate the parent node in ZooKeeper from where you want to start exporting from. The default is the root (entire config). Indicate the directory to export the file to and the file name. This export can be used to save a backup of the ZooKeeper configuration.

![Exporting ZooKeeper Configuration](Media/Image3.162.jpg)
 
Figure 2: Exporting ZooKeeper Configuration
