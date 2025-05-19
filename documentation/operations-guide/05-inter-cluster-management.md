---
title: Operations Guide
description: Operations Guide
---

# Chapter 5: Inter Cluster Management

## Migrating Configuration Changes Across Existing Environments

It is recommended that you designate one data center as the primary. Therefore, you should setup your cluster/primary data center based on the recommended architectures described in the Deployment and Tuning Guide. Then, all configurations made at the primary data center are migrated to all other data centers.

>[!note]
>The steps described in this section would also be applicable to migrating changes from a development/QA environment to an existing/configured production environment. The source and the target RadiantOne versions must be the same.

Each naming context depends on one or more resources to function properly. A resource is defined as any data source, virtual view (.dvx file), or schema file (.orx file), or Global Identity Builder project files associated with a naming context. The vdsconfig utility includes three commands that can discover, export and import the resources for a naming context.

- Resource-traverse discovers and displays the resources that a naming context depends on to function. Because some of these resources may exist behind the scenes, it is recommended that you run resource-traverse before exporting dependencies.
- Resource-export exports the dependencies to a zip file. This file can then be imported into a target server to synchronize the configuration changes.
- Resource-import imports the dependencies from a zip file onto a target server.

The commands used for traversing, exporting and importing configuration are described in
[Migrating Configuration](../command-line-configuration-guide/migration-commands).

It is recommended that configuration migration is performed during non-peak/off hours.

1. On a node in the primary cluster, use the resource-export command to export the resource and its dependencies. This exports the resource along with its dependencies into the file indicated in the command. **You MUST indicate the location of the export file in the -path command argument to be**: 
/opt/radiantone/vds/vds_server/conf/

An example command is shown below which exports the o=companydirectory naming context.

```GET https://<RadiantOneServiceRESTEndpoint>/adap/util?action=vdsconfig&commandname=resource-export&name=o=companydirectory&path=/opt/radiantone/vds/vds_server/conf/sync```

2. In the primary RadiantOne cluster, open Control Panel and navigate to Settings > Configuration > File Manager.
3. In File Manager, navigate to vds_server/conf/sync and download the .zip file containing the exported configuration.
4. In File Manager, delete the .zip file from the vds_server/conf/sync (to clean up unused files from this location as it is primarily used for attribute mapping in synchronization).
5. In the target RadiantOne cluster, open Control Panel and navigate to Settings > Configuration > File Manager.
6. In File Manager, navigate to vds_server/conf/sync and upload the export file.
7. Run the resource-import command with the -apply flag to import the configuration changes on the target. **Be sure to indicate the location of the file in the -path command argument to be**: 
/opt/radiantone/vds/vds_server/conf/sync/export/.zip (use the file name that you downloaded during the export).
8. In File Manager, delete the .zip file from the vds_server/conf/sync (to clean up unused files from this location as it is primarily used for attribute mapping in synchronization).


>[!warning]
>The vds, vdsha, and replicationjournal data sources (resources) should generally always be skipped at import time (e.g. -skip vds). The skipping of a resource only skips the stated resource, not its dependencies. If you are using the - skip argument, you must skip the resource using the actual ID (as it displays in the resource-traverse results) and not the exact root naming context. 

9. Perform any manual migration tasks applicable to your environment. Please see the Items Requiring Manual Migration section below for more details.

>[!note]
>If you are migrating a sync topology, save the transformation and restart RadiantOne on the target machine. 

### Items Requiring Manual Migration

After importing the configuration onto the production server, the following items should be
reviewed to see if they are applicable to the configuration, as they must be addressed manually.

- [Chapter 5: Inter Cluster Management](#chapter-5-inter-cluster-management)
  - [Migrating Configuration Changes Across Existing Environments](#migrating-configuration-changes-across-existing-environments)
    - [Items Requiring Manual Migration](#items-requiring-manual-migration)
    - [Update Global Settings](#update-global-settings)
      - [Configure and Initialize Persistent Cache](#configure-and-initialize-persistent-cache)
      - [Managing Server Certificate](#managing-server-certificate)
      - [Installing Servers to Run as Services](#installing-servers-to-run-as-services)
      - [Managing Interception Scripts and Custom Object Scripts](#managing-interception-scripts-and-custom-object-scripts)
  - [Detecting Differences Across Replicated RadiantOne Universal Directory (HDAP) Stores](#detecting-differences-across-replicated-radiantone-universal-directory-hdap-stores)
    - [Usage](#usage)
    - [Command Arguments](#command-arguments)
 
### Update Global Settings

If you modified any RadiantOne global settings from the Main Control Panel > Settings tab, you must manually make those same changes to the target servers. These settings can be updated using the command line API instead of the Main Control Panel if needed. Please see the Command Line Configuration Guide for details.

#### Configure and Initialize Persistent Cache

Virtual views configured as persistent cache should be manually configured as persistent cache and initialized in the target environment(s).

#### Managing Server Certificate

If you are using a CA-signed server certificate for RadiantOne, the Migration Tool cannot generate new ones for the target machine. New certificates must be configured manually if you do not want the server to use the certificate defined during the install. For steps on configuring and installing SSL certificates, please see the RadiantOne System Administration Guide.

#### Installing Servers to Run as Services

For steps on configuring and installing RadiantOne to start as a service, please see the RadiantOne Deployment and Tuning Guide.

#### Managing Interception Scripts and Custom Object Scripts

Interception scripts are deployed as jar files (<RLI_HOME>/vds_server/custom/lib/intercept.jar and/or customobjects.jar). These files should be copied from the source environment to the corresponding location on the target machine. The target RadiantOne service must be restarted for the new script to take effect.

If RadiantOne is deployed in a cluster architecture, the copied jar files are automatically synchronized to all nodes. However, the RadiantOne service on each node must be restarted for the new script logic to take effect. Therefore, restart each node one at a time so the other RadiantOne node(s) can handle the client load.
