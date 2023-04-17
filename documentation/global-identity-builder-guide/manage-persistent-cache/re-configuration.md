---
title: Re-configure Global Identity Builder project properties
description: Learn how to stop the persistent cache refresh process associated with the virtual view created by the Global Identity Builder when configuration changes are needed in the project.
---

# Re-configure Global Identity Builder project properties

After creating a Global Identity Builder project, sometimes [project properties](../create-projects/project-properties.md) require changes. For example, you may acquire a new source of identity that requires modifying the schema definition. However, with real-time persistent cache refreshes running, configuration changes cannot be made. This section describes how to make these changes.

To re-configure an existing project's properties:

1. From the Main Control Panel > PCache Monitoring tab, choose the process related to your Global Identity Builder project.
1. When the topology loads, select **Tools** > **Stop p-cache refresh**.
    ![Stopping Persistent Cache Refresh](../media/image73.png)
1. On the Wizards tab, select the **Global Identity Builder**.
1. On the **Identity Correlation Projects** page, select the **Configure** button next to the project you want to update.
1. From the **Edit** drop-down menu, choose **Global Profile**.
1. Make changes to the project property fields as required.
1. Select **Save**.
1. On the **PCache Monitoring** tab, start the persistent cache refresh related to your Global Identity Builder project.
