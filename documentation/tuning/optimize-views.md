---
title: Optimize Views
description: Learn about options to optimize identity views.
---

## Overview

This is the overview.

## Views from Database Backends

## Views from LDAP Backends

**Limit Attributes Requested from the LDAP Backend**

Whenever RadiantOne queries a backend LDAP, the default behavior is to ask for all attributes (although ONLY the attributes requested in the query are returned to the client). This default behavior of RadiantOne is for the following reasons:

-	Joins have been configured and the filter in the search request involves attributes from both the primary and secondary sources (i.e. the query filter contains conditions on both primary and secondary objects). 

-	Interception scripts that involve logic based on attributes from the backend. These attributes may not be specifically requested or searched for by the client. However, RadiantOne must retrieve them from the backend in order for the script logic to be valid.

-	ACL checking. You can setup ACLs on attribute/values of an entry (i.e. mystatus=hidden), so RadiantOne may need the whole entry to check the authorization.

-	For entry caching. The entire entry needs to be in the entry cache.

    If your virtual view does not require any of the conditions mentioned above, you can enable this option for better performance. If this option is enabled, RadiantOne queries the backend server only for attributes requested from the client in addition to attributes set as 'Always Requested' on the Attributes tab.

**Process Joins and Computed Attributes only when necessary**

The default behavior of RadiantOne is to process associated joins and build computed attributes whenever a virtual object is reached from a query regardless of whether the attributes requested come from a secondary source or computation. 

If you enable this option, RadiantOne does not perform joins or computations if a client requests or searches for attributes from a primary object only. If a client requests or searches for attributes from secondary objects or computed attributes, then RadiantOne processes the join(s) and computations accordingly. For more details on this behavior, please see the Join Behavior Diagram in the [RadiantOne System Administration Guide](/sys-admin-guide/01-introduction).

Use caution when enabling this option if you have interception scripts defined on these objects, or access controls based on filters are being used (both of which may require other attributes returned from secondary sources or computations regardless of whether the client requested or searched for them).

>[!warning] Do not enable this option if a memory entry cache is used (as the whole virtual entry is needed for the cache).

**Use Client Sizelimit Value to Query Backend**

Whenever RadiantOne queries a backend LDAP, the default behavior is to ask for all entries (sizelimit=0) even if the client to RadiantOne indicates a size limit. 
This default behavior is because the entries returned by the backend are possible candidates, but may not be retained for the final result that is sent to the client. For example, if an ACL has been defined in RadiantOne, not all entries from the backend may be authorized for the user (connected to RadiantOne) to access. Other cases are when joins or interception scripts are involved with the virtual view, these may also alter the entries that match the client’s search. 

To limit the number of entries from the backend, using paging is the recommended approach. If the backend supports paging, RadiantOne does not get all the results at once, only one page at a time (pagesize indicated in the configuration). In this case, if RadiantOne has returned the sizelimit required to the client, it does not go to the next page.

If your virtual view does not require any of the conditions mentioned above (joins, interceptions, ACL), and using paging between RadiantOne and the backend is not possible, you can enable this option to limit the number of entries requested from the backend. If this option is enabled, RadiantOne uses the sizelimit specified by the client instead of using sizelimit=0 when querying the backend.


## Views from Custom Backends
