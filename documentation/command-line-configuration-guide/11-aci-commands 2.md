---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

## Chapter 11: ACI Commands

Access controls are managed from the Main Control Panel -> Settings tab -> Security section ->
Access Control and can also be managed from command line.

This chapter describes how to configure access controls using the <RLI_HOME>/bin/vdsconfig
utility instead of the UI mentioned above.

### list-acis

This command lists all the Access Control Instructions.

Usage:
list-acis -dn <dn> [-instance <instance>]

Command Arguments:

- dn <dn>
[required] The target DN to add ACI to.
- instance <instance>
The name of the RadiantOne instance. If not specified, the default instance named vds_server
is used.

REST (ADAP) Example
In the following example, a request is made to list all ACIs configured for ou=allprofiles.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-
acis&dn=ou=allprofiles
```

### get-aci

This command gets/exports an Access Control Instruction.

Usage:
get-aci -aciname <aciname> -dn <dn> [-file <file>] [-instance <instance>]

Command Arguments:

- aciname <aciname>
[required] The name of the ACI to fetch.
- dn <dn>
[required] The target DN to add ACI to.
- file <file>
The file to export the ACI to.
- instance <instance>
The name of the RadiantOne instance. If not specified, the default instance named vds_server
is used.

REST (ADAP) Example
In the following example, a request is made to export the ACI configured for ou=AllProfiles.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-
aci&dn=ou=allprofiles&aciname=AllProfiles
ACI&file=c:/radiantone/vds/vds_server/AllProfilesACI
```
### add-aci

This command creates/imports an Access Control Instruction.

Usage:
add-aci -dn <dn> [-file <file>] [-instance <instance>] [-value <value>]

Command Arguments:

- dn <dn>
[required] The target DN to add ACI to.
- file <file>
The file containing the ACI to add to RadiantOne.
- instance <instance>
The name of the RadiantOne instance. If not specified, the default instance named vds_server
is used.


- value <value>
The ACI to add to RadiantOne.

REST (ADAP) Example
In the following example, a request is made to add an ACI to ou=AllProfiles.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=add-
aci&dn=ou=allprofiles&file=c:/radiantone/vds/vds_server&value=AllProfilesACI
```
### clear-aci

This command removes all Access Control Instructions for a given DN.

Usage:
clear-aci -dn <dn> [-instance <instance>]

Command Arguments:

- dn <dn>
[required] The DN in which all ACIs are removed.
- instance <instance>
The name of the RadiantOne instance. If not specified, the default instance named vds_server
is used.

REST (ADAP) Example
In the following example, a request is made to remove ACIs configured for ou=AllProfiles.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=clear-
aci&dn=ou=allprofiles
```
