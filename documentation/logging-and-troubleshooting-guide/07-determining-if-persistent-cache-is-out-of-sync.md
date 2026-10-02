---
title: Logging and Troubleshooting
description: Logging and Troubleshooting
---

# Determining if Persistent Cache is Out of Sync

RadiantOne includes a command line utility to help determine if a persistent cache image is out of sync from the backends. This utility is named ldif-utils located in <RLI_HOME>/bin/advanced and it can compare two LDIF files. The usage is shown below.

`ldif-utils -c <ldif1> <ldif2> [-i <ignoredAttributes>] [-g true/false] [-w <ldif> (to write LDIF difference)] [-e <excludeDN>] [--excludeDN <excludeDN>]`

Certain attributes are ignored in the comparison by default (as they are specific to RadiantOne and generally not applicable). The default ignored attributes are: createtimestamp, ds-sync-generation-id, vdssynchist, entryuuid, modifiersname, cachecreatetimestamp, ds-sync-hist, ds-sync-state, creatorsname, cachemodifytimestamp, vdssynccursor, modifytimestamp, cachecreatorsname, cachemodifiersname, uuid, and vdssyncstate. If you would like to add attributes to be ignored, use the -i flag. If you would like the comparison to stop as soon as there are differences found, use -g false (-g true means the comparison continues even when differences are found). If you would like to generate a report that lists the differences between the two LDIFs, use the -w flag, including the file path.

If you would like to exclude specific entries or entire branches from the comparison and from the generated difference file, use the -e flag (or --excludeDN) followed by a DN:

- **Exact and subtree matching:** Specifying a base DN (for example, `-e "ou=temp,dc=example,dc=com"`) excludes that entry and all entries beneath it. Specifying a leaf entry excludes only that entry.
- **Repeatable:** Specify -e or --excludeDN multiple times to exclude multiple entries or branches (for example, `-e "ou=contractors,dc=example,dc=com" -e "cn=admin,o=root"`). Both the `-e "<dn>"` and `--excludeDN="<dn>"` syntaxes are supported.
- **Case-insensitive:** DN matching is case-insensitive.
- **Difference file:** Excluded entries are skipped before differences are evaluated, so they do not appear as add, modify, or delete operations in the file generated with -w.
- **Reporting:** The console output reports the number of entries excluded from each file during the comparison. For example: `Excluded entries during comparison: file1.ldif=4, file2.ldif=2`

An example of how to use this utility is described below.

1.	Generate an LDIF file from the persistent cache contents. An easy way to do this is with the 3rd party ldapsearch command line utility (not included with RadiantOne). An example command accessing a branch in the RadiantOne namespace that is in persistent cache (o=aggregatedview) is shown below. The output is a file named cache.ldif.

    ```
    C:\ ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "o=aggregatedview" (objectclass=*) > C:\radiantone\vds\bin\advanced\cache.ldif
    ```

2.	Generate an LDIF file from the view of the backend (not in the cache). An easy way to do this is with the 3rd party ldapsearch command line utility (not included with RadiantOne). An example command accessing a branch in the RadiantOne namespace and bypassing the cache by prefixing the dn with “action=ignorecache” is shown below. The output is a file named nocache.ldif.

    ```
    C:\ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "action=ignorecache,o= aggregatedview " (objectclass=*) > C:\radiantone\vds\bin\advanced\nocache.ldif
    ```

3.	Now, the LDIF files must be sorted. Use the -s flag with ldif-utils to sort the files. Examples are shown below.

    ```C:\radiantone\vds\bin\advanced>ldif-utils.bat -s cache.ldif```

    `Using RLI home : C:\radiantone\vds
    Using Java home : C:\radiantone\vds\jdk\jre
    Start sorting...
    Done total entry sorted: 13
    Done in 80ms`

    ```C:\radiantone\vds\bin\advanced>ldif-utils.bat -s nocache.ldif```

    `Using RLI home : C:\radiantone\vds
Using Java home : C:\radiantone\vds\jdk\jre
Start sorting...
Done total entry sorted: 13
Done in 79ms`

4.	After sorting, you will have `<filename>`.ldif.sorted for each file. E.g. cache.ldif.sorted and nocache.ldif.sorted. These are the files to compare. Below is an example of the command to issue to compare the LDIF files:

    ```
    C:\radiantone\vds\bin\advanced>ldif-utils.bat -c cache.ldif.sorted nocache.ldif.sorted -i userPassword -g true -w c:/radiantone/vds/vds_server/ldif/export/LDIFReport.ldif
    ```

    `Using RLI home : C:\radiantone\vds
    Using Java home : C:\radiantone\vds\jdk\jre
    Start comparison...
    Ldif comparison done on 13 entries - result=true
    Done in 57ms`

The example result shown above (result=true) indicates that the two LDIF files are equal and hence the persistent cache is in sync with the backend data sources. If the two LDIF files were not equal (result=false), the result would indicate the DN for the entries that are different. Below is an example of a result when one entry between the two compared files is different:

`Start comparison...
!= Difference found on uid=logan_oliver@radiant.com,o=adaggregation
Ldif comparison done on 13 entries - result=false
Done in 55ms`

For an example that excludes entries from the comparison with the -e flag, see [Determining if Persistent Cache is Out of Sync](/ldif-utility-guide/03-determining-if-persistent-cache-is-out-of-sync) in the LDIF Utility Guide.

If there are many differences found between the persistent cache image and the backend data sources, it is generally best to reinitialize the persistent cache. If there are not many differences, it can be helpful to go through the RadiantOne service [log files](03-radiantone-universal-directory.md#radiantone-server-log) and the connector log files (if real-time refresh is used) in addition to checking the cn=cacherefreshlog naming context in RadiantOne to see if you can determine the cause of the persistent cache not being updated. 
