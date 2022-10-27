# Rules Configuration

Rules are packaged as a set that is associated with a single source object class and single target object class. If you want to synchronize source objects that are associated with different object classes (e.g. User and Group), then you need to configure multiple rule sets, one for each object class.

Rules are configured in the RULES section of the selected RULE SET. A Rule is comprised of one or more conditions and one or more actions. When the conditions are met, the actions are executed.

To automatically configure rules for insert, update and delete events, select ![Plus symbol](../media/image77.png). One rule is configured for each event and each rule has one condition based on the corresponding event type. You can edit an auto configured rule by selecting it and selecting the **Edit** button.

To create a new rule:

1.  Edit the Rule Set and select the **Rules** section.

2.  Select ![Plus symbol](../media/image78.png)

3.  Enter a Rule name.

4.  (Optional) Enter a Description.

5.  Configure the [identity linkage](identity-linkage.md#identity-linkage) in the Identity Linkage property.

6.  If you have selected the option to manually define the target DN in [Advanced Options](../configure-advanced-options/target-dn-generation.md#target-dn-generation), select the variable that contains the target DN. If you have the target DN generation set to Automatic in Advanced Option, you do not see the Target DN Variable in the Basic Information section.

7.  Select the **Event Type** that should invoke the rule from the **Target Event Type** drop-down list.

8.  Select the [CONDITIONS](conditions.md#conditions) section to define the conditions.

9.  Select the [ACTIONS](actions.md#actions) section to define the actions.

10. Select **OK**.

11. Repeat steps 1-10 to create rules for other source event types.

12. Select **Save**.

13. Create another [rule set](../rules/rules.md#rules) for every source object class you want to detect changes on.
