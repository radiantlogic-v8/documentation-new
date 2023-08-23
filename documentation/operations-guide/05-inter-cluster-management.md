---
title: Operations Guide
description: Operations Guide
---

# Inter Cluster Management

## Migrating Configuration Changes Across Existing Environments

It is recommended that you designate one data center as the primary. Therefore, you should setup your cluster/primary data center based on the recommended architectures described in the [RadiantOne Deployment and Tuning Guide](/documentation/deployment-and-tuning-guide/07-deployment-architecture). Then, all configurations made at the primary data center are migrated to all other data centers.

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

  `2015 - 12 - 30 16:31:54 INFO c.r.t.c.ResourceCLI:134 - Dependency tree:`
  <br>`dc=ad [NAMING] OK`
  <br>`dc_ad.dvx [DVX] OK`
  <br>`ad203 [DATASOURCE] OK`
  <br>`dc_ad.orx [ORX] OK`
  <br>`ad203 [DATASOURCE] OK`
  <br>`2015 - 12 - 30 16:31:54 INFO c.r.t.c.ResourceCLI:135 - Resource paths:`
  <br>`zk:dvx/dc_ad.dvx`
  <br>`zk:lod/dc_ad.orx`
  <br>`zk:namings/a721f1f5-853e- 4983 - b5d7-c64105082ee3_dc=ad`
  <br>`ds:ad203`

3. Using the resource-export command, export the resource and its dependencies. This exports the resource along with its dependencies into the file indicated in the command. If there are dependencies you want to omit from the export file, there are two command arguments that allow you to skip them. The -skip argument specifies the name of the resource to be skipped. The -skipregex argument allows you to indicate which resource(s) to skip using a regular expression. This makes -skipregex especially useful in situations where you want to omit a range of resources. The -skip and -skipregex arguments can be used together in the same command. The format for -skipregex is as follows.

`Resourcetype:regex`

Supported -skipregex resource types are naming, ds, orx, dvx, file, custom, and all. The
following table provides examples of the argument’s usage and syntax.


| Example | Action | 
|---------|------------|
| - skipregex orx:^test.* | Skips all resources of type ORX with a name that start with the string "test".
| - skipregex ds:.* | Skips all resources of type datasource.
| - skipregex all:.*xyz$ | Skips all resources of any type with a name ends with the string "xyz". |

If a location is not indicated with the -path command argument, the default is <RLI_HOME>/work.

In the following example, a naming context, dc=ad, and its dependencies, except for .DVX files, are exported.

`<RLI_HOME>/bin/vdsconfig.bat resource-export -name dc=ad -instance vds_server -skipregex dvx:.*`

`2015 - 12 - 30 16:37:02 INFO c.r.t.m.ResourceDependencyService:102 - Export of dc=ad to C:\radiantone\vds\work\dc_ad.zip has completed successfully.`

4. Copy the export file to the server where you want to migrate the changes.

5. On the target cluster/server, [export the current configuration](02-cluster-management.md#backing-up-configuration) to save as a backup.

6. Run the command to import the resource and dependencies. By default, resource-import displays the actions that are going to be taken on the target without performing the import. This allows you to review the changes that will be applied to your target system. Take note of any items you do not want overwritten in the target so you can skip them when running the import command with the -apply flag.
    <RLI_HOME>/bin/vdsconfig.bat resource-import -path C:\radiantone\vds\work\dc_ad.zip

7. Run the resource-import command with the -apply flag to import the configuration changes on the target. Remember to skip any resources (using the -skip and/or -skipregex flags as described in step 3 above) you do not want updated on the target.

>[!warning]
>The vds, vdsha, and replicationjournal data sources (resources) should generally always be skipped at import time (e.g. -skip vds). The skipping of a resource only skips the stated resource, not its dependencies. If you are using the - skip argument, you must skip the resource using the actual ID (as it displays in the resource-traverse results) and not the exact root naming context. For example, if a root naming context of “o=aggregateview” had a merged tree configuration at “ou=CFS Users” to another LDAP backend, the resource - traverse would look something like the following. To skip a resource, use the name as it appears in the tree (e.g. -skip mergetree_-1154533092_ou_cfs_users_o_aggregateview).

  `o_aggregateview [NAMING] OK`
  <br>`o_aggregateview.dvx [DVX] OK`
  <br>`seradiantad [DATASOURCE] OK`
  <br>`o_aggregateview.orx [ORX] OK`
  <br>`seradiantad [DATASOURCE] OK`
  <br>`mergetree_-1154533092_ou_cfs_users_o_aggregateview [NAMING] OK`
  <br>`vds_ou_cfs_users_o_aggregateview_ou_accounting_o_companydirectory.dvx [DVX] OK`
  <br>`vds [DATASOURCE] OK`
  <br>`vds_ou_cfs_users_o_aggregateview_ou_accounting_o_companydirectory.orx [ORX]OK`
  <br>`vds [DATASOURCE] OK`
  <br>`o=companydirectory [NAMING] OK`

8. Perform any manual migration tasks applicable to your environment. Please see the Items Requiring Manual Migration section below for more details.

### Items Requiring Manual Migration

After importing the configuration onto the production server, the following items should be reviewed to see if they are applicable to the configuration, as they must be addressed manually.

- [Update Global Settings](#update-global-settings)
- [Configure and Initialize Persistent Cache](#configure-and-initialize-persistent-cache)
- [Managing Server Certificate](#managing-server-certificate)
- [Installing Services](#installing-servers-to-run-as-services)
- [Managing Interception Scripts and Custom Object Scripts](#managing-interception-scripts-and-custom-object-scripts)
 
### Update Global Settings

If you modified any RadiantOne global settings from the Main Control Panel > Settings tab, you must manually make those same changes to the target servers. These settings can be updated using the command line API instead of the Main Control Panel if needed. Please see the [Radiantone Command Line Configuration Guide](/documentation/command-line-configuration-guide/01-introduction) for details.

#### Configure and Initialize Persistent Cache

Virtual views configured as persistent cache should be manually configured as persistent cache and initialized in the target environment(s).

#### Managing Server Certificate

If you are using a CA-signed server certificate for RadiantOne, the Migration Tool cannot generate new ones for the target machine. New certificates must be configured manually if you do not want the server to use the certificate defined during the install. For steps on configuring and installing SSL certificates, please see the RadiantOne System Administration Guide.

#### Installing Servers to Run as Services

For steps on configuring and installing RadiantOne to start as a service, please see the RadiantOne Deployment and Tuning Guide.

#### Managing Interception Scripts and Custom Object Scripts

Interception scripts are deployed as jar files (<RLI_HOME>/vds_server/custom/lib/intercept.jar and/or customobjects.jar). These files should be copied from the source environment to the corresponding location on the target machine. The target RadiantOne service must be restarted for the new script to take effect.

If RadiantOne is deployed in a cluster architecture, the copied jar files are automatically synchronized to all nodes. However, the RadiantOne service on each node must be restarted for the new script logic to take effect. Therefore, restart each node one at a time so the other RadiantOne node(s) can handle the client load.

## Detecting Differences Across Replicated RadiantOne Universal Directory (HDAP) Stores

The resync utility allows you to analyze and reconcile RadiantOne Universal Directory (HDAP) stores in two different clusters. This can be useful when, for example, a network outage has prevented the clusters from communicating changes between them, resulting in a period of time in which they become out of sync. The utility compares the current image of a store in two different clusters. This analysis results in two LDIF-formatted files containing the changes applicable to each store required to bring the two stores in-sync. The source names are part of the LDIF file names so you know which file is applicable to which cluster. Two other LDIF-formatted files are also generated for sorting the entries. If no changes are required, the LDIF file dedicated for that data source is empty. The LDIF files containing the changes are located at <RLI_HOME>\vds_server\ldif\export and have the following syntax:
<HDAP_Store_Suffix>_`<data source name>`.ldif

The basis for determining what is out-of-sync is determined in one of two ways:

- The first data source passed to the utility in the -d property is the one considered as the base, up-to-date image with which the image from the second data source is compared against.

- The timestamp passed in the -x property determines which new or deleted entries should apply to each store.

Both stores must be accessible and defined in the base DN of the LDAP data sources when the command is executed. You need one LDAP data source per cluster. Resync-util.bat (resync-util.sh on Linux) is located at <RLI_HOME>/bin/advanced.

### Usage

`resync-util.bat [-d <datasource1,datasource2>] [-b <base_dn>] [-x <disconnectionTimestamp>] [-i <ignoredAttributes>] [-c <true/false>] [-a <true/false>] [-m <true/false>]`

In the following example, the store o=hdap1, in two different clusters identified as data sources named localvds and localvds2, are automatically re-synchronized.

`c:\radiantone\vds\bin\advanced>resync-util.bat resync -d localvds,localvds2 -b o=hdap1 -a true`

### Command Arguments

**- d <datasource1,datasource2>**
<br> [required] This parameter specifies the names of the data sources. The data sources must exist
in RadiantOne prior to using the utility and you need one LDAP data source per cluster. Data sources are passed in the command as comma-separated values (e.g. cluster1,cluster2). If the - x argument is not specified, the first data source indicated in the -d argument is considered the
definitive source for discrepant entries.
**- b <base_dn>**
<br>[required] The base DN of the stores to be examined.

**- x `<disconnectionTimestamp>`**
<br>[optional] This value is the date and time used to determine which entries should be added and deleted in each store to bring the images in-sync. This timestamp would generally be the time the network connectivity between the clusters and the replication journal failed. If this value is specified, new entries and entry deletions that occur after the specified disconnectionTimestamp are noted in the LDIF files associated with the data source where the changes should be applied. If this value is not specified, the first data source indicated in the -d argument is considered the definitive source for discrepant entry additions and deletions. In addition, if the disconnectionTimestamp is equivalent to the time an entry was created or deleted, the first data source indicated in the -d argument is considered the definitive source.

>[!note]
>The disconnectionTimestamp format is yyyyMMddHHmmss.SSS or yyyyMMddHHmmss.SSSZ.

**[-i `<ignoreAttributes>`]**
<br>[optional] This argument specifies the attribute(s) to be ignored by the utility when comparing stores. If not specified, the utility examines all attributes in the specified stores. Attributes are comma-separated (e.g. cn,description,mail).

**[-c <true/false>]**
<br>[optional] The default behavior is to save the LDIF files that sort and describe the entries that are discrepant between the two stores. If you do not want the LDIF files stored on the file system, pass -c false. If generated, these LDIF files are stored at <RLI_HOME>vds_server\ldif\export.

**[-a <true/false>]**
<br> [optional] To perform an analysis of the stores without applying changes, pass the -a false
argument, or omit this argument from the command. After analysis, you can copy the relevant
LDIF file to the corresponding cluster and manually import it to update the store. If you prefer to
automatically apply the changes required to bring the stores back in sync, pass the - a true
argument and the re-sync occurs.

**[-m <ignoreCase>]**
<br> [optional] To ignore case when detecting changes, pass the - i true argument, or omit this argument from the command. To detect case differences, pass the -i false argument.