---
title: Create a root naming context for global profile identities and groups
description: Learn how to create a root naming context in RadiantOne that aggregates existing groups along with the virtual view containing the unique list of users created with the Global Identity Builder.
---

# Create a root naming context for global profile identities and groups

The following steps assume you have used the Global Identity Builder tool to [create a global profile of identities](../create-projects/create-project.md) and that `o=globaldirectoryview` is the RadiantOne root naming context where the final global identity view/cache is mounted. This example involves two Active Directory data sources containing identities that contribute to the global profile and contain groups. There are many different namespace designs that can be used. The following steps describe a basic example of creating a virtual view consisting of a container for all groups and one for the global profile list of identities.

1. In the **Main Control Panel** > **Directory Namespace** tab, select ![plus icon](../media/image74.png) to create a new root naming context where both a view of the global profile list and existing groups from the backend directories will be mounted. This example uses a naming context of `o=rli`.
    ![New Naming Context](../media/image75.png)
1. Select the **Virtual Tree** type and select **Next**.
1. Select the option to **Create a new view (.dvx)** and select **OK**.
    ![Create a New View Option](../media/image76.png)
1. Select **OK** to exit the confirmation.
1. With the new naming context chosen, select **New Level**.
1. Enter `Groups` for the OU property value and select **OK**.
    ![New Level for Groups](../media/image78.png)
1. Select **OK** again to exit the confirmation window.
1. With the new naming context selected, select **New Level**.
1. Enter `Users` for the OU property value and select **OK**.
    ![New Level for Users](../media/image79.png)
1. Select **OK** again to exit the confirmation window.
1. With the `ou=Groups` container selected, select **New Level**.
1. Enter a name representing one of the backend directories for the ou property and select **OK**. This example uses `ADDomain1`.
    ![New Level for Backend Directory](../media/image80.png)
1. Select **OK** again to exit the confirmation window.
1. With the `ou=Groups` container selected, select **New Level**.
1. Enter a name representing one of the backend directories for the ou property and select **OK**. This example uses `ADDomain2`.
1. Select **OK** again to exit the confirmation window.
1. With the `ou=ADDomain1` container selected, select **Backend Mapping**.
1. Choose the LDAP Backend type and select **Next**.
1. Select the data source associated with the backend directory from the drop-down list.
1. Select **Browse** to choose the container/location in the backend directory where group entries are located. If groups are spread in numerous containers, select the parent node that includes all containers.
    ![Configure LDAP Backend Example](../media/image82.png)
1. Select **OK**.
1. Select **OK** again to exit the confirmation window.
1. Repeat steps 17-22 for the other container representing the second LDAP directory.
1. With the `ou=Users` level selected, select **Backend Mapping**.
1. Choose LDAP Backend type and select **Next**.
1. Choose the **vds** data source from the drop-down list.
1. Select **Browse** to navigate to the root naming context associated with the global profile view created from the Global Identity Builder tool.
    ![Configure LDAP Backend Example](../media/image84.png)
1. Select **OK**.
1. Select **OK** again to exit the confirmation window.

At this point, the virtual namespace should resemble the following screen:

![Sample Virtual Namespace](../media/image85.png)
