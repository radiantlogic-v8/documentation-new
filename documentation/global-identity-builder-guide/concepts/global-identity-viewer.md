# Global Identity Viewer

RadiantOne includes an easy-to-use, web-based application named the Global Identity Viewer that facilitates searching for identities and/or groups across all data sources that have been integrated in the Global Identity Builder project. When a query returns an identity, a list of tabs display for the selected user based on how many identity sources the user has an account in. If the identity is found in the global profile list, the attributes corresponding to this account display on the Global Profile tab. The names of the other tabs indicate the identity source's "friendly name" as configured in the Global Identity Builder project. When a tab is selected, the identity attributes and group membership associated with the user's account in that particular identity source are displayed. In the diagram below, a user identified as Brian Carmen has an account in the RadiantOne global profile store, and accounts in identity sources named `adpartnerdomain`, `ldap`, and `azuread`. The example shows the `adpartnerdomain` tab selected and Brian's attributes from that particular data source returned.

![High Level Diagram for Global Identity Builder and Global Identity Viewer](./media/image11.png)

High Level Diagram for Global Identity Builder and Global Identity Viewer

In order to automate the configuration of the Global Identity Viewer, some properties must be defined in your Global Identity Builder project. These aspects are outlined below.

>[!note]
>If you will not use the Global Identity Viewer, you do not need to define these properties in your Global Identity Builder project.

For each Identity Source:

- Groups object (class) and location (Base DN) – allows for searches on groups from within the Global Identity Viewer.

>[!important]
>If your identity sources contain LDAP dynamic groups or nested groups, you should consider using RadiantOne to automatically compute the membership (e.g. evaluate dynamic groups, and un-nest groups) prior to starting your Global Identity Builder project. Otherwise, when you view the group information from the Global Identity Viewer, they will contain the exact value(s) from the source(s) (e.g. Sales group has the following members `ldap:///ou=users,o=directory??one?(department=Sales)` instead of the actual members of the Sales group). For details on this process, please see [Address Group Membership Challenges](#address-group-membership-challenges)

- Identity Attributes containing a DN value (Identity DN Attributes) that should be automatically translated into the virtual namespace (e.g. `isMemberOf`, `manager`)

- Group Attributes containing a DN value (Group DN Attributes) that should be automatically translated into the virtual namespace (e.g. `uniqueMember`, `managedBy`)

For details on the Global Identity Viewer, please see the RadiantOne Global Identity Viewer Guide.
