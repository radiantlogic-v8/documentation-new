---
title: Applying Patches to RadiantOne v7.4
description: Applying Patches to RadiantOne v7.4
---

## Overview

This guide describes how to apply the RadiantOne patch for v7.4.X. These steps only apply to updating your existing RadiantOne v7.4 version with a new minor release/patch of RadiantOne v7.4.X.  These steps are not relevant for major upgrades (i.e. upgrading from v7.2 or v7.3). 

## Preparing for the Patch 
Once you have stopped all RadiantOne services, make a backup copy of your entire <RLI_HOME> folder. 

If you have deployed an external ZooKeeper ensemble, make a backup copy of the entire <ZooKeeper_Home> folder. 

## Retrieving the Update Files 

The RadiantOne files are located at: https://radiantlogicinc246.sharefile.com/i/i1bc2de34c6e42bba  

After you create an account, log in and navigate to: /update_installers/7.4/<version_to_update_to>. Copy the applicable file to all of your RadiantOne nodes. 

Linux: 
File names: 
`radiantone_<version>_update_linux_64.tar.gz `
`rli-zookeeper-external-jdk<javaVersion>-zk<version>-linux_64.tar.gz` (applicable if you are using external ZooKeeper and a Java update is associated with this patch release – check release notes to see if a JDK update is associated with the patch). 
 

Windows: 
File names: 
`radiantone_<version>_update_windows_64.zip` 
`rli-zookeeper-external-jdk<javaVersion>-zk<version>-windows_64.zip` (applicable if you are using external ZooKeeper and a Java update is associated with this patch release – check release notes to see if a JDK update is associated with the patch). 

## Applying the Update 

This guide assumes you are performing an in-place update, meaning you are applying the patch on your existing active machines as opposed to having a new, clean environment. If you have a blue-green deployment, where you have an extra set of machines to install and test the patch, make sure it is running the same RadiantOne version as the active environment. Then, if needed, migrate over the current configuration from the active environment (using <RLI_HOME>\apps\migration\migrate.bat/.sh). Finally, run the update in the test environment using the procedure below. After all tests pass, switch your load balancer to direct traffic to the updated environment. 

For cluster deployments, update all RadiantOne FID follower and follower-only nodes first. Update the RadiantOne FID leader node last. After the node is patched, it is important to ensure that all needed services are back up and running prior to patching the next node.  

Make sure you have backed up your <RadiantOne_Installation> folder. 

(Optional) to gracefully scale down, drain any open connections for your load balancer to the RadiantOne node you are updating. See your vendor documentation for configuring connection draining for your load balancer. 

Close any open RadiantOne applications. 

Stop any running services. All possible (default) service names are as follows. Some might not be applicable to your deployment. 
ZooKeeper  
RadiantOne DB Access Logger  
RadiantOne FID (vds_server)  
RadiantOne FID Management Console (vds_server) 

Process Explorer (on Windows) can be used to check the handles on the RadiantOne JVM executables to confirm all applications are stopped. Search for handles on "java" and you can see every process that has a handle on a java process. For Linux, you can use something like ps aux | grep "java" to get a list of Java processes.  

Apply the RadiantOne patch with either the web installer, or from command line. 

### Applying the Patch Using the Web Interface 

1. Navigate to your RadiantOne installation /bin folder (e.g. C:\radiantone\vds\bin). Run setup.bat (.sh on Linux). If on Windows, right-click and Run As Administrator. This launches the Web Installation process. 

1. Click Choose and navigate to the location where you copied the .zip (.tar.gz) file associated with the new RadiantOne version and click OK. 

1. Click Next to confirm the file signature has been validated. 

1. Click Update on the Summary screen to start the patching process. 
 
1. Once the updater completes on the node click Exit and close the web browser. 

1. Start the RadiantOne service and ZooKeeper on this node (you can check status from the Cluster tab in Control Panel).
 
>[!warning] – If you are running the RadiantOne service and/or the Jetty server (which hosts the Control Panel) as services, restart them manually (or you can restart the machine and they will restart automatically in this scenario). 

1.After the updater is run on all nodes, make any additional updates recommended by Radiant Logic. 

1. All certificates that you imported in the default Java trust store (<RLI_HOME>\jdk\jre\lib\security\cacerts) must be re-imported. You can import them into the RadiantOne Client Trust Store instead of the default Java one, which allows them to be shared across cluster nodes. For details on the RadiantOne client trust store, see the System Administration Guide. 

1. All changes made to <RLI_HOME>\jdk\jre\lib\security\java.security (e.g. changes to jdk.tls.disabledAlgorithms) must be applied again. Use your backup copy of java.security as a reference for what changes are needed. 

1. (Optional) If you use a modified/customized <RLI_HOME>\vds_server\conf\ldapschema_00.ldif file, copy your old file from the backup location and overwrite the ldapschema_00.ldif file that was updated as a result of applying the RadiantOne patch.  

 >[!warning] Generally, the ldapschema_00.ldif file should not be modified (a new ldapschema_<N>.ldif should be defined for special schema definitions). If manual customizations have been made to this file, beware that the update installer overwrites this file. 

1. If you have an external Zookeeper ensemble deployed, follow the steps outlined in Updating External ZooKeeper Ensemble. Otherwise, continue to the next step. 

1. Run your standard tests to ensure your virtual views and complete configuration work as expected after the update. 

1. If all works as expected, the update process can be run on your production nodes (using the same sequence as described above). It is recommended to update during non-peak traffic hours.  

1. Follow the steps above to update other sites/clusters. 

### Applying the Patch Using Command Line 

1. From command line, navigate to your RadiantOne installation /bin folder (e.g. C:\radiantone\vds\bin).  

1. Run the following command to apply the patch: 
setup.[bat|sh] --mode update --file <full path to the 7.4 archive> 
 
For example: 
`C:\radiantone\vds\bin>setup.bat --mode update --file C:\Users\lgrad\Downloads\radiantone_7.4.8_update_windows_64.zip`

When the update completes, the command returns: 
INFO  com.rli.install.WebInstallUtil:311 - Update is done 

1. Start the RadiantOne service and ZooKeeper on this node (you can check status from the Cluster tab in Control Panel). 

 >[!warning] If you are running the RadiantOne service and/or the Jetty server (which hosts the Control Panel) as services, restart them manually (or you can restart the machine and they will restart automatically in this scenario). 

1. After the updater is run on all nodes, make any additional updates recommended by Radiant Logic. 

1. All certificates that you imported in the default Java trust store (<RLI_HOME>\jdk\jre\lib\security\cacerts) must be re-imported. You can import them into the RadiantOne Client Trust Store instead of the default Java one, which allows them to be shared across cluster nodes. For details on the RadiantOne client trust store, see the System Administration Guide. 

1. (Optional) If you use a modified/customized <RLI_HOME>\vds_server\conf\ldapschema_00.ldif file, copy your old file from the backup location and overwrite the ldapschema_00.ldif file that was updated as a result of applying the RadiantOne patch.  

 >[!warning] Generally, the ldapschema_00.ldif file should not be modified (a new ldapschema_<N>.ldif should be defined for special schema definitions). If manual customizations have been made to this file, beware that the update installer overwrites this file. 

1. If you have an external Zookeeper ensemble deployed, follow the steps outlined in Updating External ZooKeeper Ensemble. Otherwise, continue to the next step. 

1. Run your standard tests to ensure your virtual views and complete configuration work as expected after the update. 

1. If all works as expected, the update process can be run on your production nodes (using the same sequence as described above). It is recommended to update during non-peak traffic hours.  

1. Follow the steps above to update other sites/clusters. 

## Updating External ZooKeeper Ensemble 

If you have ZooKeeper deployed in an external ensemble, you must update it separately with the steps outlined below only when Java updates are needed, or if the ZooKeeper version used by RadiantOne is updated.  

1. Copy the rli-zookeeper-external* file to each of your ZooKeeper servers. 

1. Unzip the new ZooKeeper version in a separate, temporary folder (other than the one it is currently installed on). 

1. Stop ZooKeeper on the node you are updating. 

1. If you haven’t already done so, make a copy/backup of the existing ZooKeeper home location. 

1. Copy the following folders from the new version (that you unzipped in step 2) to the existing setup:  
/bin/                      (copy) 
/setup/                  (remove from target first – remove all jars, then copy) 
/zookeeper/bin/     (remove from target first, then copy) 
/zookeeper/docs/  (remove from target first, then copy) 
/zookeeper/lib/      (remove from target first, then copy) 
/jdk/                       (remove from target first, then copy) 

1. Delete the temporary folder that you unzipped the new ZooKeeper version to in step 2. 

1. Start ZooKeeper. 

1. Repeat the steps above for each ZooKeeper server in your external ensemble.  

 >[!warning] The truststore and keystore are created when ZooKeeper is restarted after the update. Therefore, if you want to use SSL/TLS access to ZooKeeper, ensure you have imported the required certificates. For steps, see the RadiantOne Hardening Guide. 


## Known Issues 

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues  


## How to Report Problems and Provide Feedback 

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com  

If you do not have a user ID and password to access the site, please contact support@radiantlogic.com. 
