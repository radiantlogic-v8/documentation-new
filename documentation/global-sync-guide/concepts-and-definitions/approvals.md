---
title: Approvals
description: Approvals
---

# Approvals

For synchronization pipelines that use Rules-based transformation, you can configure source events to require an extra manual approval step prior to the change being sent to target systems. The “Require Approval” option is used for this purpose and dictates that certain events must be approved by a specified set of users before they are applied to target systems. When a change associated with a rule that requires approval is detected in a source, the instance is published into the approvals queue and awaits action until the change has either been approved or rejected. Any user assigned to the Approvals role must log into the Insights, Reports and Administration portal and access the Approvals application to act on the event before it expires. If the change is approved, it is processed, removed from the queue and published to the target(s). If it is rejected, the change is aborted and the message is deleted from the queue. 

## Approvers

Any user located in the RadiantOne virtual namespace that is a member of the Approvers group can be an approver. In the following example, the ICS Admin user is made an approver.  
To manage the Approvers group: 
1.	In the Main Control Panel, click the Directory Browser tab.  
1.	Expand cn=config,ou=globalgroups. 
1.	Select cn=approvers. 
1.	Click the **Manage Group** button. The Manage Group window displays. 
1.	Click the **Add Member(s)** button.  
1.	Click the **Expand Tree** button. The RadiantOne namespace displays on the right. 
1.	In the namespace, navigate to the location for the user that you want to approve entry modifications. In this example, the location cn=config,ou=globalusers is selected.  
1.	Click the **Find Now** button.  
1.	Select the entry you want to approve entry modifications and click the **Move selected entry down** button. In this example, uid=icsadmin,ou=globalusers,cn=config is selected.

![Find Users](../media/findusers.jpg)

>[!warning]
>If you want the approver to receive an email alert when they have pending approvals, the user account must have a valid email address (mail attribute).
10.	Click the Confirm button. The member is displayed in the cn=approvers group.  
11.	Click Confirm again to commit the change. 
  
![Members of the Approvers Group](../media/approversgroup.jpg)
