---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Migration Commands

Migrating resources (e.g. root naming contexts, data sources, Global Identity Builder projects, virtual views, or schema files) from an existing development/QA environment to an existing production environment can be difficult because many resources are dependent upon other resources (virtual views are dependent upon data sources, schema files and often times even other virtual views). These resources usually need to be migrated together to ensure everything works properly in the target environment. This makes the migration process error prone.

This chapter explains how to traverse, export, and import resources and their dependencies using commands.

For more information, see the [RadiantOne Operations Guide](/documentation/operations-guide/01-overview).

>[!note]
>The commands in this chapter do not support output format configuration. Refer to [Configuring Command Output Format](introduction#configuring-command-output-format) for more information.

### resource-traverse

This command displays the resource dependency tree. The results include any data sources, .orx files, .dvx files, root naming contexts, and .jar files (from interception scripts or custom object scripts) related to the resource. If you need to migrate the resource to another environment, all of the dependent files must be migrated also.

**Usage:**
<br>`resource-traverse -name <name> [-instance <instance>]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the resource. This could be a data source name, a .dvx file name (e.g. contextcatalog.dvx), an .orx file name (e.g. sales.orx), or a root naming context (e.g. o=companydirectory).

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**REST (ADAP) Example**

In the following example, a request is made to display the resource dependency tree for a virtual view named contextcatalog.dvx.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=resource-traverse&name=contextcatalog.dvx
```
### resource-export

This command exports the resource and its dependencies.

**Usage:**
<br>`resource-export -name <name> [-instance <instance>] [-path <path>] [-skip <name>]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the resource.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- path <path>`**
<br>The file or folder to export to.

**`- skip <name>`**
<br>The name of the resource to skip and exclude from the export.

**REST (ADAP) Example**

In the following example, a request is made to export the resource so_hr_o_examples.dvx and its dependencies.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=resource-export&name=so_hr_o_examples.dvx&path=C:\radiantone\vds\vds_server
```

### resource-import

This command imports the resource and its dependencies.

**Usage:**
<br>`resource-import -path <path> [-apply] [-instance <instance>][-interactive] [-overwrite] [-skip <name>] [-skipregex <skipregex>]`

**Command Arguments:**

**`- path <path>`**
<br>[required] The file or folder to import from.

**`- apply`**
<br>Flag required to apply the import. If this isn’t passed, a summary of all resources to be added and overwritten in the target is displayed.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- interactive`**
<br>Indicates the command should run in interactive mode (user may be prompted for input if a resource already exists).

>[!note]
>REST (ADAP) commands do not support this argument.

**`- overwrite`**
<br>Indicates that existing resources are allowed to be overwritten during the import.

**`- skip <name>`**
<br>Resource name to skip. Always run the command without the -apply flag first to see how the target environment resources are going to be affected. This allows you to take note of the resources that should be skipped (using the -skip flag) when you run the command with the -apply flag.

**`- skipregex <skipregex>`**
<br>A regular expression indicating which resources to skip. The format for the regex is: resourcetype: regex. Supported resource types are: naming, ds, orx, dvx, file, custom, all.
Example: naming:^ou.* --> skips all naming contexts starting with the name ou
Example: all:^test.* --> skips all resources starting with the name test.

**REST (ADAP) Example**

In the following example, a request is made to import the resource so_hr_o_examples.dvx and its dependencies.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=resource-import&path=c:/radiantone/vds/vds_server/contextcatalog_dvx.zip&apply=&skipregex=ds:^derby.*
```
