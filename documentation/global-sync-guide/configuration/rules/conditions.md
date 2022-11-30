---
title: Conditions
description: Conditions
---

# Conditions

Conditions dictate the circumstances that invoke the actions associated with the rule. When conditions are met, the actions are processed.

To create conditions:

1. Edit the rule and select the **CONDITIONS** section.
1. Select **Start Condition**.
1. If you only need a single condition, select **Condition Node** and choose the condition type: [Source Attribute condition](#configure-source-attribute-condition), [Source Event condition](#configure-source-event-condition), [Attribute Event condition](#configure-attribute-event-condition), or [Rule Variable condition](#configure-rule-variable-condition-based-on-an-existing-rule-variable). If you need multiple conditions, select either `AND` Condition or `OR` Condition and then select ![Plus symbol](../../media/image80.png) to add a condition node or another (nested) `AND` Condition or (nested) `OR` Condition. Once you add a new condition node, you configure the expression.
1. Select **OK**.

## Configure Source Attribute condition

The Source Attribute condition type allows you to define a condition based on the value of a source attribute.

1. In the New Condition window, select **Source Attribute Condition** from the **Condition Type** drop-down list.
1. Select the source attribute from the **Source Attribute** drop-down list.
1. Select operator (e.g. `equals`, `not equals`, `greater than`, etc.) to use from the **Operator** drop-down list.
1. Depending on the operator chosen, you may have a Compare with: Constant Value setting where you can enter the value to compare with the source attribute.
1. Depending on the operator chosen, you may have a Comparison Type property where you can choose how to handle the case of the attributes in the value (e.g. ignore case, numeric, regex, etc.).
1. Select **OK**.
1. After all conditions are added, select the **ACTIONS** section in the Rule Builder.

## Configure Source Event condition

The Source Event condition type allows you to define a condition based on the when a specific type of event has occurred on the source entry.

1. In the New Condition window, select **Source Event Condition** from the **Condition Type** drop-down list
1. Select either **equals** or **not equals** to compare the event from the **Assert Equality** drop-down list.
1. Select the type of event from the **Event Type** drop-down list (e.g. **Inserted Entry**, **Updated Entry**, etc.).
1. Select **OK**.
1. After all conditions are added, select the **ACTIONS** section in the Rule Builder.

## Configure Attribute Event condition

The Attribute Event condition type allows you to configure a condition for when a specific type of event has occurred on the source attribute.

1. In the **New Condition** window, select **Attribute Event Condition** from the **Condition Type** drop-down list
1. Select the type of event from the **Change Event** drop-down list (e.g. **Value was added**, **Value was deleted**, etc.).
1. Select the attribute that the change event is to be checked for.
1. Select **OK**.
1. After all conditions are added, select the **ACTIONS** section in the Rule Builder.

## Configure Rule Variable condition based on an existing rule variable

The Rule Variable condition type allows you to populate the rule variable when an existing rule variable contains a specific value based on a comparison operation and criteria.

1. In the New Condition window, select **Rule Variable Condition** from the **Condition Type** drop-down list.
1. Select the existing variable from the **Rule Variable** drop-down list.
1. Select the operator to compare the existing variable value from the Operator drop-down list (e.g. **equals**, **not equals**, **starts with**, etc.).
1. Enter the value to use for comparison in the Compare With: Constant Value property.
1. Choose the Comparison Type (e.g. ignore case).
1. Select **OK**.
