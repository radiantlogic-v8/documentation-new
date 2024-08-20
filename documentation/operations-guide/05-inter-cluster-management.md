---
title: Operations Guide
description: Operations Guide
---

# Chapter 5: Inter Cluster Management

## Migrating Configuration Changes Across Existing Environments

It is recommended that you designate one data center as the primary. Therefore, you should setup your cluster/primary data center based on the recommended architectures described in the Deployment and Tuning Guide. Then, all configurations made at the primary data center are migrated to all other data centers.

>[!note]
>The steps described in this section would also be applicable to migrating changes from a development/QA environment to an existing/configured production environment. These steps are also applicable for migrating changes across RadiantOne deployed in a classic (active/active or active/passive) architecture. The source and the target RadiantOne versions must be the same.

Each naming context depends on one or more resources to function properly. A resource is defined as any data source, virtual view (.dvx file), or schema file (.orx file), or Global Identity Builder project files associated with a naming context. The vdsconfig utility includes three commands that can discover, export and import the resources for a naming context.

- Resource-traverse discovers and displays the resources that a naming context depends on to function. Because some of these resources may exist behind the scenes, it is recommended that you run resource-traverse before exporting dependencies.
- Resource-export exports the dependencies to a zip file. This file can then be imported into a target server to synchronize the configuration changes.
- Resource-import imports the dependencies from a zip file onto a target server.

The tool used for traversing, exporting and importing configuration is named vdsconfig.bat (Windows) or vdsconfig.sh (Linux) and is located in <RLI_HOME>/bin.

It is recommended that configuration migration is performed during non-peak/off hours.

1. On a node in the primary cluster, open a command prompt and navigate to <RLI_HOME>\bin.
2. Run vdsconfig passing the `resource-traverse -name <name of resource> -instance vds_server`. The result is a hierarchy depicting the dependencies associated with the resource. Therefore, if you were to migrate the resource to another environment, all the needed dependencies must be considered as well. For example, if a new naming context named dc=ad needed to be migrated to an existing production environment the following command would traverse the resource and display the dependencies:
<br><RLI_HOME>/bin/vdsconfig.bat resource-traverse -name dc=ad -instance vds_server

```
2015 - 12 - 30 16:31:54 INFO c.r.t.c.ResourceCLI:134 - Dependency tree:
dc=ad [NAMING] OK
dc_ad.dvx [DVX] OK
ad203 [DATASOURCE] OK
dc_ad.orx [ORX] OK
ad203 [DATASOURCE] OK
2015 - 12 - 30 16:31:54 INFO c.r.t.c.ResourceCLI:135 - Resource paths:
zk:dvx/dc_ad.dvx
zk:lod/dc_ad.orx
zk:namings/a721f1f5-853e- 4983 - b5d7-c64105082ee3_dc=ad
ds:ad203
```

3. Using the resource-export command, export the resource and its dependencies. This exports the resource along with its dependencies into the file indicated in the command. If    there are dependencies you want to omit from the export file, there are two command arguments that allow you to skip them. The -skip argument specifies the name of the resource to be skipped. The -skipregex argument allows you to indicate which resource(s) to skip using a regular expression. This makes -skipregex especially useful in situations where you want to omit a range of resources. The -skip and -skipregex arguments can be used together in the same command. The format for -skipregex is as follows.

```
Resourcetype:regex
```

Supported -skipregex resource types are naming, ds, orx, dvx, file, custom, and all. The
following table provides examples of the argument’s usage and syntax.


| Example | Action | 
|---------|------------|
| - skipregex orx:^test.* | Skips all resources of type ORX with a name that start with the string "test".
| - skipregex ds:.* | Skips all resources of type datasource.
| - skipregex all:.*xyz$ | Skips all resources of any type with a name ends with the string "xyz". |

If a location is not indicated with the -path command argument, the default is <RLI_HOME>/work.

In the following example, a naming context, dc=ad, and its dependencies, except for .DVX files, are exported.

```
<RLI_HOME>/bin/vdsconfig.bat resource-export -name dc=ad -instance vds_server -skipregex dvx:.*

2015 - 12 - 30 16:37:02 INFO c.r.t.m.ResourceDependencyService:102 - Export of dc=ad to C:\radiantone\vds\work\dc_ad.zip has completed successfully.
```

4. Copy the export file to the server where you want to migrate the changes.
5. On the target cluster/server, [export the current configuration](02-cluster-management.md#backing-up-configuration) to save as a backup.
6. Run the command to import the resource and dependencies. By default, resource-import displays the actions that are going to be taken on the target without performing the import. This allows you to review the changes that will be applied to your target system. Take note of any items you do not want overwritten in the target so you can skip them when running the import command with the -apply flag.
    <RLI_HOME>/bin/vdsconfig.bat resource-import -path C:\radiantone\vds\work\dc_ad.zip
7. Run the resource-import command with the -apply flag to import the configuration changes on the target. Remember to skip any resources (using the -skip and/or -skipregex flags as described in step 3 above) you do not want updated on the target.

>[!warning]
>The vds, vdsha, and replicationjournal data sources (resources) should generally always be skipped at import time (e.g. -skip vds). The skipping of a resource only skips the stated resource, not its dependencies. If you are using the - skip argument, you must skip the resource using the actual ID (as it displays in the resource-traverse results) and not the exact root naming context. For example, if a root naming context of “o=aggregateview” had a merged tree configuration at “ou=CFS Users” to another LDAP backend, the resource - traverse would look something like the following. To skip a resource, use the name as it appears in the tree (e.g. -skip mergetree_-1154533092_ou_cfs_users_o_aggregateview).

```
o_aggregateview [NAMING] OK
o_aggregateview.dvx [DVX] OK
seradiantad [DATASOURCE] OK
o_aggregateview.orx [ORX] OK
seradiantad [DATASOURCE] OK
mergetree_-1154533092_ou_cfs_users_o_aggregateview [NAMING] OK
vds_ou_cfs_users_o_aggregateview_ou_accounting_o_companydirectory.dvx [DVX]
OK
vds [DATASOURCE] OK
vds_ou_cfs_users_o_aggregateview_ou_accounting_o_companydirectory.orx
[ORX]OK
vds [DATASOURCE] OK
o=companydirectory [NAMING] OK
```

8. Perform any manual migration tasks applicable to your environment. Please see the Items Requiring Manual Migration section below for more details.

>[!note] If you are migrating a sync topology, save the transformation and restart RadiantOne on the target machine. 

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
