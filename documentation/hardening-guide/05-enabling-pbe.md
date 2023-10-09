# Migrating to a PBE-enabled Environment

RadiantOne generates a random master key by default to use for encrypting information in configuration files. You can migrate from the default encryption process to using a more secure PBE method by following the guidance below.

The migration process involves exporting your existing configuration, installing RadiantOne with PBE enabled, and importing the configuration from your existing deployment.

The RadiantOne configuration can be exported from one machine/cluster and imported into another. The [export](#exporting-the-existing-environment) needs to happen on only one node in a cluster (as all nodes share the same config) and needs to be [imported](#importing-the-existing-configuration) on only one node in the cluster of the target environment.

## Exporting the Existing Environment

This section describes exporting the contents of the existing environment configuration. The RadiantOne configuration is stored in various files which makes the task of manual migration a painful and error-prone process. The Migration Utility automates the process of moving the configuration files from one RadiantOne machine/cluster to another. 

To use the migration utility to export the configuration from the the existing environment, follow the steps below. 

>[!note] For details on customizing the migration plan, see the RadiantOne Migration Utility Guide.

1. Download the latest migration utility (at least v2.1) from the Radiant Logic support site and unzip it on both the source machine (from where you are exporting) and the target machine (where you plan on importing). Contact Support (support@radiantlogic.com) for credentials and location of the Migration Utility.

2. On the source machine, lock configuration changes to ensure no changes are being made while the configuration is exported. Log into the Main Control Panel as a directory administrator and go to Settings tab > Configuration > Configuration Lock and toggle the option to the Locked position. Click Save.

3. On the source machine, from a command prompt, navigate to the location where you unzipped the migration utility.

4. Run the migration command (modifying the version of the migration tool and the location of the export file to match your needs).

C:\r1\migration\radiantone-migration-tool-2.1.7/migrate.bat export /home/ec2-user/exportfromnopbe.zip

## Installing RadiantOne with PBE Enabled

To use Password-based encryption (PBE) to generate the key, you must use a silent install and indicate vds.security.pbe.enabled=true in the \vds\install\install.properties file before using Instance Manager to install RadiantOne. Refer to the RadiantOne Installation Guide for more information.

## Importing Configuration into the PBE-enabled Environment

All RadiantOne services EXCEPT ZooKeeper must be stopped on the target machine prior to importing. If you have deployed RadiantOne in a cluster, only the services on the machine you are importing into need to be stopped. ZooKeeper servers in the ensemble must be running prior to importing.

Run <RLI_HOME>/bin/advanced/stop_servers.bat (use stop_serers.sh on Linux) on all RadiantOne cluster nodes. This ensures that all RadiantOne services are stopped. 

Run <RLI_HOME>/bin/runZookeeper.bat (use runzookeeper.sh on Linux) on all RadiantOne cluster nodes. ZooKeeper on all nodes must be running.

### Specifying RLI_HOME

If you do not have an RLI_HOME system environment variable set, you must pass the location where you have RadiantOne installed when you run the Migration Utility. An example of importing configuration on Linux where RadiantOne is installed in /home/r1user/radiantone/vds, can be seen below. 

 ./migrate.sh /home/r1user/radiantone/vds import test2.zip cross-environment

### Performing the Import

Copy the export file to the target PBE-enabled machine and with the [RadiantOne services stopped](#radiantone-services) (all except for ZooKeeper), run the import command. A Windows example of the command is shown below.

C:\r1\migration\radiantone-migration-tool-2.1.7\migrate.bat import C\tmp\exportfromnopbe.zip cross-environment

### Post-import Tasks

After the import process finishes, two additional tasks must be completed on the target environment.

#### Restarting RadiantOne

Restart the RadiantOne service on all cluster nodes.

#### Re-initializing a Persistent Cache

Persistent cache should be re-initialized during off-peak hours, or during scheduled downtime, since it is a CPU-intensive process and during the initialization queries are delegated to the backend data sources which might not be able to handle the load.

Cache refresh connectors do not need to be stopped to re-initialize the persistent cache.

1. Deactivate any inter-cluster replication on the cached branch prior to re-initializing. To do so, navigate to the cached branch on the Main Control Panel > Directory Namespace Tab and on the right side, uncheck “Inter-cluster Replication”, then click Save. Click Yes to apply the changes to the server.

2. With the cached node selected, on the Refresh Settings tab, click **Initialize**.

3. Choose to either initialize the cache by creating an LDIF file or from an existing LDIF file. Typically, you would always use the default option which is to create an LDIF file. The only time you could choose to use an existing file is if you already have an up-to-date LDIF file containing all of the needed entries.

4. Click OK. A task is launched to re-initialize the persistent cache. The task can be monitored and managed from the Server Control Panel > Tasks Tab associated with the RadiantOne leader node.

5. Click OK to exit the initialization wizard.

6. Click Save in the upper right corner.

7. Re-enable Inter-cluster Replication that was deactivated in step 1.
