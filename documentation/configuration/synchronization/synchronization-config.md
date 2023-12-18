---
title: Synchronization Configuration
description: Learn how to configure synchronization. 
---

## Introduction

RadiantOne Synchronization is an advanced set of tools for synchronization and identity management. This component allows you to synchronize objects distributed across disparate data sources (directories, databases or applications): a change in an object in one source, at the attribute level, or for the whole object can be reflected into many other connected objects. Using a publisher/subscriber approach, any object can publish events (creation, deletion or modification for the whole object, or any attributes of this object) and propagate them to subscriber objects. User-defined attribute mappings and transformations can be applied during synchronization.

### Architecture

The synchronization architecture is comprised of Agents, Queues, Sync Engine, Attribute mappings and transformation scripts.

Agents manage Connectors which are components used to interface with the data sources. Changes flow to and from the Connectors asynchronously in the form of messages. This process leverages queues to temporarily store messages as they flow through the synchronization pipeline. The attribute mappings and/or transformation scripts are processed by the Sync Engine prior to the events being sent to the target endpoints.

>[!warning]
>All sources must have views mounted in the RadiantOne namespace to complete the synchronization configuration. To simplify management of the synchronization flows, it is recommended to have a dedicated section of the namespace for all source identity views. Once a view has been configured as a source for synchronization, no further changes should be made to the view (e.g. no object/attribute mapping changes, no adding/removing persistent cache, etc.). 

See the figure below for a high-level architecture of the synchronization process.

<a name="global-synchronization-architecture-figure"></a>
![A flow chart depicting the high-level architecture of the synchronization process](Media/sync-arch.png)


## Pipelines
Pipelines are automatically created when topologies are configured. There are two prerequisite steps for configuring synchronization topologies: mount the objects you want to synchronize in the RadiantOne directory namespace and extend the RadiantOne LDAP schema with any new/custom object definitions. These steps are described below. After these steps are finished, you can create topologies.

### Mount virtual views of objects

All synchronization source and target endpoints must be represented in the RadiantOne namespace, meaning that virtual views containing all source and target objects should be mounted below a root naming context. The virtual views can be created using the Control Panel > Setup > Directory Namespace > Namespace Design.

>[!warning]
>Make sure primary keys/unique identifiers are defined for all objects that will play a role in synchronization. You can manage the attributes defined for objects using Control Panel > Setup > Data Catalog > Data Sources > Schema tab.

### Extend RadiantOne LDAP schema 

After virtual views have been mounted into the RadiantOne directory namespace, extend the LDAP schema with all needed object definitions that are not currently included. The object definitions are used in attribute mappings for synchronization. The RadiantOne LDAP schema can be extended from Control Panel > Setup > Directory Namespace > Directory Schema > Extend from ORX tab. Select the schemas associated the objects in your identity views and click **+**  to move the schema into the column on the right. Then click **GENERATE**. You can verify the objects defined in the RadiantOne LDAP schema from the Control Panel > Setup > Directory Namespace > Directory Schema > LDAP Schema tab.

## Transformations

### Script

### Attribute Mappings

### Rules-based
### Approvers

Any user located in the RadiantOne virtual namespace that is a member of the *Approvers* group can be an approver. In the following example, the ICS Admin user is made an approver.  
To manage the Approvers group: 
1.	In the Main Control Panel, go to the **Directory Browser** tab.  
1.	Expand cn=config,ou=globalgroups. 
1.	Select cn=approvers. 
1.	Click the **Manage Group** button. The Manage Group window displays. 
1.	Click the **Add Member(s)** button.  
1.	Click the **Expand Tree** button. The RadiantOne namespace displays on the right. 
1.	In the namespace, navigate to the location of the user that you want to approve events. In this example, the location cn=config,ou=globalusers is selected.  
1.	Click the **Find Now** button.  
1.	Select the entry you want to approve events and click the **Move selected entry down** button. In this example, uid=icsadmin,ou=globalusers,cn=config is selected. <br>![Find Users](../media/findusers.jpg)
1.	Click the **Confirm** button. The member is displayed in the cn=approvers group.  
1.	Click **Confirm** again to commit the change. 

![Members of the Approvers Group](../media/approversgroup.jpg)

>[!warning]
>If you want the approver to receive an email alert when they have pending approvals, the user account must have a valid email address (mail attribute).


### Email Notifications

To enable email alerts for approvers, SMTP must be configured. 
1. Navigate to the RadiantOne Main Control Panel > Settings tab > Monitoring > Email Alerts Settings.
2. Enter your SMTP settings (host, port, user, password, from email and to email) in the Email Alerts (SMTP Settings) section.
3. Click **Save**.
4. If you would like to test your settings, click **Send Test Email**. 

>[!note]
>For security and audit purposes, it is not advised to connect to your mail server anonymously (leaving user and password >properties blank in the Email Alert Settings). 

![Email Alert Configuration](../media/emailalerts.jpg)

### Insights, Reports and Administration Portal

The RadiantOne Insights, Reports and Administration portal is designed for power users and administrators that are in charge of identity management tasks such as approving synchronization events (e.g. creation of new accounts in target systems) or auditing group memberships.

To access the portal, navigate in a web browser to your Control Panel endpoint appended with /portal and enter your login credentials. <br> 
e.g. https://cp-rli-qa.dc.federated-identity.com/portal/ 
>[!note] 
>User to DN mapping must be properly configured so that the approver can login with their user ID and not require their full DN.

![Insights, Reports and Administration Portal](../media/portal-login.jpg)

The applications currently available in this portal are *Approvals* and *Global Identity Viewer*. A brief description of each application is provided below. 

### Performing Approvals 
When a change associated with a rule that requires approval is detected in a source, the instance is published into the approvals queue and awaits action. Approvers use the Approvals application to accept or reject events.

Approvers log into the Insights, Reports and Administration Portal and click the Approvals icon.
![Approvals](../media/approvals.jpg)

The pending events assigned to the approver are displayed.

![Approval Decisions](../media/decisions.jpg)

The user must approve or reject the event. This can be done using the ![reject](../media/reject.jpg) to reject an event or the ![accept](../media/accept.jpg) to accept an event. <br>
Check boxes in the column on the far left can also be used. If you check the box in the column header, options include “Select Current Page”, “Select Everything”, “Unselect Current Page”, and “Unselect Everything”. Then select an option from the Select Bulk Action drop-down menu (*Approve All* or *Reject All*).

>[!note] 
>To fetch additional pending modifications, click the **Refresh** button.

After acting on all events, click **Submit Changes** and then **Yes** to confirm the updates. 

Approved events are processed by the sync engine and applied to the target.

#### Approval Audit Log
The actions taken by approvers is logged. Logging is enabled by default and the log file is: `<RLI_HOME>/logs/approvals_audit.log`

### Global Identity Viewer 
RadiantOne includes an easy-to-use, web-based application named the Global Identity Viewer that facilitates searching for identities and/or groups across all data sources that have been integrated in a Global Identity Builder project. When a query returns an identity, a list of tabs display for the selected user based on how many identity sources the user has an account in. If the identity is found in the global profile list, the attributes corresponding to this account display on the Global Profile tab. The names of the other tabs indicate the identity source’s “friendly name” as configured in the Global Identity Builder project. When a tab is selected, the identity attributes and group membership associated with the user’s account in that particular identity source are displayed. In the diagram below, a user identified as Brian Carmen has an account in the RadiantOne global profile store, and accounts in identity sources named adpartnerdomain, ldap, and azuread. The example shows the adpartnerdomain tab selected and Brian’s attributes from that particular data source returned. 
For more details on the Global Identity Viewer, see the [RadiantOne Global Identity Viewer Guide](/global-identity-viewer-guide/01-introduction).

![Global Identity Viewer](../media/givsample.jpg)



## Queue Time to Live
  

