---
title: Upgrade Guide
description: Upgrading RadiantOne Identity Data Management
---

## Overview

The process from upgrading from RadiantOne Identity Data Management v7.4.10 to v9.0 is described below. If you are running a version prior to v7.4.10, you must first update to this version.

v9 updates the platform from Java 8 to Java 25 and from Lucene 6 to Lucene 10. Lucene provides the underlying index format used by RadiantOne Directory, and Lucene 10 cannot directly read the Lucene 6 indexes used by v7.4. 

As a result, RadiantOne Directory data is not migrated by copying the existing index files. Instead, the directory data is exported from v7.4 and rebuilt in the new v9 deployment as part of the initial installation. This is also why the v7.4 migration export is provided when the new v9 deployment is created rather than restored into an already running v9 deployment. 

#### Notice on Versioning Scheme

Similar to the v8 release, in v9 release, the software now follows Semantic Versioning. This differs from earlier RadiantOne releases, such as 7.2, 7.3, and 7.4, where the first two digits together represented the major version.

Version numbers will use the format MAJOR.MINOR.PATCH:

MAJOR – incompatible API or behavior changes <br> MINOR – backward-compatible feature additions <br> PATCH – backward-compatible bug fixes

This versioning scheme makes it easier to identify the scope of changes in a release and plan upgrades with greater confidence.

**Before beginning the migration:** 

* Review the [features list](./features-list.md) and the [comparison matrix guide](./iddm-v7-v8-v9-comparison) section to understand changes that may affect your deployment.
* Plan a configuration freeze on the v7.4 environment after the migration export is created. Configuration changes made after the export are not automatically carried over to the v9 deployment.
* Plan a maintenance window for the final cutover, when production clients and traffic are redirected from the existing v7.4 deployment to the new v9 deployment. 

The migration is performed by creating a new v9 deployment alongside the existing v7.4 deployment. The existing v7.4 deployment is not upgraded in place. 

To migrate to v9, you must: 

* First, use the [Migration Utility](to-add) to export the configuration from the existing v7.4 environment.  

* Then, install v9 as a separate deployment using the exported configuration. 


## Steps to Perform on the v7.4 Environment 

The section describes the processes of backing up and exporting your RadiantOne v7.4 configuration and backing up existing stores and ACIs. 

Complete the following before running the export using the migration utility tool: 

### Create backups 

1. Back up the entire <RLI_HOME> directory to a safe location outside <RLI_HOME>. <RLI_HOME> is the file system location of the root installation directory where RadiantOne is installed (e.g., /opt/radiantone/vds on Linux or C:\radiantone\vds on Windows). 

2. Export the RadiantOne Directory (HDAP) stores as LDIF files, with Export for Replication checked. Store all LDIF exports outside <RLI_HOME>.  

To back up naming contexts defined as RadiantOne Directory (HDAP) stores, perform the following steps for each of your HDAP stores. Note that in v9, HDAP stores are referred to as RadiantOne Directory stores. 

  i. Log into Control Panel as a user associated with the Directory Administrator role.  
  
  ii. In the Directory Namespace tab, select your HDAP store. HDAP stores are identified with a ![HDAP icon](Media/hdap-icon.jpg) icon. 
  
  iii. In the right pane, in the Properties tab, click Export. The Export box is displayed.  
  
  iv. Enter an export file name. 
  
  v. Check the Export for Replication box (to ensure the UUID attribute remains with the entries).  
  
  vi. Click OK. The Tasks Launched window opens.
    ![Task Monitor](Media/task-monitor.jpg) 
  
  vii. Once the export finishes, click OK to close the Tasks Launched window. You are returned to the store’s Properties tab.  
  
  viii. Repeat steps 2-7 for each RadiantOne Directory (HDAP) store. 
  
  ix. Copy the LDIF files from <RLI_HOME>/vds_server/ldif/export to a safe place outside of the <RLI_HOME> location. 

### Export existing configurations

Download the migration utility v2.1.X from the [Radiant Logic support site](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA) and unzip it on the source v7.4 machine (the node from where you are exporting). Login using the email address associated with your Radiant Logic Support Portal account. If you do not yet have access, email support@radiantlogic.com.

Once logged in, navigate to Customer Downloads/MigrationUtility/Migration Utility v2.1. Download the Migration Utility version 2.1.x, where x matches the v7.4 patch release number. For example, if you are on v7.4.10, use radiantone-migration-tool-2.1.10.zip. 

For a multi-node cluster, run the export from a follower node rather than the leader node. To identify each node’s role, run:

`<RLI_HOME>/bin/advanced/cluster.sh list`

  > Note: <RLI_HOME> is the file system location of the root installation directory where RadiantOne is installed (e.g., /opt/radiantone/vds on Linux or C:\radiantone\vds on Windows).

In the command output, a follower node will display `false` in the **ZK leader** column. 

**Generating the Export**

Modify the file path depending on where your migration utility is located and run one of the following commands based on your operating system:

* In Windows, run the command from an Administrator command prompt: 

  `C:\r1\migration\radiantone-migration-tool-2.1.10\migrate.bat export C:/tmp/export.zip `

* In Linux, run the following: 

  `./migrate.sh /home/r1user/radiantone/vds export export.zip `

The final argument specifies the path and filename of the migration export to create. 

After the command executes successfully, the Migration Utility creates a `.zip` archive containing the v7.4 configuration and RadiantOne Directory Store data needed to initialize v9. It includes naming contexts, global syncs, data sources, identity views (`.dvx`) and schemas (`.orx`), roles, ACLs, configured stores, and RadiantOne Directory Store data. Directory data is exported without Lucene indexes; during v9 initialization, the data is imported and indexes are rebuilt in the v9 format.

The export does not include persistent cache data, inactive stores, custom JARs or scripts, third-party libraries, TLS certificates, keystores, external trust configuration, or v7.4 changes made after the export. Reinitialize persistent caches after migration, and recreate, restore, or otherwise handle the remaining items as needed in v9. For the complete list, see [Items Not Migrated](../migration-utility/04-items-not-migrated/).

### Complete the Configuration in the SaaS Environment

After your v7.4 configuration is imported, work through the following in order. Each step assumes the previous one is complete.

#### Access the Control Panel

The new Control Panel endpoint is listed in Environment Operations Center > Environments > *Environment_Name* > OVERVIEW > Application Endpoints. You can enable the LDAPS and REST endpoints from here as well if your integrations require them.

![Control Panel Endpoint](Media/new-cp-endpoint.jpg)

Connect to this endpoint and log in as the Directory Manager with the password you defined during the environment creation.

#### Create Secure Data Connectors

Review each backend data source and its network location to determine whether the SaaS environment can reach it directly. To connect to data sources that are not directly accessible from the SaaS environment, create a Secure Data Connector group and add a data connector in Environment Operations Center, selecting the environment you created for the Identity Data Management application.

Once a secure data connector has been created in Environment Operations Center, the SDC client must be deployed on your local system, in a network that can reach the data source, before you can establish a connection. Confirm the connector is available once deployed. For assistance see: [Creating Environments](../../../../eoc/latest/secure-data-connector/configure-sdc-service/)

#### Update Data Source Connections to use Secure Data Connector (where applicable)

In Control Panel > Setup > Data Catalog > Data Sources, select your data source. In the Secure Data Connector Group drop-down list, select the secure data connector that should be used to tunnel a secure connection to the data source. Save the data source and run Test Connection.

![Data Source SDC](Media/data-source-sdc.jpg)

#### Validate Data Sources

Check the data sources to make sure they point to the desired servers and failover servers, and that the host, port, SSL setting, bind DN, password, and base DN are correct. 

Start from Control Panel > Usage & Activity > DATA SOURCE STATUS, which reports whether the RadiantOne service can reach each backend without having to open every data source and run Test Connection individually. The STATUS column shows one of the following:

| Status | Meaning |
|---|---|
| ON | RadiantOne can connect to the data source. |
| OFF | The connection test to the data source failed. The MESSAGE column reads Data Source Unreachable. |
| OFFLINE | The data source's active property is set to false, so no connection is attempted. The MESSAGE column reads Data Source Offline. |
| UNAVAILABLE | No classname property is defined for the data source. |

![Data Source Status](Media/data-source-status.jpg)

>[!note] You only need to validate the data sources referenced by your naming contexts. Anything with a status of OFFLINE was already disabled in v7.4 and can be left alone; review the sources with a status of ON or OFF. A status of ON only means the backend is reachable. Confirm the source points at the backend you intend to use in v9 — a source carried over from v7.4 may still point at an old backend, or you may want to repoint it as part of this migration.

For every data source you rely on, confirm it points to the desired servers and failover servers, and that the host, port, SSL setting, bind DN, password, and base DN are correct. Open each one from Control Panel > Setup > Data Catalog > Data Sources, correct any values, and run Test Connection before saving.

**replicationjournal** — if you were using inter cluster replication, verify that this LDAP data source points to the correct journal, with the correct primary LDAP host, port, SSL setting, and Directory Manager credentials. Then open Advanced > Failover LDAP Servers and confirm each required failover server is present with the correct host, port, SSL setting, and SDC assignment.

**vdslb** and **adaplb** — if you were using either in v7.4, verify the load-balanced LDAP endpoint, credentials, and remaining connection values.

If you were connecting to backend data sources via SSL, make sure your certificates were migrated over successfully and that they are still valid from Control Panel > Global Settings > Client Certificates. Confirm the required client certificates and private keys are present, unexpired, and used by the intended backend data source or service. Import any missing certificates, install the required keystores and external trust configuration, and retest the affected data sources.

>[!note] Remove unused certificates only according to your certificate-retention policy.

If you had Global Identity Builder projects in v7.4, you must re-upload the identity sources in your SaaS environment. If the Global Identity Builder project has identity sources that are based on persistent cache, make sure these caches are reinitialized in SaaS before re-uploading the global profile.

To edit Global Identity Builder projects in SaaS, from the Control Panel use the “Logged in...” account menu and choose: Open Classic Control Panel.

![Classic CP Link](Media/classic-cp-link.jpg)

Navigate to the Wizards tab, launch the Global Identity Builder, and re-upload your identities in your project.

>[!note] You need to go through the cache configuration process described above again after the upload.


#### Migrate Custom Objects and Interception Scripts

To migrate custom objects and/or interception scripts, use the File Manager in the SaaS environment to upload the files from your v7.4 backup location. Go to Control Panel > Manage > File Manager, which opens at the RLI_HOME directory. Use the breadcrumb and folder list to navigate to each target folder below, click UPLOAD FILE, and either drag and drop or browse to the corresponding location from your v7.4 backup, overwriting the target files:

- For custom data sources, upload `<RLI_HOME>\vds_server\custom\src\com\rli\scripts\customobjects\<files>` to vds_server > custom > src > com > rli > scripts > customobjects.
- For interception scripts, upload `<RLI_HOME>\vds_server\custom\src\com\rli\scripts\intercept\<files>` to the corresponding intercept folder.
- If custom libraries are used, upload `<RLI_HOME>\vds_server\custom\lib\<files>` to the vds_server > custom > lib folder.

>[!note] Single-file upload is supported. When multiple files are selected at once, only the last file in the list is processed in the current release.

After the files are uploaded, navigate to the custom folder or one of its subfolders and choose BUILD > Build All Jars. You can be more selective and just choose to build the Intercept Jars and Custom Jars instead of all jars. The Build Results panel displays the compilation messages, the jar files produced, and any warnings.

>[!note] If the build fails, you must investigate further to ensure you are only including libraries that are needed. Any extra, unused libraries can cause the build of the jars to fail.

Restart the RadiantOne service using Environment Operations Center. Navigate to Environments > *Environment_Name* > OVERVIEW and use the following menu:

![Restart Menu](Media/restart-menu.jpg)

This performs a rolling restart of all RadiantOne cluster nodes for the new scripts to take effect.

#### Initialize Persistent Cache

Go to Control Panel > Setup > Directory Namespace > Namespace Design, where you should see the naming contexts that were migrated from v7.4. Identify every migrated naming context that has a cache defined; persistent-cache data is not restored by the v7.4 export, so each one must be reinitialized from its backend data source or exported LDIF cache image.

Select the root naming context and click the CACHE tab. Stop all persistent cache refreshes if they are running, then use the ... menu inline with the cached subtree to deactivate the cache. Once the refresh has been stopped and the cache deactivated, use the ... menu inline with the cache and choose Edit to go through the configuration process. In the CONFIGURE section, choose and configure the refresh strategy. Then, in the INITIALIZE section, initialize the cache. Finally, manage the cache properties from the MANAGE PROPERTIES section. The cache becomes active after initialization completes successfully. You must do this for every imported naming context that has a cache defined.

![Cache Init](Media/cache-init.jpg)


#### Configure Delegated Administrators

There are new Control Panel entitlements in v9. There are two aspects to take into consideration:

To continue to use the delegated admin roles applicable to the Classic (old) Control Panel in the new Control Panel, update them to assign permissions for the new Control Panel. Log into the Control Panel as the Directory Manager (configured when you create the environment in EOC) and go to ADMIN > Roles and Permissions. Select a role from the list and enable the needed permissions.

![roles and permissions](Media/roles-and-permissions.jpg)

The default list of delegated admin roles and the permissions that are equivalent for the new control panel are as follows. Update your default roles with the same permissions shown in the screenshots:

**ACIADMIN**

![aciadmin role](Media/aciadmin-admin-role.jpg)

**DIRECTORY ADMINISTRATORS**

![directory admin role](Media/directoryadmin-admin-role.jpg)

**ICSADMIN**

![icsadmin role](Media/icsadmin-admin-role.jpg)

**ICSOPERATOR**

![icsoperator role](Media/icsoperator-admin-role.jpg)

**NAMESPACEADMIN**

![namespaceadmin role](Media/namespace-admin-role.jpg)

**OPERATOR**

![operator role](Media/operator-admin-role.jpg)

**READONLY**

![readonly admin role](Media/readonly-admin-role.jpg)

**SCHEMAADMIN**

![schemaadmin role](Media/schema-admin-role.jpg)

To properly assign new users to delegated admin roles, log into the Control Panel as the Directory Manager and go to ADMIN > USER MANAGEMENT. Search for the delegated admin user account and assign the user to the new role.

![Assign Roles](Media/assign-roles.jpg)

>[!note] If the default roles are inadequate, you can create new roles from the ROLES and PERMSSIONS tab. Do this first and then search for/assign the user to the role. Also, if the user should be able to switch to/configure settings in the Classic Control Panel, the new role MUST have the “Classic Control Panel Access” permission enabled, and the group associated with this role for entitlement enforcement for the classic control panel selected.


## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com

If you do not have a user ID and password to access the site, please contact support@radiantlogic.com.


