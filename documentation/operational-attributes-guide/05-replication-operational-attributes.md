---
title: Operational Attributes
description: Operational Attributes
---

# Replication Operational Attributes
## timestampms

This attribute indicates the date/time (Unix epoch time format) the entry was added into the “changelog” (“changelog” meaning cn=changelog, cn=replicationjournal, and/or cn=replicationjournal…depending on the context) as opposed to the time the entry (originally) changed. Entries in the cn=changelog, cn=replicationjournal, and cn=localjournal branches contain this attribute. This attribute is used by RadiantOne internally for storage cleanup and changelog isolation per context.

## targetContextID

This attribute is used by RadiantOne internally for storage cleanup and changelog isolation per context.

## targetEntryuuid

UUID of the target entry.
## replicationDomain

The naming context on which the replication topology is established.

## replicationCSN, CSN

Change Sequence Number (CSN) which is a unique number to differentiate change events that have happened within the replication topology.

## replicaIdentifier

The identifier to distinguish each replica within the replication topology.
## changetype

This attribute indicates the type of change associated with the entry. Possible values are add, modify and delete. Entries in the cn=changelog, cn=replicationjournal, and cn=localjournal branches contain this attribute.

## changetime

This attribute indicates the time the entry (originally) changed, as opposed to the exact time it was added into the “changelog” (“changelog” meaning cn=changelog, cn=replicationjournal, and/or cn=replicationjournal…depending on the context). Entries in the cn=changelog, cn=replicationjournal, and cn=localjournal branches contain this attribute.

## changes

This attribute includes details about the changes associated with the entry. Entries in the cn=changelog, cn=replicationjournal, and cn=localjournal branches contain this attribute. The following example is associated with an update to the “l” attribute of an entry:

```
replace: l
l: San Francisco
-
replace: modifiersName
modifiersName: cn=directory manager
-
replace: modifyTimestamp
modifyTimestamp: 20180904173203.571Z
-
```

## changenumber

This attribute uniquely identifies an entry in the changelog and is automatically incremented by RadiantOne. Changes are automatically removed from the changelog after a configurable amount of days (default is 3). Old change log numbers do not get re-used.

## firstChangeNumber 

This attribute contains the first changelog number. This attribute is part of the rootdse entry. This attribute is also in the cn=changelog entry and cn=replicationjournal entry and is used internally by RadiantOne for cluster consistency and cursor positioning during startup or when switching leadership.

## lastChangeNumber

This attribute contains the last changelog number. This attribute is part of the rootdse entry and can be used by clients to detect (and keep track of) changes on RadiantOne entries from the changelog. This attribute is also in the cn=changelog entry and cn=replicationjournal entry and is used internally by RadiantOne for cluster consistency and cursor positioning during startup or when switching leadership.

## targetDN

This attribute contains the DN for the entry that changed. This attribute is found in entries logged into both cn=replicationjounal, cn=localjournal, and cn=changelog.  For certain entries, this attribute could also contain details related to replication configuration.

## vdsSyncState

Keeps track of the sync state of replicas within the replication topology.

## vdsSyncCursor

Keeps track of the cursor which is the last record applied on this replica.

## vdsSyncHist

Keeps track of the historical information (attribute changes) within the entry. Whenever an attribute's value is changed, the information indicating who/when/what is logged inside the vdsSyncHist attribute to be used for replication conflict resolution.

>**Note – the maximum age defined for the changelog at Main Control Panel -> Settings -> Logs -> Changelog also applies to the vdsSyncHist attribute maintained at the level of entries involved in inter-cluster replication. This attribute is multi-valued and continues to grow until the RadiantOne service scans the values and removes ones that are older than the maximum age. RadiantOne scans the values only when the entry is modified. For entries that aren’t updated often, vdsSyncHist will potentially contain values that are older than the maximum age.**
