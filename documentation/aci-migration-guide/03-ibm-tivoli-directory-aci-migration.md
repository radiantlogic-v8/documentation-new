---
title: ACI Migration Guide
description: ACI Migration Guide
---

# Chapter 3: IBM Tivoli Directory ACI Migration

This chapter describes how to migrate IBM Tivoli Directory ACI to RadiantOne v7. Starting in RadiantOne v7.2, the migration tool, ibmAciMigration.bat (.sh on Unix systems), migrates IBM Tivoli Directory ACI to RadiantOne v7 ACI. This tool is located at <RLI_HOME>\bin\advanced.

## Preparing Properties Files

Before running the migration tool, two properties files must be created. The migration tool examines the contents of these files.

### Creating the Configuration Properties File

First, the configuration properties file must be created. The values specified in this file contain the URL of the IBM server, login credentials for the server, and the destination of the output file.

To create the properties files:

1. Open a file editor, such as Notepad.
2. Paste the following into the Notepad file.
    <br>serverURL=
    <br>bindDN=
    <br>password=
    <br>outputFile=
3. Enter values for each of the above fields.
    <br>**serverURL**: The value for this field indicates the URL of the IBM server.
    <br>**bindDN**: The value for this field indicates the bind DN used to authenticate on the IBM server. For example, cn=directory manager.
    <br>**password**: The value for this field indicates the password associated with the bindDN used to authenticate on the IBM server.
    <br>**outputFile**: The value for this field indicates the path to the file, including the file name itself,that will contain the converted ACI.
    <br>Below is an example of a completed configuration properties file.

```
serverURL=ldap://10.11.9.15:389/dc=lgsmall
bindDN=cn=directory manager
password=Password
outputFile=C:\genldif\output.ldif
```
4. Save the file with a .properties file extension type. In this example, the file is saved as “config.properties”. Record the saved location of this file as it is required for the migration command.

### Creating the Mapping Properties File

Next, the mapping properties file must be created. This file contains the mappings between the attribute classes from IBM to the corresponding attributes in RadiantOne. There five attribute classes: critical, system, restricted, normal and sensitive.

1. In a file editor’s main menu, select File > New.
2. Paste the following into the Notepad file.
    <br>critical=
    <br>system=
    <br>restricted=
    <br>normal=
    <br>sensitive=
3. Enter values for each of the above fields. Each category determines which users have access to the attributes. All of an LDAP object’s attributes must be included in one of the five categories. If one or more of the LDAP object’s attributes is not included in one of the five attribute categories, the migration tool displays an error. If you have no attributes for a category, do not enter a value for that attribute. Attributes are separated by double “|” characters. The syntax is as follows.

    `<attributetype>=<attribute> || <attribute> || `<attribute>

    Below is an example of a completed mapping properties file.
    <br>critical=username || l
    <br>system=
    <br>restricted=phone || mail
    <br>normal=postalcode || ou
    <br>sensitive= postaladdress
4. Save the file with a .properties file extension type. In this example, the file is saved as mapping.properties. Record the saved location of this file as it is required for the migration command.

## Running the IBM ACI Migration Utility

This utility employs two parameters. Parameters are written in a command line. Both
parameters are required.

1. Open a command processor.
2. In the command processor, navigate to <RLI_HOME>\bin\advanced.
3. Run ibmAciMigration.bat (.sh on Unix systems) as follows.

### Command Syntax

```
ibmAciMigration.bat <configurationfilelocation> <mappingfilelocation>
```
NOTE – The command argument `<configurationfilelocation>` is the path to the configuration properties file. The command argument `<mappingfilelocation>` is the path to the mapping properties file. These files were configured in the Preparing Properties Files section.

### Example

```
ibmAciMigration.bat C:\genldif\config.properties C:\genldif\mapping.properties
```
The utility extracts and converts the IBM Tivoli Directory ACI to an ACI format compatible with RadiantOne v7 in the location specified by the outputFile value (this was configured in the [Creating the Configuration Properties File](#creating-the-configuration-properties-file) section). The ACI are now ready to be imported into RadiantOne manually. For more information on RadiantOne ACI, refer to the RadiantOne System Administration Guide.
