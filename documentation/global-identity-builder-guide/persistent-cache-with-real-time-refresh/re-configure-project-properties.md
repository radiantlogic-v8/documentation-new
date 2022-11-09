# Re-configure Project Properties

[Project properties](#project-properties) sometimes require changes after creating a project. For example, you may acquire a new source of identity that requires modifying the schema definition. However, with real-time persistent cache refreshes running, configuration changes cannot be made. This section describes how to make these changes.

To re-configure an existing project's properties:

1. From the Main Control Panel > PCache Monitoring tab, choose the process related to your Global Identity Builder project.

2. When the topology loads, select **Tools** > **Stop p-cache refresh**.

![Stopping Persistent Cache Refresh](./media/image73.png)

Stopping Persistent Cache Refresh

3. On the Wizards tab, select the **Global Identity Builder**.

4. On the **Identity Correlation Projects** page, select the **Configure** button next to the project you want to update.

5. From the **Edit** drop-down menu, choose **Global Profile**.

6. Make changes to the project property fields as required.

7. Select **Save**.

8. On the **PCache Monitoring** tab, start the persistent cache refresh related to your Global Identity Builder project.
