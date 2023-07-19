---
title: Deployment and Tuning Guide
description: Deployment and Tuning Guide
---

# Starting and Stopping Components and Services

This chapter describes how to start and stop the RadiantOne service and the web server hosting the Control Panels.

## RadiantOne Service

The various ways the RadiantOne service can be started are described below. It is recommended that it runs as a service in production environments.

>[!warning]
>When deploying in a cluster, the first node in the cluster is the leader node. No matter how you choose to start the process, the one on the leader node should be started first.

### From Main Control Panel

After starting the Control Panel, login with the super user (e.g. default cn=directory manager) along with the password you selected during the install of RadiantOne.

You can start the RadiantOne service from the Dashboard tab if it is not configured as a service. If it is, you must start/stop the service directly from the OS services window.

>[!warning]
>If the RadiantOne service is started from the Dashboard tab, the process is killed when the user logs off the machine. Start RadiantOne as a Windows service to avoid this problem.

### As a Windows Service

Once you have tested your virtual views and are ready to deploy your architecture, the RadiantOne service can be configured to start as a Windows service. Configure it as a Windows service with the following steps. Perform these steps on the RadiantOne leader node first (if you are running in a cluster). If you are not running in a cluster, perform these steps on any server in your classic architecture.

1.	Make sure that the RadiantOne service is stopped if it is currently running.

2.	Navigate to the <RLI_HOME>\bin\windows.service directory. You will find fid-server-service-install.bat and fid-server-service-uninstall.bat. These files install RadiantOne as a service and uninstall the service respectively.

    >[!warning]
    >If you are running RadiantOne on Windows 7, 2008, 2012, or 2016 you should execute fid-server-service-install or fid-server-service-uninstall as an administrator. To do so, right-click on the file and choose Run as administrator.

3.	Execute the fid-server-service-install.bat file. A command window opens briefly and then closes. Check your services window (refresh if it was already open) and you should see a new service for the RadiantOne Server.

4.	Start the RadiantOne service (be sure to start the leader node first if you are deploying a cluster).

5.	(Optional) If a local ZooKeeper is deployed (instead of an external ZooKeeper ensemble), reboot the machine to ensure ZooKeeper also starts as a service along with the RadiantOne service.

6.	Repeat steps 1-5 on all nodes (if deploying in a cluster) or on all other servers if deployed in a classic architecture.

#### Uninstalling the Windows Service

To uninstall the Windows service, stop the service and execute <RLI_HOME>\ \bin\windows.service\fid-server-service-uninstall.bat. The process of uninstalling RadiantOne as a Windows service does not update the setting in ZooKeeper. Therefore, the Dashboard tab in the Main Control Panel does not properly display the stop/start options for the RadiantOne service since it assumes it is still configured to run as a service. To address this, manually update the asAService property in ZooKeeper. There are two methods you can choose from.

-	From the Main Control Panel, switch to [Expert Mode](00-preface#expert-mode). Go to the Settings tab and navigate to Server Front End -> Advanced. Uncheck the Run as a Window Service option and save the configuration. Restart the Control Panel.

-	Use the vdsconfig utility to update the asAService property to false. Below is an example. After running the command, restart the Control Panel.

C:\radiantone\vds\bin>vdsconfig.bat set-property -name asAService -value false
<br> Using RLI home : C:\radiantone\vds
<br> Using Java home : C:\radiantone\vds\jdk\jre
<br> 0 [ConnectionStateManager-0] WARN com.rli.zookeeper.ZooManagerConnectionStateListener - Curator connection state change: CONNECTED
<br> 9 [ConnectionStateManager-0] WARN com.rli.zookeeper.ZooManagerConnectionStateListener - VDS-ZK connection state changed: CONNECTED
<br> 9 [ConnectionStateManager-0] WARN com.rli.zookeeper.ZooManager - ZooManager connection state changed: CONNECTED
<br> Previous value: true
<br> New value: false
<br> Configuration has been updated successfully.

### As a LINUX Daemon

On UNIX platforms, the RadiantOne service can be started with $RLI_HOME/bin/runVDSServer.sh.

Once you have tested your configuration and are ready to deploy your architecture, the RadiantOne service can be configured to start as a Linux Daemon. The startup script is located in $RLI_HOME/bin/rc.d (for init.d scripts) and $RLI_HOME/bin/system.d (for system.d scripts). Documents to assist with the configuration of the service are located at $RLI_HOME/bin/rc.d/readme.txt (for init.d scripts) and $RLI_HOME/bin/system.d/readme.txt (for system.d scripts).

Assuming you are logged into your LINUX machine, use the following commands on the leader node first if you are running in a cluster. Once the daemon is running on the leader node, run the following commands on the follower/follower-only nodes:

For init.d scripts:

sudo cp $RLI_HOME/bin/rc.d/vds /etc/init.d/
<br> sudo chmod +x /etc/init.d/vds
<br> sudo chkconfig --add vds   #To automatically configure the vds init script for the configured runlevels (3 and 5, these are defined in the vds script). If you want to uninstall the script, use: chkconfig --del vds 
<br> sudo service vds start
<br> ps -ef | grep vds   #To verify that RadiantOne FID is not running as root, but as the user that owns the RadiantOne install location.

For system.d scripts:

sudo cp $RLI_HOME/bin/system.d/vds.service /etc/systemd/system/ <BR>sudo systemctl enable vds.service <BR>sudo systemctl start vds.service

>[!warning]
>If you are deploying RadiantOne in a cluster, be sure to start the RadiantOne service on the leader node first before you start it on any follower/follower-only nodes.

### How to Stop the RadiantOne Service

Options for stopping the RadiantOne service:

-	On Windows and UNIX platforms, the RadiantOne service can be stopped from the Dashboard tab in the Main Control Panel.

-	If it is installed as a Windows service, it can be stopped from the Windows services menu.

-	To stop it on Linux platforms, execute: $RLI_HOME/bin/stopVDSServer.sh

-	To stop the RadiantOne Daemon Process:

-	For init.d use /etc/init.d/vds stop

-	For system.d use systemctl stop vds.service

## Global Synchronization

There are two approaches to starting Global Synchronization, the Main Control Panel and from command line. Each is described below.

### From Main Control Panel

Global Synchronization pipelines can be started from the Main Control Panel > Global Syn tab. Select the topology from the list on the left. Click **RESUME** to start synchronization for all pipelines. 

![An image showing ](Media/Image6.1.jpg)

Figure 6.1: Starting Global Sync for All Pipelines in a Topology

If a topology has more than one pipeline, you can start synchronization for each independently. To resume a single pipeline, click CONFIGURE and select the APPLY component. Click RESUME.

![An image showing ](Media/Image6.2.jpg)
 
Figure 6.2: Starting Global Sync for a Specific Pipeline in a Topology

### From Command Line

The change-pipeline-state command in the vdsconfig utility, can be used to start/resume and stop/suspend a pipeline. The syntax of the command is as follows:

change-pipeline-state -pipelineid <pipelineID> -state <state>

Run the list-topologies command to locate the pipelines identifiers for each topology. This is the value to pass in the -pipelineid. For the -state property, use a value of “resume” to start the synchronization process. Use a value of “suspend” to stop the synchronization process.

For more details on the vdsconfig utility, see the [Radiantone Command Line Configuration Guide](/documentation/command-line-configuration-guide/01-introduction).

## Control Panels

The Main Control Panel and Server Control Panel applications are hosted in a Jetty Web Server. The Server Control Panel can be accessed from the Dashboard tab in the Main Control Panel. The various ways the Jetty web server can be started are described below. It is recommended that it runs as a service in production environments.
### Windows Start Menu

After installing RadiantOne, execute <RLI_HOME>\bin\openControlPanel.bat (this starts the web server if it is not running in addition to opening the Main Control Panel in your default Internet browser).

>[!warning]
>If the Jetty web server hosting the Control Panel is started from the Windows Start Menu or using openControlpanel.bat, the process is killed when the user logs off the machine. Start Jetty as a Windows service to avoid this problem.

### As a Windows Service

The web server that hosts the control panels can be installed as a Windows service and can be set to start automatically. You can configure it as a Windows service with the following steps:

1.	Navigate to the %RLI_HOME%\bin\windows.service directory. Control-panel-service-install and control-panel-service-uninstall are located here. You can use these to install the web server as a service and uninstall the web server as a service respectively.

    >[!warning]
    >If you are running the web server that hosts the control panel on Windows 7, 2008, 2012, or 2016, you should execute control-panel-service-install or control-panel-service-uninstall as an administrator. To do so, right-click on the file and choose Run as administrator.

2.	Verify that the web server is stopped. For example, try going to: http://localhost:7070 (this is using the default port, if you set a different port during the RadiantOne install, you should use it here). If this page doesn’t return anything, the web server probably isn’t running. If it is running you can stop it with: <RLI_HOME>/bin/stopWebAppserver.bat. 
3.	Execute the control-panel-service-install file. A command window opens briefly and then exits. Check your services window (refresh if it was already open) and you should see a new service for the RadiantOne FID Management Console. 
4.	Verify the server started by opening a web browser and navigating to: http://localhost:7070 (this is using the default port, if you set a different port during the RadiantOne install, you should use it here). If the web server starts successfully, you can close the browser window and stop the server with <RLI_HOME>/bin/stopWebAppserver.bat. 
 	
>[!warning]
>If a cluster, execute the steps described in this section on each cluster node.

### As a LINUX Daemon

On UNIX platforms, you can start the Main Control Panel with $RLI_HOME/bin/openControlPanel.sh.

The Jetty server that hosts the Control Panels can also be configured as a Linux daemon. Documents to assist with this are located at $RLI_HOME/bin/rc.d/readme.txt (for init.d scripts) and $RLI_HOME/bin/system.d/readme.txt (for system.d scripts).

For init.d scripts:

sudo cp $RLI_HOME/bin/rc.d/control_panel /etc/init.d/
<br> sudo chmod +x /etc/init.d/control_panel
<br> sudo chkconfig -add control_panel  #To automatically configure the script for the configured runlevels (3 and 5, these are defined in the control_panel script). If you want to uninstall the script, use: chkconfig --del control_panel
<br> sudo service control_panel start

For system.d scripts:

sudo cp $RLI_HOME/bin/system.d/control_panel.service /etc/systemd/system/ <BR>sudo systemctl enable control_panel.service <BR> sudo systemctl start control_panel.service

>[!warning]
>If a cluster is deployed, execute the steps described in this section on each cluster node.

### How to Stop Control Panel

Options for stopping the Jetty web server that hosts the control panels:

-	To stop the Jetty web server, first close the Internet browser where the control panel is running. Then, on Windows platforms, execute <RLI_HOME>\bin\stopWebAppServer.bat. 

-	If the web server is running as a Windows service, stop it (RadiantOne FID Management Console) from the services window. 

-	As a Linux daemon process you can use: 

-	For init.d script use: service control_panel stop

-	For system.d use systemctl stop control_panel.service

-	On Linux platforms, execute $RLI_HOME\bin\stopWebAppServer.sh.

## Order to Restart Components when Deployed in a Cluster

To check the status of each component, go to the Main Control Panel > Dashboard tab > Overview section. For cluster deployments, the following is the recommended order to restart the components.

1.	(Optional) Suspend [Global Synchronization](#global-synchronization) if used. 

2.	Stop the [RadiantOne service](#how-to-stop-the-radiantone-service). All follower nodes first and then the leader node last. Verify the leader/follower status of each node from the Main Control Panel > Dashboard tab.

3.	Stop [Management Console](#how-to-stop-control-panel) (Jetty web server that hosts the Control Panels).

4.	Make sure all java processes related to RadiantOne components are stopped, if any of the process is still running, please kill from the task manager or command line.

5.	Start [Management Console](#control-panels) (Jetty web server that hosts the Control Panels) on all nodes in the cluster.

6.	Start the [RadiantOne service](#radiantone-service) first on the previous leader node, wait until it has fully started and then start it on the follower nodes. To find the previous leader node, log in to the Main Control Panel (expert mode) > ZooKeeper tab and navigate to `/radiantone/<version>/<cluster_name>`. The previous leader is noted in the lastLeaderID property. You can identify the server corresponding to this cloud ID from the Dashboard tab. 

7.	(Optional) Start/resume [Global Synchronization](#global-synchronization) if used.

>[!warning]
>Zookeeper must be running on at least half of the cluster nodes to maintain the integrity of the cluster. Zookeeper starts automatically with the RadiantOne service and/or the Management Console (Jetty web server that hosts the Control Panels).
