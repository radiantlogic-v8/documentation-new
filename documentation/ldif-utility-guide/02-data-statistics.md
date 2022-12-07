---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Chapter 2: Data Statistics

In general, knowing statistics about your data can be helpful for troubleshooting.

To get statistics about the entries in your view, you can use the LDIFStatistics function of the <RLI_HOME>/bin/advanced/ldif-utils utility. Once you have an LDIF file containing your entries, pass the file name and path to the utility. 

>**Note – if you have nested groups, and want them included in the results, include -n in the command.**

The syntax of the command is: 

```
ldif-utils LDIFStatistics -f <ldif_file_path> [-n (to get nested group stats)]
```

The results include the following statistics about entries (non-group), groups, and objectclasses: 

`###### Entries statistics ###### `
<br>Entry count – number of entries 
<br>Max attributes per entry 

`###### Non-group entry statistics ###### `
<br>AVG attributes per entry 
<br>Max entry size in bytes 
<br>AVG entry size in bytes 
<br>Max attribute size 
<br>AVG attributes size (non-objectclass) 

`###### Groups statistics ###### `
<br>Group count – number of group entries 
<br>Groups Statistics: [

    `### Groups SIZE_RANGE_NAME statistics ### `
    Group entry count 
    Max members 
    AVG members 
    Max entry size in bytes 
    AVG entry size in bytes 

`###### ObjectClass Statistics ###### `

    `### objectclass_name statistics ### `
    Entry count – number of entries 
    Max attributes per entry 
    AVG attributes per entry 
    Max entry size in bytes 
    AVG entry size in bytes 
    Max attribute size 
    AVG attributes size 
    RDN Types: [rdn_name] 
    Entry count per branch: {branch_dn=entrycount_x}, 

The following would be an example of the command and statistics returned. 

``
C:\radiantone\vds\bin\advanced>ldif-utils LDIFStatistics -f "C:\radiantone\vds\vds_server\ldif\export\mydirectory.ldif" 
``

`###### Entries statistics ######`

Entry count: 10014 
Max attributes per entry: 19 

`###### Non-group entry statistics ###### `

AVG attributes per entry: 8 
<br>Max entry size: 956 bytes 
<br>AVG entry size: 813 bytes 
<br>Max attribute size: 1 
<br>AVG attributes size (non-objectclass): 1

`###### Groups statistics ######`
<br>Group count: 2 
<br>Groups Statistics: [

    `### Groups LESS_THAN_10 statistics ###`
    -Group entry count: 1 
    -Max members: 2 
    -AVG members: 2 
    -Max entry size: 578 bytes 
    -AVG entry size: 578 bytes, 

    ### Groups BETWEEN_1K_AND_10K statistics ### 
    -Group entry count: 1 
    -Max members: 10000 
    -AVG members: 10000 
    -Max entry size: 571 KB 
    -AVG entry size: 571 KB] 

`###### ObjectClass Statistics ###### `

`### organization statistics ### `

    -Entry count: 1 
    -Max attributes per entry: 8 
    -AVG attributes per entry: 8 
    -Max entry size: 403 bytes 
    -AVG entry size: 403 bytes 
    -Max attribute size: 1 
    -AVG attributes size: 1 
    -RDN Types: [o] 
    -Entry count per branch: {root=1}, 

    `### groupofuniquenames statistics ### `
    -Entry count: 1 
    -Max attributes per entry: 9 
    -AVG attributes per entry: 9 
    -Max entry size: 578 bytes
    -AVG entry size: 578 bytes 
    -Max attribute size: 2 
    -AVG attributes size: 2 
    -RDN Types: [cn] 
    -Entry count per branch: {ou=groups,o=companydirectory=1}, 
    
    `### organizationalunit statistics ### `

    -Entry count: 11 
    -Max attributes per entry: 8 
    -AVG attributes per entry: 8 
    -Max entry size: 468 bytes 
    -AVG entry size: 439 bytes 
    -Max attribute size: 1 
    -AVG attributes size: 1 
    -RDN Types: [ou] 
    -Entry count per branch: {o=companydirectory=11}, 

    `### inetorgperson statistics ### `

    -Entry count: 10000 
    -Max attributes per entry: 19 
    -AVG attributes per entry: 19 
    -Max entry size: 956 bytes 
    -AVG entry size: 814 bytes 
    -Max attribute size: 1 
    -AVG attributes size: 1 
    -RDN Types: [uid] 
    -Entry count per branch: {ou=inventory,o=companydirectory=1000, 

ou=management,o=companydirectory=1000, ou=human resources,o=companydirectory=1000, ou=product development,o=companydirectory=1000, ou=accounting,o=companydirectory=1000, ou=information technology,o=companydirectory=1000, ou=customer service,o=companydirectory=1000, ou=sales,o=companydirectory=1000, ou=quality assurance,o=companydirectory=1000, ou=administration,o=companydirectory=1000}, 

    `### groupofurls statistics ### `

    -Entry count: 1
    -Max attributes per entry: 9 
    -AVG attributes per entry: 9 
    -Max entry size: 571 KB 
    -AVG entry size: 571 KB 
    -Max attribute size: 10000 
    -AVG attributes size: 10000 
    -RDN Types: [cn] 
    -Entry count per branch: {ou=groups,o=companydirectory=1}] 

Done in 1169ms
