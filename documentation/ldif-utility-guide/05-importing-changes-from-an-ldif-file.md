---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Chapter 5: Importing Changes from an LDIF File

Entries can be added, modified, and deleted based on changes described in an LDIF formatted file using the ldif-utils utility located at <RLI_HOME>/bin/advanced. The command syntax to import an LDIF file is shown below.


`ldif-utils ImportLdifChanges -f <ldif_file_path> -d <datasource_name>  [-g true/false (continueOnError;default=true)]`

An example of the syntax used inside the LDIF file is shown below.

dn: cn=GBS-ES-ActiveEmployees-US,ou=groups,o=world
<br>changeype: modify
<br>add: member
<br>member: uid=en1531,ou=people,ou=rli,o=world
<br>member: uid=en1537,ou=people,ou=rli,o=world
<br>member: uid=en1494,ou=people,ou=rli,o=world
<br>-
<br>dn: cn=GLO-PG-NOFUNCTION,ou=groups,o=world
<br>changeype: modify
<br>add: member
<br>member: uid=en1314,ou=people,ou=rli,o=world
<br>member: uid=en1494,ou=people,ou=rli,o=world

