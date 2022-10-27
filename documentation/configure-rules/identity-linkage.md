# Identity Linkage

Identity linkage is used to match the target identity to the source identity. The attribute that is used in the identity linkage must uniquely identify the account in both the source and target. To configure the identity linkage:

1.  For a selected rule, choose the **BASIC INFORMATION** tab.

2.  Select the **Edit** button next to Identity Linkage.

3.  The target attribute used for the identity linkage is configured in the Target Object RDN property of the [Advanced Options](../configure-advanced-options/target-object-rdn.md) for the Rule Set. You cannot change the target attribute on the identity linkage configuration page.

4.  In the **Type** drop-down list, choose **Constant**, **Source Attribute**, or **Function** to indicate how you want the target attribute populated. The **Constant** option allows you to enter a static value. The **Source Attribute** option lets you select a source attribute to base the target attribute value on. The [Function](../transformation/attribute-mappings.md#standard-functions-available) option lets you compute the target attribute value based on a function.

5.  Select **OK**.
