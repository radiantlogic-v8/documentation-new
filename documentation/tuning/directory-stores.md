---
title: Tuning Directory Stores
description: Learn about tuning properties for Directory Stores.
---

## Overview

The properties related to tuning RadiantOne Directory stores can be managed from the Control Panel. To access the properties tab, select the node representing the directory storage below the Root Naming Contexts section on the Control Panel > Setup > Directory Namespace > Namespace Design.

## Indexed Attributes
This property lists the attributes that should be indexed. Attributes in this list support client search filters that use presence, equality, approximate, substring, matching rule, and browsing indexes. By default, all attributes are indexed (except for binary attributes and a few “internal” attributes defined in the Non Indexed Attributes property). If the Indexed Attributes setting is empty, this means all attributes are indexed.

For more details, see: [Indexed Attributes](/documentation/configuration/directory-stores/managing-properties#indexed-attributes)

## Non-indexed Attributes
If the Indexed Attributes list is empty, all attributes (except binary ones and the description attribute) are indexed by default. Also, the following *internal* ones are not indexed either: “pwdLastLogonTime”, "creatorsName", "createTimestamp", "modifiersName", "modifyTimestamp", "cacheCreatorsName", "cacheCreateTimestamp", "cacheModifiersName", "cacheModifyTimestamp", "uuid", "vdsSyncState", "vdsSyncHist", "ds-sync-generation-id", "ds-sync-state", "ds-sync-hist", "vdsSyncCursor", "entryUUID", "userpassword”. Any additional attributes that you do not want indexed should be added to the Non-Indexed Attributes list on the Properties tab for the selected RadiantOne Directory store.

For more details, see: [Non-indexed Attributes](/documentation/configuration/directory-stores/managing-properties#indexed-attributes)

## Sorted Attributes
This is a list of attributes to be used in association with Virtual List Views (VLV) or sort control. These sorted indexes are managed internally in the store and kept optimized for sorting. They are required if you need to sort the search result or to execute a VLV query on the RadiantOne Directory.

For more details, see: [Sorted Attributes](/documentation/configuration/directory-stores/managing-properties#sorted-attributes)

## Optimize Linked Attributes

Linked attributes are attributes that allow relationships between objects. A typical example would be isMemberOf/uniqueMember for user/groups objects. A group has members (uniqueMember attribute) which is the forward link relationship. Those members have an isMemberOf attribute which is the back link (to the group entry) relationship.

If the back link attribute location and forward link attribute location in the Linked Attributes setting is a RadiantOne Directory, the computation of the references can be optimized in order to return client requests for the back link attribute(s) at high speed. This optimization has to be manually enabled and has sub-settings that dictate whether entries that have had their back link attribute are logged into the changelog, and if RadiantOne should update the linked entries asynchronously, allowing the client that issued the group modification request to get a response immediately after the group membership (object containing the forward link attribute) is updated without waiting for the back link attribute in all related objects to be updated.

For more details, see: [Optimize Linked Attributes](/documentation/configuration/directory-stores/managing-properties#optimize-linked-attribute)

## Changelog

Changes to the RadiantOne directory data are logged into the changelog (cn=changelog branch). This is only required if you have applications that need to detect changes on the data and propagate them to other targets/applications. If you do not have this requirement, it is recommended that you disable the changelog for your store. This can alleviate unnecessary disk saturation.

To disable the changelog, navigate to the Classic Control Panel > Settings tab > Logs > Changelog. You can disable it globally (for all stores) or for a specific naming context.

To switch to Classic Control Panel, use the menu options for the logged in user in the upper right.

![Classic Control Panel](Media/classic-cp.jpg)

For more details, see: [Changelog](/documentation/configuration/directory-stores/managing-directory-stores#changelog)
