---
title: 05-data-source-commands
description: 05-data-source-commands
---
         
# Chapter 5: Data Source Commands

Data sources can be managed from the Main Control Panel > Settings tab > Server Backend section. This interface is shown below.

![An image showing ](Media/Image5.1.jpg)

The following sections contain details on how to create and delete database and LDAP data
sources. It also explains how to update and print data source information using
<RLI_HOME>/bin/vdsconfig instead of using the tools mentioned above.

## Listing, Getting and Deleting Data Sources

The following commands are for listing configured data sources, getting details about a specified data source and deleting data sources.

### list-datasource

This command displays a list of configured data source names.

**Usage:**
`list-datasource [-custom] [-database] [-instance <instance>] [-ldap]`

**Command Arguments:**

**- custom**
<br> Indicates that custom-type data sources should be listed.

**- database**
<br>Indicates that database-type data sources should be listed.

**- instance <instance>**
The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**- ldap < ldap >**
<br> Indicates that LDAP-type data sources should be listed.

**REST (ADAP) Example**
In the following example, a request is made to display a list of custom, database, and ldap data sources.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-datasource&custom&database&ldap
```

### get-datasource

This command displays the connection info for the specified data source.

**Usage:**
<br>`get-datasource -datasourcename <datasourcename> [-instance <instance>]`

**Command Arguments:**

**- datasourcename <datasourcename>**
<br> [required] The name of the data source.

**- instance <instance>**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
<br> In the following example, a request is made to display connection information for a data source named derby-northwind2.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-datasource&datasourcename=derby-northwind2
```

### delete-datasource

This command deletes the data source.

**Usage:**
<br> `delete-datasource -datasourcename <datasourcename> [-instance <instance>]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
<br> [required] The name of the data source.

**`- instance <instance>`**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
<br> In the following example, a request is made to delete a data source named derb-northwind2.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=delete-
datasource&datasourcename=derby-northwind2
```

## Creating and Updating Database Data Sources

The following commands are for managing connections to database backends.

### create-db-datasource

This command creates a new database data source.

**Usage:**
`create-db-datasource -datasourcename <datasourcename> [-active <active>] [-autocommit
<autocommit>] [-dbtype <dbtype>] [-driverclass <driverclass>] [-failover <failover>] [-instance
<instance>] [-jdbcurl <jdbcurl>] [-password <password>] [-username <username>]`

Command Arguments:

**`- datasourcename <datasourcename>`**
<br> [required] The name of the data source. Do not use spaces in the name.
**`- active <active>`**
<br> Indicates that the data source is active or disabled. Accepted values are “true”, “false”.
**`- autocommit <autocommit>`**
<br> Indicates if the data source should be written/saved in ZooKeeper. The default is true (if this property is omitted). Accepted values are “true”, “false”. If you are using execfile to run a series of commands from a file, to create many data sources, you can indicate to only commit to ZooKeeper after the last data source. This limits the number of transactions done in ZooKeeper and can avoid I/O overhead by writing one batch of new data sources as opposed to writing one at a time. An example of the file contents is shown below.

create-db-datasource -datasourcename DB1 -autocommit false ....<other props>
create-db-datasource -datasourcename DB2 - autocommit false ....<other props>
create-db-datasource -datasourcename DB3 -autocommit false ....<other props>
create-ldap-datasource -datasourcename LDAP1 -autocommit false ....<other props>
create-ldap-datasource -datasourcename LDAP2 -autocommit true ....<other props>

**`- dbtype <dbtype>`**
<br>The type of database (example: Oracle, Sybase, DB2)

**`- driverclass <driverclass>`**
<br> The fully qualified class name of the JDBC driver.

**`- failover <failover>`**
<br>The name of the data source used for failover.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- jdbcurl <jdbcurl>`**
<br>The JDBC URL.

**`- password <password>`**
<br>The password used to connect to the database.

**`- username <username>`**
<br>The username for the database connection.

**REST (ADAP) Example**
<br>In the following example, a request is made to create a database data source named derby-Northwind2.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=create-db-datasource&datasourcename=derby-
Northwind2&dbtype=derby&driverclass=org.apache.derby.jdbc.ClientDriver&jdbcurl=%3bjdbc:derby://localhost:1527/Northwind%3b&password=app&username=app
```
### update-db-datasource

This command updates the connection info for the specified database data source.

**Usage:**
<br>`update-db-datasource -datasourcename <datasourcename> [-active <active>] [-autocommit <autocommit>] [-dbtype dbtype>] [-driverclass <driverclass>] [-failover <failover>] [-instance <instance>] [-jdbcurl <jdbcurl>] [-password <password>] [-username <username>]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
<br>[required] The name of the data source.

**`- active <active>`**
<br>Indicates that the data source is active or disabled. Accepted values are “true”, “false.

**`- autocommit <autocommit>`**
<br>Indicates if the data source should be written/saved in ZooKeeper. The default is true (if this property is omitted). Accepted values are “true”, “false”. If you are using [execfile](02-general-commands.md#execfile) to run a series of commands from a file, to update many data sources, you can indicate to only commit to ZooKeeper after the last data source is updated. This limits the number of transactions done in ZooKeeper and can avoid I/O overhead by writing one batch of updated data sources as opposed to writing one at a time. An example of the file contents is shown below.

update-db-datasource -datasourcename DB1 -autocommit false ....<other props>
update-db-datasource -datasourcename DB2 -autocommit false ....<other props>
update-db-datasource -datasourcename DB3 -autocommit false ....<other props>
update-ldap-datasource -datasourcename LDAP1 -autocommit false ....<other props>
update-ldap-datasource -datasourcename LDAP2 -autocommit true ....<other props>

**`- dbtype <dbtype>`**
<br>The type of database (example: Oracle, Sybase, DB2)

**`- driverclass <driverclass>`**
<br>The fully qualified class name of the JDBC driver.

**`- failover <failover>`**
<br>The name of the data source used for failover.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- jdbcurl <jdbcurl>`**
<br>The JDBC URL.

**`- password <password>`**
<br>The password used to connect to the database.

**`- username <username>`**
<br>The username for the database connection.

**REST (ADAP) Example**
In the following example, a request is made to take the data source derby-Northwind2 offline.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=update-db-datasource&datasourcename=derby-Northwind2&dbtype=derby&driverclass=org.apache.derby.jdbc.ClientDriver&jdbcurl=%3bjdb
c:derby://localhost:1527/Northwind%3b&password=app&username=app&active=false
```

## Creating and Updating LDAP Data Sources

The following commands are for managing connections to LDAP backends.

### create-ldap-datasource

This command creates a new LDAP data source.

**Usage:**
`create-ldap-datasource -datasourcename <datasourcename> [-active <active>] [-autocommit <autocommit>] [-basedn <basedn>] [-binddn <binddn>] [-chaseref <chaseref>]
[-dirtype dirtype>] [-failover <failover>] [-host <host>] [-instance <instance>] [-pagedresults <pagedresults>] [-pagesize <pagesize>] [-password <password>] [-port <port>] [-ssl <ssl>]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
<br>[required] The name of the data source. Do not use spaces in the name.

**`- active <active>`**
<br>Indicates that the data source is active or disabled. Accepted values are “true”, “false.

**`- autocommit <autocommit>`**
<br>Indicates if the data source should be written/saved in ZooKeeper. The default is true (if this property is omitted). Accepted values are “true”, “false”. If you are using [execfile](02-general-commands.md#execfile) to run a series of commands from a file, to create many data sources, you can indicate to only commit to ZooKeeper after the last data source is updated. This limits the number of transactions done in ZooKeeper and can avoid I/O overhead by writing one batch of data sources as opposed to writing one at a time. An example of the file contents is shown below.

create-db-datasource -datasourcename DB1 -autocommit false ....<other props>
create-db-datasource -datasourcename DB2 -autocommit false ....<other props>
create-db-datasource -datasourcename DB3 -autocommit false ....<other props>
create-ldap-datasource -datasourcename LDAP1 -autocommit false ....<other props>
create-ldap-datasource -datasourcename LDAP2 -autocommit true ....<other props>

**`- basedn <basedn>`**
<br>The base DN for the data source.

><span style="color:red">**IMPORTANT NOTE – When creating an LDAP data source, do not use special characters in the Base DN value.**

**`- binddn <binddn>`**
<br>The DN used to bind.

**`- chaseref <chaseref>`**
<br>Indicates that referral-chasing is used for this data source (default is no referral-chasing).

**`- dirtype <dirtype>`**
<br>The type of LDAP directory.

**`- failover <failover>`**
<br>The list of failover servers, separated by a single space (example: -failover “ldap://vds72f1:2389 ldap://vds72f2:4489 ldaps://vds72f3:636”). If the connection is via TLS/SSL (you have -ssl set to true), the URL listed in the failover server must indicate ldaps.

**`- host <host>`**
<br>The host name/server IP.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- pagedresults <pagedresults>`**
<br>Indicates that paged results is used for this data source (default is no paged results).

**`- pagesize <pagesize>`**
<br>The page size (used only if paged results are enabled).

**`- password <password>`**
<br>The password used to bind

**`- port <port>`**
<br>The port number.

**`- ssl <ssl>`**
<br>true to indicate SSL is used, false otherwise.

**REST (ADAP) Example**
In the following example, a request is made to create an LDAP data source called ldap1.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=create-ldap-datasource&datasourcename=ldap1&dirtype=ldap&basedn=dc=radiantlogic&host=localhost
&port=2389&binddn=cn=directory manager&password=secret123
```

### update-ldap-datasource

This command updates the connection info for the specified LDAP data source.

**Usage:**
<br> `update-ldap-datasource -datasourcename <datasourcename> [-active <active>] [-autocommit <autocommit>] [-basedn <basedn>] [-binddn <binddn>] [-chaseref <chaseref>] [-dirtype <dirtype>] [-failover <failover>] [-host <host>] [-instance <instance>]
[-pagedresults <pagedresults>] [-pagesize <pagesize>] [-password <password>] [-port <port>] [-ssl <ssl>]`

Command Arguments:

**`- datasourcename <datasourcename>`**
<br>[required] The name of the data source.

**`- active <active>`**
<br>Indicates that the data source is active or disabled. Accepted values are “true”, “false”.

**`- autocommit <autocommit>`**
<br>Indicates if the data source should be written/saved in ZooKeeper. The default is true (if this property is omitted). Accepted values are “true”, “false”. If you are using execfile to run a series of commands from a file, to update many data sources, you can indicate to only commit to ZooKeeper after the last data source is updated. This limits the number of transactions done in ZooKeeper and can avoid I/O overhead by writing one batch of updated data sources as opposed to writing one at a time. An example of the file contents is shown below.

update-db-datasource -datasourcename DB1 -autocommit false ....<other props>
update-db-datasource -datasourcename DB2 -autocommit false ....<other props>
update-db-datasource -datasourcename DB3 -autocommit false ....<other props>
update-ldap-datasource -datasourcename LDAP1 -autocommit false ....<other props>
update-ldap-datasource -datasourcename LDAP2 -autocommit true ....<other props>

**`- basedn <basedn>`**
<br>The base DN for the data source.

><span style="color:red">**IMPORTANT NOTE – When updating an LDAP data source, do not use special characters in the Base DN value.**

**`- binddn <binddn>`**
<br>The DN used to bind.

**`- chaseref <chaseref>`**
<br>Indicates that referral-chasing is used for this data source (default is no referral-chasing).

**`- dirtype <dirtype>`**
<br>The type of LDAP directory.

**`- failover <failover>`**
<br>The list of failover servers, separated by a single space (example: -failover “ldap://vds72f1:2389 ldap://vds72f2:4489 ldaps://vds72f3:636”). If the connection is via TLS/SSL (you have -ssl set to true), the URL listed in the failover server must indicate ldaps.

**`- host <host>`**
<br>The host name/server IP.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- pagedresults <pagedresults>`**
<br>Indicates that paged results is used for this data source (default is no paged results).

**`- pagesize <pagesize>`**
<br>The page size (used only if paged results are enabled).

**`- password <password>`**
<br>The password used to bind.

**`- port <port>`**
<br>The port number.

**`- ssl <ssl>`**
<br>true to indicate SSL is used, false otherwise.

**REST (ADAP) Example**
In the following example, a request is made to add a failover server to a data source.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=update-ldap-datasource&datasourcename=ldap1&dirtype=ldap&basedn=dc=radiantlogic&host=localhost
&port=2389&binddn=cn=directory manager&password=secret123&failover=sun102
```

## Creating and Updating Custom Data Sources

The following commands are for managing connections to custom data sources.

### create-custom-datasource

This command creates a new custom data source.

>**Note - This command requires you to pass either the -propfile or -propstr command argument to set the custom data source properties.**

**Usage:**
`create-custom-datasource -datasourcename <datasourcename> [-instance <instance>] [-propfile <propfile>] [-propstr <propstr>]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
[required] The name of the data source.

**`- instance <instance>`**
The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- propfile <propfile>`**
The full path to a file containing the properties to set for your custom data source.

**`- propstr <propstr>`**
A string containing the different properties to set for your custom data source. Properties can be separated by semi-colons. Example usage: -propstr prop1=value1;prop2=value2.

**REST (ADAP) Example**

In the following example, a request is made to create a custom data source named custom1 using a properties file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=create-custom-datasource&datasourcename=custom1&propfile=c:/custom.properties
```

### update-custom-datasource

This command updates the connection information for the specified custom data source.

>**Note - This command requires you to pass either the -propfile or -propstr command argument to set the custom data source properties.**

**Usage:**
<br>`update-custom-datasource -datasourcename <datasourcename>[-instance <instance>] [-propfile <propfile>] [-propstr <propstr>]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
<br> [required] The name of the data source.

**`- instance <instance>`**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- propfile <propfile>`**
<br> The full path to a file containing the properties to set for your custom data source.

**`- propstr <propstr>`**
<br> A string containing the different properties to set for your custom data source. Properties can be separated by semi-colons. Example usage: -propstr prop1=value1;prop2=value2.

**REST (ADAP) Example**

In the following example, a request is made to change the URL value to 10.11.1.50.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=update-custom-datasource&datasourcename=custom1&propstr=url=10.11.1.50
```

## Importing and Exporting Data Sources

The following commands are for importing and exporting data sources.

### import-datasource

Imports data sources from a given XML file.

**Usage:**
<br>`import-datasource -filepath <filepath> [-instance <instance>]`

**Command Arguments:**

**`- filepath <filepath>`**
<br> [required] The full path to the file that contains the data sources to import.

**`- instance <instance>`**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

><span style="color:red">**IMPORTANT NOTE – if a data source in the import file has the same name as an existing data source, the existing data source is overwritten by the one you are importing.**

**REST (ADAP) Example**

In the following example, a request is made to import data sources using an XML file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=import-datasource&filepath=c:/export_ad (1).xml
```

### export-datasource

Exports data sources to an XML file.

**Usage:**
<br>`export-datasource -filepath <filepath> [-all] [-datasources <datasources>] [-instance <instance>]
[-overwrite]`

**Command Arguments:**

**`- filepath <filepath>`**
<br> [required] The full path to the file that will contain the exported data sources.

**`- all`**
<br> This option is used to indicate that all data sources (LDAP, database and custom) should be exported.

- datasources <datasources>
<br> If you don’t want all data sources to be exported, list the name(s) of the data sources to export. Separate the names by a comma (e.g. oracle,ad,sun)

**`- instance <instance>`**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- overwrite`**
<br> This option is used to indicate that the export file should overwrite an existing file of the same
name.

**REST (ADAP) Example**
In the following example, a request is made to export a data source named ldap1.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=export-datasource&datasources=ldap1&filepath=c:/tmp/export.xml
```
