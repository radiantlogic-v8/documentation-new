---
title: Managing RadiantOne Directory Properties
description: Learn how to manage RadiantOne Directory Properties. 
---

## Overview

The settings described below appear on the Properties tab for the selected Directory store in the Control Panel > Setup > Directory Namespace > Namespace Design.

## Naming Context
The external suffix used by clients to access this branch in the RadiantOne namespace. 

## Schema Checking

Toggle on the **Enable Schema Checking** option if you want Schema Checking enabled.

Enabling schema checking means whenever entries or attributes are added or modified for this naming context, RadiantOne Directory checks them to ensure that:

-	Object classes and attributes in the entry are defined in the directory schema 

-	Attributes required for an object class are contained in the entry 

-	Only attributes allowed by the object class are contained in the entry 

Schema checking occurs when populating the directory from the Control Panel > Manage > Directory Browser, or when using an LDIF file. Schema checking does not enforce the validity of values against their syntax.

## Add Superior Objectclasses

This option is to dictate whether, when creating an entry or adding an 'objectClass' value to an entry, all superclasses of the named classes will be implicitly added as well if not already present. By default, this option is not enabled. This means that when an entry is created, or an objectclass value is added to an existing entry, only the object classes explicitly listed in the request are included in the final objectclass attribute value. If this option in enabled, RadiantOne automatically adds associated superclasses (based on the LDAP schema definition) to the final objectclass attribute value if they are not already present. Toggle on the **Add Superior Objectclasses** option if you want to enable this behavior.

## Normalize Attribute Names

This option is for determining the case that is used for attribute names of an entry. If this option is enabled, all attribute names entered during an insert of an entry conform to the same case as defined in the RadiantOne LDAP schema. The attribute name is stored in the same case as defined in the schema. If the attribute is not defined in the RadiantOne LDAP schema then the attribute name is stored as all lower case. Toggle on the **Normalize Attribute Names** option if you want to enable this behavior.

If this option is not enabled, then the attributes are stored in the entry with the same case as used in the insert request.

This option is to improve the performance of initializing the local store when possible. If the attribute names are not normalized, the import of user entries is faster.

## Indexed Attributes

This property lists the attributes that should be indexed. Attributes in this list support client search filters that use presence, equality, approximate, substring, matching rule, and browsing indexes. By default, all attributes are indexed (except for binary attributes and a few “internal” attributes defined in the Non Indexed Attributes property). If the Indexed Attributes setting is empty, this means all attributes are indexed. If you do not want all attributes indexed, define a list of attributes to index in this setting by entering the attribute name and pressing the "Enter" key on your keyboard after each. If you indicate a list of attributes and later add attributes to index, you must remember to re-build the index. To do so, select the naming context on Control Panel > Setup > Directory Namespace > Namespace Design and on the Properties tab on the right side, click **RE-BUILD INDEX**. 

>[!note] 
>Although the underlying Lucene engine enforces a size limit of 32K characters for indexed attributes, we generally advise not indexing attributes containing more than 4K characters. To ignore these attributes, add them to the Non-indexed Attributes list and Re-build the Index (click Re-build Index).
**Using OR conditions in filters containing non-indexed attributes is strongly discouraged since it requires a full scan and all entries fetched from disk.**

## Non Indexed Attributes

If the Indexed Attributes list is empty, all attributes (except binary ones and the description attribute) are indexed by default. Also, the following “internal” ones are not indexed either: “pwdLastLogonTime”, "creatorsName", "createTimestamp", "modifiersName", "modifyTimestamp", "cacheCreatorsName", "cacheCreateTimestamp", "cacheModifiersName", "cacheModifyTimestamp", "uuid", "vdsSyncState", "vdsSyncHist", "ds-sync-generation-id", "ds-sync-state", "ds-sync-hist", "vdsSyncCursor", "entryUUID", "userpassword”. Any additional attributes that you do not want indexed should be added to the Non Indexed Attributes list on the Properties tab for the selected RadiantOne Directory store. This parameter is an alternative to listing all the attributes you want to index in the Indexed Attributes parameter.

If you change the non indexed attributes, you must re-build the index. You can do this from the Properties tab by clicking **Re-build Index**.

>[!warning] 
>If possible, add attributes that must be modified frequently to the non-indexed attribute list to improve update performance of RadiantOne Directory. Attributes that don’t need to be used in searches are good candidates for the non-indexed attribute list. Limit the number of configured non-indexed attributes to further improve update performance.

## Sorted Attributes

Defined on the Properties Tab for the selected RadiantOne Directory, this is a comma-separated list of attributes to be used in association with Virtual List Views (VLV) or sort control configured for RadiantOne. These sorted indexes are managed internally in the store and kept optimized for sorting. They are required if you need to sort the search result or to execute a VLV query on the RadiantOne Directory.

If you need to support VLV, the VLV/Sort control must be enabled in RadiantOne. For details on this control, please see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).

If you change the sorted attributes, re-build the index. You can do this from the Properties tab by clicking **Re-build Index**.

## Encrypted Attributes for Data at Rest

Attribute encryption protects sensitive data while it is stored in RadiantOne Directory. You can specify that certain attributes of an entry are stored in an encrypted format. This prevents data from being readable while stored, in any temporary replication stores/attributes (cn=changelog, cn=replicationjournal, cn=localjournal), in backup files, and exported in [LDIF files](#importing-changes-from-an-ldif-file) (must use the LDIFZ file extension). Attribute values are encrypted before they are stored in RadiantOne Directory, and decrypted before being returned to the client, as long as the client is authorized to read the attribute (based on ACLs defined in RadiantOne), is connected to RadiantOne via SSL, and is not a member of the special blacklisted group (e.g. cn=ClearAttributesOnly,cn=globalgroups,cn=config). For more information about the blacklisted group, see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).

>[!warning] 
>Define a security encryption key from the Main Control Panel -> Settings Tab -> Security section -> Attribute Encryption prior to configuring encrypted attributes. For steps on defining key generation, changing the encryption security key, or using an HSM like Amazon Web Services KMS as the master security key storage, see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).

Defined on the Properties Tab for the selected RadiantOne Directory, this is a comma-separated list of attributes to store encrypted. Attributes listed in the Encrypted Attributes property are added to the Non-indexed attribute list by default. This means these attributes are not searchable by default. Indexing encrypted attributes is generally not advised as the index itself is less secure than the attribute stored in RadiantOne Directory, because the index is not salted. However, if you must be able to search on the encrypted attribute value, it must be indexed. Only “exact match/equality” index is supported for encrypted attributes. To make an encrypted attribute searchable, remove the attribute from the list of nonindexed attributes, save the configuration and then click **Re-build Index**.

>[!warning] 
>To prevent the sensitive attribute values from being logged in clear in RadiantOne logs, make sure you add them to the Attributes Not Displayed in Logs property on the Main Control Panel > Settings tab > Server Front End > Attributes Handling. Each attribute name should be separated with a single space. Any attribute indicated here has a value of ***** printed in the RadiantOne logs instead of the value in clear.

### Updating Encrypted Attributes

In order to update encrypted attributes, the client must connect to RadiantOne via SSL, be authorized (via ACLs) to read and update the attribute, and not be a member of the special blacklisted group (e.g. cn=ClearAttributesOnly,cn=Global Groups,cn=config). For more information about the blacklisted group, see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction). When editing entries from the Main Control Panel > Directory Browser tab > selected RadiantOne Directory store, encrypted attributes appear as encrypted because this operation is not connected to RadiantOne via SSL. If you are connected to the Control Panel via SSL, then the Directory Browser tab connects to the RadiantOne service via SSL and the attributes defined as encrypted are shown in clear as long as the user you’ve connected to the Main Control Panel is authorized to read those attributes. In this case, the connected user can also update the encrypted attribute if permissions allow for it. For details on connecting to the Control Panel via SSL, see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).

### Removing Attribute Encryption

If you need to remove attribute encryption, follow the steps below.

1.	Go to the Main Control Panel > Directory Namespace tab.

2.	Select the naming context representing the RadiantOne Directory.

3.	On the right, remove all values from the encrypted attributes list.

4.	Click **Save**.

5.	Click **Re-build Index**.

## Support for Full Text Search

RadiantOne Directory can support full text searches. This offers additional flexibility for clients as they can search data based on text (character) data. These types of searches are no longer linked to specific attributes as the characters requested could be found in any attribute value. An entry is returned by RadiantOne if any attribute in the entry contains the character string(s) requested by the client.

Clients issue full text searches similar to the way they issue LDAP searches. The only difference is the filter contains (fulltext=`<value>`) where `<value>` would be the text they are interested in. As an example, if a client was interested in the text John Doe as an exact phrase, the search filter sent to RadiantOne would be (fulltext= “John Doe”) where the phrase is encapsulated in double quotes. If the phrase in the filter is not encapsulated in double quotes it means the client wants any entries that have at least one attribute that contains the character string John and one attribute that contains the character string Doe.

The part of the filter that contains the piece related to the full text search can also be combined with other “standard” LDAP operators. As an example, a filter could be something like (&(uid=sjones)(fulltext=”John Doe”)). This would return entries that contain a uid attribute with the value sjones AND any other attribute that contains the exact character string John Doe.

Below are two examples of LDAP filters leveraging the NEAR operator in full text searches: 

Example Filter 1: (fulltext~="A B") 

RadiantOne returns all the entries with A before B and A near B: 

The examples below show different possible values for an attribute and whether they would match the fulltext filter: 

"A Z B C D" (matches the filter) 

"A Z C D B" (doesn't match the filter, A not near enough to B) 

"B Z A C D" (doesn't match the filter, A is after B) 

Example Filter 2: (fulltext~=A B) 

RadiantOne returns all the entries containing an attribute value with A near B. 

The examples below show different possible values for an attribute and whether they would match the fulltext filter: 

"A Z B C D" (matches the filter) 

"A Z C D B" (doesn't match the filter, A not near enough to B) 

"B Z A C D" (matches the filter) 

When using the NEAR operator, the indicated texts must be in the same attribute value. 

When you search for A NEAR B, RadiantOne looks at all the entries with an attribute value containing A and B where B and A have a maximum of 2 words in between.

If you want to support full text searches, check the Full-Text Search option on the Properties tab for the selected RadiantOne Directory and click Save. If you add the support for full text searches, remember to re-build the index. To do so, select the naming context below Root Naming Contexts on the Directory Namespace tab and on the right side, click **Re-build Index**.

## Active

Check the Active option if you want to activate this naming context. Uncheck the Active option to deactivate the node. Only active nodes are accessible in RadiantOne and returned when querying the rootDSE.


## Optimize Linked Attribute

Linked attributes are attributes that allow relationships between objects. A typical example would be isMemberOf/uniqueMember for user/groups objects. A group has members (uniqueMember attribute) which is the forward link relationship. Those members have an isMemberOf attribute which is the back link (to the group entry) relationship. Other examples of linked attributes are:

manager/directReports
<br>altRecipient/altRecipientBL
<br>dLMemRejectPerms/dLMemRejectPermsBL
<br>dLMemSubmitPerms/dLMemSubmitPermsBL
<br>msExchArchiveDatabaseLink/msExchArchiveDatabaseLinkBL
<br>msExchDelegateListLink/msExchDelegateListBL
<br>publicDelegates/publicDelegatesBL
<br>owner/ownerBL

The most common back link/forward link relationship is between group and user objects. A list of groups a user is a member of can be automatically calculated by RadiantOne and returned in the membership attribute of the user entry. The default attribute name in the user entry for the group membership is isMemberOf. However, you can configure any attribute name (e.g. memberOf) you want. This is configured on the Main Control Panel, click Settings > Interception > Special Attributes Handling, Linked Attribute section.

>[!note] 
>When the Optimize Linked Attribute setting is enabled, the backlink attribute is always returned to clients even when not requested unless Hide Operational Attributes is enabled in RadiantOne (in which case isMemberOf is only returned when a client explicitly requests it). For details on the Hide Operational Attributes setting, please see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).

If the back link attribute location and forward link attribute location in the Linked Attributes setting is a RadiantOne Directory, the computation of the references can be optimized in order to return client requests for the back link attribute(s) at high speed. To enable this optimization, follow the steps below.

It is assumed you have configured the Linked Attribute Special Attributes Handling. If you have not, please do so prior to continuing with the steps below.

1.	Select the Optimize Linked Attribute option on the Properties tab for the selected RadiantOne Directory on the Main Control Panel -> Directory Namespace tab.
2.	Click **Save**.
3.	Click **Re-build Index**.

>[!warning] 
>If your users and groups are in a RadiantOne Directory, and you enable the Optimize Linked Attribute setting, and must support nested groups, only one Target Base DN location and Source Base DN location per RadiantOne Directory store is supported. For example, in the Linked Attribute Special Attribute Handling, having a Target Base DN location configured for ou=people1,dc=myhdap and ou=people2,dc=myhdap (both in the same dc=myhdap store) is not supported. In this case, you should configure a single location as dc=myhdap as a shared parent for both containers.

### Enable Changelog

When Optimize Linked Attributes is enabled, the Enable Changelog option is available. Check this option if you want the RadiantOne service to publish changes to the back link attribute into the cn=changelog. By default, the RadiantOne service doesn’t publish changes to operational back link attributes like isMemberOf into the cn=changelog. 

This option should only be enabled if downstream applications are leveraging the changelog to detect changes in the RadiantOne service and need access to entries that have had their back link attribute (e.g. memberOf, isMemberOf) updated by RadiantOne. If this option is not enabled, and the back link attribute is the only change on an entry, it is not published into cn=changelog.

The most common linked objects are groups and users. Use caution when enabling this option because modifications that add or update dynamic (memberURL attribute) or static group members can result in changing memberOf/isMemberOf for many users, causing many time-consuming writes into the changelog. Also, all RadiantOne changelog connectors (e.g. Global Sync connectors and/or persistent cache refresh connectors), and downstream applications leveraging the changelog for capturing changes, will have to process many potentially irrelevant changes. Enabling this option forces the RadiantOne service to update the linked entries (e.g. groups and users) asynchronously, allowing the client that issued the group modification request to get a response immediately after the group membership is updated without waiting for the backlink attribute in all related objects to be updated. This can avoid a modification timeout getting returned to the client that issued the modify request, but can result in transactional integrity because all related objects haven’t necessarily been updated when the modify response is returned. For example, if a client application queries a user entry to get isMemberOf during this period (could be as much as a few seconds), there is a risk that they receive outdated information because the backlink attribute hasn’t been updated yet. Also, the asynchronous processing results in higher CPU usage on the RadiantOne node while it is processing the modifications on objects containing the forward link and back link attributes, which could trigger monitoring alerts if configured thresholds are reached. 

### Async Indexing

When Optimize Linked Attributes is enabled, the Aysnc Indexing option is available to be used in conjunction with the Enable Changelog option, or on its own. 

Enabling this option forces the RadiantOne service to update the linked entries (most commonly, groups and users) asynchronously, allowing the client that issued the group modification request to get a response immediately after the group membership (object containing the forward link attribute) is updated without waiting for the back link attribute in all related objects to be updated. This can avoid a modification timeout getting returned to the client that issued the modify request, but can result in transactional integrity because all related objects haven’t necessarily been updated when the modify response is returned. For example, if a client application queries a user entry to get isMemberOf during this period (could be as much as a few seconds), there is a risk that they receive outdated information because the back link attribute hasn’t been updated yet. Also, the asynchronous processing results in higher CPU usage on the RadiantOne node while it is processing the modifications on objects containing the forward link and back link attributes, which could trigger monitoring alerts if configured thresholds are reached. 

If async indexing is not used, all objects containing either a forward link or back link attribute are updated before the modify response is returned to the client. If the modification request results in many objects getting updated, this can be time-consuming and the client may receive a timeout error.

>[!note] 
>For persistent cached branches, you should only consider enabling this option if client applications issue modification requests to the RadiantOne service for the cached branch. If the data is only modified directly on the backend, and this is the event that triggers the persistent cache refresh, async indexing is irrelevant and not used.

## Inter-Cluster Replication

This option should be enabled if you want to support replication between this RadiantOne Directory store and stores in different clusters. If you have a classic RadiantOne architecture deployed, this would be used to support replication between stores across the active/active or active/passive RadiantOne servers.

If inter-cluster replication is enabled, a replication journal is used to store changes that happen on the configured naming context. The replication journal is associated with the default LDAP data source defined as replicationjournal and root naming context named cn=replicationjournal. The RadiantOne leader nodes in other clusters pick up changes from the replication journal to update their local image. In classic architectures, each RadiantOne server acts as a leader node whether it is active or passive.

For details on inter-cluster replication deployment options, please see the RadiantOne Deployment and Tuning Guide.

## Operations Redirection

In certain deployment scenarios, RadiantOne Directory stores should not process all types of operations. By default, RadiantOne directs all operations to the local store. However, in certain circumstances (e.g. deployments across multiple sites/data centers) you may want to direct write and/or bind operations to another RadiantOne server. For details on redirections, please see the [RadiantOne System Administration Guide](/documentation/sys-admin-guide-rebuild/01-introduction).
