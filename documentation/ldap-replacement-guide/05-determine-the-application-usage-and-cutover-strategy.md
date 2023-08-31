---
title: LDAP Replacement Guide
description: LDAP Replacement Guide
---

# Determine the Application Usage and Cutover Strategy

## Determine Cutover Strategy

Generally all applications are not switched to use the new directory at the same time. There is a gradual migration of applications to point to the new directory. This allows application teams to migrate and test on their own schedule.

Likewise, the legacy LDAP directory isn’t immediately switched off overnight. There is generally a temporary time period where both the legacy LDAP directory and the RadiantOne Universal Directory store must co-exist. This results in a required temporary synchronization process between the two. 

The persistent cache refresh process is in charge of keeping the LDAP directory in sync with the target RadiantOne Universal Directory store. This configuration is outlined in [Import Data Into RadiantOne Universal Directory](03-import-data-into-radiantone-universal-directory).

## Analyze Client Requests

Once applications are modified to point to the RadiantOne Universal Directory, analyze the <RLI_HOME>/vds_server/logs/vds_server.log to track the sequence of requests in an effort to determine what settings to tweak in RadiantOne.

Items to pay special attention to:

-	Does the client query for the rootDSE (blank base DN in the search request)? If so, what attributes are being requested?

-	What are the requested attributes for searches? Are they sensitive attributes that require being stored encrypted?

-	Do the requests invoke a sort control (special index for the attribute)?

-	Do clients use proxy authorization (connect as a specific user and issue requests on behalf of someone else)?

-	Do clients issue modification operations or only read operations? If modifications, which attributes are being modified?

-	How is group membership checked (e.g. searching group entry if user is a member or searching user entry to see if they are a member of a certain group)?
