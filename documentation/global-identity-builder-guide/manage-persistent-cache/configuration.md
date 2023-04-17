---
title: Configure Global Identity Builder real-time persistent cache refresh
description: Learn how to configure persistent cache refreshes for the virtual view created by the Global Identity Builder.
---

# Configure Global Identity Builder real-time persistent cache refresh

To configure a real-time persistent cache refresh for a Global Identity Builder project, follow these steps.

1. Go to the Directory Namespace Tab of the Main Control Panel associated with the current FID leader node.
2. Below the Cache node, choose the naming context associated with your Global Identity Builder project.
3. On the Refresh Settings tab, select the **Real-time refresh** option.

>[!note]
>Periodic persistent cache refresh is not available for the global profile cache.

4. Configure any needed database connectors. Active Directory and LDAP connectors are automatically configured. You can change the LDAP connector type from Changelog (the default) to Persistent Search if needed. For details on available change detection mechanisms and properties, see the RadiantOne Deployment and Tuning Guide.
5. Select **Save**. All source connectors are started automatically. Runtime connector properties can be configured from the Main Control Panel > PCache Monitoring tab.

>[!note]
>This persistent cache is specialized for storing the global profile resulting from identity aggregation and correlation. As such, certain cache properties and functions are unavailable and greyed out on the Properties tab. These are: Encrypted Attributes, Access Changes from Replicas, Updatable Attributes from Replicas, and Delete.
