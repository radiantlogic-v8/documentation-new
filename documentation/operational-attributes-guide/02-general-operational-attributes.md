---
title: Operational Attributes
description: Operational Attributes
---

# General Operational Attributes

## vendorversion

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the RadiantOne version/release. An example would be RadiantOne 7.2. This is only updated with each major release, not each patch release.

## supportedControl

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the LDAP controls and extensions that RadiantOne supports. Some of the default LDAP controls and features are explicitly mentioned in the roodse.ldif file while some are determined during startup by the RadiantOne service and returned automatically when clients request the rootDSE of the service (an LDAP search request with a empty base DN). The values could be any combination of the following:

-	Subtree Delete Control - 1.2.840.113556.1.4.805

-	Password expired notification control - 2.16.840.1.113730.3.4.4

-	Password expiring notification control - 2.16.840.1.113730.3.4.5

-	Password policy control - 1.3.6.1.4.1.42.2.27.8.5.1

-	Persistent search control - 2.16.840.1.113730.3.4.3

-	Virtual list view request control - 2.16.840.1.113730.3.4.9

-	Proxied authorization (version 2) control, described in RFC 4370 - 2.16.840.1.113730.3.4.18

-	Server-side sort request, described in RFC 2891 - 1.2.840.113556.1.4.473

-	Authorization bind identity response control, described in RFC 3829 - 2.16.840.1.113730.3.4.15

-	Authorization bind identity request control, described in RFC 3829 - 2.16.840.1.113730.3.4.16

-	Who Am I extended operation, described in RFC 4532 - 1.3.6.1.4.1.4203.1.11.3

-	Paged Results Control - 1.2.840.113556.1.4.319

-	Dynamic entries extension, described in RFC 2589  - 1.3.6.1.4.1.1466.101.119.1

-	All Operational Attributes feature, described in RFC 3673 - 1.3.6.1.4.1.4203.1.5.1

-	Absolute True and False Filters as described in RFC 4526 - 1.3.6.1.4.1.4203.1.5.3

## changelog

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the location in RadiantOne where changes that have occurred in the directory are logged. This allows clients to query this location to learn about these changes. 

## serverType

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the type of server. For RadiantOne, the value is VDS.

## namingContexts

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the naming contexts which the server contains. This attribute allows a client to choose suitable base objects for searching when it contacts the server.

## supportedldapversion

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates which protocol version of LDAP RadiantOne supports. It has values of 2 and 3.

## supportedSASLMechanisms

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the names of the supported SASL mechanisms which RadiantOne supports. The values could be any combination of the following:

<br>EXTERNAL
<br>DIGEST-MD5
<br>GSSAPI
<br>GSS-SPNEGO

## vendorname

An attribute found in the rootDSE (<RLI_HOME>\vds_server\conf\rootdse.ldif) that indicates the name of the LDAP server implementer. It has a value of Radiant Logic, Inc.

## createTimestamp

This attribute contains the date and time that the entry was initially created.

## creatorsName

This attribute contains the name of the user which created the entry.

## entrydn

For every entry inserted into a RadiantOne Universal Directory (HDAP) store, an entryDN operational attribute is generated. This attribute contains a normalized form of the entry’s DN. This attribute is indexed by default and can be used in search filters.

## nsAccountlock

This attribute shows whether the account is active (value of false or the attribute doesn’t exist for the entry) or inactive (value of true).

## modifiersName 

This attribute contains the name of the user which last modified the entry.

## modifyTimestamp

This attribute contains the date and time that the entry was most recently modified.

## hasSubordinates

To search for entries in a RadiantOne Universal Directory store (or persistent cache) that have child entries, use the hasSubordinates attribute in your filter. The value is either true (for entries that have subordinates) or false (for entries that don’t have subordinates). Entries returned when using a search filter of (hasSubordinates=false) are leaf entries because they currently have no subordinates/child nodes.

## numSubordinates

To search for the number of subordinates an entry in a RadiantOne Universal Directory store contains, use the numSubordinates attribute in your filter. This indicates how many immediate subordinates an entry has. Entries returned when using a search filter of (numSubordinates=0) are leaf entries because they currently have no subordinates/child nodes. You can also leverage “greater than” or “less than” in your filter. A filter of (numSubordinate>=5) would return only entries that have 5 or more subordinates.

## uuid

The Universally Unique Identifier (UUID) attribute is a reserved, internal attribute that is assigned to each entry and can guarantee uniqueness across space and time.

## subschemaSubentry

The value of the subschemaSubentry attribute is the DN of the entry that contains schema information for this entry.

## isMemberOf

isMemberOf is an operational attribute that automatically maintains the relationships between groups and user entries. A user’s group memberships are available in the isMemberOf/memberOf attribute and updated automatically if a user is added or removed from a group. A user can be a member of a nested group, dynamic group, or standard static group. The isMemberOf/memberOf attribute can either be computed dynamically when it is explicitly requested or pre-computed at indexing time of the RadiantOne Universal Directory store if the “Optimize MemberOf” option is enabled. 
