---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Determining if Persistent Cache is Out of Sync

To determine if a persistent cache image is out of sync from the backends, you can compare two LDIF files using the ldif-utils utility located at <RLI_HOME>/bin/advanced. The usage is shown below. 

`ldif-utils -c <ldif1> <ldif2> [-i <ignoredAttributes>] [-g true/false] [-w <ldif> (to write LDIF difference)]`

Certain attributes are ignored in the comparison by default (as they are specific to RadiantOne FID and generally not applicable). The default ignored attributes are: createtimestamp, ds-sync-generation-id, vdssynchist, entryuuid, modifiersname, cachecreatetimestamp, ds-sync-hist, ds-sync-state, creatorsname, cachemodifytimestamp, vdssynccursor, modifytimestamp, cachecreatorsname, cachemodifiersname, uuid, and vdssyncstate. If you would like to add attributes to be ignored, use the -i flag. If you would like the comparison to stop as soon as there are differences found, use -g false (-g true means the comparison continues even when differences are found). If you would like to generate a report that lists the differences between the two LDIFs, use the -w flag, including the file path.

An example of how to use this utility is described below. 

1.	Generate an LDIF file from the persistent cache contents. An easy way to do this is with the 3rd party ldapsearch command line utility (not included with RadiantOne). An example command accessing a branch in RadiantOne FID that is in persistent cache (o=aggregatedview) is shown below. The output is a file named cache.ldif. 

    `C:\ ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "o=aggregatedview" (objectclass=*) > C:\radiantone\vds\bin\advanced\cache.ldif`

2.	Generate an LDIF file from the view of the backend (not in the cache). An easy way to do this is with the 3rd party ldapsearch command line utility (not included with RadiantOne). An example command accessing a branch in RadiantOne FID and bypassing the cache by prefixing the dn with “action=ignorecache” is shown below. The output is a file named nocache.ldif. 

    `C:\ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "action=ignorecache,o= aggregatedview " (objectclass=*) > C:\radiantone\vds\bin\advanced\nocache.ldif `

3.	Now, the LDIF files must be sorted. Use the -s flag with ldif-utils to sort the files. Examples are shown below. 

    `C:\radiantone\vds\bin\advanced>ldif-utils.bat -s cache.ldif`
    <br> `Using RLI home : C:\radiantone\vds`
    <br> `Using Java home : C:\radiantone\vds\jdk\jre`
    <br> `Start sorting...`
    <br> `Done total entry sorted: 13 Done in 80ms `
    <br> `C:\radiantone\vds\bin\advanced>ldif-utils.bat -s nocache.ldif`
    <br> `Using RLI home : C:\radiantone\vds`
    <br> `Using Java home : C:\radiantone\vds\jdk\jre`
    <br> `Start sorting...`
    <br> `Done total entry sorted: 13`
    <br> `Done in 79ms `

4.	After sorting, you will have <filename>.ldif.sorted for each file. E.g. cache.ldif.sorted and nocache.ldif.sorted. These are the files to compare. Below is an example of the command to issue to compare the LDIF files: 

`C:\radiantone\vds\bin\advanced>ldif-utils.bat -c cache.ldif.sorted nocache.ldif.sorted -i userPassword -g true -w c:/radiantone/vds/vds_server/ldif/export/LDIFReport.ldif`
<br> `Using RLI home : C:\radiantone\vds`
<br> `Using Java home : C:\radiantone\vds\jdk\jre`
<br> `Start comparison...`
<br> `Ldif comparison done on 13 entries - result=true`
<br> `Done in 57ms `

The example result shown above (result=true) indicates that the two LDIF files are equal and hence the persistent cache is in sync with the backend data sources. If the two LDIF files were not equal (result=false), the result would indicate the DN for the entries that are different. Below is an example of a result when one entry between the two compared files is different: 

Start comparison... 
!= Difference found on uid=logan_oliver@radiant.com,o=adaggregation 
Ldif comparison done on 13 entries - result=false 
Done in 55ms 

If there are many differences found between the persistent cache image and the backend data sources, it is generally best to reinitialize the persistent cache. If there are not many differences, it can be helpful to go through the RadiantOne FID log files and the connector log files (if real-time refresh is used) in addition to checking the cn=cacherefreshlog naming context in RadiantOne FID to see if you can determine the cause of the persistent cache not being updated.
