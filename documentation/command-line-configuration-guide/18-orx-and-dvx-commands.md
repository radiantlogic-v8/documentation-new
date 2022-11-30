---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Chapter 18: ORX and DVX Commands

Schema files containing metadata and mappings associated with backend data sources are ORX files (names have a .orx extension). Virtual directory view files describing hierarchies based on schema metadata associated with backend data sources are DVX files (names have a .dvx extension). The list of .orx and .dvx files on a server can be viewed from the Main Control Panel > Context Builder tab > Schema Manager > Open menu and View Designer > Open menu. Viewing the connection information, testing the connection and changing the associated data source can be accomplished from Context Builder.

![An image showing ](Media/Image18.1.jpg)

As an alternative, you can list the files, print the connection information associated with the files, test the connection to the data source associated with the files and change the data source name and/or base DN of an existing file using <RLI_HOME>/bin/vdsconfig and the following commands.

## list-orx

This command displays a list of all existing orx files.

**Usage:**
<br>list-orx

**Command Arguments:**

No command arguments are required. The command lists all existing orx files for all types of backends (database, custom, ldap).

**REST (ADAP) Example**

In the following example, a request is made to list all existing .orx files.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-orx
```

## list-dvx

This command displays a list of all existing dvx files.

**Usage:**
<br>list-dvx

**Command Arguments:**

No command arguments are required. The command lists all existing dvx files for all types of backends (database, custom, ldap).

**REST (ADAP) Example**

In the following example, a request is made to display a list of all .dvx files.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-dvx
```

## print-connection

Prints the connection information (to the command line interface) associated with a given orx or dvx file.

**Usage:**
<br>`print-connection -name <name of dvx or orx> [-dvx] [-instance <instance>] [-orx]`

**Command Arguments:**

**`- name <name of dvx or orx>`**
<br>[required] The name of the dvx or orx file that you want to print the connection for.

**`- dvx`**
<br>Indicates that the command should work with a dvx file.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- orx`**
<br>Indicates that the command should work with an orx file.

**REST (ADAP) Example**

In the following example, a request is made to display connection information about address book.dvx.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=print-connection&name=address book&dvx
```

## test-connection

Tests the connection to the data source associated with a given orx or dvx file.

**Usage:**
<br>`test-connection -name <name of dvx or orx> [-dvx] [-instance <instance>] [-orx]`

**Command Arguments:**

**`- name <name of dvx or orx>`**
<br>[required] The name of the dvx or orx file that you want to test the connection for.

**`- dvx`**
<br>Indicates that the command should work with a dvx file.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- orx`**
<br>Indicates that the command should work with an orx file.

**REST (ADAP) Example**

In the following example, a request is made to test the connection to the data source associated with dc_db.orx

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=test-connection&name=dc_db&orx
```

## set-connection

Allows you to change the data source name associated with an orx or dvx file. For files associated with LDAP backends, you can also change the base DN associated with the data source.

**Usage:**
<br>`set-connection -name <name of dvx or orx> [-basedn <basedn>] [-datasourcename <datasourcename>] [-dvx] [-instance <instance>] [-orx]`

**Command Arguments:**

**`- name <name of dvx or orx>`**
<br>[required] The name of the dvx or orx file that you want to modify the data source and/or base
DN for.

**`- basedn <basedn>`**
<br> The new base DN to set for the orx or dvx file. This option only applies to schemas and views associated with LDAP backends.
**`- datasourcename <datasourcename>`**
<br>The new data source name to set for the orx/dvx file.

**`- dvx`**
<br>Indicates that the command should work with a dvx file.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- orx`**
<br>Indicates that the command should work with an orx file.

**REST (ADAP) Example**

In the following example, a request is made to set the name of the data source for mydirectory.dvx to vdsha.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-connection&name=mydirectory&dvx=&datasourcename=vdsha
```

## extract-orx

This command extracts an LDAP/database schema to a new .orx file.

**Usage:**
<br>`extract-orx -datasourcename <datasourcename> -name <name> -objects <objects> - type <type> [-basedn <basedn>] [-dbschema <dbschema>] [-instance <instance>] [-overwrite]`

**Command Arguments:**

**`- datasourcename <datasourcename>`**
<br>[required] The name of the data source to use for schema extraction.

**`- name <name>`**
<br>[required] The name of the new .orx file.

**`- objects <objects>`**
<br>[required] The list of objects to extract. The value ALL indicates all schema objects.

**`- type <type>`**
<br>[required] The type of schema (orx). Accepted values are: ldap, database.

**`- basedn <basedn>`**
<br>When extracting a LDAP schema, use this option if you want to overwrite the base DN.

**`- dbschema <dbschema>`**
<br>When extracting a database schema, use this option to specify a database schema name.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- overwrite`**
<br>Indicates that the command is allowed to overwrite existing files.

**REST (ADAP) Example**
In the following example, a request is made to extract an LDAP schema to a new .orx file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=extract-orx&datasourcename=vdsha&name=neworx&objects=all&type=ldap&overwrite
```

## list-orx-object

This command prints out the list of objects in a schema(.orx) file.

**Usage:**
<br>`list-orx-object -name <name> -type <type> [-instance <instance>] [-objects] [-relations] [-views]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the file (.dvx or .orx) used with the command.

**`- type <type>`**
<br>[required] The type of schema (orx). Accepted values are: ldap, database.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- objects`**
<br>Indicates that the command should print out all the objects in the schema of type 'OBJECT' or 'TABLE'.

**`- relations`**
<br>Indicates that the command should print out all the objects in the schema of type
'RELATIONSHIP'.

**`- views`**
<br>Indicates that the command should print out all the objects in the schema of type 'VIEW'.

**REST (ADAP) Example**

In the following example, a request is made to print a list of objects in a schema file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-orx-object&name=neworx&type=ldap&objects
```

## get-orx-object-prop

This command prints out the properties for an object in a schema(.orx) file.

**Usage:**
<br>`get-orx-object-prop -name <name> -object <object> -type <type> [-basetable] [-instance <instance>] [-objectclass] [-pkey] [-rdnattr] [-rdnname]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the file (.dvx or .orx) used with the command.

**`- object <object>`**
<br>[required] The name of the object in the ORX.

**`- type <type>`**
<br>[required] The type of schema (orx). Accepted values are: ldap, database.

**`- basetable`**
<br>The base table property for the object.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- objectclass`**
<br>The LDAP Object Class for the object.

**`- pkey`**
<br>The list of primary key attribute(s) for the object.

**`- rdnattr`**
<br>The attribute(s) that will be used for the RDN value for the object

- rdnname
<br>The name of the RDN for the object.

**REST (ADAP) Example**

In the following example, a request is made to print the properties for an object in a schema(.orx) file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-orx-object-prop&name=neworx&object=ldapserver&type=ldap
```
## set-orx-object-prop

This command sets properties for an object in a schema(.orx) file.

**Usage:**
<br>`set-orx-object-prop -name <name> - object <object> -type <type> [-basetable <basetable>] [-instance <instance>] [-objectclass <objectclass>] [-pkey <pkey>] [-rdnattr <rdnattr>] [-rdnname <rdnname>]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the file (.dvx or .orx) used with the command.

**`- object <object>`**
<br>[required] The name of the object in the ORX.

**`- type <type>`**
<br>[required] The type of schema (orx). Accepted values are: ldap, database.

**`- basetable <basetable>`**
<br>The base table property for the object.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- objectclass <objectclass>`**
<br>The LDAP Object Class for the object.

**`- pkey <pkey>`**
<br>The list of primary key attribute(s) for the object.

**`- rdnattr <rdnattr>`**
<br>The attribute(s) that will be used for the RDN value for the object

**`- rdnname <rdnname>`**
<br>The name of the RDN for the object.

**REST (ADAP) Example**

In the following example, a request is made to set properties for an object in a schema file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-orx-object-prop&name=neworx&object=ldapserver&type=ldap&pkey=cn
```

## list-orx-attr

This command prints out the list of attributes for an object in a schema(.orx) file.

**Usage:**
<br>`list-orx-attr -name <name> -object <object> -type <type> [-instance <instance>] [-properties]`

**Command Arguments:**

**`- name <name>`**
<br>[required] The name of the file (.dvx or .orx) used with the command.

**`- object <object>`**
<br>[required] The name of the object in the ORX.

**`- type <type>`**
<br>[required] The type of schema (orx). Accepted values are: ldap, database.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- properties
<br>Indicates that the command should print out the properties of the attributes in addition to the attribute names.

**REST (ADAP) Example**

In the following example, a request is made to print a list of attributes for an object in a schema file.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-orx-attr&name=neworx&object=ldapserver&type=ldap&properties
```
