---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Converting LDIF Files to CSV

This chapter describes how to convert an LDIF file into a CSV file using the
<RLI_HOME>/bin/vdsconfig utility.

## ldif-to-csv

This command converts an LDIF file into a CSV file.

**Usage**
<br>`ldif-to-csv -csv <csv> -ldif <ldif> [-returnattributes <returnattributes>]`

**Command Arguments**

**`- csv <csv>`**
<br>[required] The path to a CSV file. If the file exists, it will be overwritten.

**`- ldif <ldif>`**
<br>[required] The path to an LDIF file.

**`- returnattributes <returnattributes>`**
<br>Optional comma-separated list of specified return attributes.

**REST (ADAP) Example**

In the following example, a request is made to generate a CSV file containing three return attributes.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=ldif-to-csv&csv=c:/radiantone/vds/vds_server/ldif/export/csvfile.csv&ldif=c:/radiantone/vds/vds_server/ldif/export/accounting_companydirectory.ldif&returnattributes=dn,entrydn,homephone
```
