---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Chapter 6: Exporting Entries from an LDAP Directory to an LDIF File

Entries can be exported from an LDAP directory into an LDIF file using the following command. 

`ldif-utils.bat ExportLDIF  -l <ldif_file_path> -b <baseDn>  -f <filter> -h <hostname> -u <username> -w <password> -p <port> -i <ignored-attributes (comma separated)>`
