---
title: Operations Guide
description: Operations Guide
---

# Patching Production Environment

Typically, before implementing code updates (patches) in production, they should be tested in a development/QA environment. Product updates are applied by running an updater. A document describing how to apply the patch update accompanies each updater.

In some cases, additional steps may be required to update your environment depending on your current version and the version you are updating to. Please email support@radiantlogic.com and request a link for the relevant updater and documentation.

If your production machines are not yet configured with RadiantOne, you should follow the steps detailed in the Migration to Production section. This section is only related to patching existing production machine(s).

>[!warning]
>All updates/patches should be performed during non-peak/off- hours to avoid any disruption in service.

## Classic Architecture Deployments

You should typically have at least one primary and one failover server in production, so the failover server can handle the load while the primary server is offline being patched.

Below are high level steps for patching classic architectures. A more detailed document accompanies the updater. Please email support@radiantlogic.com and request a link for the relevant updater and documentation.

1. Stop all RadiantOne components on the production server.

2. Make a backup of your entire production instance(s) <RLI_HOME> folder in addition to backing up any RadiantOne Universal Directory (HDAP) stores.

3. Run the updater and make any additional updates recommended by Radiant Logic.

4. Restart the relevant RadiantOne components.

5. Follow the steps above to update other production servers.

## Cluster Deployments

In a cluster, one node is updated at a time while the other node(s) maintain the integrity and availability of the cluster. Below are high level steps for patching cluster architectures. A more detailed document accompanies the updater. Please email support@radiantlogic.com and request a link for the relevant updater and documentation.

1. Make a backup of the entire <RLI_HOME> folder in addition to backing up any RadiantOne Universal Directory (HDAP) stores. It is recommended to perform this on each node.

1. On one of the cluster nodes, stop all services except for ZooKeeper and then run the updater.

    >[!warning] To execute the updater on Windows, right-click on the installer file and select Run As Administrator.

1. When the updater completes, check the <RLI_HOME>/logs/update-installer/migration-update-installer.log file for errors. The log indicates the following if everything was successful:
    INFO - Migration(s) completed successfully.

1. Once the RadiantOne services are running again on this node (you can check status from the Dashboard tab in Main Control Panel), run the updater on another node.

    >[!warning] If you are running the RadiantOne service and/or the Jetty server (which hosts the Control Panel) as services, you will need to restart them manually (or you can restart the machine as they will restart automatically in this scenario).

1. After the updater is run on all nodes, make any additional updates recommended by Radiant Logic.

1. Run your standard tests to ensure your virtual views and complete configuration work as expected after the update.

1. If all works as expected, the updater can be run on your production nodes (using the same sequence as described above).

1. Follow the steps above to update other production sites/clusters.

## Updating License Keys

To update license keys or replace expired licenses, it is important to understand the type of license keys you currently have deployed and what type of new license keys you received from Radiant Logic. If you received license keys for each node/server, each RadiantOne node in a cluster must have its own unique license key. If you received a license key that is valid for a cluster, each node in a given/same cluster can share the same key value. Check with your Radiant Logic Account Representative if you are unsure what kind of license key you received.

### Replacing Single Node License Keys with New Single Node License Keys

This scenario assumes you currently have a RadiantOne cluster deployed, each node in the cluster has its own unique license key, and you want to replace the single node license keys with new single node license keys. The following are the replacement steps whether the license key has expired or not.


1. On one RadiantOne node, open the <RLI_HOME>/vds_server/license.lic file in a text editor and replace the entire key value with your new license key and save the file. The key value should start with {rlib}. Make sure there are no extra leading or trailing spaces. Save the license.lic file. Make sure no extra extensions (e.g. .txt) have been added to the file.
2. Restart the RadiantOne service on the node. The new license key value gets registered in ZooKeeper once the service is restarted. Confirm that the RadiantOne service has restarted before continuing to step 3.
3. Repeat steps 1-2 on each RadiantOne cluster node. Keep in mind that each cluster node should have its own unique key value.

### Replacing Cluster License Keys with New Cluster License Keys

This scenario assumes you currently have a RadiantOne cluster deployed with one cluster license for all nodes in the cluster. The following are the replacement steps whether the license key has expired or not.

1. On one RadiantOne node, open the <RLI_HOME>/vds_server/license.lic file in a text editor and replace the entire key value with your new cluster license key and save the file. The key value should start with {rlib}. Make sure there are no extra leading or trailing spaces. Save the license.lic file. Make sure no extra extensions (e.g. .txt) have been added to the file.
1. Restart the RadiantOne service on the node. The new license key value gets registered in ZooKeeper once the service is restarted. Confirm that the RadiantOne service has restarted before continuing to step 3.
 >[!warning] If you are running RadiantOne v7.4.8(+), all cluster nodes update their local license file automatically with the updated license file on the first cluster node that is updated (and restarted). Therefore, you can skip step 3 below.

1. Repeat steps 1-2 on each RadiantOne cluster node. Use the same cluster license value for all RadiantOne nodes.

### Replacing Single Node License Keys with New Cluster License Key

This scenario assumes you currently have a RadiantOne cluster deployed, each node in the cluster has its own unique license key, and you want to replace the single node license keys with a cluster license key. The following are the replacement steps whether the license key has expired or not.

1.  On one RadiantOne node, open the <RLI_HOME>/vds_server/license.lic file in a text editor and replace the entire key value with your new cluster license key and save the file. The key value should start with {rlib}. Make sure there are no extra leading or trailing spaces. Save the license.lic file. Make sure no extra extensions (e.g. .txt) have been added to the file.
1.  Restart the RadiantOne service on the node. The new license key value gets registered in ZooKeeper once the service is restarted. Confirm that the RadiantOne service has restarted before continuing to step 3.

>[!warning] If you are running RadiantOne v7.4.8(+), all cluster nodes update their local license file automatically with the updated license file on the first cluster node that is updated (and restarted). Therefore, you can skip step 3 below.

1.  Repeat steps 1-2 on each RadiantOne cluster node. Use the same cluster license value for all RadiantOne nodes.
