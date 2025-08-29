---
title: Installation Guide
description: Installation Guide
---

# Uninstalling RadiantOne

To remove RadiantOne, follow the instructions below.

## Classic Architectures

For classic, non-clustered installs, to remove RadiantOne, open a command-line interface,
navigate to <RLI_HOME>/bin, and execute instancemanager.exe -X. After uninstalling and
restarting, you can manually remove any remaining folders in <RLI_HOME> (e.g. c:/radiantone).

## Cluster Architectures


### Clusters with Internal Zookeeper

For cluster architectures using **internal Zookeeper** (i.e., Zookeeper included with the product), unregister the node from the cluster before running the uninstaller by following the steps below:

 1. Detach the node to be uninstalled

    On the **node to be uninstalled**, stop all **RadiantOne services** (except for Zookeeper) and any running tools, then run:
    
    **Windows**

    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat detach
    ````
    
    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh detach
    ```

 2. Uninstall the node

    Navigate to the following directory:
    
    ```
    <RLI_HOME>/bin
    ```

    Run the uninstall command:

    ```bash
    instancemanager.exe -X
    ```

    After uninstalling and restarting, manually remove any remaining folders in `<RLI_HOME>` (e.g., `C:/radiantone`).


 3. Verify Zookeeper client configuration

    On **each remaining cluster node**, run the following command:
    
    ```
    <RLI_HOME>/vds_server/conf/cloud.properties
    ```

    Check that the `zk.servers` value correctly lists the cluster nodes and ZooKeeper client port.

    If incorrect, update it by running:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat update-zk-client-conf
    ```

    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh update-zk-client-conf
    ```

 5. Verify ZooKeeper dynamic configuration

    On **each remaining cluster node**, run:
    
    ```
    <RLI_HOME>/apps/zookeeper/conf/zoo.cfg
    ```

    Locate the value for `dynamicConfigFile`. Example:
    
    ```
    dynamicConfigFile=C:/radiantone/vds/apps/zookeeper/conf/zoo.cfg.dynamic.3000013b8
    ```

 6. Update the dynamic configuration file

    Edit the **dynamicConfigFile** noted above to ensure that all remaining ZooKeeper nodes are listed.
    Example of 2 remaining nodes:
    
    ```
    server.2=DOC-E1WIN2:2888:3888:participant;0.0.0.0:2181
    server.3=DOC-E1WIN3:2888:3888:participant;0.0.0.0:2181
    ```

 7. Reset cluster data sources

    On **one of the remaining cluster nodes**, update the `vdsha` and `replicationjournal` data sources to remove references to the uninstalled node:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat reset-cluster-datasource
    ```
    
    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh reset-cluster-datasource
    ```


 8. Reset a specific data source (optional)

    To update a specific data source (e.g., `vdsha`), run:
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.bat reset-cluster-datasource vds_server vdsha
    ```
    
    Here, `vds_server` refers to the instance name and `vdsha` is the data source name. 



 9) Verify in Control Panel

    In the **Main Control Panel**:
    
    ```
    Settings → Server Backend → LDAP Data Sources
    ```
    
    * Confirm that both **vdsha** and **replicationjournal** data sources reference a **reachable cluster node**.
    * Ensure **Failover LDAP Servers** reference only **accessible nodes** in the cluster.



### Clusters with External Zookeeper

For cluster architectures using external Zookeeper (i.e., your self-managed Zookeeper), unregister the node from the cluster prior to running the uninstaller by following the steps below:


 1. Stop all FID services

    Stop all **FID services** (FID server + Control Panel) on **all** nodes in the cluster, starting with the **Followers first** and the **Leader node last**.
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\stop_servers.bat
    ```

    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/stop_servers.sh
    ```
    
    > **Note:** Ensure there are **no Java processes** running by using the following:
    >
    > * **Windows:** Check **Task Manager**
    > * **Linux:** `ps -ef | grep java`


 2. Detach the node to be removed

    Run on the **node to be removed**:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat detach
    ```

    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh detach
    ```


 3. Verify the node is fully stopped

    On the **same node**, run:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\stop_servers.bat
    ```
    
    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced\stop_servers.sh
    ```

Confirm there are **no Java processes** by using the following:

* **Windows:** Task Manager
* **Linux:** `ps -ef | grep java`

4. Clean up the node

   Delete or rename the `<RLI_HOME>` folder on the node that was removed.


 5. Reset cluster data sources on remaining nodes

    Update the `vdsha` and `replicationjournal` data sources (to remove references to the removed node) by running on **each remaining cluster node**:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat reset-cluster-datasource
    ```
    
    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh reset-cluster-datasource
    ```

 6. Restart services on remaining nodes

    Start the **Radiant One** service and **Control Panel (Jetty)** on all remaining cluster nodes.


 7. Remove certificates from the Leader node

    In the **Control Panel** on the **Leader node**, remove any self-signed certificates associated with the removed node:
    
    **Control Panel → Settings → Security → Client Certificate Truststore**


 8. Validate the node was removed

    Run the command to verify only the working nodes are listed:
    
    **Windows**
    
    ```bat
    <RLI_HOME>\bin\advanced\cluster.bat list
    ```
    
    **Linux**
    
    ```bash
    <RLI_HOME>/bin/advanced/cluster.sh list
    ```
    
    In the **Control Panel → Zookeeper** tab, you should see **only** the working nodes under:
    
    ```
    /radiantone/v2/<clustername>/nodes/registry
    ```



