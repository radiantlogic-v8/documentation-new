---
title: define-computed-group-membership
description: define-computed-group-membership
---
         
# Define Computed Group Membership

The virtual view of group entries needs a computed attribute defined for the membership attribute. Steps to define a computed attribute are described in this section.

1. With the `ou=ADDomain1` level selected, select the **Objects** tab.

2. In the Primary Object section, select **Add**.

3. Select the object class associated with the group entries in the backend directory (e.g. group) and select **OK**.

4. Select the group object class in the **Primary Object** table and select **Edit** next to **Define Computed Attributes** (at the bottom).

5. Select **Add**.

6. Enter the computed attribute name. Since the existing groups maintain members in the `member` attribute, this should be the computed attribute name.

7. For the expression to compute the `member` attribute, select **Function**.

8. Select the **remapDN(attr2remap,dataSourceID,externalBaseDN,scope,externalIdAttr)** function and select **OK**.

9. Select the `member` attribute as the `attr2remap` attribute. This the existing group entry attribute that contains the information needed to lookup the member in the global profile view.

10. Select **vds** as the data source ID.

11. Check the **External Base DN** option and enter the container where the global profile view was mounted below the `ou=Users` described in this chapter (e.g. `ou=Users,o=rli`).

12. The `externalIdAttr` attribute must be the one in the global profile that contains that matching value of the RDN in the existing group member DNs. In this example, it is the `cn` attribute.

![Function Parameters](./media/image91.png)

Function Parameters

13. Select **Ok**.

14. Select **Validate**.

15. Select **OK** and **OK** again to exit the computed attributes window.

![Computed Attributes](./media/image93.png)

Computed Attributes

1.  Select **Save**.

2.  Select **Yes** to apply the changes to the server.

3.  On the **Objects** tab, in the **Virtual Attribute Name** table, select the `member` attribute. It is noted that the attribute is populated from both the primary backend and a computed attribute: ![member icon](./media/image95.png). To avoid returning the existing actual member DNs and return only the computed value, select **Edit Attribute**.

4.  In the **Priority** drop-down list for the **GLOBAL (Computed)** origin, choose **Highest** (or **High** – as long as the value has more priority than the one assigned to the group origin).

![Attribute Priority](./media/image97.png)

Attribute Priority

20. Select **OK**.

21. Select **Save**.

22. Select **Yes** to apply the changes to the server.

23. Repeat steps 1-22 for the container representing the groups in the second backend directory.
