---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Determining if Persistent Cache is Out of Sync

To determine if a persistent cache image is out of sync from the backends, you can compare two LDIF files using the ldif-utils utility located at <RLI_HOME>/bin/advanced. The usage is shown below. 

`ldif-utils -c <ldif1> <ldif2> [-i <ignoredAttributes>] [-g true/false] [-w <ldif> (to write LDIF difference)] [-e <excludeDN>] [--excludeDN <excludeDN>]`

Certain attributes are ignored in the comparison by default (as they are specific to RadiantOne FID and generally not applicable). The default ignored attributes are: createtimestamp, ds-sync-generation-id, vdssynchist, entryuuid, modifiersname, cachecreatetimestamp, ds-sync-hist, ds-sync-state, creatorsname, cachemodifytimestamp, vdssynccursor, modifytimestamp, cachecreatorsname, cachemodifiersname, uuid, and vdssyncstate. If you would like to add attributes to be ignored, use the -i flag. If you would like the comparison to stop as soon as there are differences found, use -g false (-g true means the comparison continues even when differences are found). If you would like to generate a report that lists the differences between the two LDIFs, use the -w flag, including the file path.

If you would like to exclude specific entries or entire branches from the comparison and from the generated difference file, use the -e flag (or --excludeDN) followed by a DN:

- **Exact and subtree matching:** Specifying a base DN (for example, `-e "ou=temp,dc=example,dc=com"`) excludes that entry and all entries beneath it. Specifying a leaf entry excludes only that entry.
- **Repeatable:** Specify -e or --excludeDN multiple times to exclude multiple entries or branches (for example, `-e "ou=contractors,dc=example,dc=com" -e "cn=admin,o=root"`). Both the `-e "<dn>"` and `--excludeDN="<dn>"` syntaxes are supported.
- **Case-insensitive:** DN matching is case-insensitive.
- **Difference file:** Excluded entries are skipped before differences are evaluated, so they do not appear as add, modify, or delete operations in the file generated with -w.
- **Reporting:** The console output reports the number of entries excluded from each file during the comparison. For example: `Excluded entries during comparison: file1.ldif=4, file2.ldif=2`

An example of how to use this utility is described below. 

1.	Generate an LDIF file from the persistent cache contents.

    An easy way to do this is with the 3rd-party `ldapsearch` command-line utility (not included with RadiantOne). An example command accessing a branch in RadiantOne FID that is in persistent cache (`o=aggregatedview`) is shown below. The output is saved to `cache.ldif`:

    `C:\ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "o=aggregatedview" (objectclass=*) > C:\radiantone\vds\bin\advanced\cache.ldif`

2.	Generate an LDIF file from the view of the backend (bypassing the cache).

    Access the branch in RadiantOne FID and bypass the cache by prefixing the DN with `action=ignorecache`. The output is saved to `nocache.ldif`:

    `C:\ldaputility>ldapsearch -h localhost -p 2389 -D "cn=directory manager" -w password -b "action=ignorecache,o=aggregatedview" (objectclass=*) > C:\radiantone\vds\bin\advanced\nocache.ldif`

3.	Sort the LDIF files.

    The LDIF files must be sorted prior to comparison. Use the `-s` flag with `ldif-utils`:

    `C:\radiantone\vds\bin\advanced>ldif-utils.bat -s cache.ldif`
    <br> `Using RLI home : C:\radiantone\vds`
    <br> `Using Java home : C:\radiantone\vds\jdk\jre`
    <br> `Start sorting...`
    <br> `Done total entry sorted: 13 Done in 80ms`
    <br> `C:\radiantone\vds\bin\advanced>ldif-utils.bat -s nocache.ldif`
    <br> `Using RLI home : C:\radiantone\vds`
    <br> `Using Java home : C:\radiantone\vds\jdk\jre`
    <br> `Start sorting...`
    <br> `Done total entry sorted: 13`
    <br> `Done in 79ms`

    After sorting, each file will have a `.sorted` extension (e.g., `cache.ldif.sorted` and `nocache.ldif.sorted`).

4.	Compare the sorted LDIF files.

    Run the comparison command with your desired options:

    `C:\radiantone\vds\bin\advanced>ldif-utils.bat -c cache.ldif.sorted nocache.ldif.sorted -i userPassword -g true -e "ou=temp,o=aggregatedview" -w c:/radiantone/vds/vds_server/ldif/export/LDIFReport.ldif`
    <br> `Using RLI home : C:\radiantone\vds`
    <br> `Using Java home : C:\radiantone\vds\jdk\jre`
    <br> `Start comparison...`
    <br> `Excluded entries during comparison: cache.ldif.sorted=2, nocache.ldif.sorted=2`
    <br> `Ldif comparison done on 11 entries - result=true`
    <br> `Done in 57ms`

    - `result=true`: Indicates the two LDIF files are equal (after accounting for ignored attributes and excluded DNs), meaning the persistent cache is in sync with the backend.
    - `result=false`: Indicates differences were found. The output lists the DNs of differing entries:

        `Start comparison...`
        <br> `!= Difference found on uid=user1@radiantlogic.com,o=aggregatedview`
        <br> `Ldif comparison done on 13 entries - result=false`
        <br> `Done in 55ms`

If many differences are found between the persistent cache image and the backend data sources, reinitializing the persistent cache is generally recommended. If only a small number of differences exist, inspect the RadiantOne FID logs, connector refresh logs (for real-time refresh), and the `cn=cacherefreshlog` naming context in RadiantOne FID to determine why the persistent cache was not updated.
