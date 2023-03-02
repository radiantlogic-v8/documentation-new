---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Chapter 4: Testing Attribute Uniqueness

To test attribute uniqueness, you must have an LDIF file containing all entries you want to check attribute uniqueness for. 

To verify uniqueness of attribute values in an LDIF, you can use the Attribute Uniqueness function of the <RLI_HOME>/bin/advanced/ldif-utils utility. Once you have an LDIF file containing entries, pass the file name, path, and the name(s) of the attribute(s) to be verified. The usage is shown below. 

```
`ldif-utils AttrUniqueness -f <ldif file path> -u <list of (comma-separated) attributes>`
```

An example command analyzing values for the attributes givenName and telephonenumber is shown below. 

```
c:\radiantone\vds\bin\advanced>ldif-utils.bat AttrUniqueness -f c:\globaldirectory.ldif -u givenname,telephonenumber 
```

If the utility returns the result, “Attribute Uniqueness check successful”, the values for the analyzed attribute(s) are unique. In this example, the utility returns the following at the end of completion of the command. 

Checking attribute uniqueness... 
<br>Attribute Uniqueness check successful.
<br>Done in 9ms 

In the following example command, the attributes givenName and facsimiletelephonenumber are analyzed. 

```
c:\radiantone\vds\bin\advanced>ldif-utils.bat AttrUniqueness -f c:\globaldirectory.ldif -u givenname,facsimiletelephonenumber 
```

If the utility returns the result, “Attribute Uniqueness check result false”, entries sharing the same value for at least one analyzed attribute were detected. In this example, the utility returns the following at the end of completion of the command. 

Checking attribute uniqueness... 
<br>Attribute Uniqueness check result false. Entries with duplicates: 
<br>uid=bgreene,ou=users,o=globaldirectory 
<br>uid=cbaldwin,ou=users,o=globaldirectory 
<br>uid=fhostetler,ou=users,o=globaldirectory 
<br>uid=jhiggins,ou=users,o=globaldirectory 
<br>uid=kchung,ou=users,o=globaldirectory 
<br>uid=mhue,ou=users,o=globaldirectory 
<br>uid=mpoole,ou=users,o=globaldirectory 
<br>uid=owright,ou=users,o=globaldirectory 
<br>uid=ytanaka,ou=users,o=globaldirectory 
<br>Done in 12ms
