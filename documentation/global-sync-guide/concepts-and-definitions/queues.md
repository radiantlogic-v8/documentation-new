---
title: Queues
description: Queues
---

# Queues

RadiantOne Global Sync relies on queues for guaranteed delivery of messages. Queues are a special kind of store managed in the RadiantOne Universal Directory below the `cn=queue`, `cn=dlqueue`, and `cn=approvalqueue` (only applicable if the Require Approvals option is enabled for a rule) root naming contexts. Every synchronization pipeline has its own queue below these naming contexts identified by the pipelineID. Messages are added into the queues by the capture connectors and/or the sync engine and retrieved from the queues by the sync engine. All of these queues are hidden root naming contexts, so if you want to view them, you must search for them. The Main Control Panel > Directory Browser tab can be used. An example is shown below.

![The Directory Browser tab in the Main Control Panel with search results for "(objectclass=*)"](../media/image18.png)

## Message time-to-live

Messages remain in the cn=queue and cn=dlqueue until they are either picked up by the sync engine, or the message time-to-live has been reached (default of 3 days). Message time-to-live is configured in the "Changelog and Replicationjournal Max Age" property from the Main Control Panel > Settings > Logs > Changelog.

![Message Time-to-live Enforced by the Global Sync Queues](../media/image19.png)

Messages remain in the cn=approvalqueue until they have either been approved, rejected or expired.  The message expiration timeframe is configured along with the approvers in the rule.
