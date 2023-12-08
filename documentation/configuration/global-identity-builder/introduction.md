---
title: Introduction to Global Identity Builder
description: Introduction to Global Identity Builder
---

# Introduction to Global Identity Builder

If you do not have a single source of users, an application would have to look in all the different data stores across the enterprise to find a particular user. Even if a user is listed in only one store (unless that exact store is already known), an application still needs to locate them, resulting in multiple queries issued (at least one to each source the user could potentially be located in). However, if you have a master index (an "identity hub"), the application only needs to query this list to locate a user, which results in queries to only the backend stores where the user is located. The more sources involved, the more valuable this global index is. It is this global list that is created and maintained by RadiantOne.

In cases where the data stores contain user overlap, the RadiantOne service performs aggregation and correlation, creating a common key to identify users across disparate systems. However, the union operation is still important for data sources that may or may not have identity intersection. If they do not have identity overlap there is no need for correlation, but the function of union is still crucial for building your identity service.

The diagrams below provide a summary/review of data sources containing duplicate/intersecting identities.

In the first scenario, the data sources have no overlap of identities. In this scenario the benefits of union would still be important for identity management since a single unique index/list is still required for applications to identify a user for authentication. However, the design effort is a bit easier as no correlation logic is required. An aggregation of sources A, B, and C is sufficient, so the primary design consideration in this case is what hierarchy applications are expecting and to build this namespace accordingly.

![Data Sources with No Overlapping Identities](../Media/image2.png)

In cases where there starts to be user overlap (as seen in Sources A and B in the diagram below), the configuration starts to require correlation. In this scenario, an aggregation of users from sources A, B and C is required in addition to correlation for the overlapping users in sources A and B. The design considerations now involve correlation logic in addition to where you want the unique list of users to appear in the virtual namespace.

![Data Sources with No Overlapping Identities](../Media/image3.png)

In scenarios where the number of data sources increases, the amount of overlapping identities varies (as depicted in the diagram below), and the logic required to correlate identities becomes complex with the possible need of cascading rules to determine correlation, the RadiantOne Identity Data Analysis tool analyzes the quality of data in the backends, helping you determine which attributes would be the best candidates for correlation rules. The data analysis tool generates a report for each of your data sources. These reports give you a glimpse of your existing data and provide insight on the quality of your data and what is available for you to use for correlation logic.

![Complex Identity Integration Scenario](../Media/image4.png)

It is recommended that you use the Data Analysis tool on your data prior to using the Global Identity Builder tool.

>[!warning]
>If you have identities in cloud directories/applications or other data sources being accessed through a custom API, you must use RadiantOne to virtualize and persistent cache them prior to using the Global Identity Builder tool. For details on this process, please see [integrate and configure a Global Identity Builder custom data source](integrate-configure-data-source.md).

Once you have a list of your identity sources and ideas about how to correlate overlapping identities, you are ready to use the Global Identity Builder tool to create your global profile view/reference list.

>[!warning]
>The virtual view created by the Global Identity Builder is read-only since it is an aggregation/computation of identities and attributes from a variety of heterogeneous data sources. The [Global Identity Viewer](concepts.md#global-identity-viewer) tool can be used to search/browse the global profile view and offers edit-ability of attributes on the tabs representing the backend data sources.

The purpose of this guide is to describe how to use the Global Identity Builder tool accessible from the Wizards tab in the RadiantOne Main Control Panel.

## Access the Global Identity Builder tool

The Global Identity Builder tool is accessible from the Wizards tab in the RadiantOne Main Control Panel.

Any user that is a member of the RadiantOne Directory Administrator role, or the Namespace Admin role can access the tool. For details on the RadiantOne delegated admin roles, see the RadiantOne System Administration Guide.

To access the Global Identity Builder tool, navigate in a web browser to the **Main Control Panel** associated with the RadiantOne leader node.

`http://{HOST_NAME}:7070/main/login`

Examples include the following:

- `http://vdservername:7070/main/login`
- `http://10.11.12.10:7070/main/login`

![The RadiantOne Main Control Panel Login Page](../Media/image5.png)

Enter your credentials and select **Login**. Go to the Wizards tab and select **Global Identity Builder**.

## Next steps

There are several fundamental aspects and features of Global Identity Builder. To learn about these, please read [Global Identity Builder concepts](concepts.md).

The creation of a Global Identity Builder project is a process that involves multiple steps. To learn about these steps, please read the section on [creating projects](create-projects/create-project.md).

Manual interventions are often required in a Global Identity Builder project. To learn about these manual tasks, please read the section on [manual identity administration](identity-administration.md).

After a Global Identity Builder project has been created, it must be kept up to date. To learn how to perform this maintenance, please read the section on [managing real-time persistent cache refresh](manage-persistent-cache/overview.md).

Authorization and personalization is commonly enforced using LDAP. In a Global Identity Builder project, this functionality is retained by remapping existing LDAP directories to the [global profile](concepts.md#global-profile). To learn how this is done, please read the section on [linking existing groups to global profile identities](link-groups/overview.md).

An Azure AD of your choosing can be specified as the data source for a Global Identity Builder project. To learn how to do this, please read the section on [integrating and configuring a custom data source](integrate-configure-data-source.md).

A Global Identity Builder project may encounter issues related LDAP dynamic groups, nested groups, and users/groups in multiple containers. Read this section to learn how to [address group membership challenges](address-group-challenges/ldap-dynamic-groups.md).

Certain optional configurations can be added to a Global Identity Builder project by using the [Global Identity Viewer](concepts.md#global-identity-viewer). To learn about how to enable these configurations, read the section on [extending the global profile view](global-profile-view.md).
