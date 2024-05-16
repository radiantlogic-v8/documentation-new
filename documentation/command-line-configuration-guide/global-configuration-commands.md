---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Global Configuration Commands

Many properties can be modified manually from the Main Control Panel > Zookeeper tab (edit mode).

![Zookeeper tab](Media/Image3.1.jpg)

RadiantOne properties can also be defined on the Settings tab in the Main Control Panel.

This chapter explains how to display and set RadiantOne configuration property values using the REST API instead of using the UI mentioned above.

## product-info

This command displays the product information for RadiantOne. This includes Product (name), Version, Build, Build-Id, Date (build date), RadiantOne home (install directory), License type, Licensed product, Licensed to, License expires (if temp license) and License ID.

**REST (ADAP) Example**
<br> The following example describes how to issue the request through ADAP.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=product-info`

## list-properties

This command displays the contents of the RadiantOne configuration.

**Usage:**
<br> `list-properties [-instance <instance>]`

**Command Arguments:**

`- instance <instance>`
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
<br> In the following example, a request is made to display RadiantOne configuration information.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-properties`

## get-property

This command displays the value of a property in the RadiantOne configuration.

**Usage:**
<br> `get-property -name <name> [-instance <instance>]`

>[!note]
>Properties that contain a password value do not return with the get-property command. A message is returned indicating, “The property XXX contains a password and cannot be displayed.”

To list supported SSL cipher suites, use the list-cipher-suites command.

**Command Arguments:**

**`- name <name>`**
<br> [required] The name of the property. This is case sensitive, except for vdshttpPort and vdshttpsPort.
**`- instance <instance>`**
<br> The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**REST (ADAP) Example**
In the following example, a request is made to display the RadiantOne service LDAP port number.

`https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-property&name=ldapPort`

## set-property

This command sets the value of a property in the RadiantOne configuration.

**Usage:**
<br> `set-property -name <name> -value <value> [-instance <instance>] [-pwdfile <path to file>]`

>>[!note]
>Updating properties containing a password value requires the super user (e.g. cn=directory manager) credentials. You are prompted to enter this password interactively. To pass the credentials in the command, use the - pwdfile flag. See the Examples section below. To set the current list of enabled SSL cipher suites, use the set-cipher-suites command.

**Command Arguments:**

**`- name <name>`**
<br> [required] The name of the property. This is case sensitive, except for vdshttpPort and vdshttpsPort.

**`- value <value>`**
<br> [required] The value of the property. The value can be provided in a file. To indicate a file, use the following syntax: file:::/path/to/file. An example is shown below:

```
radiantone/vds/bin/vdsconfig.sh set-property -name virtualStaticGroupDNs -value file:::/home/files/dyngroup.txt
```

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- pwdfile <full path to file>`**
<br>To pass the super user (e.g. cn=directory manager) credentials in a file instead of interactively in the command. To use, save the current password into a text file and then pass the full path to this file in the -pwdfile flag. This is only applicable when setting the value of a property that contains a password, as this requires the directory manager credentials. See examples below for more details.


### REST (ADAP) Example

In the following example, a request is made to modify the LDAP port to 9999.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-property&name=ldapPort&value=9999
```

