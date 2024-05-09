---
title: REST API Configuration Guide
description: REST API Configuration Guide
---

## Introduction

RadiantOne offers a REST-based API that can be used for issuing configuration commands. Each chapter explains the different commands along with their syntax.

## How this Manual is Organized

This guide is broken down into the following chapters:

[Introduction](introduction.md)
<br>This chapter offers a quick introduction to this guide in addition to how the manual is organized and how to contact Radiant Logic technical support.

[Global Configuration Commands](global-configuration-commands.md)
<br>This chapter explains how to display and set RadiantOne global configuration property values.

[Node Configuration Commands](node-configuration-commands.md)
<br>This chapter explains how to display and set RadiantOne cluster node configuration property values.

[Data Source Commands](data-source-commands.md)
<br>This chapter describes how to create and delete database and LDAP data sources. It also explains how to update and print data source information.

[Naming Context Commands](naming-context-commands.md)
<br>This chapter describes how to create persistent caches, naming contexts, proxy naming contexts, and backup images of Universal Directory (HDAP) stores. It also describes how to delete naming contexts and their caches.

[Tree Hierarchy Commands](tree-hierarchy-commands.md)
<br>This chapter explains how to manage node properties in a virtual tree.

[Object and Attribute Commands](object-and-attribute-commands.md)
<br>This chapter explains how to perform various object and attribute commands including joins and merged trees.

[Task Launch Commands](task-launch-commands.md)
<br>This chapter describes how to launch tasks to initialize a cache, a Universal Directory (HDAP) store from LDIF file, and export data from an LDAP data source to LDIF file.

[Naming Context Property Commands](naming-context-property-commands.md)
<br>This chapter explains how to display a list of accepted property names, and how to set, print, and remove the current value for a property.

[ACI Commands](aci-commands.md)
<br>This chapter describes access control commands and how to configure them.

[LDAP Schema Commands](ldap-schema-commands.md)
<br>This chapter covers publishing and removing an ORX’s schema from the RadiantOne LDAP schema.

[Password Policy Commands](password-policy-commands.md)
<br>This chapter explains how to add, update, and remove a password policy.

[Log Settings Commands](log-settings-commands.md)
<br>This chapter describes how to configure log settings.

[Monitoring and Alert Settings Commands](monitoring-and-alert-settings-commands.md)
<br>This chapter describes how to configure monitoring and alert settings.

[Migration Commands](migration-commands.md)
<br>This chapter explains how to migrate resources from an existing development/QA environment to an existing production environment.

[Security Commands](security-commands.md)
<br>This chapter explains how to define the attribute encryption cipher and key. Commands to add and remove client certificates and enable FIPS-mode are also discussed.

[ORX and DVX Commands](orx-and-dvx-commands.md)
<br>This chapter explains how to list existing orx and dvx files, and view and test the connection to the backend data source associated with the files.

[Search Commands](search-commands.md)
<br>This chapter explains how to search the RadiantOne namespace.

[Real-time Persistent Cache Refresh Commands](real-time-persistent-cache-refresh-commands.md)
<br>This chapter explains how to configure real-time persistent cache refresh.

[Configuring Global Synchronization](global-sync-commands.md)
<br>This chapter explains how to configure the components used for global synchronization.

[Converting LDIF files to CSV](converting-ldif-files-to-csv.md)
<br>This chapter explains how to convert LDIF files to CSV.


## Issuing Commands Through ADAP (RESTFul Web Service)

The syntax of the URL is as follows.

`http://<RadiantOne_REST_Endpoint/adap/util?action=vdsconfig&commandname=<commandname>&<param>=<paramvalue>&<param>=<paramvalue>`

Results are returned in the response. A successful operation’s response contains an exit code value of 0 and a “systemOut” message. An unsuccessful operation’s response contains an exit code of 1 and a system error message. If a required parameter is missing from the URL, the response returns the following error.

`"SystemErr": "Parsing failed. Reason: Missing required option"`

Examples of ADAP requests follow the descriptions of the commands that support it in this guide.

## ADAP Response Format

ADAP responses are formatted as shown below.

![default ADAP response formatting](Media/Image1.1.jpg)


### Basic Password Authentication

All REST (ADAP) operations require a header which is used to bind to the RadiantOne LDAP service. If this header is not populated, an HTTP status 403 results. The user that performs the bind must be a member of one of the following RadiantOne delegated admin groups:

- Directory Administrator
- Namespace Administrator
- Operator
- ICS Administrator

An example is shown below.

```
Header name: Authorization
Header value: Basic <username>:<password>
Ex: Basic cn=directory manager:password
```
The username:password value can be passed base64 encoded.
Ex: Basic Y249ZGlyZWN0b3J5IG1hbmFnZXI6cGFzc3dvcmQ=

## Expert Mode

Some settings in the Control Panel are accessible only in Expert Mode. To switch to Expert Mode, click the Logged in as, (username) drop-down menu and select Expert Mode.

![expert mode](Media/expert-mode.jpg)

>[!note]
>The Main Control Panel saves the last mode (Expert or Standard) it was in when you log out and returns to this mode automatically when you log back in. The mode is saved on a per-role basis.


## Technical Support

Before contacting Customer Support, please make sure you have the following information:

- Version of RadiantOne.
- Type of computer you are using including operating system.
- The license number for your software.
- A description of your problem including error numbers if appropriate.

Technical support can be reached using any of the following options:

- E-mail: support@radiantlogic.com
- Website: https://support.radiantlogic.com
- Toll-Free Phone: 1-877-727-6442
