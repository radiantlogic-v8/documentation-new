---
title: Deployment and Tuning Guide
description: Deployment and Tuning Guide
---

# Chapter 4: Tuning Tips for RadiantOne Universal Directory

The RadiantOne platform offers an LDAP v3 compliant storage that can be used to store any entries.  After the root naming context is created, the local store can be populated from an LDIF file or manually on the Main Control Panel -> Directory Browser Tab. RadiantOne can support multiple Universal Directory stores. 

>[!warning] Details about each of the parameters mentioned below can be found in the RadiantOne System Administration Guide. This document is only for pointing out these parameters as key to review when tuning RadiantOne.**

## Indexed Attributes

Verify that all attributes that are searchable (used in a filter or requested) from LDAP clients are listed in the Index parameter for the local storage. This can be verified from the Main Control Panel -> Directory Namespace tab. Select the RadiantOne Universal Directory store below the Root Naming Contexts node. The indexed attributes are shown on the right side, Properties tab. If the list is empty, all attributes are indexed by default (except for binary attributes and any attribute listed in the Non Indexed Attributes parameter). Otherwise enter a comma separated list of attribute names. If the VLV/Sort control is enabled for RadiantOne, you can indicate a list of attributes to maintain a special index for in the Sorted Attributes property.

![An image showing ](Media/Image4.1.jpg)
 
Figure 4.1: RadiantOne Universal Directory Index Lists

### Non-Indexed Attributes

If possible, add attributes that must be modified frequently (e.g. pwdLastLogonTime) to the non-indexed attributes list to improve update performance of the RadiantOne Universal Directory. Attributes that don’t need to be used in searches are good candidates for the non-indexed attribute list.  Limit the number of configured non-indexed attributes to further improve update performance.

The userPassword, description and pwdLastLogonTime attributes are in the non-indexed list by default along with some other operational attributes.

### Support for Full Text Search

RadiantOne Universal Directory supports full text searches. This offers additional flexibility for clients as they can search data based on text (character) data. These types of searches are no longer linked to specific attributes as the characters requested could be found in any attribute value. An entry is returned by RadiantOne if any attribute in the entry contains the character string/s requested by the client.

Clients issue full text searches like they issue LDAP searches. The only difference is the filter contains (fulltext=<value>) where <value> would be the text they are interested in. As an example, if a client was interested in the text John Doe as an exact phrase, the search filter sent to RadiantOne would be (fulltext= “John Doe”) where the phrase is encapsulated in double quotes. If the phrase in the filter is not encapsulated in double quotes it means the client wants any entries that have attribute values that contain the character string John OR Doe.

The part of the filter that contains the piece related to the full text search can also be combined with other “standard” LDAP operators. As an example, a filter could be something like (&(uid=sjones)(fulltext=”John Doe”)). This would return entries that contain a uid attribute with the value sjones AND any other attribute that contains the exact character string John Doe.

Filters can also leverage the NEAR operator in full text searches. When using the NEAR operator, the indicated texts must be in the same attribute value. The two examples below describe the usage.

1. (fulltext~="A B")
When processing this filter, RadiantOne returns all the entries containing an attribute value with A before B and A near B. The examples below show different possible values for an attribute and whether or not they would match the fulltext filter: 
	-	"A Z B C D" (matches the filter)
	-	"A Z C D B" (doesn't match the filter, A not near enough to B)
	-	"B Z A C D" (doesn't match the filter, A is after B)

	When you search for A NEAR B, RadiantOne looks at all the entries with an attribute value containing A and B where B and A have a maximum of 2 words in between.

2. (fulltext~=A B)

	When processing this filter, RadiantOne returns all the entries containing an attribute value with A near B. The examples below show different possible values for an attribute and whether they would match the fulltext filter:

	-	"A Z B C D" (matches the filter)

	-	"A Z C D B" (doesn't match the filter, A not near enough to B)

	-	"B Z A C D" (matches the filter)

	To support full text searches, check the Full-Text Search option on the Properties tab for the select store and click Save. If you add support for full text searches, re-build the index. To do so, select the naming context below Root Naming Contexts on the Configuration tab and on the Properties tab on the right side, click the Re-build Index button.
## Memory

The memory required to host data in the Universal Directory is unrelated to the memory allocated to RadiantOne service (for the JVM). The Universal Directory storage leverages Memory Mapping Files (MMapDirectory) which uses virtual memory and a kernel feature called “mmap” to access the disk files. To estimate the amount of memory required to house your stores, take the size of the LDIF file (that stores all the entries) and multiply it times 2. This is also roughly equivalent to: (`<number of entries> x <size of an entry>` x 2). For example, if you needed to store 1 million entries each 1 KB in size (results in about 1 GB sized LDIF file), approximately 2-3 GB of memory would be required.

>[!warning] when RadiantOne is deployed primarily for local Universal Directory stores on machines with large amounts of memory (e.g. 32GB), it is recommended to [set a max JVM (-Xmx) for the RadiantOne](01-global-tuning#memory-size) service instead of letting it expand to ¼ of the available memory. This leaves more memory for the local stores to ensure optimal performance.

## Storage Location

The default location for Universal Directory data files is <RLI_HOME>\vds_server\data. To tune the local disk load, you can specify a different location on the file system. If RadiantOne is deployed in a cluster, the value of the storage location parameter is also assigned to all other nodes. The drive location indicated in the value must exist on the file system of each node. The nodes cannot leverage a single shared drive.

Any data in the default location is lost if the storage location is changed. If you have data in the existing location that you want to keep, export it to an LDIF file and after the storage location is changed, import this LDIF file.

## Changelog

Changes to RadiantOne Universal Directory data are logged into the changelog (cn=changelog branch). This is only required if you have applications that need to detect changes on the data and propagate them to other targets/applications. If you do not have this requirement, it is recommended that you disable the changelog for your store. This can alleviate unnecessary disk saturation.

To disable the changelog, navigate to the Main Control Panel > Settings tab > Logs > Changelog. You can disable it globally (for all stores) or for a specific naming context.

## Statistics

For each Universal Directory store initialization, statistics are calculated for the total number of entries and sub-categorized by branches and object classes. The average and peak number of attributes per entry, and the average and peak size (in KB) per entry are also calculated. This information is logged into the <RLI_HOME>/vds_server/logs/stats.log. If you don’t care about statistics, you can improve the performance of initialization by disabling the statistics logging.  This logging is enabled by default and can be managed from the Main Control Panel > Settings Tab > Logs section > Statistics > Init Statistics Settings sub-section.

## Replication 
If you configure replication for Universal Directory stores across clusters, and the bandwidth between the clusters is low (e.g. 10 Megabits/sec), increasing the ReplicationPollChunkSize can help improve replication efficiency. The ReplicationPollChunkSize can be modified using <RLI_HOME>/bin/vdsconfig and a recommended value is between 10,000 and 15,000.

An example of using vdsconfig to configure ReplicationPollChunkSize is shown below.

c:\radiantone\vds\bin\vdsconfig.bat set-property -name replicationPollChunkSize -value 15000

For more details on the vdsconfig utility, see the RadiantOne Command Line Configuration Guide.
