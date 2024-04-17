---
title: LDIF Utility Guide
description: LDIF Utility Guide
---

# Overview

RadiantOne includes a command line utility that allows you to perform the following functions.

-	To compile statistics about the entries in your virtual view, see [Data Statistics](02-data-statistics). 

-	To determine if a persistent cache is out of sync from backends by comparing LDIF files created from the persistent cache contents, see [Determining if Persistent Cache is Out of Sync](03-determining-if-persistent-cache-is-out-of-sync). 

-	To verify uniqueness of attribute values in an LDIF file, see [Testing Attribute Uniqueness](04-testing-attribute-uniqueness). 

-	To import changes from an LDIF file, see [Importing Changes from an LDIF File](05-importing-changes-from-an-ldif-file)

-	To export entries from an LDAP directory to an LDIF file, see [Export Entries from an LDAP Directory](06-exporting-entries-from-an-ldap-directory).

This utility is named ldif-utils and is located in <RLI_HOME>/bin/advanced. 

>[!warning] If LDIF-Utils needs to connect to the RadiantOne service via LDAPS or HTTPS, you must import the public key certificate into the trust store (unless it already trusts the CA who signed it). Refer to [PKCS12 Certificates](/sys-admin-guide/01-introduction#pkcs12-certificates) for more information.
