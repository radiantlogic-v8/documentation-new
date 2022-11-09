# Create Virtual View

RadiantOne includes a default virtual view for Azure AD. Edit this virtual view to point to your [Azure AD custom data source](#customize-data-source) configured in the previous section.

1. Launch **RadiantOne Context Builder** and select the **View Designer** perspective.

2. Choose **File** > **Open** > **View**.

3. Choose the **mgraph** view and select **OK**.

![Default mgraph Virtual View](./media/image106.png)

Default mgraph Virtual View

4. Choose **File** > **Save As** and enter a file name. E.g. `azureadglobalrlitenant`

5. Select **OK**.

6. On the Tree View tab, right-click on the view name and select **Edit Connection String**.

7. Select **Edit**.

8. Choose the custom data source created in the previous section and select **OK**.

![Editing Data Source Associated with Virtual View](./media/image108.png)

Editing Data Source Associated with Virtual View

9. Select **OK** to exit the connection string dialog.

10. Since contacts and devices aren't needed for this use case, on the **Tree View** tab, right-click on **Category=contacts** and choose **Delete**. Select **Yes**, to confirm.

11. On the **Tree View** tab, right-click on **Category=devices** and choose **Delete**. Select **Yes**, to confirm.

12. The default group object class need remapped to a common name because the group settings allowed by the Global Identity Builder are currently, `group`, `groupOfNames` and `groupOfUniqueNames`. On the **Tree View** tab, expand **category=groups** and select **group**.

![Tree View Tab](./media/image111.png)

Tree View Tab

13. Select the **Properties** tab and locate the Object Class.

14. Select **Edit** next to Object Class.

15. From the drop-down list, choose **group** and select **OK**.

![Group Object Class Mapping](./media/image113.png)

Group Object Class Mapping

16. Select ![floppy disk icon](./media/image114.png) to save the view.

17. In the **RadiantOne Main Control Panel**, go to the **Directory Namespace** tab.

18. Select **New Naming Context**.

19. Enter a naming context (e.g. `o=azuread`) and select the **Virtual Tree** type.

20. Select **Next**.

21. Choose the **Use an existing view (.dvx)** option and select **Browse**.

22. Choose the virtual view created in Context Builder (saved in step 24 above) and select **OK**.

23. Select **OK** and then **OK** again to exit the confirmation.

24. Select the **Main Control Panel** > **Directory Browser** tab and select ![monitor symbol](./media/image118.png) to re-load the tree.

25. Navigate to the root naming context created in step 27. Expand the tree and verify your Azure AD user and groups are returned.
