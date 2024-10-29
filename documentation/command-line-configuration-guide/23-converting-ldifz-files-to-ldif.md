---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Decrypt LDIFZ Files to LDIF

This chapter describes how to decrypt an LDIFZ file into an LDIF file using the
<RLI_HOME>/bin/vdsconfig utility.

## ldifz-to-ldif

This command decrypts an LDIFZ file into an LDIF file.
 

**Usage**
<br>`ldifz-to-ldif -pwdfile <PathToPwdFile> -ldifz <PathToLdifzFile> -ldif <PathToDecryptedLdifFile>`


**Command Arguments**

`- pwdfile <PathToPwdFile>`
<br>[required] The path to a file containing the password for the RadiantOne directory super user (e.g. cn=directory manager). This command requires Directory administrator credentials in order to extract the secret key required to decrypt the ldifz file.

`- ldifz <PathToLdifzFile>`
<br>[required] The path to an LDIFZ file.

`- ldif <PathToLdifFile>`
<br>[required] The path to the decrypted file.


**Example**

radiantone/vds/bin/vdsconfig.sh ldifz-to-ldif -pwdfile /home/ec2-user/rootpwd -ldifz /home/ec2-user/radiantone/vds/vds_server/ldif/export/encyrpted.ldifz -ldif /home/ec2-user/radiantone/vds/vds_server/ldif/export/decrypted.ldif
