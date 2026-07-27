---
title: Customer Advisory Document
description: Known Issue with Active Directory Cache Initialization and Refresh in Identity Data Management 7.4.22 & 7.4.23
---

## Customer Advisory Document
_**Active Directory Cache Initialization and Refresh Issue Affecting Identity Data Management 7.4.22 & 7.4.23**_

**Published:** July 27, 2026 <br>
**Severity:** High <br>
**Affected versions:** RadiantOne Identity Data Management (IDDM) 7.4.22 and 7.4.23 <br>
**Resolved version:** RadiantOne Identity Data Management (IDDM) 7.4.24 <br>

### Summary

Radiant Logic has identified a regression in RadiantOne Identity Data Management (IDDM) versions 7.4.22 and 7.4.23 that can affect cache initialization and periodic cache refresh operations on cached LDAP proxies connected to Microsoft Active Directory.

The issue occurs when Identity Data Management initializes its cache. To do this, it must use Active Directory range retrieval queries to retrieve all values of a large multi-valued attribute for any entry. Depending on the affected configuration, cache initialization or periodic refresh may fail, stop progressing, or complete with incomplete data.
Identity Data Management 7.4.24 resolves this issue and is now available through the normal Radiant Logic distribution channels.

**We strongly recommend that customers running versions 7.4.22 or 7.4.23 with Active Directory caches as part of their Directory Namespace configuration upgrade to version 7.4.24 as soon as possible.**

### Affected Versions

The following Identity Data Management versions are affected:

- Identity Data Management 7.4.22
- Identity Data Management 7.4.23

Identity Data Management 7.4.21 and earlier versions are not affected by this regression. Similarly, Identity Data Management v8+ versions are not affected by this regression.

### Affected Configurations

A deployment is affected when all of the following conditions apply:

1. Identity Data Management 7.4.22 or 7.4.23 is installed.
2. An Identity Data Management cache is configured on an LDAP proxy connected to Microsoft Active Directory.
3. The cache retrieves an Active Directory object (typically a group object with 1500+ members) containing a large multi-valued attribute that requires Active Directory range retrieval.
4. A cache initialization or periodic cache refresh is performed.

Active Directory requires range retrieval when a multi-valued attribute contains more values than can be returned in a single request. This is typically encountered with attributes containing more than 1,500 values, although the applicable limit can depend on the Active Directory configuration.

Common examples include:

- An Active Directory group containing more than 1,500 values in its `member` attribute.
- A user, computer, group, or service account containing more than 1,500 values in its `memberOf` attribute.
- Other Active Directory objects containing large multi-valued attributes that must be retrieved through multiple range requests.

For additional information about Active Directory range retrieval, refer to the [Microsoft documentation on Range Retrieval of Attribute Values](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/e27b48db-6f82-44cd-9038-2e54f790cc1f).

Customers who do not use an Identity Data Management cache on an LDAP proxy connected to Active Directory are not affected. Customers whose Active Directory cache configurations do not require range retrieval are also not affected by this issue.

### Symptoms

An affected cache initialization or periodic refresh may exhibit one or more of the following symptoms:

- The cache initialization task fails.
- The cache initialization stops progressing and does not complete. Task logs remain stuck after the message that states "Exporting LDIF..."
- The cache operation completes successfully, but the cache contains only a subset of the total entries from the source Active Directory dataset.

### Customer Impact

This issue is limited exclusively to the caches on Active Directory LDAP proxies within Identity Data Management.

An existing, already initialized cache (from a version before 7.4.22) is not affected during normal operation unless periodic cache refresh is enabled. When periodic refresh runs, the refresh operation will also encounter the same issue and cause the cache to become incomplete or fall out of synchronization with Active Directory.

If the affected cache is used for authentication, authorization, group membership evaluation, or other downstream application behavior, incomplete cache data may result in incorrect or unsuccessful downstream operations.

### Resolution

This issue is resolved in Identity Data Management 7.4.24.

Customers with an affected configuration should upgrade to Identity Data Management 7.4.24 using the standard Identity Data Management update installers and the normal update process.

After upgrading:

- Customers may rerun the cache initialization operation to fully rebuild the cache.
- If periodic cache refresh is already enabled, the next subsequent refresh will bring the cache back into synchronization.
- As an optional verification step, customers may compare the resulting cache entry count with the expected number of entries in the Active Directory backend.

### Temporary Mitigation

Customers who cannot immediately upgrade to Identity Data Management 7.4.24 may roll back to Identity Data Management 7.4.21 or an earlier supported version.

Customers who remain on Identity Data Management 7.4.22 or 7.4.23 should avoid initializing or using periodic refresh on Active Directory proxy caches until the upgrade or rollback has been completed. If possible, disabling the cache is the most advisable option in this case.

### Root Cause

The regression was introduced in Identity Data Management 7.4.22 as part of an improvement to the handling of range-based Active Directory group membership retrieval across domain controllers.

### Recommended Action

Customers should take the following action based on their environment:

- **Customers using an affected Active Directory Proxy cache:** Upgrade to Identity Data Management 7.4.24 and rerun cache initialization or allow the next periodic refresh to complete.
- **Customers unable to upgrade immediately:** Roll back to Identity Data Management 7.4.21 or an earlier supported version. Re-run cache initialization or allow the next periodic refresh to complete.
- **Customers not using an Active Directory-backed cache:** No action is required.
- **Customers whose cache does not require Active Directory range retrieval:** No action is required for this issue. Note: most sizable Active Directory groups with 1500+ members require range retrieval.

### Support

Customers who need assistance determining whether their environment is affected, upgrading Identity Data Management, validating their cache, or applying the temporary mitigation should contact Radiant Logic Support through the Customer Support Portal.
