---
title: Rule configuration
description: Rule configuration
---

# Rule configuration

Rules are packaged as a set that is associated with a single source object class and single target object class. If you want to synchronize source objects that are associated with different object classes (e.g. User and Group), then you need to configure multiple rule sets, one for each object class.

Rules are configured in the RULES section of the selected RULE SET. A Rule is comprised of one or more conditions and one or more actions. When the conditions are met, the actions are executed.

To automatically configure rules for insert, update and delete events, select ![Plus symbol](../../media/image77.png). One rule is configured for each event and each rule has one condition based on the corresponding event type. You can edit an auto configured rule by selecting it and selecting the **Edit** button.

## Creating Rules

1. Edit the Rule Set and select the **Rules** section.
1. Select ![Plus symbol](../../media/image78.png)
1. Enter a Rule name.
1. (Optional) Enter a Description.
1. Configure the [identity linkage](identity-linkage.md) in the Identity Linkage property.
1. If source events associated with this rule should be manually approved before being synchronized to the target, check to enable *Require Approvals*, click ![Approval Config](../../media/editapprovals.jpg) and [Configure Approvers](#configuring-approvers).
1. If you have selected the option to manually define the target DN in [Advanced options](../advanced-options.md#target-dn-generation), select the variable that contains the target DN. If you have the target DN generation set to Automatic in Advanced Option, you do not see the Target DN Variable in the Basic Information section.
1. Select the **Event Type** that should invoke the rule from the **Target Event Type** drop-down list.
1. Uncheck [Adaptive Mode](#adaptive-mode) if you don't want to use it. 
1. Select the [CONDITIONS](conditions.md) section to define the conditions.
1. Select the [ACTIONS](actions.md) section to define the actions.
1. Select **OK**.
1. Repeat steps 1-10 to create rules for other source event types.
1. Select **Save**.
1. Create another [rule set](overview.md) for every source object class you want to detect changes on.

### Adaptive Mode
Adaptive mode is enabled for rules by default.
Adaptive mode attempts to intelligently apply changes to a target by first performing a lookup to see if the entry exists. Based on this, it automatically determines the best way to handle the event: update an existing entry or insert a new entry.

Adaptive mode may change the type of operation performed on multi-valued attribute and how the modification is performed (add, replace or delete values) when the target is an LDAP directory. If you need to control the LDAP operation type for multi-valued attributes in the target, don't use adaptive mode.

Source Event Type | Default Behavior (non-Adaptive Mode) | Adaptive Mode
-|-|-
Insert  New Entry | Insert the new entry into the destination without checking to first see if the entry already exists. If the entry already exists, an error is returned and no action is performed on the target. |Lookup to see if the entry exists: if it doesn’t, insert it. If the entry does exist, and the update involves a multi-valued attribute in a target LDAP directory, adaptive mode will determine the operation type to perfrom (e.g. add value, update value, delete value). If you need control over the operation type, disable Adaptive mode.
Update Existing Entry | Update the entry into the destination without checking to first see if the entry already exists. If the entry does not exist, an error is returned and no action is performed on the target. | Lookup to see if the entry exists: if it exists, update it. If the update involves a multi-valued attribute in a target LDAP directory, adaptive mode will determine the operation type to perfrom (e.g. add value, update value, delete value). If you need control over the operation type, disable Adaptive mode.
Delete Existing Entry | Try to delete the entry in the destination, if it doesn’t exist,  an error is returned and no action is performed on the target. | Perform a lookup to see if the entry exists in the destination. If it exists, delete the entry. If it doesn’t exist, do nothing (don't return an error). 

## Configuring Approvers
The Require Approvals option is located on the **BASIC INFORMATION** tab.
1. Enable the Require Approvals checkbox.
2. Click ![Edit Approvals](../../media/editapprovals.jpg).
3. Click ![Plus symbol](../../media/image78.png).
4. Select one or more members of the [Approvers group](../../concepts-and-definitions/approvals/#approvers) and click ADD. If you select more than one approver, all must approve the action before it expires.
5. Enter a length of time to indicate how long a message should be queued awaiting action (approval or rejection) before it is deleted from the queue. This can be in either minutes or days.
6. Enter a meaningful description and select a source attribute to display in the [*Approvals* experience](../../concepts-and-definitions/approvals/#performing-approvals) to help provide context for the approver about the synchronization event. 

![Approval Config](../../media/editapprovalsux.jpg).

