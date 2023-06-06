---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Node Configuration Commands

This chapter describes how to display the contents of the Cluster Node Configuration. It also explains how to get and set a node property. These commands can be issued using
<RLI_HOME>/bin/vdsconfig.

## list-cluster-node-properties

This command displays the contents of the Cluster Node Configuration.

**Usage:**
<br>`list-cluster-node-properties [-guid <guid>] [-instance <instance>]`

**Command Arguments:**

**- guid <guid>**
<br>The GUID of the node. Defaults to the current node.

**- instance <instance>**
<br>The name of the RadiantOne instance. If this is not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
<br>In the following example, a request is made to display the contents of the cluster node configuration.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-cluster-node-properties&guid=67ceb388-8b92- 3148 - 9cb9-752d47e9c350`

## get-cluster-node-property

This command gets the value of a property in the Cluster Node Configuration.

**Usage:**
`get-cluster-node-property -name <name> [-guid <guid>] [-instance <instance>]`

**Command Arguments:**

**- name <name>**
<br>[required] The name of the property.
**- guid <guid>**
The GUID of the node. Defaults to the current node.
**- instance <instance>**
<br>The name of the RadiantOne instance. If this is not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
<br>In the following example, a request is made to get the value of the server name property in the cluster node configuration.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-cluster-node-property&name=serverName`

## set-cluster-node-property

This command sets the value of a property in the Cluster Node Configuration.

**Usage:**
<br>`set-cluster-node-property -name <name> -value <value> [-guid <guid>] [-instance <instance>] [-pwdfile <pwdfile>]`

**Command Arguments:**

**- name <name>**
<br>[required] The name of the property.

**- value <value>**
<br>[required] The value of the property.

>[!note] Use the file:::path\to\file notation if you want to use a value contained in a file.

**- guid <guid>**
<br>The GUID of the node. Defaults to the current node.

**- instance <instance>**
<br>The name of the RadiantOne instance. If this is not specified, the default instance named
vds_server is used.

**- pwdfile <pwdfile>**
<br>The full path to a file containing the directory manager password. This is only necessary for specific commands that require the directory manager password.

**REST (ADAP) Example**
<br>In the following example, a REST request is made to set the value of the forceLeader property
to true.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-cluster-node-property&name=forceLeader&value=true`
